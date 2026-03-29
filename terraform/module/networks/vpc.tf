
resource "aws_vpc" "app_vpc" {
  cidr_block = var.app_network.vpc_cidr
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.app_vpc_name
  }
}

resource "aws_vpc" "cicd_vpc" {
  cidr_block = var.cicd_network.vpc_cidr
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.cicd_vpc_name
  }
}