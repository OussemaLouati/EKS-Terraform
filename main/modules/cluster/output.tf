locals{

  endpoint    =  var.db.enabled &&  ( var.db.recoverFrom.type == "SCRATCH" )  ? data.aws_db_instance.postgres.0.endpoint : "" 
  endpointS3 	 = var.db.enabled &&  ( var.db.recoverFrom.type == "S3" )   ?  data.aws_db_instance.postgresFromS3.0.endpoint : ""
  endpointSnapshot 	 = var.db.enabled &&  ( var.db.recoverFrom.type == "SNAPSHOT" ) ? data.aws_db_instance.postgresFromSnapshot.0.endpoint : ""

  finalEndpoint = coalesce(local.endpoint, local.endpointS3, local.endpointSnapshot)

}

output "cluster-endpoint" {
  description = "Cluster endpoint"
  value       = aws_eks_cluster.eks-cluster.endpoint
  sensitive   = true
}


output "cluster-cert-auth" {
  description = "Cluster certificate authority"
  value       = aws_eks_cluster.eks-cluster.certificate_authority[0].data
  sensitive   = true
}

output "cluster-oidc-issuer" {
  description = "Cluster oidc issuer"
  value       = aws_eks_cluster.eks-cluster.identity.0.oidc.0.issuer
  sensitive   = true
}

output "database-endpoint" {
  description = "Database endpoint"
  value       = var.db.enabled ? local.finalEndpoint : null
  sensitive   = true
}


output "vpc-id" {
  description = "VPC ID"
  value       = data.aws_vpc.eks.id
  sensitive   = true
}

output "node-role-arn" {
  description = "Node group role arn"
  value       = aws_iam_role.node-role.arn
  sensitive   = true
}

output "private-subnet-ids" {
  description = "Lits of IDs of private subnets"
  value       = data.aws_subnets.private.ids
  sensitive   = true
}

output "db-subnets-ids" {
  description = "Lits of IDs of private subnets of rds database"
  value       = data.aws_subnets.db.ids
  sensitive   = true
}



output "node-role-name" {
  description = "Node role name"
  value       = aws_iam_role.node-role.name
  sensitive   = true
}