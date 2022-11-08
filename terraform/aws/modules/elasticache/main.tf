# TODO: Close b hole from the world access
resource "aws_security_group" "security_group" {
  name        = "elasticache"
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
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Elasticache subnet group"
  }
}

resource "aws_elasticache_replication_group" "elasticache" {
  replication_group_id          = "elasticache"
  replication_group_description = "Redis cluster for Hashicorp ElastiCache example"

  node_type            = "cache.m4.large"
  port                 = var.port
  parameter_group_name = "default.redis3.2.cluster.on"

  security_group_ids = [aws_security_group.security_group.id]
  subnet_group_name  = aws_elasticache_subnet_group.subnet_group.name

  automatic_failover_enabled = true

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = "${var.node_groups}"
  }
}
