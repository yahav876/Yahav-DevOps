module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.general_config.vpc_name
  cidr = var.general_config.vpc_cidr

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = var.vpc_private_subnets
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24" ]
  enable_dns_hostnames = true

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

