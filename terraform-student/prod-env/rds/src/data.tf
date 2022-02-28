data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf-circles"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/vpc_prod"
    
   }
}
data "terraform_remote_state" "lb" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf-circles"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/${var.general_config.lb_state}"
    
   }
}

data "terraform_remote_state" "bastion" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf-circles"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/${var.general_config.bastion_state}"
    
   }
}


data "aws_db_cluster_snapshot" "latest_db_snapshot" {
  db_cluster_identifier = var.db.db_cluster_identifier
  most_recent            = true
}

data "aws_db_cluster_snapshot" "latest_strapi_snapshot" {
  db_cluster_identifier = var.strapi.db_cluster_identifier
  most_recent            = true
}