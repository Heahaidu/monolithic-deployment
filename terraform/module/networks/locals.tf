locals {
  project_name = var.project_name
  environment  = var.environment

  # App 
  app_vpc_name                = "${var.project_name}-app-vpc"
  cicd_vpc_name               = "${var.project_name}-cicd-vpc"
  public_subnet_app_name      = "${var.project_name}-public-subnet-app"
  private_subnet_app_1_name   = "${var.project_name}-private-subnet-app-1"
  private_subnet_app_2_name   = "${var.project_name}-private-subnet-app-2"
  private_subnet_app_3_name   = "${var.project_name}-private-subnet-app-3"
  private_subnet_app_4_name   = "${var.project_name}-private-subnet-app-4"
  app_internet_gateway_name   = "${local.project_name}-internet-gateway"
  app_public_route_table_name = "${local.project_name}-public-route-table"
  nat_gateway_name            = "${local.project_name}-nat-gateway"
  eip_name                    = "${local.project_name}-eip"
  private_route_table_name    = "${local.project_name}-private-route-table"

  # CICD
  cicd_public_subnet_name = "${var.project_name}-public-subnet-cicd"

  # SG

  frontend_security_group_name       = "${local.project_name}-frontend-security-group"
  backend_security_group_name        = "${local.project_name}-backend-security-group"
  database_security_group_name       = "${local.project_name}-database-security-group"
  loadbalancer_security_group_name   = "${local.project_name}-loadbalancer-security-group"
  imagebuilder_security_group_name = "${local.project_name}-imagebuilder-security-group"
}
