general_config = {

  region              = "us-east-1"
  backend_region      = "eu-west-3"
  backend_bucket_name = "cloudteam-tf-circles"

}

sec_group_allinone = {

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
  name                = "sec-group-allinone-prod"
  from_port_1         = 9000
  to_port_1           = 9001
  protocol_1          = "tcp"
  from_port_2         = 9000
  to_port_2           = 9001
  protocol_2          = "tcp"

}

sec_group_website = {

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
  name                = "sec-group-website-prod"
  from_port_1         = 1336
  to_port_1           = 1337
  protocol_1          = "tcp"
  from_port_2         = 1336
  to_port_2           = 1337
  protocol_2          = "tcp"

}

sec_group_db = {

  name          = "rds_prod"
  ingress_rules = ["https-443-tcp", "http-80-tcp", "ssh-tcp", "postgresql-tcp"]
  egress_rules  = ["all-all"]
}

lb_website = {

  name               = "website-lb-prod"
  load_balancer_type = "network"
  backend_port_1     = "80"
  backend_port_2     = "1337"
  certificate_arn    = "arn:aws:acm:us-east-1:294650027016:certificate/41818168-80cb-4b20-9e16-bf2e2645ec70"
  port_1             = "80"
  port_2             = "1337"
  tag_key            = "ManagedBy"
  tag_value          = "Terraform"

}

lb_allinone = {

  name               = "allinone-lb-prod"
  load_balancer_type = "network"
  backend_port_1     = "80"
  backend_port_2     = ""
  certificate_arn    = "arn:aws:acm:us-east-1:294650027016:certificate/41818168-80cb-4b20-9e16-bf2e2645ec70"
  port_1             = "80"
  tag_key            = "ManagedBy"
  tag_value          = "Terraform"
}


