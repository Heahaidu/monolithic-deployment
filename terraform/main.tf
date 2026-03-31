module "networks" {
  source       = "./module/networks"
  project_name = local.project_name
  environment  = local.environment
}

module "instances" {
  source = "./module/instances"

  project_name = local.project_name
  environment  = local.environment
  region       = var.region

  db_password = var.db_password

  cicd_subnet_ids = module.networks.cicd_subnet_ids

  jenkins_security_group_ids = module.networks.jenkins_security_group_ids

  instance_subnet_ids = module.networks.app_private_subnet_ids

  instance_security_group_ids = module.networks.instance_security_group_ids

  database_security_group_ids = module.networks.database_security_group_ids

  db_subnet_group_name = module.networks.db_subnet_group_name

}

module "alb" {
  source       = "./module/alb"
  project_name = local.project_name
  environment  = local.environment

  app_vpc_id = module.networks.app_vpc_id

  public_subnet_ids = module.networks.app_public_subnet_ids

  loadbalancer_security_group_ids = module.networks.loadbalancer_security_group_ids

  backend_health_check_path  = ""
  frontend_health_check_path = ""
}

module "asg" {
  source = "./module/asg"

  project_name = local.project_name
  environment  = local.environment

  private_subnet_ids = module.networks.app_private_subnet_ids

  frontend_target_group_arns = module.alb.frontend_target_group_arns

  backend_target_group_arns = module.alb.backend_target_group_arns

  launch_template_id = module.instances.launch_template_id
}

module "ecr" {
  source = "./module/ecr"

  project_name = local.project_name
  environment  = local.environment
}

module "ecs" {
  source = "./module/ecs"

  project_name = local.project_name
  environment  = local.environment

  ecs_asg_arn = module.asg.ecs_asg_arn

  security_group_ids = []

  private_subnet_ids = []
  alb_role_arn = ""

  frontend_target_group_arns = module.alb.frontend_target_group_arns
  backend_target_group_arns = module.alb.backend_target_group_arns

  frontend_listener_rule_arn = ""

  backend_listener_rule_arn = ""

}

data "aws_caller_identity" "current" {}
