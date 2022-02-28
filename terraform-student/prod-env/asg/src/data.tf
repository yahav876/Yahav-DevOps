data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "${var.general_config.backend_bucket_name}"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/vpc_prod"

  }
}

data "terraform_remote_state" "asg_bastion" {

  backend = "s3"
  config = {
    bucket = "${var.general_config.backend_bucket_name}"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/asg_bastion_prod" # make var for state files per env.

  }
}

data "terraform_remote_state" "alb" {

  backend = "s3"
  config = {
    bucket = "${var.general_config.backend_bucket_name}"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/${var.general_config.lb_state}"

  }
}


data "aws_ami" "website" {
  most_recent = true
  owners      = ["self"]

  dynamic "filter" {
    for_each = var.filter-tags-website
    iterator = tag

    content {
      name   = "tag:${tag.key}"
      values = ["${tag.value}"]
    }
  }
}

data "aws_ami" "allinone" {
  most_recent = true
  owners      = ["self"]

  dynamic "filter" {
    for_each = var.filter-tags-allinone
    iterator = tag

    content {
      name   = "tag:${tag.key}"
      values = ["${tag.value}"]
    }
  }
}



