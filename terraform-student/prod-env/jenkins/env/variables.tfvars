general_config = {

  region              = "us-east-2"
  backend_region      = "eu-west-3"
  lb_state            = "lb_qa_and_stage"
  backend_bucket_name = "cloudteam-tf-circles"

}

jenkins_asg = {

  # Auto-Scalling
  asg_name                  = "asg-jenkins"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  force_delete              = true # Bool 
  protect_from_scale_in     = true # Bool 
  iam_instance_profile      = "arn:aws:iam::1112223334444:instance-profile/ec2-access-s3-cf"

  # Launch-Template
  lt_name                = "circles-lt-jenkins"
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

  first_tag_key   = "env"
  first_tag_value = "qa"

  second_tag_key   = "Name"
  second_tag_value = "asg-jenkins"

  third_tag_key   = "backup-weekly"
  third_tag_value = "true"

}

jenkins_asg_slaves = {

  # Auto-Scalling
  asg_name                  = "asg-jenkins-slaves"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  force_delete              = true # Bool 
  protect_from_scale_in     = true # Bool 
  iam_instance_profile      = "arn:aws:iam::1112223334444:instance-profile/ec2-access-s3-cf"
  associate_public_ip_address = true # Bool

  # Launch-Template
  lt_name                = "circles-lt-jenkins-slaves"
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
  private_ip_address     = "10.0.1.65"

  first_tag_key   = "env"
  first_tag_value = "qa"

  second_tag_key   = "Name"
  second_tag_value = "asg-jenkins-slaves"

  third_tag_key   = "backup-weekly"
  third_tag_value = "true"

}

lb_jenkins = {

  name               = "jenkins-lb"
  load_balancer_type = "network"
  backend_port_1     = "8080"
  backend_port_2     = "1337"
  backend_port_3     = "22"
  certificate_arn    = "arn:aws:acm:us-east-2:1112223334444:certificate/5ceef26f-a74e-46cc-8d62-d8f7dacde7f1"
  port_1             = "8080"
  port_2             = "1337"
  port_3             = "8080"
  tag_key            = "ManagedBy"
  tag_value          = "Terraform"

}

sec_group_jenkins = {

    ingress_cidr_blocks = ["0.0.0.0/0"]
    ingress_rules       = ["ssh-tcp"]
    egress_rules        = ["all-all"]
    name                = "sec-group-jenkins"
  
}