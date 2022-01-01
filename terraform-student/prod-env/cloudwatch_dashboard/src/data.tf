data "terraform_remote_state" "rds_qa" {

  backend = "s3"
  config = {
    bucket =  "${var.general_config.backend_bucket_name}"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/${var.general_config.rds_state}"

  }
}

data "aws_instance" "allinone" {
  instance_tags = {
    Name = local.aws_instance_allinone
  }
}

data "aws_instance" "website" {
  instance_tags = {
    Name = local.aws_instance_website
  }
}
