general_config = {

  region              = "us-east-2"
  backend_region      = "eu-west-3"
  lb_state            = "lb_stage"
  backend_bucket_name = "cloudteam-tf-circles"
}


allinone_asg = {

  # Auto-Scalling
  asg_name                  = "asg-all-in-one-stage"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  force_delete              = true # Bool 
  protect_from_scale_in     = true # Bool 

  # Launch-Template
  lt_name                = "circles-lt-asg-stage"
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
  availability_zone      = "us-east-2a"
  iam_instance_profile   = "arn:aws:iam::1112223334444:instance-profile/ec2-access-s3-cf"


  first_tag_key   = "env"
  first_tag_value = "stage"

  second_tag_key   = "Name"
  second_tag_value = "asg-allinone-stage"

  third_tag_key   = "backup-weekly"
  third_tag_value = "true"


}

website_asg = {

  # Auto-Scalling
  asg_name                  = "asg-website-stage"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  force_delete              = true # Bool 
  protect_from_scale_in     = true # Bool 

  # Launch-Template
  lt_name                = "circles-lt-asg-stage"
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
  availability_zone      = "us-east-2b"
  iam_instance_profile   = "arn:aws:iam::1112223334444:instance-profile/ec2-access-s3-cf"


  first_tag_key   = "env"
  first_tag_value = "stage"

  second_tag_key   = "Name"
  second_tag_value = "asg-website-stage"

  third_tag_key   = "backup-weekly"
  third_tag_value = "true"


}

filter-tags-website = {
  Name = "asg-website-stage"
  }
filter-tags-allinone = {
  Name = "asg-all-in-one-stage"
  }
