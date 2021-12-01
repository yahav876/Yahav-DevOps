data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/vpc"
    
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

data "terraform_remote_state" "ec2" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/ec2"
    
   }
}


data "aws_ebs_snapshot" "bastion" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["bastion-yahav-circles"]
  }
}
# data "aws_ssm_parameter" "ubuntu-focal" {
#     name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
# }