output "cluster_endpoint" {
  description = "Endpoint for GKE control plane"
  value       = google_container_cluster.primary.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = google_container_cluster.primary.name
}

output "nginx_ingress_ip" {
  description = "External IP of the NGINX Ingress Controller"
  value       = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
  depends_on = [helm_release.nginx_ingress]
}
