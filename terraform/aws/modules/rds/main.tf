# TODO: Close b hole from the world access
resource "aws_security_group" "security_group" {
  name        = format("%s-rds-security-group", var.name)
  vpc_id      = var.vpc_id
  description = "Allow all inbound for Postgres"
  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = format("%s-rds-subnet-group", var.name)
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "Postgres subnet group"
  }
  )
}

resource "aws_db_instance" "postgresql" {
  identifier             = format("%s-rds", var.name)
  instance_class         = var.machine_type
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "14.4"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  port                   = var.port
  db_name                = var.database
  username               = var.username
  password               = var.password
  tags                   = var.tags
}
