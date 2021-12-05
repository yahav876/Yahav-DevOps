general_config = {

  vpc_name       = "test-circles-terraform"
  backend_region = "eu-west-3"
  vpc_cidr       = "10.0.0.0/16"
}

private_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
public_subnet_cidr  = ["10.0.101.0/24", "10.0.102.0/24"]


vpc_azs = ["us-east-2a", "us-east-2b"]
