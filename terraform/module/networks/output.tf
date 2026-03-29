output "app_public_subnet_ids" {
  value = [aws_subnet.public_subnet_app_1.id, aws_subnet.public_subnet_app_2.id]
}

output "imagebuilder_security_group_ids" {
  value = [aws_security_group.imagebuilder_security_group.id]
}

output "cicd_subnet_ids" {
  value = [aws_subnet.public_subnet_cicd.id]
}

output "jenkins_security_group_ids" {
  value = [aws_security_group.jenkins_security_group.id]
}

output "app_private_subnet_ids" {
  value = [aws_subnet.private_subnet_app_1.id, aws_subnet.private_subnet_app_2.id]
}

output "instance_security_group_ids" {
  value = [aws_security_group.frontend_security_group.id, aws_security_group.backend_security_group.id]
}

output "database_security_group_ids" {
  value = [aws_security_group.database_security_group.id]
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "loadbalancer_security_group_ids" {
  value = [aws_security_group.loadbalancer_security_group.id]
}

output "app_vpc_id" {
  value = aws_vpc.app_vpc.id
}

