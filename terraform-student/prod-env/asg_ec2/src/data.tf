data "terraform_remote_state" "ec2" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/ec2"
    
   }
}

data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/vpc"
    
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

data "terraform_remote_state" "alb" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/alb"
    
   }
}

data "aws_ssm_parameter" "linuxAmi" {
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ebs_snapshot" "all_in_one_prod" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["all in one prod"]
  }
}

data "aws_ebs_snapshot" "website_prod" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["website prod"]
  }
}




# data "aws_ebs_snapshots_ids" "all-in-one-prod" {

#   filter {
#     name = "tag:Name"
#     values = ["all in one prod"]
#   }  
# }
