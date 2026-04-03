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

resource "aws_appautoscaling_target" "ecs_target_frontend" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.frontend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = aws_iam_role.auto_scaling_role.arn
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_frontend" {
  name               = "frontend-scale-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_frontend.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_frontend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_frontend.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.auto_scale_cpu_target
    scale_in_cooldown  = 180
    scale_out_cooldown = 180
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
    container_name   = "backend"
    container_port   = 5000

    advanced_configuration {
      alternate_target_group_arn = var.backend_target_group_arns.green
      production_listener_rule   = var.backend_listener_rule_arn
      role_arn                   = var.alb_role_arn
    }
  }
}

resource "aws_appautoscaling_target" "ecs_target_backend" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = aws_iam_role.auto_scaling_role.arn
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_backend" {
  name               = "backend-scale-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_backend.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_backend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_backend.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.auto_scale_cpu_target
    scale_in_cooldown  = 180
    scale_out_cooldown = 180
  }
}
