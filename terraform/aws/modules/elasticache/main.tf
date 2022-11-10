# TODO: Close b hole from the world access
resource "aws_security_group" "security_group" {
  name        = format("%s-elasticache-security-group", var.name)
  vpc_id      = var.vpc_id
  description = "Allow all inbound for Elasticache"
  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = format("%s-elasticache-subnet-group", var.name)
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Elasticache subnet group"
  }
}

resource "aws_elasticache_replication_group" "elasticache" {
  replication_group_id = format("%s-elasticache", var.name)
  description = format("%s Redis", var.name)

  security_group_ids = [aws_security_group.security_group.id]
  subnet_group_name  = aws_elasticache_subnet_group.subnet_group.name

  engine         = "redis"
  engine_version = "6.2"
  node_type      = var.machine_type
  port           = var.port

  #  transit_encryption_enabled = true
  #  auth_token                 = var.password

  num_node_groups         = 1
  replicas_per_node_group = 1
}
