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

# --- AWS KMS Customer Managed Key ---
resource "aws_kms_key" "cmk" {
  description             = "KMS CMK for SAA Project 8"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags = { Name = "saa-p8-kms-key" }
}

resource "aws_kms_alias" "alias" {
  name          = "alias/saa-p8-encryption-key"
  target_key_id = aws_kms_key.cmk.key_id
}

# --- Amazon GuardDuty Detector ---
resource "aws_guardduty_detector" "primary" {
  enable = true
}

# --- AWS Security Hub ---
resource "aws_securityhub_account" "hub" {}

# --- Encrypted S3 Bucket ---
resource "aws_s3_bucket" "secure_bucket" {
  bucket_prefix = "saa-p8-secure-vault-"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.cmk.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
