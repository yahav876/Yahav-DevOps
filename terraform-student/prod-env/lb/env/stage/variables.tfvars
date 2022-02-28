general_config = {

  region              = "us-east-2"
  backend_region      = "eu-west-3"
  backend_bucket_name = "cloudteam-tf-circles"
}

sec_group_allinone = {

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
  name                = "sec-group-allinone-stage"
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
  name                = "sec-group-website-stage"
  from_port_1         = 1336
  to_port_1           = 1337
  protocol_1          = "tcp"
  from_port_2         = 1336
  to_port_2           = 1337
  protocol_2          = "tcp"

}

sec_group_db = {

  name          = "rds-stage-sg"
  ingress_rules = ["https-443-tcp", "http-80-tcp", "ssh-tcp", "postgresql-tcp"]
  egress_rules  = ["all-all"]
}

lb_website = {

  name               = "website-lb-stage"
  load_balancer_type = "network"
  backend_port_1     = "80"
  backend_port_2     = "1337"
  backend_port_3     = "22"
  certificate_arn    = "arn:aws:acm:us-east-2:294650027016:certificate/b456a653-841f-47f6-9b14-30ac148bb71e"
  port_1             = "80"
  port_2             = "1337"
  port_3             = "8080"
  tag_key            = "ManagedBy"
  tag_value          = "Terraform"

}

lb_allinone = {


  name               = "allinone-lb-stage"
  load_balancer_type = "network"
  backend_port_1     = "9001"
  backend_port_2     = "22"
  backend_port_3     = "9000"
  backend_port_4     = "9001"

  certificate_arn = "arn:aws:acm:us-east-2:294650027016:certificate/de4adac9-90c9-41c5-900c-9717e11a182c"
  port_1          = "9001"
  port_2          = "22"
  port_3          = "9000"
  port_4          = "9001"

  tag_key   = "ManagedBy"
  tag_value = "Terraform"



}


