resource "aws_sqs_queue" "sqs-queue" {
  count                     = var.enabled ? length(var.queue-names) : 0
  name                      = var.queue-names[count.index]
  policy = data.aws_iam_policy_document.queue.json
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10


  tags = {
    Name        = "${var.cluster-name}-${var.queue-names[count.index]}-queue"
    Environment = var.Environment
    CreatedBy   = "Terraform"
  }
}

data "aws_iam_policy_document" "queue" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:*:*:*"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.bucket-arns[0]]
    }
  }
}

