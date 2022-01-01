module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {

    "${var.general_config.zone_2}" = {
      comment = "${var.general_config.zone_2}"
    },
    "${var.general_config.zone_1}" = {
      comment = "${var.general_config.zone_1}"
    },

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
      name = "circles-up"
      type = "A"
      alias = {
        name    = data.terraform_remote_state.alb.outputs.elb_dns_name
        zone_id = data.terraform_remote_state.alb.outputs.elb_zone_id
      }
    }
  ]

  depends_on = [module.zones]
}



