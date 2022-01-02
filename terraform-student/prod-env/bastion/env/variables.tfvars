general_config = {

  region              = "us-east-1"
  backend_region      = "eu-west-3"
  backend_bucket_name = "cloudteam-tf-circles"
  ec2_size_bastion    = "t2.micro"
  bastion_name        = "bastion-server"
  first_tag_key       = "Project"
  first_tag_value     = "terraform"
  key_name            = "terraform-circles2"
}

cidr_blocks         = ["0.0.0.0/0"]
