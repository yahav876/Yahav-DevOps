general_config = {

  region              = "us-east-1"
  backend_region      = "eu-west-3"
  lb_state            = "lb_prod"
  backend_bucket_name = "cloudteam-tf-circles"
}

allinone_asg = {

  # Auto-Scalling
  asg_name                  = "asg-all-in-one-prod"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  force_delete              = true # Bool 
  protect_from_scale_in     = true # Bool 

  # Launch-Template
  lt_name                = "circles-lt-asg-prod"
  update_default_version = true # Bool
  ebs_optimized          = true # Bool 
  enable_monitoring      = true # Bool
  delete_on_termination  = true
  encrypted              = true
  volume_size            = "30"
  volume_type            = "gp3" # gp3/gp2 
  instance_type          = "t3a.medium"
  core_count             = 1 # Change this according to instance type!
  threads_per_core       = 2 # Change this according to instance type!
  availability_zone      = "us-east-1a"

  first_tag_key   = "env"
  first_tag_value = "prod"

  second_tag_key   = "Name"
  second_tag_value = "asg-allinone-prod"

  third_tag_key   = ""
  third_tag_value = ""


}

website_asg = {

  # Auto-Scalling
  asg_name                  = "asg-website-prod"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  force_delete              = true # Bool 
  protect_from_scale_in     = true # Bool 

  # Launch-Template
  lt_name                = "circles-lt-asg-prod"
  update_default_version = true # Bool
  ebs_optimized          = true # Bool 
  enable_monitoring      = true # Bool
  delete_on_termination  = true
  encrypted              = true
  volume_size            = 30
  volume_type            = "gp3" # gp3/gp2 
  instance_type          = "t3a.small"
  core_count             = 1 # Change this according to instance type!
  threads_per_core       = 2 # Change this according to instance type!
  availability_zone      = "us-east-1b"

  first_tag_key   = "env"
  first_tag_value = "prod"

  second_tag_key   = "Name"
  second_tag_value = "asg-website-prod"

  third_tag_key   = ""
  third_tag_value = ""


}
