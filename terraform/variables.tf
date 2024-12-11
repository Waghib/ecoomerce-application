variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Ecommerce cluster"
  type        = string
  default     = "ecommerce-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
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

variable "aws_access_key_id" {
  description = "AWS access key ID"
  type        = string
  default     = "AKIA5WLTTFW5D3ZMLSN3"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
  default     = "sP6k3NQ3Q0qKN6Hk49+hWf7vzI0J7FzQF7xzMOYe"
}
