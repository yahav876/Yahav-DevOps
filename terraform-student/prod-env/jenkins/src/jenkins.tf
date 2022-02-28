locals {
  user_data_allinone = <<-EOT
#!/bin/sh
# Create docker-compose stack for jenkins
cat <<EOF > docker-compose.yaml
version: '3.8'
services:
  jenkins:
    image: jenkins/jenkins:lts-jdk11
    privileged: true
    user: root
    ports:
      - 8080:8080
      - 50000:50000
    container_name: jenkins
    volumes:
     - /home/ubuntu/jenkins_compose/jenkins_configuration:/var/jenkins_home
     - /var/run/docker.sock:/var/run/docker.sock
     
EOF

apt update -y
apt install cron vim awscli zip -y


# Initiate jenkins container
sudo docker-compose -f /docker-compose.yaml up -d

sudo docker exec jenkins apt update -y
sudo docker exec jenkins apt install cron vim awscli zip -y

sudo docker exec jenkins service cron enable
sudo docker exec jenkins service cron start

sudo cat << EOF > /home/ubuntu/jenkins_backup/crontab
0 1 * * * cd /var/jenkins_home/ && zip -r jenkins.zip . && aws s3 cp /var/jenkins_home/jenkins.zip s3://cloudteam-tf-circles/backup-jenkins/
EOF


sudo docker cp /home/ubuntu/crontab jenkins:/etc/cron.d/crontab 
sudo docker exec jenkins crontab /etc/cron.d/crontab
sudo docker exec jenkins chmod 0777 /etc/cron.d/crontab

aws s3 cp s3://cloudteam-tf-circles/backup-jenkins/jenkins.zip jenkins.zip
sudo docker cp jenkins.zip jenkins:/var/

sudo cat << EOF > /home/ubuntu/restore.sh
cd /var/jenkins_home
rm -rf *
mv ../jenkins.zip .
unzip jenkins.zip
rm jenkins.zip
EOF

sudo chmod +x /home/ubuntu/restore.sh

sudo docker cp /home/ubuntu/restore.sh jenkins:/root

sudo docker exec jenkins /bin/sh -c /root/restore.sh 



  EOT

user_data_jenkins_slave = <<-EOT
#!/bin/sh



sudo apt update -y
sudo apt install default-jre -y

  EOT



}



module "asg-jenkins" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = var.jenkins_asg.asg_name

  depends_on = [
    module.lb-jenkins
  ]

  min_size                  = var.jenkins_asg.min_size
  max_size                  = var.jenkins_asg.max_size
  desired_capacity          = var.jenkins_asg.desired_capacity
  wait_for_capacity_timeout = var.jenkins_asg.wait_for_capacity_timeout
  health_check_type         = "EC2"
  vpc_zone_identifier       = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]
  target_group_arns         = [module.lb-jenkins.target_group_arns[0], module.lb-jenkins.target_group_arns[1] ]
  force_delete              = var.jenkins_asg.force_delete
  protect_from_scale_in     = var.jenkins_asg.protect_from_scale_in
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

  # instance_market_options = { # Comment out to choose On-demand.  (if var env == prod , do on-demand )
  #   market_type = "spot"
  # }

  # Launch template
  lt_name                  = var.jenkins_asg.lt_name
  description              = "Launch template circles"
  update_default_version   = var.jenkins_asg.update_default_version
  iam_instance_profile_arn = var.jenkins_asg.iam_instance_profile
  user_data_base64         = base64encode(local.user_data_allinone) 


  use_lt    = true
  create_lt = true

  image_id      = "ami-06260e310ae1cac3f"
  instance_type = var.jenkins_asg.instance_type

  ebs_optimized     = var.jenkins_asg.ebs_optimized
  enable_monitoring = var.jenkins_asg.enable_monitoring


  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = "${var.jenkins_asg.core_count}"
    threads_per_core = "${var.jenkins_asg.threads_per_core}"
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
    availability_zone = var.jenkins_asg.availability_zone
  }

  tags = [
    {
      key                 = var.jenkins_asg.first_tag_key
      value               = var.jenkins_asg.first_tag_value
      propagate_at_launch = true
    },
    {
      key                 = var.jenkins_asg.second_tag_key
      value               = var.jenkins_asg.second_tag_value
      propagate_at_launch = true
    },
    {
      key                 = var.jenkins_asg.third_tag_key
      value               = var.jenkins_asg.third_tag_value
      propagate_at_launch = true
    },
  ]
}


module "sec-group-jenkins" {
  source = "terraform-aws-modules/security-group/aws"


  name        = var.sec_group_jenkins.name
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = var.sec_group_jenkins.ingress_cidr_blocks
  ingress_rules       = var.sec_group_jenkins.ingress_rules
  egress_rules        = var.sec_group_jenkins.egress_rules

}


module "asg-jenkins-slaves" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = var.jenkins_asg_slaves.asg_name

  depends_on = [
    module.lb-jenkins,
    module.sec-group-jenkins
  ]

  min_size                  = var.jenkins_asg_slaves.min_size
  max_size                  = var.jenkins_asg_slaves.max_size
  desired_capacity          = var.jenkins_asg_slaves.desired_capacity
  wait_for_capacity_timeout = var.jenkins_asg_slaves.wait_for_capacity_timeout
  health_check_type         = "EC2"
  vpc_zone_identifier       = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0],data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]
  # target_group_arns         = [module.lb-jenkins.target_group_arns[0], module.lb-jenkins.target_group_arns[1] ]
  force_delete              = var.jenkins_asg_slaves.force_delete
  protect_from_scale_in     = var.jenkins_asg_slaves.protect_from_scale_in
  key_name                  = data.terraform_remote_state.asg_bastion.outputs.key_pair
  # associate_public_ip_address = var.jenkins_asg_slaves.associate_public_ip_address

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

  instance_market_options = { # Comment out to choose On-demand.  (if var env == prod , do on-demand )
    market_type = "spot"
  }

  # Launch template
  lt_name                  = var.jenkins_asg_slaves.lt_name
  description              = "Launch template circles"
  update_default_version   = var.jenkins_asg_slaves.update_default_version
  iam_instance_profile_arn = var.jenkins_asg_slaves.iam_instance_profile
  user_data_base64         = base64encode(local.user_data_jenkins_slave) 


  use_lt    = true
  create_lt = true

  # image_id = data.aws_ami.allinone.image_id
  image_id      = "ami-06d0ac125fdd0fa12"
  instance_type = var.jenkins_asg_slaves.instance_type

  ebs_optimized     = var.jenkins_asg_slaves.ebs_optimized
  enable_monitoring = var.jenkins_asg_slaves.enable_monitoring

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = "${var.jenkins_asg_slaves.delete_on_termination}"
        encrypted             = "${var.jenkins_asg_slaves.encrypted}"
        volume_size           = "${var.jenkins_asg_slaves.volume_size}"
        volume_type           = "${var.jenkins_asg_slaves.volume_type}"
      }
    },
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = "${var.jenkins_asg_slaves.core_count}"
    threads_per_core = "${var.jenkins_asg_slaves.threads_per_core}"
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
      security_groups       = [module.sec-group-jenkins.security_group_id]
    }
  ]


  placement = {
    availability_zone = var.jenkins_asg_slaves.availability_zone
  }

  tags = [
    {
      key                 = var.jenkins_asg_slaves.first_tag_key
      value               = var.jenkins_asg_slaves.first_tag_value
      propagate_at_launch = true
    },
    {
      key                 = var.jenkins_asg_slaves.second_tag_key
      value               = var.jenkins_asg_slaves.second_tag_value
      propagate_at_launch = true
    },
    {
      key                 = var.jenkins_asg_slaves.third_tag_key
      value               = var.jenkins_asg_slaves.third_tag_value
      propagate_at_launch = true
    },
  ]
}

module "lb-jenkins" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name               = var.lb_jenkins.name
  load_balancer_type = var.lb_jenkins.load_balancer_type

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [data.terraform_remote_state.vpc.outputs.subnets_id_public[0], data.terraform_remote_state.vpc.outputs.subnets_id_public[1]]


  target_groups = [
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = "${var.lb_jenkins.backend_port_1}"
      target_type      = "instance"
    },
    {
      name_prefix      = "circ-"
      backend_protocol = "TLS"
      backend_port     = 443
      target_type      = "instance"
    },
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = "${var.lb_jenkins.certificate_arn}"
      target_group_index = 1
    }
  ]

  http_tcp_listeners = [
    {
      port               = "${var.lb_jenkins.port_1}"
      protocol           = "TCP"
      target_group_index = 0
    },
    
  ]
  

  tags = {
    "${var.lb_jenkins.tag_key}" = "${var.lb_jenkins.tag_value}"
  }
}



