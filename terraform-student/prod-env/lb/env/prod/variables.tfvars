general_config = {

  region              = "us-east-2"
  backend_region      = "eu-west-3"
  backend_bucket_name = "cloudteam-tf-circles"

}

sec_group_allinone = {

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
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
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
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

  name          = "rds_prod_sg"
  ingress_rules = ["https-443-tcp", "http-80-tcp", "ssh-tcp", "postgresql-tcp"]
  egress_rules  = ["all-all"]
}

lb_website = {

  name               = "website-lb-prod"
  load_balancer_type = "network"
  backend_port_1     = "80"
  backend_port_2     = "1337"
  backend_port_3     = "22"
  certificate_arn    = "arn:aws:acm:us-east-2:1112223334444:certificate/80ddd496-0523-4414-b237-1cddfd0ff869"
  port_1             = "80"
  port_2             = "1337"
  port_3             = "8080"
  tag_key            = "ManagedBy"
  tag_value          = "Terraform"

}

lb_allinone = {

  name               = "allinone-lb-prod"
  load_balancer_type = "network"
  backend_port_1     = "9001"
  backend_port_2     = "22"
  backend_port_3     = "9000"
  backend_port_4     = "9001" 

  certificate_arn = "arn:aws:acm:us-east-2:1112223334444:certificate/e991545f-2b66-417c-b304-8b9379ae3998"
  port_1          = "9001"
  port_2          = "22"
  port_3          = "9000"
  port_4          = "9001"

  tag_key   = "ManagedBy"
  tag_value = "Terraform"
}


