output "launch_template_id" {
  value = aws_launch_template.launch_template.id
}

output "db_endpoint" {
  value = aws_db_instance.database_instance.address
}