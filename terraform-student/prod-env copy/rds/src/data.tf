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

data "terraform_remote_state" "elb" {

  backend = "s3"
  config = {
    bucket = "cloudteam-tf"
    region = "${var.general_config.backend_region}"
    key = "Terraform/circlesup/alb"
    
   }
}


data "aws_db_snapshot" "db-prod" {
  db_instance_identifier = var.general_config.db-prod-identifier
  most_recent = true

}

data "aws_db_snapshot" "db-stage" {
  db_instance_identifier = var.general_config.db-stage-identifier
  most_recent = true

}

data "aws_db_snapshot" "strapi-database" {
  db_instance_identifier = var.general_config.db-strapi-identifier
  most_recent = true

}

data "aws_db_snapshot" "strapi-database-prod" {
  db_instance_identifier = var.general_config.db-strapi-prod-identifier
  most_recent = true

}

