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

# --- AWS Transit Gateway ---
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Central Hub TGW"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = { Name = "saa-p4-tgw" }
}

# --- Dev VPC ---
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "saa-p4-dev-vpc" }
}

resource "aws_subnet" "dev_subnet" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "${var.aws_region}a"
  tags              = { Name = "saa-p4-dev-sub" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dev_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.dev_vpc.id
  subnet_ids         = [aws_subnet.dev_subnet.id]
  tags               = { Name = "saa-p4-dev-tgw-attachment" }
}

# --- Prod VPC ---
resource "aws_vpc" "prod_vpc" {
  cidr_block           = "10.30.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "saa-p4-prod-vpc" }
}

resource "aws_subnet" "prod_subnet" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.30.1.0/24"
  availability_zone = "${var.aws_region}a"
  tags              = { Name = "saa-p4-prod-sub" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "prod_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.prod_vpc.id
  subnet_ids         = [aws_subnet.prod_subnet.id]
  tags               = { Name = "saa-p4-prod-tgw-attachment" }
}

# --- Simulated Customer Gateway & Site-to-Site VPN ---
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = "203.0.113.12" # RFC 5737 Test IP
  type       = "ipsec.1"
  tags       = { Name = "saa-p4-onprem-cgw" }
}

resource "aws_vpn_connection" "vpn" {
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  static_routes_only  = false
  tags                = { Name = "saa-p4-site-to-site-vpn" }
}
