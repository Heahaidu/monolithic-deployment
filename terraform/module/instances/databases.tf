resource "aws_db_instance" "database_instance" {
  db_name                 = "fcjresbar"
  identifier              = local.database_name
  instance_class          = var.db_instance_class
  engine                  = "mysql"
  engine_version          = "8.0"
  allocated_storage       = 20
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = var.database_security_group_ids
  username                = var.db_username
  password                = var.db_password
  backup_retention_period = 7
  multi_az                = false
  storage_encrypted       = true
  publicly_accessible     = false
  deletion_protection     = false
  skip_final_snapshot     = true
}
