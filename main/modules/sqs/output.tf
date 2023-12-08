output "sqs-arn" {
  description = "SQS queue ARN"
  value       = aws_sqs_queue.sqs-queue.0.arn
  sensitive   = true
}


