data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "${var.general_config.backend_bucket_name}"
    region = "${var.general_config.backend_region}"
    key    = "Terraform/circlesup/vpc"

  }
}

