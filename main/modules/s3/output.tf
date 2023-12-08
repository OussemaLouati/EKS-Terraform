output "bucket-arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.s3-bucket.*.arn
  sensitive   = true
}

output "bucket-names" {
  description = "S3 bucket names"
  value       = aws_s3_bucket.s3-bucket.*.id
  sensitive   = true
}