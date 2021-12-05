data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/vpc"
    
   }
}

data "terraform_remote_state" "elb" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/alb"
    
   }
}

data "terraform_remote_state" "asg_bastion" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/asg_bastion"
    
   }
}



data "aws_ssm_parameter" "linuxAmi" {
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ebs_snapshot" "website-stage" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["website stage-1"]
  }
}

data "aws_ebs_snapshot" "all-in-one-stage" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["all in one stage-1"]
  }
}
