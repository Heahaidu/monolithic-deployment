#################################
#     fontend security group    #
#################################

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

#################################
#     backend security group    #
#################################

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

#################################
#    database security group    #
#################################

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

#################################
#     jenkins security group    #
#################################

resource "aws_security_group" "jenkins_security_group" {
  name   = "jenkins-security-group"
  vpc_id = aws_vpc.cicd_vpc.id
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

#############################
#     alb security group    #
#############################

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


######################################
#     imagebuilder security group    #
######################################

resource "aws_security_group" "imagebuilder_security_group" {
  name        = local.imagebuilder_security_group_name
  description = "Security group for image builder"
  vpc_id      = aws_vpc.app_vpc.id
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.imagebuilder_security_group_name
  }
}

resource "aws_vpc_security_group_egress_rule" "imagebuilder_security_group_egress_rule" {
  security_group_id = aws_security_group.imagebuilder_security_group.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}
