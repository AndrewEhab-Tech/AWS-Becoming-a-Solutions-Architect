output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "auth_ecr_url" {
  value = aws_ecr_repository.auth_repo.repository_url
}

output "orders_ecr_url" {
  value = aws_ecr_repository.orders_repo.repository_url
}
