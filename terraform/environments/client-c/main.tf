terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "eks" {
  source = "../../modules/eks-aws"

  cluster_name          = "epd-client-c"
  kubernetes_version    = var.kubernetes_version
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  private_subnet_cidrs  = var.private_subnet_cidrs
  public_subnet_cidrs   = var.public_subnet_cidrs
  node_instance_types   = var.node_instance_types
  node_desired_count    = var.node_desired_count
  node_min_count        = var.node_min_count
  node_max_count        = var.node_max_count

  tags = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = "epd-client-c/platform-app"
  tags             = local.common_tags
}

locals {
  common_tags = {
    Project     = "enterprise-platform-deployer"
    Client      = "client-c"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
