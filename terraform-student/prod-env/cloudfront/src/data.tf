data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf-circles"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/vpc_prod"

  }
}

