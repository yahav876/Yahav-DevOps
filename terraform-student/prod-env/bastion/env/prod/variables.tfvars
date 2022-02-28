general_config = {

  region                 = "us-east-2"
  backend_region         = "eu-west-3"
  backend_bucket_name    = "cloudteam-tf-circles"
  ec2_size_bastion       = "t2.micro"
  bastion_name           = "bastion-server"
  first_tag_key          = "backup-weekly"
  first_tag_value        = "true"
  key_name               = "terraform-circles2"
  eip_id                 = "eipalloc-071c2af991797984e"
  bastion_name_tag_value = "bastion-server-bastion"
  filter_ami_key         = "Name"
  filter_ami_value       = "bastion-server-prod"
}

cidr_blocks = ["0.0.0.0/0"]
