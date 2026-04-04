variable "project_name" {
  default = "monolithic"
}

variable "region" {
  description = "The region to deploy the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "ecs_ami_id" {
  description = "The AMI ID for the ECS instance"
  type        = string
  default     = "ami-0ca63348a6bc46da3"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "database" {
  default = "fcjresbar"
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}
