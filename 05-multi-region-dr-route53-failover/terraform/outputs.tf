output "primary_bucket" {
  value = aws_s3_bucket.primary_bucket.id
}

output "secondary_bucket" {
  value = aws_s3_bucket.secondary_bucket.id
}

output "health_check_id" {
  value = aws_route53_health_check.primary_health.id
}
