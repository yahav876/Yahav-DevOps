variable "general_config" {
  type = any
  default = {
    lb_state            = ""
    backend_bucket_name = ""
    region              = ""
    backend_region      = ""
  }
}


variable "jenkins_asg" {

  type = any
  default = {

    # Auto-Scalling
    asg_name                  = ""
    min_size                  = ""
    max_size                  = ""
    desired_capacity          = ""
    wait_for_capacity_timeout = ""
    force_delete              = "" # Bool 
    protect_from_scale_in     = "" # Bool 
    iam_instance_profile      = ""

    # Launch-Template
    lt_name                = ""
    update_default_version = "" # Bool
    ebs_optimized          = "" # Bool 
    enable_monitoring      = "" # Bool
    private_ip_address     = ""

    delete_on_termination = ""
    encrypted             = ""

    volume_size       = ""
    volume_type       = "" # gp3/gp2 
    instance_type     = ""
    core_count        = "" # Change this according to instance type!
    threads_per_core  = "" # Change this according to instance type!
    availability_zone = ""

    first_tag_key   = ""
    first_tag_value = ""

    second_tag_key   = ""
    second_tag_value = ""

    third_tag_key   = ""
    third_tag_value = ""

  }
}

variable "jenkins_asg_slaves" {

  type = any
  default = {

    # Auto-Scalling
    asg_name                  = ""
    min_size                  = ""
    max_size                  = ""
    desired_capacity          = ""
    wait_for_capacity_timeout = ""
    force_delete              = "" # Bool 
    protect_from_scale_in     = "" # Bool 
    iam_instance_profile      = ""

    # Launch-Template
    lt_name                = ""
    update_default_version = "" # Bool
    ebs_optimized          = "" # Bool 
    enable_monitoring      = "" # Bool
    private_ip_address     = ""
    associate_public_ip_address = "" # Bool


    delete_on_termination = ""
    encrypted             = ""

    volume_size       = ""
    volume_type       = "" # gp3/gp2 
    instance_type     = ""
    core_count        = "" # Change this according to instance type!
    threads_per_core  = "" # Change this according to instance type!
    availability_zone = ""

    first_tag_key   = ""
    first_tag_value = ""

    second_tag_key   = ""
    second_tag_value = ""

    third_tag_key   = ""
    third_tag_value = ""

  }
}

variable "lb_jenkins" {
  type = any
  default = {
    name               = ""
    load_balancer_type = ""
    backend_port_1     = ""
    backend_port_2     = ""
    backend_port_3     = ""
    certificate_arn    = ""
    port_1             = ""
    port_2             = ""
    port_3             = ""
    tag_key            = ""
    tag_value          = ""

  }
}
variable "sec_group_jenkins" {
  type = any
  default = {
    ingress_cidr_blocks = ""
    ingress_rules       = ""
    egress_rules        = ""
    name                = ""
  }
}


variable "subnets_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "filter-tags-website" {
  type = map(any)
  default = {
    "Name" = "web-site.prod"
  }
}

variable "filter-tags-allinone" {
  type = map(any)
  default = {
    "Name" = "all-in-one.prod"
  }
}
