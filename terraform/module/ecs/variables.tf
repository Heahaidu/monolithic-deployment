variable "project_name" {
  type = string
}

variable "aws_region" {
  
}

variable "environment" {
  type = string
}

variable "ecs_asg_arn" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "frontend_listener_rule_arn" {
  type = string
}

variable "backend_listener_rule_arn" {
  type = string
}

variable "alb_role_arn" {
  type = string
}

variable "frontend_target_group_arns" {
  type = object({
    blue  = string
    green = string
  })
}

variable "backend_target_group_arns" {
  type = object({
    blue  = string
    green = string
  })
}

variable "ecs_cluster_name" {
  type = string
}

variable "auto_scale_cpu_target" {
  type    = number
  default = 70
}