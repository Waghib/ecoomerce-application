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

variable "mongodb_uri" {
  description = "MongoDB connection URI"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT secret key"
  type        = string
  default     = "waghib"
}

variable "gke_num_nodes" {
  description = "Number of GKE nodes"
  type        = number
  default     = 1
}
