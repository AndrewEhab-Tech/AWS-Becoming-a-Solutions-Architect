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

# --- S3 Buckets ---
resource "aws_s3_bucket" "raw" {
  bucket_prefix = "saa-p7-raw-zone-"
  force_destroy = true
}

resource "aws_s3_bucket" "curated" {
  bucket_prefix = "saa-p7-curated-zone-"
  force_destroy = true
}

resource "aws_s3_bucket" "athena_results" {
  bucket_prefix = "saa-p7-athena-results-"
  force_destroy = true
}

# --- Glue Data Catalog ---
resource "aws_glue_catalog_database" "retail_db" {
  name = "saa_p7_retail_db"
}

# --- Athena Workgroup ---
resource "aws_athena_workgroup" "analytics" {
  name = "saa-p7-analytics"
  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/output/"
    }
  }
}
