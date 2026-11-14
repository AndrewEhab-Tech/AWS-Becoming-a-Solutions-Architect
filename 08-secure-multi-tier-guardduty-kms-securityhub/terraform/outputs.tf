output "kms_key_arn" {
  value = aws_kms_key.cmk.arn
}

output "guardduty_detector_id" {
  value = aws_guardduty_detector.primary.id
}
