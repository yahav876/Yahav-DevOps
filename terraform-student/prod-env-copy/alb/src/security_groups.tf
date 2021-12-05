
module "sec-group-ec2" {
  source = "terraform-aws-modules/security-group/aws"


  name        = "ec2-sec-group-all-in-one-prod"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 9000
      to_port     = 9001
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "${data.aws_network_interface.elb-ip-1.private_ip}/32"
    },
    {
      from_port   = 9000
      to_port     = 9001
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "${data.aws_network_interface.elb-ip-2.private_ip}/32"
    },
    # {
    #   from_port   = 1336
    #   to_port     = 1337
    #   protocol    = "tcp"
    #   description = "User-service ports"
    #   cidr_blocks = "${data.aws_network_interface.elb-ip-1.private_ip}/32"
    # },
    # {
    #   from_port   = 1336
    #   to_port     = 1337
    #   protocol    = "tcp"
    #   description = "User-service ports"
    #   cidr_blocks = "${data.aws_network_interface.elb-ip-2.private_ip}/32"
    # },
  ]
}


module "sec-group-ec2-stage" {
  source = "terraform-aws-modules/security-group/aws"


  name        = "ec2-sec-group-website-prod"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]

  ingress_with_cidr_blocks = [
    # {
    #   from_port   = 9000
    #   to_port     = 9001
    #   protocol    = "tcp"
    #   description = "User-service ports"
    #   cidr_blocks = "${data.aws_network_interface.elb-ip-1.private_ip}/32"
    # },
    # {
    #   from_port   = 9000
    #   to_port     = 9001
    #   protocol    = "tcp"
    #   description = "User-service ports"
    #   cidr_blocks = "${data.aws_network_interface.elb-ip-2.private_ip}/32"
    # },
    {
      from_port   = 1336
      to_port     = 1337
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "${data.aws_network_interface.elb-ip-1.private_ip}/32"
    },
    {
      from_port   = 1336
      to_port     = 1337
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "${data.aws_network_interface.elb-ip-2.private_ip}/32"
    },
  ]
}

module "sec-group-ec2-website-stage" {
  source = "terraform-aws-modules/security-group/aws"


  name        = "ec2-sec-group-website-stage"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 1336
      to_port     = 1337
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
    # {
    #   from_port   = 1336
    #   to_port     = 1337
    #   protocol    = "tcp"
    #   description = "User-service ports"
    #   cidr_blocks = "0.0.0.0/0"
    # },
  ]
}

module "sec-group-ec2-allinone-stage" {
  source = "terraform-aws-modules/security-group/aws"


  name        = "ec2-sec-group-allinone-stage"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 9000
      to_port     = 9001
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
    # {
    #   from_port   = 9000
    #   to_port     = 9001
    #   protocol    = "tcp"
    #   description = "User-service ports"
    #   cidr_blocks = "0.0.0.0/0"
    # },
  ]
}





module "sec-group-db" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "db-sec-group"
  description         = "Security group allowing inbound only from the EC2 SG"
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress_cidr_blocks = [var.general_config.vpc_cidr]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp" ,"postgresql-tcp"]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.sec-group-ec2.security_group_id

    },
    {
      rule                     = "all-all"
      source_security_group_id = data.terraform_remote_state.asg_bastion.outputs.bastion_sg

    },

  ]
  number_of_computed_ingress_with_source_security_group_id = 2

}






# # module "sec-group-ec2" {
# #   source = "terraform-aws-modules/security-group/aws"

# #   name        = "ec2-sec-group"
# #   description = "Security group allowing inbound only from the ELB SG"
# #   vpc_id      = module.vpc.vpc_id

# #   computed_ingress_with_source_security_group_id = [
# #     {
# #       rule                     = "https-443-tcp"
# #       source_security_group_id = module.sec-group-elb.security_group_id

# #     }
# #   ]
# #   number_of_computed_ingress_with_source_security_group_id = 1

# # }
