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
  description = format("%s-elasticache", var.name)

  replication_group_id = format("%s-elasticache", var.name)

  security_group_ids = [aws_security_group.security_group.id]
  subnet_group_name  = aws_elasticache_subnet_group.subnet_group.name

  node_type            = "cache.m4.large"
  port                 = var.port
  parameter_group_name = "default.redis3.2.cluster.on"

  automatic_failover_enabled = true

  auth_token              = var.password
  num_cache_clusters      = 2
  replicas_per_node_group = 1
}
