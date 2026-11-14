terraform {
  required_version = ">= 1.5.0"
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

# --- ECR Repositories ---
resource "aws_ecr_repository" "auth_repo" {
  name                 = "saa-p6-auth"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
}

resource "aws_ecr_repository" "orders_repo" {
  name                 = "saa-p6-orders"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
}

# --- ECS Cluster ---
resource "aws_ecs_cluster" "cluster" {
  name = "saa-p6-microservices-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# --- Cloud Map Service Discovery ---
resource "aws_service_discovery_private_dns_namespace" "dns" {
  name = "corp.internal"
  vpc  = var.vpc_id != "" ? var.vpc_id : "vpc-mock123"
}
