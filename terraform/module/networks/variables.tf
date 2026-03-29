variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_network" {
  type = object({
    vpc_cidr              = string
    public_subnet_1_cidr  = string
    public_subnet_2_cidr  = string
    private_subnet_1_cidr = string
    private_subnet_2_cidr = string
    private_subnet_3_cidr = string
    private_subnet_4_cidr = string
  })
  default = {
    vpc_cidr              = "20.0.0.0/16"
    public_subnet_1_cidr  = "20.0.1.0/24"
    public_subnet_2_cidr  = "20.0.2.0/24"
    private_subnet_1_cidr = "20.0.3.0/24"
    private_subnet_2_cidr = "20.0.4.0/24"
    private_subnet_3_cidr = "20.0.5.0/24"
    private_subnet_4_cidr = "20.0.6.0/24"
  }
}

variable "cicd_network" {
  type = object({
    vpc_cidr              = string
    public_subnet_1_cidr  = string
  })
  default = {
    vpc_cidr              = "20.1.0.0/16"
    public_subnet_1_cidr  = "20.1.1.0/24"
  }
}
