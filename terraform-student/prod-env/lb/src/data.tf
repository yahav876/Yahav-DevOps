data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf-circles"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/vpc_prod"

  }
}

data "terraform_remote_state" "asg_bastion" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf-circles"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/asg_bastion_prod"
  }
}

data "terraform_remote_state" "jenkins" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf-circles"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/jenkins"
  }
}

data "aws_network_interface" "elb-ip-1" {
  filter {
    name   = "description"
    values = ["*${var.lb_website.name}*"]
  }

  filter {
    name   = "subnet-id"
    values = [local.public_subnet_id_1]
  }

  depends_on = [
    module.lb-website
  ]
}

data "aws_network_interface" "elb-ip-2" {
  filter {
    name   = "description"
    values = ["*${var.lb_website.name}*"]
  }

  filter {
    name   = "subnet-id"
    values = [local.public_subnet_id_2]
  }

  depends_on = [
    module.lb-website
  ]
}

data "aws_network_interface" "elb-ip-allinone-1" {
  filter {
    name   = "description"
    values = ["*${var.lb_allinone.name}*"]
  }

  filter {
    name   = "subnet-id"
    values = [local.public_subnet_id_1]
  }

  depends_on = [
    module.lb-allinone
  ]
}

data "aws_network_interface" "elb-ip-allinone-2" {
  filter {
    name   = "description"
    values = ["*${var.lb_allinone.name}*"]
  }

  filter {
    name   = "subnet-id"
    values = [local.public_subnet_id_2]
  }

  depends_on = [
    module.lb-allinone
  ]
}
