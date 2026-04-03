locals {
  project_name = var.project_name
  environment  = var.environment

  alb_role_name                    = "${local.project_name}-alb-role"
  app_lb_name                      = "${local.project_name}-app-lb"
  frontend_target_group_blue_name  = "${local.project_name}-frontend-tg-blue"
  frontend_target_group_green_name = "${local.project_name}-frontend-tg-green"
  backend_target_group_blue_name   = "${local.project_name}-backend-tg-blue"
  backend_target_group_green_name  = "${local.project_name}-backend-tg-green"
  alb_role_policy_name             = "${local.project_name}-alb-role-policy"
}
