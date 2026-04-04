locals {
  ecs_providers_name = "${var.project_name}-provider"

  frontend_family = "${var.project_name}-frontend"
  backend_family  = "${var.project_name}-backend"

  frontend_ecs_service_name = "frontend"
  backend_ecs_service_name = "backend"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
