output "host" {
  value = aws_elasticache_replication_group.elasticache.configuration_endpoint_address
}
output "port" {
  value = aws_elasticache_replication_group.elasticache.port
}
output "password" {
  value = aws_elasticache_replication_group.elasticache.auth_token
}
