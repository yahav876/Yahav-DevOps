resource "aws_key_pair" "master-key" {
  key_name   = "terraform-circles"
  public_key = file("/home/yahav/.ssh/terraform-circles.pub")
}

module "ec2_instance_11" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "website-prod"

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.general_config.ec2_size
  key_name               = aws_key_pair.master-key.key_name
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-elb]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "ec2_instance_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "all_in_one-prod"

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.general_config.ec2_size
  key_name               = aws_key_pair.master-key.key_name
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-elb]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[1]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "ec2_instance_3" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "all_in_one-test"

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.general_config.ec2_size
  key_name               = aws_key_pair.master-key.key_name
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-elb]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[2]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance_4" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "website-test"

  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.general_config.ec2_size
  key_name               = aws_key_pair.master-key.key_name
  monitoring             = true
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sec-group-elb]
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id_private[3]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "bastion" {
  source                  = "Guimove/bastion/aws"
  bucket_name             = var.general_config.s3_bucket_name
  region                  = var.general_config.region
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  is_lb_private           = "false"
  bastion_host_key_pair   = aws_key_pair.master-key.key_name
  create_dns_record       = "false"
  hosted_zone_id          = data.terraform_remote_state.vpc.outputs.zone_id
  bastion_record_name     = "circles-test."
  bastion_iam_policy_name = "myBastionHostPolicy"
  elb_subnets = [
    data.terraform_remote_state.vpc.outputs.subnets_id_private[0],
    data.terraform_remote_state.vpc.outputs.subnets_id_private[1]
  ]
  auto_scaling_group_subnets = [
    data.terraform_remote_state.vpc.outputs.subnets_id_private[0],
    data.terraform_remote_state.vpc.outputs.subnets_id_private[1]
  ]
  tags = {
    name        = "my_bastion_name",
    description = "my_bastion_description"
  }
}


module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = "example-asg"

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]

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
  lt_name                = var.general_config.launch_template_name
  description            = "Launch template circles"
  update_default_version = true

  use_lt    = true
  create_lt = true

  image_id          = data.aws_ssm_parameter.linuxAmi.value
  instance_type     = var.general_config.ec2_size
  ebs_optimized     = true
  enable_monitoring = true

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp3"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp3"
      }
    }
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification = {
    cpu_credits = "standard"
  }

  instance_market_options = {
    market_type = "spot"
    spot_options = {
      block_duration_minutes = 60
    }
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
      network_interface_id  = module.ec2_instance_11.primary_network_interface_id
    }
  ]

  placement = {
    availability_zone = "$${module.ec2_instance_11.availability_zone, module.ec2_instance_2.availability_zone}"
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = { WhatAmI = "Volume" }
    },
    {
      resource_type = "spot-instances-request"
      tags          = { WhatAmI = "SpotInstanceRequest" }
    }
  ]

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}
