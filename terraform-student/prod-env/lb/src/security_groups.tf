
module "sec-group-allinone" {
  source = "terraform-aws-modules/security-group/aws"


  name        = var.sec_group_allinone.name
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = var.sec_group_allinone.ingress_cidr_blocks
  ingress_rules       = var.sec_group_allinone.ingress_rules
  egress_rules        = var.sec_group_allinone.egress_rules

  ingress_with_cidr_blocks = [
    {
      from_port   = var.sec_group_allinone.from_port_1
      to_port     = var.sec_group_allinone.to_port_1
      protocol    = var.sec_group_allinone.protocol_1
      description = "User-service ports"
      cidr_blocks = "${data.aws_network_interface.elb-ip-allinone-1.private_ip}/32"
    },
    {
      from_port   = var.sec_group_allinone.from_port_2
      to_port     = var.sec_group_allinone.to_port_2
      protocol    = var.sec_group_allinone.protocol_2
      description = "User-service ports"
      cidr_blocks = "${data.aws_network_interface.elb-ip-allinone-2.private_ip}/32"
    },
  ]
}


module "sec-group-website" {
  source = "terraform-aws-modules/security-group/aws"


  name        = var.sec_group_website.name
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = var.sec_group_website.ingress_cidr_blocks
  ingress_rules       = var.sec_group_website.ingress_rules
  egress_rules        = var.sec_group_website.egress_rules

  ingress_with_cidr_blocks = [
    {
      from_port   = var.sec_group_website.from_port_1
      to_port     = var.sec_group_website.to_port_1
      protocol    = var.sec_group_website.protocol_1
      description = "User-service ports"
      cidr_blocks = "${data.aws_network_interface.elb-ip-1.private_ip}/32"
    },
    {
      from_port   = var.sec_group_website.from_port_2
      to_port     = var.sec_group_website.to_port_2
      protocol    = var.sec_group_website.protocol_2
      description = "User-service ports"
      cidr_blocks = "${data.aws_network_interface.elb-ip-2.private_ip}/32"
    },
  ]
}


module "sec-group-db" {
  source = "terraform-aws-modules/security-group/aws"

  name                = var.sec_group_db.name
  description         = "Security group allowing inbound only from the EC2 SG"
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress_cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  ingress_rules       = var.sec_group_db.ingress_rules
  egress_rules        = var.sec_group_db.egress_rules

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.sec-group-allinone.security_group_id

    },
    {
      rule                     = "all-all"
      source_security_group_id = module.sec-group-website.security_group_id

    },
    {
      rule                     = "all-all"
      source_security_group_id = data.terraform_remote_state.asg_bastion.outputs.bastion_sg

    },

  ]
  number_of_computed_ingress_with_source_security_group_id = 3

}





