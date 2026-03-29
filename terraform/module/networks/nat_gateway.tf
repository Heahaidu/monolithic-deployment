resource "aws_nat_gateway" "app_nat_gateway" {
  subnet_id     = element([aws_subnet.public_subnet_app_1.id, aws_subnet.public_subnet_app_2.id], 0)
  allocation_id = aws_eip.eip.id
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.nat_gateway_name
  }
}
