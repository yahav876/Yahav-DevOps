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


data "terraform_remote_state" "asg_bastion" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/asg_bastion"
    
   }
}
