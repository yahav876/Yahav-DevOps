data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "${var.general_config.backend_bucket_name}"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/vpc_prod"

  }
}

data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["self"]

  dynamic "filter" {
    for_each = var.filter-tags-bastion
    iterator = tag

    content {
      name   = "tag:${tag.key}"
      values = ["${tag.value}"]
    }
  }
}