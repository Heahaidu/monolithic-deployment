variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "desired_capacity" { 
  type = number
  default = 2 
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 5
}

variable "frontend_launch_template_id" {
  type = string
}

variable "backend_launch_template_id" {
  type = string
}


variable "max_threshod" {
  type = number
  default = 70
}

variable "min_threshod" {
  type = number
  default = 30
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "frontend_target_group_arn" {
  type = string
}

variable "backend_target_group_arn" {
  type = string
}