variable "region" {
  description = "The region to deploy the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "app_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_app_cidr" {
  description = "The CIDR block for the public subnet for load balancer"
  default     = "10.0.1.0/24"
}

variable "public_subnet_app_2_cidr" {
  description = "The CIDR block for the public subnet for nat gateway"
  default     = "10.0.2.0/24"
}

variable "private_subnet_app_1_cidr" {
  description = "The CIDR block for the private subnet for app 1"
  default     = "10.0.2.0/24"
}

variable "private_subnet_app_2_cidr" {
  description = "The CIDR block for the private subnet for app 2"
  default     = "10.0.3.0/24"
}

variable "private_subnet_app_3_cidr" {
  description = "The CIDR block for the private subnet for app 3"
  default     = "10.0.4.0/24"
}

variable "private_subnet_app_4_cidr" {
  description = "The CIDR block for the private subnet for app 4"
  default     = "10.0.5.0/24"
}


variable "cicd_vpc_cidr" {
  description = "The CIDR block for the CICD VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cicd_cidr" {
  description = "The CIDR block for the public subnet for CICD"
  default     = "10.1.1.0/24"
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

variable "frontend_health_check_path" {
  type    = string
  default = ""
}

variable "backend_health_check_path" {
  type    = string
  default = ""
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.small"
}

variable "ami_id" {
  type    = string
  default = "ami-0532be01f26a3de55"
}

variable "jenkins_instance_type" {
  type    = string
  default = "t2.small"
}

variable "backend_instance_type" {
  default = "t3.medium"
}

variable "frontend_instance_type" {
  default = "t3.medium"
}
