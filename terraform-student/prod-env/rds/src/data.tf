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

data "aws_db_snapshot" "db-prod" {
  db_instance_identifier = module.db-prod.db_instance_id
  most_recent = true
  depends_on = [
    module.db-prod
  ]
}

# data "aws_db_snapshot" "db-stage" {
#   db_instance_identifier = module.db-stage.db_instance_id
#   depends_on = [
#     module.db-stage
#   ]
# }
