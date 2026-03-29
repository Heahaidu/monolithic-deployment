resource "aws_route_table" "app_public_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.app_public_route_table_name
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_app_1.id
  route_table_id = aws_route_table.app_public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_app_2.id
  route_table_id = aws_route_table.app_public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.app_nat_gateway.id
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

resource "aws_route_table_association" "cicd_public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_cicd.id
  route_table_id = aws_route_table.cicd_public_route_table.id
}
