output "cluster_endpoint" {
  description = "Endpoint for GKE control plane"
  value       = google_container_cluster.primary.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = google_container_cluster.primary.name
}

output "client_service_endpoint" {
  description = "The hostname of the client service load balancer"
  value       = try(data.kubernetes_service.client_service.status[0].load_balancer[0].ingress[0].ip, null)
}

data "kubernetes_service" "client_service" {
  metadata {
    name      = "ecommerce-client"
    namespace = "default"
  }
  depends_on = [helm_release.client]
}
