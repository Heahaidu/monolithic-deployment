locals {
  ecs_providers_name = "${var.project_name}-provider"

  frontend_family = "${var.project_name}-frontend"
  backend_family  = "${var.project_name}-backend"

  frontend_ecs_service_name = "frontend"
  backend_ecs_service_name  = "backend"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }

  env = [
    { name = "MYSQL_USER", value = var.db_username },
    { name = "MYSQL_PASSWORD", value = var.db_password },
    { name = "MYSQL_DATABASE", value = var.database },
    { name = "DB_HOST", value = var.db_endpoint },
    { name = "DB_DIALECT", value = "mysql" },
    { name = "NODE_ENV", value = "development" },
    { name = "PORT", value = 5000 },
    { name = "JWT_SECRET", value = var.jwt_secret }
  ]
}
