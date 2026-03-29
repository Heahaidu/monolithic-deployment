module "networks" {
  source       = "./module/networks"
  project_name = local.project_name
  environment  = local.environment
}

# module "image_builder" {
#   source = "./module/image_builder"

#   region       = var.region
#   project_name = local.project_name
#   environment  = local.environment

#   public_subnet_ids = module.networks.app_public_subnet_ids
#   security_group_ids = module.networks.imagebuilder_security_group_ids
# }

module "instances" {
  source = "./module/instances"

  project_name = local.project_name
  environment = local.environment
  region = var.region

  db_password = var.db_password

  cicd_subnet_ids = module.networks.cicd_subnet_ids

  jenkins_security_group_ids = module.networks.jenkins_security_group_ids

  instance_subnet_ids = module.networks.app_private_subnet_ids

  instance_security_group_ids = module.networks.instance_security_group_ids

  database_security_group_ids = module.networks.database_security_group_ids

  db_subnet_group_name = module.networks.db_subnet_group_name
  
}

module "alb" {
  source = "./module/alb"
  project_name = local.project_name
  environment = local.environment

  app_vpc_id = module.networks.app_vpc_id

  public_subnet_ids = module.networks.app_public_subnet_ids

  loadbalancer_security_group_ids = module.networks.loadbalancer_security_group_ids

  backend_health_check_path = ""
  frontend_health_check_path = ""
}

module "asg" {
  source = "./module/asg"

  project_name = local.project_name
  environment = local.environment

  private_subnet_ids = module.networks.app_private_subnet_ids

  frontend_target_group_arn = module.alb.frontend_target_group_arn

  backend_target_group_arn = module.alb.backend_target_group_arn

  frontend_launch_template_id = module.instances.frontend_launch_template_id

  backend_launch_template_id = module.instances.backend_launch_template_id

}

resource "aws_iam_role" "app_ec2_role" {
  name = "${local.project_name}-app-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = {
    Project     = local.project_name
    Environment = local.environment
  }
}

resource "aws_iam_role_policy" "app_ec2_ecr_policy" {
  name = "${local.project_name}-app-ecr-policy"
  role = aws_iam_role.app_ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "app_ec2_profile" {
  name = "${local.project_name}-app-ec2-profile"
  role = aws_iam_role.app_ec2_role.name
}

resource "aws_ecr_repository" "frontend" {
  name                 = "${local.project_name}/frontend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-ecr-frontend"
  }
}

resource "aws_ecr_repository" "backend" {
  name                 = "${local.project_name}/backend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-ecr-backend"
  }
}

resource "aws_ecr_lifecycle_policy" "frontend" {
  repository = aws_ecr_repository.frontend.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = { type = "expire" }
    }]
  })
}

resource "aws_ecr_lifecycle_policy" "backend" {
  repository = aws_ecr_repository.backend.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = { type = "expire" }
    }]
  })
}

data "aws_caller_identity" "current" {}