# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "ecommerce-vpc"
  auto_create_subnetworks = false
}

# Create Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "ecommerce-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/16"
}

# Create GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Add disk configuration to use standard PD
  node_config {
    disk_type    = "pd-standard"  # Use standard persistent disk
    disk_size_gb = 50
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# Create Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# Wait for the cluster to be ready
resource "time_sleep" "wait_30_seconds" {
  depends_on = [google_container_node_pool.primary_nodes]
  create_duration = "30s"
}

# Deploy client application using Helm
resource "helm_release" "client" {
  name       = "ecommerce-client"
  chart      = "./helm/client"
  namespace  = "default"
  depends_on = [time_sleep.wait_30_seconds]

  set {
    name  = "image.repository"
    value = split(":", var.client_image)[0]
  }
  set {
    name  = "image.tag"
    value = split(":", var.client_image)[1]
  }

  timeout = 600 # 10 minutes timeout

  # Add verification that chart exists
  verify = false
}

# Deploy server application using Helm
resource "helm_release" "server" {
  name       = "ecommerce-server"
  chart      = "./helm/server"
  namespace  = "default"
  depends_on = [time_sleep.wait_30_seconds]

  # Increase timeout to 20 minutes
  timeout = 1200

  # Add debug flags
  # debug    = true
  wait     = true

  set {
    name  = "image.repository"
    value = split(":", var.server_image)[0]
  }
  set {
    name  = "image.tag"
    value = split(":", var.server_image)[1]
  }
  
  set {
    name  = "mongodb.uri"
    value = var.mongodb_uri
  }

  set {
    name  = "jwt.secret"
    value = var.jwt_secret
  }

  # Add resource limits
  set {
    name  = "resources.requests.memory"
    value = "256Mi"
  }
  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }
  set {
    name  = "resources.limits.memory"
    value = "512Mi"
  }
  set {
    name  = "resources.limits.cpu"
    value = "500m"
  }
}