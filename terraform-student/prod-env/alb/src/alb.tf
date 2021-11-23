
module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "circles-up-elb-for-logs"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  attach_elb_log_delivery_policy = true
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "circles-up-test"

  load_balancer_type = "network"

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets         = [data.terraform_remote_state.vpc.outputs.subnets_id_private[0], data.terraform_remote_state.vpc.outputs.subnets_id_private[1]]
  # security_groups = [data.terraform_remote_state.vpc.outputs.sec-group-elb]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"
      # targets = [
      #   {
      #     target_id = "${data.terraform_remote_state.ec2.outputs.ec2-prod-id-website}"
      #     port      = 80
      #   },
      #   {
      #     target_id = "${data.terraform_remote_state.ec2.outputs.ec2-prod-id-all-in-one}"
      #     port      = 80
      #   }
      # ]
    }
    # {
    #   name_prefix      = "pref-"
    #   backend_protocol = "TCP"
    #   backend_port     = 5000
    #   target_type      = "instance"
    #         targets = [
    #     {
    #       target_id = "${data.terraform_remote_state.asg_bastion.outputs.bastion_id}"
    #       port      = 5000
    #     }
    # }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = "arn:aws:acm:us-east-1:457486133872:certificate/881ca1f7-e716-430b-9784-58afc05ac0da"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "TCP"
      target_group_index = 0
      # action_type = "redirect"
      # redirect = {
      #   port        = "443"
      #   protocol    = "HTTPS"
      #   status_code = "HTTP_301"
      # }
    }
  ]

  tags = {
    Environment = "Test"
  }
}
