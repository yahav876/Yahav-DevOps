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
        name    = "dualstack.circles-up-test-877142550.us-east-1.elb.amazonaws.com"
        zone_id = "Z35SXDOTRQ7X7K"
      }
    }
  ]

  depends_on = [module.zones]
}

# # zone_id = module.zones.route53_zone_zone_id["${var.general_config.zone_1}"]