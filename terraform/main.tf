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
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/compute"
    ]

    labels = {
      env = var.project_id
    }

    machine_type = "e2-medium"
    disk_size_gb = 50
    disk_type    = "pd-standard"

    metadata = {
      disable-legacy-endpoints = "true"
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

# Install NGINX Ingress Controller
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  timeout          = 600

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_nodes,
    time_sleep.wait_30_seconds
  ]
}

# Deploy MongoDB
resource "helm_release" "mongodb" {
  name       = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "default"
  timeout    = 600

  set {
    name  = "auth.enabled"
    value = "false"
  }

  depends_on = [
    helm_release.nginx_ingress
  ]
}

# Deploy Backend
resource "helm_release" "backend" {
  name      = "ecommerce-backend"
  chart     = "./helm/server"
  namespace = "default"
  timeout   = 600

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
    value = "mongodb://mongodb-mongodb:27017/ecommerce"
  }

  depends_on = [
    helm_release.mongodb,
    helm_release.nginx_ingress
  ]
}

# Deploy Frontend
resource "helm_release" "frontend" {
  name      = "ecommerce-frontend"
  chart     = "./helm/client"
  namespace = "default"
  timeout   = 600

  set {
    name  = "image.repository"
    value = split(":", var.client_image)[0]
  }

  set {
    name  = "image.tag"
    value = split(":", var.client_image)[1]
  }

  depends_on = [
    helm_release.backend,
    helm_release.nginx_ingress
  ]
}