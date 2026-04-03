variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.small"
}

variable "ami_id" {
  type    = string
  default = "ami-0992dd78fde27ac81"
}

variable "jenkins_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "cicd_subnet_ids" {
  type = list(string)
}

variable "jenkins_security_group_ids" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "instance_security_group_ids" {
  type = list(string)
}

variable "instance_subnet_ids" {
  type = list(string)
}

variable "database_security_group_ids" {
  type = list(string)
}

variable "db_subnet_group_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_ami_id" {
  type = string
}