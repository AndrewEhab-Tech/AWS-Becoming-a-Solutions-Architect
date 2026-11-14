variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS deployment region"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Main VPC CIDR block"
}

variable "ami_id" {
  type        = string
  default     = "ami-0c101f26f147fa7fd" # Amazon Linux 2023 in us-east-1
  description = "AMI ID for Launch Template"
}

variable "db_password" {
  type        = string
  default     = "SuperSecurePassword123!"
  sensitive   = true
  description = "RDS Master password"
}
