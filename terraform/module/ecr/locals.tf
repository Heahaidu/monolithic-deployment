locals {
  frontend_ecr_name = "${var.project_name}/frontend"
  backend_ecr_name = "${var.project_name}/backend"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
