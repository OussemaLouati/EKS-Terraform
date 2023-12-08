###################
#   PostgreSQL    #
###################


data "aws_db_instance" "postgres" {
  count                  = var.db.enabled &&  ( var.db.recoverFrom.type == "SCRATCH" )  ? 1 : 0
  db_instance_identifier = aws_db_instance.postgres.0.identifier
}

# RDS instance (Postgres)
resource "aws_db_instance" "postgres" {
  count          = var.db.enabled &&  ( var.db.recoverFrom.type == "SCRATCH" )  ? 1 : 0
  identifier     = "${var.db.db-name}-${var.Environment}"
  db_name        = var.db.db-name
  engine         = var.db.engine
  engine_version = var.db.engine-version
  instance_class = var.db.instance-class
  username       = var.db.username
  password       = var.db.password
  #parameter_group_name   = "default.${var.db.engine}${var.db.engine-version}"
  final_snapshot_identifier = "latest-snapshort-${var.Environment}"
  skip_final_snapshot     = false
  allocated_storage       = var.db.allocated-storage
  max_allocated_storage   = var.db.max-allocated-storage
  db_subnet_group_name    = module.vpc.database_subnet_group_name
  backup_retention_period = 14
  vpc_security_group_ids  = [data.aws_security_group.rds.0.id]
  delete_automated_backups = false
  tags = {
    Name        = "database/${var.db.db-name}"
    Environment = var.Environment
    CreatedBy   = "Terraform"
  } 
 

  lifecycle {
    prevent_destroy = true
  }

}


# RDS BACKUP
provider "aws" {
  region = "us-east-1"
  alias  = "replica"
}


resource "aws_db_instance_automated_backups_replication" "rds-backup" {
  count                  = var.db.enabled &&  ( var.db.recoverFrom.type == "SCRATCH" )  ? 1 : 0
  source_db_instance_arn = aws_db_instance.postgres.0.arn
  provider               = aws.replica
 
  lifecycle {
    prevent_destroy = true
  }

}