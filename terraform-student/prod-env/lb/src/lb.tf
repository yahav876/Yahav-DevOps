module "lb-website" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name               = var.lb_website.name
  load_balancer_type = var.lb_website.load_balancer_type

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [data.terraform_remote_state.vpc.outputs.subnets_id_public[0], data.terraform_remote_state.vpc.outputs.subnets_id_public[1]]

  target_groups = [
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = "${var.lb_website.backend_port_1}"
      target_type      = "instance"
    },
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = "${var.lb_website.backend_port_2}"
      target_type      = "instance"
    },
    {
      name_prefix      = "circ-"
      backend_protocol = "TLS"
      backend_port     = 443
      target_type      = "instance"
    },
        {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = 8080
      target_type      = "instance"
    },
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = "${var.lb_website.certificate_arn}"
      target_group_index = 2
    }
  ]

  http_tcp_listeners = [
    {
      port               = "${var.lb_website.port_1}"
      protocol           = "TCP"
      target_group_index = 0
    },
    { port               = "${var.lb_website.port_2}"
      protocol           = "TCP"
      target_group_index = 1
    },
    #     { port               = "${var.lb_website.port_3}"
    #   protocol           = "TCP"
    #   target_group_index = 3
    # },
  ]

  tags = {
    "${var.lb_website.tag_key}" = "${var.lb_website.tag_value}"
  }
}


module "lb-allinone" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = var.lb_allinone.name

  load_balancer_type = var.lb_allinone.load_balancer_type

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [data.terraform_remote_state.vpc.outputs.subnets_id_public[0], data.terraform_remote_state.vpc.outputs.subnets_id_public[1]]

  target_groups = [
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = "${var.lb_allinone.backend_port_1}"
      target_type      = "instance"
    },
    {
      name_prefix      = "circ-"
      backend_protocol = "TLS"
      backend_port     = 443
      target_type      = "instance"
    },
    {
      name_prefix      = "circ-"
      backend_protocol = "TCP"
      backend_port     = "${var.lb_allinone.backend_port_3}"
      target_type      = "instance"
    }
    # {
    #   name_prefix      = "circ-"
    #   backend_protocol = "TCP"
    #   backend_port     = "${var.lb_allinone.backend_port_4}"
    #   target_type      = "instance"
    # }

  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = "${var.lb_allinone.certificate_arn}"
      target_group_index = 1
    }
  ]

  http_tcp_listeners = [
    {
      port               = "${var.lb_allinone.port_1}"
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = "${var.lb_allinone.port_3}"
      protocol           = "TCP"
      target_group_index = 2
    },
    # {
    #   port               = "${var.lb_allinone.port_4}"
    #   protocol           = "TCP"
    #   target_group_index = 3
    # },
  ]

  tags = {
    "${var.lb_allinone.tag_key}" = "${var.lb_allinone.tag_value}"
  }
}

