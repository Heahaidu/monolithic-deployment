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