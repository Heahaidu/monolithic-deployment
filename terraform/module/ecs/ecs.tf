resource "aws_ecs_cluster" "main" {
  name = local.ecs_name

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.main.name
      }
    }
  }

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/ecs/${var.project_name}"
  retention_in_days = 7

  tags = local.tags
}

resource "aws_ecs_capacity_provider" "main" {
  name = local.ecs_providers_name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.ecs_asg_arn
    managed_termination_protection = "ENABLE"

    managed_scaling {
      status                    = "ENABLE"
      target_capacity           = 40
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1000
    }
  }

  tags = local.tags

}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.ecs.name

  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.main.name
  }

}
