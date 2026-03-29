resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.app_internet_gateway_name
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
