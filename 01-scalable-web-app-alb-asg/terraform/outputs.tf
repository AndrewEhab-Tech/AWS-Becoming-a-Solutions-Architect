output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cf.domain_name
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}
