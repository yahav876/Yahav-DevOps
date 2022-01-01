module "vpc" {
  source = "terraform-aws-modules/vpc/aws"


  name = var.general_config.vpc_name
  cidr = var.general_config.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr

  enable_dns_hostnames = var.general_config.enable_dns_hostnames
  enable_nat_gateway   = var.general_config.enable_nat_gateway
  enable_vpn_gateway   = var.general_config.enable_vpn_gateway
  single_nat_gateway   = var.general_config.single_nat_gateway

  tags = {
    "${var.general_config.first_tag_key}"  = "${var.general_config.first_tag_value}"
    "${var.general_config.second_tag_key}" = "${var.general_config.second_tag_value}"
  }
}

