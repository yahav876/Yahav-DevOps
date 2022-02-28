variable "general_config" {
  type = any
  default = {
    lb_state            = ""
    backend_bucket_name = ""
    region              = ""
    backend_region      = ""
  }
}


variable "allinone_asg" {

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

    filter-tags-allinone = ""

    first_tag_key   = ""
    first_tag_value = ""

    second_tag_key   = ""
    second_tag_value = ""

    third_tag_key   = ""
    third_tag_value = ""

  }
}

variable "website_asg" {

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

    # Launch-Template
    lt_name                = ""
    update_default_version = "" # Bool
    ebs_optimized          = "" # Bool 
    enable_monitoring      = "" # Bool
    volume_size            = ""
    volume_type            = "" # gp3/gp2 
    instance_type          = ""
    core_count             = "" # Change this according to instance type!
    threads_per_core       = "" # Change this according to instance type!
    availability_zone      = ""
    private_ip_address     = ""
    iam_instance_profile   = ""

    filter-tags-website = ""


    first_tag_key   = ""
    first_tag_value = ""

    second_tag_key   = ""
    second_tag_value = ""

    third_tag_key   = ""
    third_tag_value = ""

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
    "Name" = ""
  }
}

variable "filter-tags-allinone" {
  type = map(any)
  default = {
    "Name" = ""
  }
}
