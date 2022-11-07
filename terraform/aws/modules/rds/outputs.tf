output "host" {
  value = aws_db_instance.postgresql.address
}
output "port" {
  value = aws_db_instance.postgresql.port
}
output "database" {
  value = var.postgresql_database
}
output "username" {
  value = var.postgresql_username
}
output "password" {
  value = var.postgresql_password
}
