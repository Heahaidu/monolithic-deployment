resource "aws_lb" "app_lb" {
  name               = local.app_lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.loadbalancer_security_group_ids
  subnets            = var.public_subnet_ids
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.app_lb_name
  }
}

resource "aws_alb_listener" "frontend_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }
}

resource "aws_alb_listener" "backend_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }
}