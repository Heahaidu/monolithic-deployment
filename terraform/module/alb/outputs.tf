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
