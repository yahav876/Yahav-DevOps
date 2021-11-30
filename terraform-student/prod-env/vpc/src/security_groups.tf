

# module "sec-group-db" {
#   source = "terraform-aws-modules/security-group/aws"

#   name                = "db-sec-group"
#   description         = "Security group allowing inbound only from the EC2 SG"
#   vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
#   ingress_cidr_blocks = [var.general_config.vpc_cidr]
#   ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp" ,"postgresql-tcp"]

#   computed_ingress_with_source_security_group_id = [
#     {
#       rule                     = "all-all"
#       source_security_group_id = module.sec-group-ec2.security_group_id

#     },
#     {
#       rule                     = "all-all"
#       source_security_group_id = data.terraform_remote_state.asg_bastion.outputs.bastion_sg

#     },

#   ]
#   number_of_computed_ingress_with_source_security_group_id = 2

# }

