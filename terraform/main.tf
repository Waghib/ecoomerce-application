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
}

# Create Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Deploy client application using Helm
resource "helm_release" "client" {
  name       = "ecommerce-client"
  chart      = "./helm/client"
  namespace  = "default"
  depends_on = [google_container_node_pool.primary_nodes]

  set {
    name  = "image.repository"
    value = split(":", var.client_image)[0]
  }
  set {
    name  = "image.tag"
    value = split(":", var.client_image)[1]
  }
}

# Deploy server application using Helm
resource "helm_release" "server" {
  name       = "ecommerce-server"
  chart      = "./helm/server"
  namespace  = "default"
  depends_on = [google_container_node_pool.primary_nodes]

  set {
    name  = "image.repository"
    value = split(":", var.server_image)[0]
  }
  set {
    name  = "image.tag"
    value = split(":", var.server_image)[1]
  }
}