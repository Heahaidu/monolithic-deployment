locals {
  project_name                       = var.project_name
  environment                        = "dev"

  ecs_cluster_name = "${local.project_name}-ecs-cluster"
}
