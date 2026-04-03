variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "desired_capacity" { 
  type = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 5
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

variable "frontend_target_group_arns" {
  type = object({
    blue = string
    green = string
  })
}

variable "backend_target_group_arns" {
  type = object({
    blue = string
    green = string
  })
}

variable "launch_template_id" {
  type = string
}