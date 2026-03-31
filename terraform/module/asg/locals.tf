locals {
  ecs_asg_name = "${var.project_name}-ecs-asg"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
