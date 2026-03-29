variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_vpc_id" {
  type = string
}

variable "frontend_health_check_path" {
  type    = string
}

variable "backend_health_check_path" {
  type    = string
}

variable "loadbalancer_security_group_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}