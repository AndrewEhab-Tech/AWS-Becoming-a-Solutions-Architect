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
  alias  = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias  = "secondary"
  region = "eu-west-1"
}

# --- Primary S3 Bucket ---
resource "aws_s3_bucket" "primary_bucket" {
  provider      = aws.primary
  bucket_prefix = "saa-p5-primary-assets-"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "primary_v" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary_bucket.id
  versioning_configuration { status = "Enabled" }
}

# --- Secondary S3 Bucket ---
resource "aws_s3_bucket" "secondary_bucket" {
  provider      = aws.secondary
  bucket_prefix = "saa-p5-dr-replica-"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "secondary_v" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary_bucket.id
  versioning_configuration { status = "Enabled" }
}

# --- Route 53 Health Check ---
resource "aws_route53_health_check" "primary_health" {
  provider          = aws.primary
  fqdn              = "primary-mock.example.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/health"
  failure_threshold = "3"
  request_interval  = "10"

  tags = { Name = "saa-p5-primary-probe" }
}
