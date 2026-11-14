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
resource "aws_s3_bucket" "raw_bucket" {
  bucket_prefix = "saa-p2-raw-images-"
  force_destroy = true
}

resource "aws_s3_bucket" "processed_bucket" {
  bucket_prefix = "saa-p2-processed-images-"
  force_destroy = true
}

# --- SQS & DLQ ---
resource "aws_sqs_queue" "dlq" {
  name                      = "saa-p2-image-dlq"
  message_retention_seconds = 1209600 # 14 days
}

resource "aws_sqs_queue" "queue" {
  name                       = "saa-p2-image-queue"
  visibility_timeout_seconds = 300
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}

# --- S3 Event Notification to SQS ---
resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.queue.id
  policy    = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
      Action    = "sqs:SendMessage"
      Resource  = aws_sqs_queue.queue.arn
      Condition = {
        ArnEquals = { "aws:SourceArn" = aws_s3_bucket.raw_bucket.arn }
      }
    }]
  })
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.raw_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".jpg"
  }
  depends_on = [aws_sqs_queue_policy.sqs_policy]
}

# --- DynamoDB Metadata Table ---
resource "aws_dynamodb_table" "metadata" {
  name         = "saa-p2-image-metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ImageId"

  attribute {
    name = "ImageId"
    type = "S"
  }
}

# --- SNS Notification Topic ---
resource "aws_sns_topic" "alerts" {
  name = "saa-p2-pipeline-alerts"
}

# --- IAM Role for Lambda ---
resource "aws_iam_role" "lambda_role" {
  name = "saa-p2-lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_pipeline_policy" {
  name = "saa-p2-lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject"]
        Resource = ["${aws_s3_bucket.raw_bucket.arn}/*", "${aws_s3_bucket.processed_bucket.arn}/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:GetItem"]
        Resource = aws_dynamodb_table.metadata.arn
      },
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = aws_sns_topic.alerts.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_custom" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_pipeline_policy.arn
}
