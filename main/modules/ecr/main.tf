
# API 
resource "aws_ecr_repository" "repository" {
  count                = var.enabled ? length(var.repository-names) : 0
  name                 = "${var.project-prefix}/${var.repository-names[count.index]}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Environment = var.Environment
    CreatedBy   = "Terraform"
    Name        = "${var.cluster-name}-${var.repository-names[count.index]}-repository"
  }
}
