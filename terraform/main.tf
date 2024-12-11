data "kubernetes_service" "client" {
  metadata {
    name      = "ecommerce-client"
    namespace = "default"
  }
  depends_on = [helm_release.client]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "ecommerce-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 3

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

# Deploy client application using Helm
resource "helm_release" "client" {
  name       = "ecommerce-client"
  chart      = "./helm/client"
  namespace  = "default"
  depends_on = [module.eks]

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
  depends_on = [module.eks]

  set {
    name  = "image.repository"
    value = split(":", var.server_image)[0]
  }
  set {
    name  = "image.tag"
    value = split(":", var.server_image)[1]
  }
}