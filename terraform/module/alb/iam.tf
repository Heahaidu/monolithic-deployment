resource "aws_iam_role" "alb_role" {
  name = local.alb_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "alb_role_policy" {
  name = local.alb_role_policy_name
  role = aws_iam_role.alb_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "AmazonEC2ContainerServiceRole",
        "Effect" : "Allow",
        "Action" : [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:Describe*",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "ELBReadOperations",
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "TargetGroupOperations",
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ],
        "Resource" : "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
      },
      {
        "Sid" : "ALBModifyListeners",
        "Effect" : "Allow",
        "Action" : "elasticloadbalancing:ModifyListener",
        "Resource" : [
          "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*"
        ]
      },
      {
        "Sid" : "NLBModifyListeners",
        "Effect" : "Allow",
        "Action" : "elasticloadbalancing:ModifyListener",
        "Resource" : [
          "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*"
        ]
      },
      {
        "Sid" : "ALBModifyRules",
        "Effect" : "Allow",
        "Action" : "elasticloadbalancing:ModifyRule",
        "Resource" : [
          "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*/*"
        ]
      }
    ]
  })
}

// AmazonECSInfrastructureRolePolicyForLoadBalancers
