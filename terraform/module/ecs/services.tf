resource "aws_ecs_service" "frontend" {
  name = "frontend"

  cluster       = aws_ecs_cluster.main.id
  launch_type   = "EC2"
  desired_count = 1
  

  task_definition = aws_ecs_task_definition.frontend.arn

  network_configuration {
    security_groups = var.security_group_ids
    subnets         = var.private_subnet_ids
  }


  deployment_configuration {
    strategy             = "BLUE_GREEN"
    bake_time_in_minutes = 30
  }

  load_balancer {
    target_group_arn = var.frontend_target_group_arns.blue
    container_name   = "frontend"
    container_port   = 80

    advanced_configuration {
      alternate_target_group_arn = var.frontend_target_group_arns.green
      production_listener_rule   = var.frontend_listener_rule_arn
      role_arn                   = var.alb_role_arn
    }
  }
}

resource "aws_ecs_service" "backend" {
  name = "backend"

  cluster       = aws_ecs_cluster.main.id
  launch_type   = "EC2"
  desired_count = 1
  

  task_definition = aws_ecs_task_definition.backend.arn

  network_configuration {
    security_groups = var.security_group_ids
    subnets         = var.private_subnet_ids
  }


  deployment_configuration {
    strategy             = "BLUE_GREEN"
    bake_time_in_minutes = 30
  }

  load_balancer {
    target_group_arn = var.backend_target_group_arns.blue
    container_name   = "frontend"
    container_port   = 80

    advanced_configuration {
      alternate_target_group_arn = var.backend_target_group_arns.green
      production_listener_rule   = var.backend_listener_rule_arn
      role_arn                   = var.alb_role_arn
    }
  }
}