output "db_instance_endpoint" {
  value       = aws_db_instance.mydb_instance.endpoint
  description = "The endpoint of the RDS MySQL database."
}

output "db_instance_username" {
  value       = aws_db_instance.mydb_instance.username
  description = "The username for the RDS MySQL database."
}