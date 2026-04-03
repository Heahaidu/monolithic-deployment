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

resource "aws_alb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "frontend_rule" {
  listener_arn = aws_alb_listener.app_lb_listener.arn
  priority     = 20
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group_blue.arn
  }
}

resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_alb_listener.app_lb_listener.arn
  priority     = 10
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group_blue.arn
  }
}
