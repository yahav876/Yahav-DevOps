module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {

    "${var.general_config.zone_2}" = {
      comment = "circles-test.com"
    }
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(module.zones.route53_zone_zone_id)[0]

  records = [
    {
      name    = "circles-test"
      type    = "A"
      alias   = {
        name    = data.terraform_remote_state.alb.elb_dns_name
        zone_id = data.terraform_remote_state.alb.elb_zone_id
      }
    }
  ]

  depends_on = [module.zones]
}

# # zone_id = module.zones.route53_zone_zone_id["${var.general_config.zone_1}"]