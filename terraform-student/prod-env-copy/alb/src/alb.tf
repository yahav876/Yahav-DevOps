
# module "s3_bucket_for_logs" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket = "circles-up-elb-for-logs"
#   acl    = "log-delivery-write"

#   # Allow deletion of non-empty bucket
#   force_destroy = true

#   attach_elb_log_delivery_policy = true
# }


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = var.general_config.lb_name

  load_balancer_type = "network"

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]

  target_groups = [
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"
    },
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = 9000
      target_type      = "instance"
    },
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = 9001
      target_type      = "instance"
    },
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = 1336
      target_type      = "instance"
    },
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = 1337
      target_type      = "instance"
    },
        {
      name_prefix      = "circ-"
      backend_protocol = "TLS"
      backend_port     = 443
      target_type      = "instance"
    }

  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = "arn:aws:acm:us-east-1:457486133872:certificate/881ca1f7-e716-430b-9784-58afc05ac0da"
      target_group_index = 5
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    { port               = 9000
      protocol           = "TCP"
      target_group_index = 1
    },
    { port               = 9001
      protocol           = "TCP"
      target_group_index = 2
    },
    { port               = 1336
      protocol           = "TCP"
      target_group_index = 3
    },
    { port               = 1337
      protocol           = "TCP"
      target_group_index = 4
    },
  ]

  tags = {
    Environment = "Test"
  }
}
