module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

alias tfinit='terraform  -chdir=../src/ init  -backend-config=../vpc/circles/backend  -var-file=../circles/variables.tfvars -backend=true'
alias gitpull='git pull | terraform  -chdir=../../src/terraform/ plan  -var-file=../circles/variables.tfvars'
alias tfapply='terraform  -chdir=../../src/terraform/ apply --auto-approve  -var-file=../../deployment-profiles/Yahav-Test/envconfig.tfvars'
alias tfdestroy='terraform  -chdir=../../src/terraform/ destroy --auto-approve  -var-file=../../deployment-profiles/Yahav-Test/envconfig.tfvars'