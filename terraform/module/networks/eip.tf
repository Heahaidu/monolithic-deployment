resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Project     = local.project_name
    Environment = local.environment
    Name        = local.eip_name
  }
}