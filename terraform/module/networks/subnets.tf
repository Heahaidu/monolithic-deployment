###################
#       cicd      #
###################

resource "aws_subnet" "public_subnet_cicd" {
  vpc_id                  = aws_vpc.cicd_vpc.id
  cidr_block              = var.cicd_network.public_subnet_1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.cicd_public_subnet_name
  }
}

############################
#     app public subnet    #
############################

resource "aws_subnet" "public_subnet_app_1" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.app_network.public_subnet_1_cidr
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
  cidr_block              = var.app_network.public_subnet_2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = "${local.project_name}-public-subnet-app-2"
  }
}

############################
#    app private subnet    #
############################

resource "aws_subnet" "private_subnet_app_1" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.app_network.private_subnet_1_cidr
  availability_zone = "us-east-1a"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.private_subnet_app_1_name
  }
}

resource "aws_subnet" "private_subnet_app_2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.app_network.private_subnet_2_cidr
  availability_zone = "us-east-1b"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.private_subnet_app_2_name
  }
}

resource "aws_subnet" "private_subnet_app_3" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.app_network.private_subnet_3_cidr
  availability_zone = "us-east-1a"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.private_subnet_app_3_name
  }
}

resource "aws_subnet" "private_subnet_app_4" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.app_network.private_subnet_4_cidr
  availability_zone = "us-east-1b"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.private_subnet_app_4_name
  }
}
