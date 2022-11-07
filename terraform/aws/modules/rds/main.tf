resource "aws_db_instance" "postgresql" {
  identifier             = "postgresql"
  instance_class         = "db.m5.large"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "14.4"
  skip_final_snapshot    = true
  db_name                = var.postgresql_database
  username               = var.postgresql_username
  password               = var.postgresql_password
}
