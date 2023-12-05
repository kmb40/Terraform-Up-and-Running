output "address" {
  value = aws_db_instance.prod_example.address
  description = "Connect to the database at this endpoint"
}

output "db_Name" {
  value = aws_db_instance.prod_example.db_name
  description = "The name of the database"
}

output "port" {
  value = aws_db_instance.prod_example.port
  description = "The port the database is listening on"
}