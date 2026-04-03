output "frontend_target_group_arns" {
  value = {
    blue  = aws_lb_target_group.frontend_target_group_blue.arn
    green = aws_lb_target_group.frontend_target_group_green.arn
  }
}

output "backend_target_group_arns" {
  value = {
    blue  = aws_lb_target_group.backend_target_group_blue.arn
    green = aws_lb_target_group.backend_target_group_green.arn
  }
}

output "frontend_listener_rule_arn" {
  value = aws_lb_listener_rule.frontend_rule.arn
}

output "backend_listener_rule_arn" {
  value = aws_lb_listener_rule.backend_rule.arn
}

output "alb_role_arn" {
  value = aws_iam_role.alb_role.arn
}