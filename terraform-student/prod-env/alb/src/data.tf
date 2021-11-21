data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.region}"
    key = "Terraform/circlesup/vpc"
    
   }
}

data "terraform_remote_state" "ec2" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.region}"
    key = "Terraform/circlesup/ec2"
    
   }
}
