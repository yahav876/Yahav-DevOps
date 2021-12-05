module "vpc" {
  source = "terraform-aws-modules/vpc/aws"


  name = var.general_config.vpc_name
  cidr = var.general_config.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr
  enable_dns_hostnames = true

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

