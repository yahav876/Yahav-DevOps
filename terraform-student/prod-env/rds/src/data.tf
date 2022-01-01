data "terraform_remote_state" "vpc" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf-circles"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/vpc"
    
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

data "aws_db_snapshot" "db" {
  db_instance_identifier = var.db.db_instance_identifier
  most_recent = true

}

data "aws_db_snapshot" "strapi-database" {
  db_instance_identifier = var.strapi.db_instance_identifier
  most_recent = true

}
