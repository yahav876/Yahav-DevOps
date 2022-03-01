general_config = {

  region              = "us-east-2"
  backend_region      = "eu-west-3"
  backend_bucket_name = "cloudteam-tf-circles"

}

sec_group_allinone = {

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  egress_rules        = ["all-all"]
  name                = "sec-group-allinone-demo"
  from_port_1         = 9000
  to_port_1           = 9001
  protocol_1          = "tcp"
  from_port_2         = 9000
  to_port_2           = 9001
  protocol_2          = "tcp"

}

sec_group_website = {

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  egress_rules        = ["all-all"]
  name                = "sec-group-website-demo"
  from_port_1         = 1336
  to_port_1           = 1337
  protocol_1          = "tcp"
  from_port_2         = 1336
  to_port_2           = 1337
  protocol_2          = "tcp"

}

sec_group_db = {

  name          = "rds_demo_sg"
  ingress_rules = ["https-443-tcp", "http-80-tcp", "ssh-tcp", "postgresql-tcp"]
  egress_rules  = ["all-all"]
}

lb_website = {

  name               = "website-lb-demo"
  load_balancer_type = "network"
  backend_port_1     = "80"
  backend_port_2     = "1337"
  backend_port_3     = "22"
  certificate_arn    = "arn:aws:acm:us-east-2:1112223334444:certificate/f9e0df8b-612f-45cb-a3f5-54a312de6ab2"
  port_1             = "80"
  port_2             = "1337"
  port_3             = "8080"
  tag_key            = "ManagedBy"
  tag_value          = "Terraform"

}

lb_allinone = {

  name               = "allinone-lb-demo"
  load_balancer_type = "network"
  backend_port_1     = "9001"
  backend_port_2     = "22"
  backend_port_3     = "9000"
  backend_port_4     = "9001" 

  certificate_arn = "arn:aws:acm:us-east-2:1112223334444:certificate/7ecfadcb-93c7-4740-97f0-5721bd0a9ac4"
  port_1          = "9001"
  port_2          = "22"
  port_3          = "9000"
  port_4          = "9001"

  tag_key   = "ManagedBy"
  tag_value = "Terraform"
}


