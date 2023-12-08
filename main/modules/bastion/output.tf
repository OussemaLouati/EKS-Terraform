output "bastion-sec-group-id" {
  description = "Bastion security group id"
  value       = var.enabled ? data.aws_security_group.bastion.0.id : null
  sensitive   = true
}
