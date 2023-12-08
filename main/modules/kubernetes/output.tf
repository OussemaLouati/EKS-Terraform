output "ingestion-role" {
  description = "role to assume"
  value       = "arn:aws:iam::${var.account-id}:role/${aws_iam_role.s3-and-sqs-role.0.name}"
  sensitive   = true
}