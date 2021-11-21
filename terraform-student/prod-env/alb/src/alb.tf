module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id             = data.terraform_remote_state.vpc.vpc_id
  subnets            = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]
  security_groups    = [data.terraform_remote_state.vpc.outputs.sec-group-elb]

  access_logs = {
    bucket = "cloudteam-tf"
  }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "${data.terraform_remote_state.ec2.outputs.ec2-prod-id-website}"
          port = 80
        },
        {
          target_id = "${data.terraform_remote_state.ec2.outputs.ec2-prod-id-all-in-one}"
          port = 80
        }
      ]
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:us-east-1:457486133872:certificate/881ca1f7-e716-430b-9784-58afc05ac0da"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}