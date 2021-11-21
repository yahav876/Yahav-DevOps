resource "aws_key_pair" "master-key" {
  key_name   = "terraform-circles"
  public_key = file("/home/yahav/.ssh/terraform-circles.pub")
}

module "ec2_instance_11" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "website-prod"

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.general_config.ec2_size
  key_name               = aws_key_pair.master-key.key_name
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-elb]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "ec2_instance_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "all_in_one-prod"

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.general_config.ec2_size
  key_name               = aws_key_pair.master-key.key_name
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-elb]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[1]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "ec2_instance_3" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "all_in_one-test"

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.general_config.ec2_size
  key_name               = aws_key_pair.master-key.key_name
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-elb]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[2]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance_4" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "website-test"

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.general_config.ec2_size
  key_name               = aws_key_pair.master-key.key_name
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-elb]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[3]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

