variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Ecommerce cluster"
  type        = string
  default     = "ecommerce-cluster"
}

variable "client_image" {
  description = "Docker image for client application"
  type        = string
  default     = "waghib/ecoommerce-application-client:latest"
}

variable "server_image" {
  description = "Docker image for server application"
  type        = string
  default     = "waghib/ecoommerce-application-server:latest"
}
