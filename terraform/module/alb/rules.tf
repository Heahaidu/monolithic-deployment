resource "aws_lb_listener_rule" "backend_rule_blue" {
  listener_arn = aws_alb_listener.frontend_lb_listener.arn
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

resource "aws_lb_listener_rule" "backend_rule_green" {
  listener_arn = aws_alb_listener.frontend_lb_listener.arn
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

resource "aws_lb_listener_rule" "frontend_rule" {
  listener_arn = aws_alb_listener.backend_lb_listener.arn
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
