resource "aws_lb_target_group" "frontend_target_group" {
  name        = local.target_group_frontend
  vpc_id      = var.app_vpc_id
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  health_check {
    path                = var.frontend_health_check_path
    timeout             = 10
    interval            = 60
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Project     = local.project_name
    Environment = local.environment
  }

}

resource "aws_lb_target_group" "backend_target_group" {
  name        = local.target_group_backend
  vpc_id      = var.app_vpc_id
  target_type = "instance"
  port        = 5000
  protocol    = "HTTP"
  health_check {
    path                = var.backend_health_check_path
    timeout             = 10
    interval            = 60
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Project     = local.project_name
    Environment = local.environment
  }

}

# resource "aws_lb_target_group_attachment" "frontend" {
#   target_group_arn = aws_lb_target_group.target_group_frontend.arn
#   target_id        = aws_instance.frontend.private_ip
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "backend" {
#   target_group_arn = aws_lb_target_group.target_group_backend.arn
#   target_id        = aws_instance.backend.private_ip
#   port             = 5000
# }
