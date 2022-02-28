locals {
  user_data_website = <<-EOT
  #!/bin/bash
  /home/ubuntu/.npm-global/bin/pm2 restart /home/ubuntu/ecosystem.config.js

  EOT

  user_data_allinone = <<-EOT
  #!/bin/bash
  apt update -y
  systemctl restart webapp
  systemctl restart messenger
  systemctl restart analyzer
  EOT
}


module "asg-qa-1" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = var.allinone_asg.asg_name

  min_size                  = var.allinone_asg.min_size
  max_size                  = var.allinone_asg.max_size
  desired_capacity          = var.allinone_asg.desired_capacity
  wait_for_capacity_timeout = var.allinone_asg.wait_for_capacity_timeout
  health_check_type         = "EC2"
  vpc_zone_identifier       = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]
  target_group_arns         = [data.terraform_remote_state.alb.outputs.lb_target_group_allinone[0], data.terraform_remote_state.alb.outputs.lb_target_group_allinone[1], data.terraform_remote_state.alb.outputs.lb_target_group_allinone[2]]
  force_delete              = var.allinone_asg.force_delete
  protect_from_scale_in     = var.allinone_asg.protect_from_scale_in
  key_name                  = data.terraform_remote_state.asg_bastion.outputs.key_pair

  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # instance_market_options = { # Comment out to choose On-demand.  (if var env == prod , do on-demand , )
  #   market_type = "spot"
  # }

  # Launch template
  lt_name                  = var.allinone_asg.lt_name
  description              = "Launch template circles"
  update_default_version   = var.allinone_asg.update_default_version
  iam_instance_profile_arn = var.allinone_asg.iam_instance_profile
  user_data_base64         = base64encode(local.user_data_allinone) 


  use_lt    = true
  create_lt = true
  # user_data = "systemctl restart webapp && systemctl restart analyzer && systemctl restart messenger"

  image_id = data.aws_ami.allinone.image_id
  # image_id      = "ami-08153e037fe38b5c9"
  instance_type = var.allinone_asg.instance_type

  ebs_optimized     = var.allinone_asg.ebs_optimized
  enable_monitoring = var.allinone_asg.enable_monitoring

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = "${var.allinone_asg.delete_on_termination}"
        encrypted             = "${var.allinone_asg.encrypted}"
        volume_size           = "${var.allinone_asg.volume_size}"
        volume_type           = "${var.allinone_asg.volume_type}"
      }
    },
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = "${var.allinone_asg.core_count}"
    threads_per_core = "${var.allinone_asg.threads_per_core}"
  }

  credit_specification = {
    cpu_credits = "standard"
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [data.terraform_remote_state.alb.outputs.sec-group-ec2]
    }
  ]


  placement = {
    availability_zone = var.allinone_asg.availability_zone
  }

  tags = [
    {
      key                 = var.allinone_asg.first_tag_key
      value               = var.allinone_asg.first_tag_value
      propagate_at_launch = true
    },
    {
      key                 = var.allinone_asg.second_tag_key
      value               = var.allinone_asg.second_tag_value
      propagate_at_launch = true
    },
    {
      key                 = var.allinone_asg.third_tag_key
      value               = var.allinone_asg.third_tag_value
      propagate_at_launch = true
    },
  ]
}




module "asg-qa-2" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = var.website_asg.asg_name

  min_size                  = var.website_asg.min_size
  max_size                  = var.website_asg.max_size
  desired_capacity          = var.website_asg.desired_capacity
  wait_for_capacity_timeout = var.website_asg.wait_for_capacity_timeout
  health_check_type         = "EC2"
  vpc_zone_identifier       = [data.terraform_remote_state.vpc.outputs.subnets_id_private[1], data.terraform_remote_state.vpc.outputs.subnets_id_private[0]]
  target_group_arns         = [data.terraform_remote_state.alb.outputs.lb_target_group_website[0], data.terraform_remote_state.alb.outputs.lb_target_group_website[1], data.terraform_remote_state.alb.outputs.lb_target_group_website[2]]
  force_delete              = var.website_asg.force_delete
  protect_from_scale_in     = var.website_asg.protect_from_scale_in
  key_name                  = data.terraform_remote_state.asg_bastion.outputs.key_pair

  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # instance_market_options = { # Comment out to choose On-demand.
  #   market_type = "spot"

  # }

  # Launch template
  lt_name                  = var.website_asg.lt_name
  description              = "Launch template circles"
  update_default_version   = var.website_asg.update_default_version
  iam_instance_profile_arn = var.website_asg.iam_instance_profile
  user_data_base64         = base64encode(local.user_data_website) 


  use_lt    = true
  create_lt = true


  image_id          = data.aws_ami.website.image_id
  # image_id          = "ami-0ea933562b3c68f0d"
  instance_type     = var.website_asg.instance_type
  ebs_optimized     = var.website_asg.ebs_optimized
  enable_monitoring = var.website_asg.enable_monitoring


  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = var.website_asg.delete_on_termination
        encrypted             = var.website_asg.encrypted
        volume_size           = var.website_asg.volume_size
        volume_type           = var.website_asg.volume_type
      }
    },
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = 1
    threads_per_core = 2
  }

  credit_specification = {
    cpu_credits = "standard"
  }


  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [data.terraform_remote_state.alb.outputs.sec-group-ec2-stage]
    }
  ]

  placement = {
    availability_zone = var.website_asg.availability_zone
  }

  tags = [
    {
      key                 = var.website_asg.first_tag_key
      value               = var.website_asg.first_tag_value
      propagate_at_launch = true
    },
    {
      key                 = var.website_asg.second_tag_key
      value               = var.website_asg.second_tag_value
      propagate_at_launch = true
    },
    {
      key                 = var.website_asg.third_tag_key
      value               = var.website_asg.third_tag_value
      propagate_at_launch = true
    },
  ]

}
