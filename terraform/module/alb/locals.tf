locals {
  project_name = var.project_name
  environment  = var.environment

  app_lb_name                        = "${local.project_name}-app-lb"
  target_group_frontend = "${local.project_name}-frontend"
  target_group_backend  = "${local.project_name}-backend"
  
}
