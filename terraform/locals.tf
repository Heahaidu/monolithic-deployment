locals {
  project_name                       = "monolithic"
  environment                        = "dev"

  ecs_cluster_name = "${local.project_name}-ecs-cluster"
}
