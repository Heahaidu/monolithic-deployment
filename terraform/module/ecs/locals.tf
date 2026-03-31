locals {
  ecs_name           = "${var.project_name}-ecs"
  ecs_providers_name = "${var.project_name}-provider"

  frontend_family = "${var.project_name}-frontend"
  backend_family  = "${var.project_name}-backend"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
