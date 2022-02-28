general_config = {

  region              = "us-east-2"
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
  iam_instance_profile      = "arn:aws:iam::294650027016:instance-profile/ec2-access-s3-cf"

  # Launch-Template
  lt_name                = "circles-lt-asg-prod"
  update_default_version = true # Bool
  ebs_optimized          = true # Bool 
  enable_monitoring      = true # Bool
  delete_on_termination  = false
  encrypted              = true
  volume_size            = "30"
  volume_type            = "gp3" # gp3/gp2 
  instance_type          = "t3a.medium"
  core_count             = 1 # Change this according to instance type!
  threads_per_core       = 2 # Change this according to instance type!
  availability_zone      = "us-east-2a"
  private_ip_address     = "10.0.1.64"

  # filter-tags-allinone = "asg-all-in-one-prod"

  first_tag_key   = "env"
  first_tag_value = "prod"

  second_tag_key   = "Name"
  second_tag_value = "asg-allinone-prod"

  third_tag_key   = "backup-daily"
  third_tag_value = "true"

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
  delete_on_termination  = false
  encrypted              = true
  volume_size            = 30
  volume_type            = "gp3" # gp3/gp2 
  instance_type          = "t3a.small"
  core_count             = 1 # Change this according to instance type!
  threads_per_core       = 2 # Change this according to instance type!
  availability_zone      = "us-east-2b"
  private_ip_address     = "10.0.2.87"
  iam_instance_profile   = "arn:aws:iam::294650027016:instance-profile/ec2-access-s3-cf"

  # filter-tags-website = "asg-website-prod"

  first_tag_key   = "env"
  first_tag_value = "prod"

  second_tag_key   = "Name"
  second_tag_value = "asg-website-prod"

  third_tag_key   = "backup-daily"
  third_tag_value = "true"

}

filter-tags-website = {
  Name = "web-site.prod"
  }
filter-tags-allinone = {
  Name = "all-in-one.prod"
  }

### Uncomment bellow & comment out above after first deploying to prod. ###

#   filter-tags-website = {
#   Name = "asg-website-prod"
#   }
# filter-tags-allinone = {
#   Name = "asg-all-in-one-prod"
#   }


