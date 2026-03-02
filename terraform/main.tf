resource "aws_vpc" "app_vpc" {
  cidr_block = var.app_vpc_cidr
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.app_vpc_name
  }
}

resource "aws_subnet" "public_subnet_app" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.public_subnet_app_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.public_subnet_app_name
  }
}

resource "aws_subnet" "public_subnet_app_2" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.public_subnet_app_2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-public-subnet-app-2"
  }
}

resource "aws_subnet" "private_subnet_app_1" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.private_subnet_app_1_cidr
  availability_zone = "us-east-1a"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.private_subnet_app_1_name
  }
}

resource "aws_subnet" "private_subnet_app_2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.private_subnet_app_2_cidr
  availability_zone = "us-east-1b"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.private_subnet_app_2_name
  }
}

resource "aws_subnet" "private_subnet_app_3" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.private_subnet_app_3_cidr
  availability_zone = "us-east-1a"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.private_subnet_app_3_name
  }
}

resource "aws_subnet" "private_subnet_app_4" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.private_subnet_app_4_cidr
  availability_zone = "us-east-1b"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.private_subnet_app_4_name
  }
}

resource "aws_vpc" "cicd_vpc" {
  cidr_block = var.cicd_vpc_cidr
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.cicd_vpc_name
  }
}

resource "aws_subnet" "public_subnet_cicd" {
  vpc_id                  = aws_vpc.cicd_vpc.id
  cidr_block              = var.public_subnet_cicd_cidr
  map_public_ip_on_launch = true
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.public_subnet_cicd_name
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.internet_gateway_name
  }
}

resource "aws_internet_gateway" "cicd_igw" {
  vpc_id = aws_vpc.cicd_vpc.id
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-cicd-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.public_route_table_name
  }
}

resource "aws_route_table" "cicd_public_route_table" {
  vpc_id = aws_vpc.cicd_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cicd_igw.id
  }
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-cicd-public-rt"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_app.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_app_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "cicd_public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_cicd.id
  route_table_id = aws_route_table.cicd_public_route_table.id
}

resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.eip_name
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnet_app.id
  allocation_id = aws_eip.eip.id
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.nat_gateway_name
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.private_route_table_name
  }
}

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_app_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_app_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_3" {
  subnet_id      = aws_subnet.private_subnet_app_3.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_4" {
  subnet_id      = aws_subnet.private_subnet_app_4.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "loadbalancer_security_group" {
  name        = local.loadbalancer_security_group_name
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.app_vpc.id
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.loadbalancer_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_security_group_ingress_rule" {
  security_group_id = aws_security_group.loadbalancer_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "loadbalancer_security_group_egress_rule" {
  security_group_id = aws_security_group.loadbalancer_security_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "frontend_security_group" {
  vpc_id      = aws_vpc.app_vpc.id
  name        = local.frontend_security_group_name
  description = "Security group for frontend"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.frontend_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "frontend_security_group_ingress_rule" {
  security_group_id            = aws_security_group.frontend_security_group.id
  referenced_security_group_id = aws_security_group.loadbalancer_security_group.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "frontend_security_group_egress_rule" {
  security_group_id = aws_security_group.frontend_security_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "backend_security_group" {
  name        = local.backend_security_group_name
  vpc_id      = aws_vpc.app_vpc.id
  description = "Security group for backend"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.backend_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "backend_security_group_ingress_rule" {
  security_group_id            = aws_security_group.backend_security_group.id
  referenced_security_group_id = aws_security_group.loadbalancer_security_group.id
  ip_protocol                  = "tcp"
  from_port                    = 5000
  to_port                      = 5000
}

resource "aws_vpc_security_group_egress_rule" "backend_security_group_egress_rule" {
  security_group_id = aws_security_group.backend_security_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "database_security_group" {
  name        = local.database_security_group_name
  description = "Security group for database"
  vpc_id      = aws_vpc.app_vpc.id
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.database_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "database_security_group_ingress_rule" {
  security_group_id            = aws_security_group.database_security_group.id
  referenced_security_group_id = aws_security_group.backend_security_group.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "database_security_group_egress_rule" {
  security_group_id            = aws_security_group.database_security_group.id
  referenced_security_group_id = aws_security_group.backend_security_group.id
  ip_protocol                  = "-1"
}

resource "aws_security_group" "jenkins_security_group" {
  name        = "jenkins-security-group"
  vpc_id      = aws_vpc.cicd_vpc.id
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-jenkins-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_security_group_ingress_ssh" {
  security_group_id = aws_security_group.jenkins_security_group.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_security_group_ingress_ui" {
  security_group_id = aws_security_group.jenkins_security_group.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "jenkins_security_group_egress_rule" {
  security_group_id = aws_security_group.jenkins_security_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_app_3.id, aws_subnet.private_subnet_app_4.id]
}

resource "aws_lb" "app_lb" {
  name               = local.app_lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer_security_group.id]
  subnets            = [aws_subnet.public_subnet_app.id, aws_subnet.public_subnet_app_2.id]
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
      status_code  = "404"
      content_type = "text/plain"
      message_body = "Not found"
    }
  }
}

resource "aws_lb_target_group" "loadbalancer_target_group_frontend" {
  name        = local.loadbalancer_target_group_frontend
  vpc_id      = aws_vpc.app_vpc.id
  target_type = "ip"
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
}

resource "aws_lb_target_group" "loadbalancer_target_group_backend" {
  name        = local.loadbalancer_target_group_backend
  vpc_id      = aws_vpc.app_vpc.id
  target_type = "ip"
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
    target_group_arn = aws_lb_target_group.loadbalancer_target_group_backend.arn
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
    target_group_arn = aws_lb_target_group.loadbalancer_target_group_frontend.arn
  }
}

resource "aws_db_instance" "database_instance" {
  identifier              = local.database_name
  instance_class          = var.db_instance_class
  engine                  = "mysql"
  engine_version          = "8.0"
  allocated_storage       = 20
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.database_security_group.id]
  username                = var.db_username
  password                = var.db_password
  backup_retention_period = 7
  multi_az                = false
  storage_encrypted       = true
  publicly_accessible     = false
  deletion_protection     = false
  skip_final_snapshot     = true
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

resource "aws_iam_role" "jenkins_role" {
  name = "${local.project_name}-jenkins-role"
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

resource "aws_iam_role_policy" "jenkins_policy" {
  name = "${local.project_name}-jenkins-policy"
  role = aws_iam_role.jenkins_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations",
          "ssm:DescribeInstanceInformation"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "${local.project_name}-jenkins-profile"
  role = aws_iam_role.jenkins_role.name
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

resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.frontend_instance_type
  subnet_id              = aws_subnet.private_subnet_app_1.id
  vpc_security_group_ids = [aws_security_group.frontend_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.app_ec2_profile.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = file("${path.module}/user_data/frontend_setup.sh")

  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-frontend"
    Role        = "frontend"
  }
}

resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.backend_instance_type
  subnet_id              = aws_subnet.private_subnet_app_2.id
  vpc_security_group_ids = [aws_security_group.backend_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.app_ec2_profile.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = file("${path.module}/user_data/backend_setup.sh")

  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-backend"
    Role        = "backend"
  }
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = var.jenkins_instance_type
  subnet_id                   = aws_subnet.public_subnet_cicd.id
  vpc_security_group_ids      = [aws_security_group.jenkins_security_group.id]
  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name
  key_name                    = "${local.project_name}-jenkins"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = file("${path.module}/user_data/jenkins_setup.sh")

  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-jenkins"
  }
}

resource "aws_lb_target_group_attachment" "frontend" {
  target_group_arn = aws_lb_target_group.loadbalancer_target_group_frontend.arn
  target_id        = aws_instance.frontend.private_ip
  port             = 80
}

resource "aws_lb_target_group_attachment" "backend" {
  target_group_arn = aws_lb_target_group.loadbalancer_target_group_backend.arn
  target_id        = aws_instance.backend.private_ip
  port             = 5000
}

data "aws_caller_identity" "current" {}