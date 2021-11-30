data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/vpc"
    
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

data "terraform_remote_state" "asg_bastion" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/asg_bastion"
    
   }
}

data "aws_network_interface" "elb-ip-1" {
  # for_each = var.private_subnets_lb
  filter {
    name = "description"
    values = ["*${var.general_config.lb_name}*"]
    }

  filter {
    name = "subnet-id"
    values = [local.private_subnet_id_1]
  }

    depends_on = [
      module.alb
    ]
}

data "aws_network_interface" "elb-ip-2" {
  # for_each = var.private_subnets_lb
  filter {
    name = "description"
    values = ["*${var.general_config.lb_name}*"]
    }

  filter {
    name = "subnet-id"
    values = [local.private_subnet_id_2]
  }

    depends_on = [
      module.alb
    ]
}
