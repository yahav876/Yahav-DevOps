general_config = {

  vpc_name       = "test-circles-terraform"
  backend_region = "eu-west-3"
  vpc_cidr       = "10.0.0.0/16"
  region         = "us-east-1"

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  single_nat_gateway   = true

  first_tag_key    = "ManagedBy"
  first_tag_value  = "Terraform"
  second_tag_key   = "Environment"
  second_tag_value = "prod_qa_stage"

}

private_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
public_subnet_cidr  = ["10.0.101.0/24", "10.0.102.0/24"]


vpc_azs = ["us-east-1a", "us-east-1b"]
