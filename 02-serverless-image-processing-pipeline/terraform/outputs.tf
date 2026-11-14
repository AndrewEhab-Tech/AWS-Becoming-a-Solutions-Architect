output "raw_bucket_name" {
  value = aws_s3_bucket.raw_bucket.id
}

output "processed_bucket_name" {
  value = aws_s3_bucket.processed_bucket.id
}

output "sqs_queue_url" {
  value = aws_sqs_queue.queue.url
}

output "dynamodb_table" {
  value = aws_dynamodb_table.metadata.name
}
