output "raw_bucket" {
  value = aws_s3_bucket.raw.id
}

output "curated_bucket" {
  value = aws_s3_bucket.curated.id
}

output "glue_database" {
  value = aws_glue_catalog_database.retail_db.name
}
