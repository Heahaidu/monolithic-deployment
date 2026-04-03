# #################
# #    frontend   #  
# #################

# # ASG -> Policy scale out -> CloudWatch Metric -> Policy scale in -> CloudWatch Metric

# resource "aws_autoscaling_group" "frontend_asg" {
#   name = "${var.project_name}-frontend-asg"

#   min_size = var.min_size
#   max_size = var.max_size
#   desired_capacity = var.desired_capacity

#   # Multi AZ
#   vpc_zone_identifier = var.private_subnet_ids

#   # Target group
#   target_group_arns = [ var.backend_target_group_arn ]

#   health_check_grace_period = 300
#   health_check_type = "ELB"

#   launch_template {
#     id = var.frontend_launch_template_id
#     version = "$Latest"
#   }

#   instance_refresh {
#     strategy = "Rolling"
#     preferences {
#       min_healthy_percentage = 80
#       instance_warmup = 300
#     }
#   }
# }

# resource "aws_autoscaling_policy" "frontend_scale_out" {
#   name = "${var.project_name}-frontend-scale-out"
#   autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
#   adjustment_type = "ChangeInCapacity"
#   scaling_adjustment = 1
#   cooldown = 300
# }

# resource "aws_cloudwatch_metric_alarm" "frontend_alarm_cpu_high" {
#   alarm_name  = "${var.project_name}-frontend-alarm-cpu-high"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods = 2
#   metric_name = "CPUUtilization"
#   namespace = "AWS/EC2"
#   period = 120
#   statistic = "Average"
#   threshold = var.max_threshod

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.frontend_asg.name
#   }

#   alarm_actions = [aws_autoscaling_policy.frontend_scale_out.arn]
# }

# resource "aws_autoscaling_policy" "frontend_scale_in" {
#   name                   = "${var.project_name}-frontend-scale-in"
#   autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = -1     
#   cooldown               = 300
# }

# resource "aws_cloudwatch_metric_alarm" "frontend_cpu_low" {
#   alarm_name          = "${var.project_name}-frontend-alarm-cpu-low"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = var.min_threshod

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.frontend_asg.name
#   }

#   alarm_actions = [aws_autoscaling_policy.frontend_scale_in.arn]
# }

# #################
# #    backend    #  
# #################

# # ASG -> Policy scale out -> CloudWatch Metric -> Policy scale in -> CloudWatch Metric

# resource "aws_autoscaling_group" "backend_asg" {
#   name = "${var.project_name}-backend-asg"

#   min_size = var.min_size
#   max_size = var.max_size
#   desired_capacity = var.desired_capacity

#     # Multi AZ
#   vpc_zone_identifier = var.private_subnet_ids

#   # Target group
#   target_group_arns = [ var.backend_target_group_arn ]

#   health_check_grace_period = 300
#   health_check_type = "ELB"

#   launch_template {
#     id = var.backend_launch_template_id
#     version = "$Latest"
#   }

#   instance_refresh {
#     strategy = "Rolling"
#     preferences {
#       min_healthy_percentage = 80
#       instance_warmup = 300
#     }
#   }
# }

# resource "aws_autoscaling_policy" "backend_scale_out" {
#   name = "${var.project_name}-backend-scale-out"
#   autoscaling_group_name = aws_autoscaling_group.backend_asg.name
#   adjustment_type = "ChangeInCapacity"
#   scaling_adjustment = 1
#   cooldown = 300
# }

# resource "aws_cloudwatch_metric_alarm" "backend_alarm_cpu_high" {
#   alarm_name  = "${var.project_name}-backend-alarm-cpu-high"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods = 2
#   metric_name = "CPUUtilization"
#   namespace = "AWS/EC2"
#   period = 120
#   statistic = "Average"
#   threshold = var.max_threshod

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.backend_asg.name
#   }

#   alarm_actions = [aws_autoscaling_policy.backend_scale_out.arn]
# }

# resource "aws_autoscaling_policy" "backend_scale_in" {
#   name                   = "${var.project_name}-backend-scale-in"
#   autoscaling_group_name = aws_autoscaling_group.backend_asg.name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = -1     
#   cooldown               = 300
# }

# resource "aws_cloudwatch_metric_alarm" "backend_cpu_low" {
#   alarm_name          = "${var.project_name}-backend-alarm-cpu-low"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = var.min_threshod

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.backend_asg.name
#   }

#   alarm_actions = [aws_autoscaling_policy.backend_scale_in.arn]
# }

#############
#    ECS    #  
#############

resource "aws_autoscaling_group" "ecs" {
  name = local.ecs_asg_name

  vpc_zone_identifier = var.private_subnet_ids

  health_check_type = "EC2"
  health_check_grace_period = 300

  min_size = var.min_size
  max_size = var.max_size

  desired_capacity = var.desired_capacity

  protect_from_scale_in = false

  launch_template {
    id = var.launch_template_id
    version = "$Latest"
  }

  initial_lifecycle_hook {
    name                 = "ecs-instance-terminating"
    default_result       = "ABANDON"
    heartbeat_timeout    = 900  
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize", 
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

}