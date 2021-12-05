# resource "aws_ami" "all-in-one-prod" {
#   name                = "all-in-one-prod"
#   virtualization_type = "hvm"
#   root_device_name    = "/dev/xvda"
#   ena_support         = true

#   ebs_block_device {
#     device_name = "/dev/xvda"
#     snapshot_id = data.aws_ebs_snapshot.all_in_one_prod.id
#   }
# }

# resource "aws_ami" "website-prod" {
#   name                = "website-prod"
#   virtualization_type = "hvm"
#   root_device_name    = "/dev/xvda"
#   ena_support         = true

#   ebs_block_device {
#     device_name = "/dev/xvda"
#     snapshot_id = data.aws_ebs_snapshot.website_prod.id
#   }
# }


module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = "asg-allinone-prod"

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  # vpc_zone_identifier       = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]
  vpc_zone_identifier   = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0],data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]
  target_group_arns     = [data.terraform_remote_state.alb.outputs.lb_target_group[0], data.terraform_remote_state.alb.outputs.lb_target_group[1], data.terraform_remote_state.alb.outputs.lb_target_group[2], data.terraform_remote_state.alb.outputs.lb_target_group[5]]
  force_delete          = true
  protect_from_scale_in = true
  key_name = data.terraform_remote_state.asg_bastion.outputs.key_pair

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

  # Launch template
  lt_name                = "circles-lt-asg"
  description            = "Launch template circles"
  update_default_version = true

  use_lt    = true
  create_lt = true

  image_id = data.aws_ami.allinone.image_id
  # image_id          = data.aws_ssm_parameter.linuxAmi.value
  instance_type = var.general_config.asg_ec2_size-allinone
  # instance_type     = "t3a.medium"

  ebs_optimized     = true
  enable_monitoring = true

  #   target_group_arns = [data.terraform_remote_state.alb.outputs.lb_arn]

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = var.general_config.volume_size_all-in-one
        volume_type           = "gp3"
      }
      },
    #    {
    #   device_name = "/dev/sda1"
    #   no_device   = 1
    #   ebs = {
    #     delete_on_termination = true
    #     encrypted             = true
    #     volume_size           = 30
    #     volume_type           = "gp3"
    #   }
    # }
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
      security_groups       = [data.terraform_remote_state.alb.outputs.sec-group-ec2]
    }
    # {
    #   delete_on_termination = true
    #   description           = "eth1"
    #   device_index          = 1
    #   security_groups       = [data.terraform_remote_state.alb.outputs.sec-group-ec2]
    # }
  ]

  placement = {
    availability_zone = "us-east-2a"
    # "us-east-2a"
  }

  tags = [
    {
      key                 = "env"
      value               = "prod"
      propagate_at_launch = true
    },
    {
      key                 = "backup-daily"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "all-in-one.prod-terraform"
      propagate_at_launch = true
    },
    {
      key                 = "Create_Auto_Alarms"
      value               = "2021-11-30 11:04:25.685576"
      propagate_at_launch = true
    },
  ]

  #   tags_as_map = {
  #     extra_tag1 = "extra_value1"
  #     extra_tag2 = "extra_value2"
  #   }
}



module "asg-2" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = "asg-website-prod"

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  # vpc_zone_identifier       = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]
  vpc_zone_identifier   = [data.terraform_remote_state.vpc.outputs.subnets_id_private[1],data.terraform_remote_state.vpc.outputs.subnets_id_private[0]]
  target_group_arns     = [data.terraform_remote_state.alb.outputs.lb_target_group[5], data.terraform_remote_state.alb.outputs.lb_target_group[0], data.terraform_remote_state.alb.outputs.lb_target_group[3], data.terraform_remote_state.alb.outputs.lb_target_group[4]]
  force_delete          = true
  protect_from_scale_in = true
  key_name = data.terraform_remote_state.asg_bastion.outputs.key_pair

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

  # Launch template
  lt_name                = "circles-lt-asg"
  description            = "Launch template circles"
  update_default_version = true

  use_lt    = true
  create_lt = true

  image_id          = data.aws_ami.website.image_id
  # image_id          = "ami-05e689e027345dda7"
  instance_type     = var.general_config.asg_ec2_size-website
  ebs_optimized     = true
  enable_monitoring = true

  #   target_group_arns = [data.terraform_remote_state.alb.outputs.lb_arn]

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           =  var.general_config.volume_size-website
        volume_type           = "gp3"
      }
      },
    #    {
    #   device_name = "/dev/sda1"
    #   no_device   = 1
    #   ebs = {
    #     delete_on_termination = true
    #     encrypted             = true
    #     volume_size           = 30
    #     volume_type           = "gp3"
    #   }
    # }
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
    # {
    #   delete_on_termination = true
    #   description           = "eth1"
    #   device_index          = 1
    #   security_groups       = [data.terraform_remote_state.alb.outputs.sec-group-ec2]
    # }
  ]

  placement = {
    availability_zone = "us-east-2b"
    # "us-east-2a"
  }

  tags = [
    {
      key                 = "env"
      value               = "production"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "web-site.prod-terraform"
      propagate_at_launch = true
    },
    {
      key                 = "backup-daily"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "aws:ec2launchtemplate:id"
      value               = "lt-0196fcd158ac0b11c"
      propagate_at_launch = true
    },
    {
      key                 = "aws:ec2launchtemplate:version"
      value               = "1"
      propagate_at_launch = true
    },
    {
      key                 = "Create_Auto_Alarms"
      value               = "2021-11-30 11:05:35.961315"
      propagate_at_launch = true
    },
  ]

  #   tags_as_map = {
  #     extra_tag1 = "extra_value1"
  #     extra_tag2 = "extra_value2"
  #   }
}
