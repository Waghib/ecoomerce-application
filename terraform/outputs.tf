output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "client_service_endpoint" {
  description = "The hostname of the client service load balancer"
  value       = try(data.kubernetes_service.client_service.status[0].load_balancer[0].ingress[0].hostname, null)
}

data "kubernetes_service" "client_service" {
  metadata {
    name      = "ecommerce-client"
    namespace = "default"
  }
  depends_on = [helm_release.client]
}
