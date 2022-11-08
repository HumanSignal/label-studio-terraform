variable "vpc_id" {
}
variable "subnet_ids" {
  type = list(string)
}

resource "aws_security_group" "security_group" {
  name        = "postgresql"
  vpc_id      = var.vpc_id
  description = "Allow all inbound for Postgres"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Postgres subnet group"
  }
}

resource "aws_db_instance" "postgresql" {
  identifier             = "postgresql"
  instance_class         = "db.m5.large"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "14.4"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  db_name                = var.postgresql_database
  username               = var.postgresql_username
  password               = var.postgresql_password
}
