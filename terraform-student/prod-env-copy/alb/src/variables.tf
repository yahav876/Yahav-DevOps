variable "general_config" {
  type = map(any)
  default = {
    region         = ""
    backend_region = ""
    ec2_size       = ""
    lb_name        = ""
    vpc_cidr       = ""
  }
}


variable "sec_group" {
  type = map(any)
  default = {
    website-stage    = ""
    all-in-one-stage = ""
    website-prod     = ""
    all-in-one-prod  = ""
    db-sec-group     = ""
  }

}

# variable "private_subnets_lb" {

#   #   type = map
#   default = {

#     subnet-a = ""
#     subnet-b = ""
#   }
# }

# variable "private_subnets_lb" {
#   type = list(string)
#   default = [locals.private_subnet_id_1, locals.private_subnet_id_2]


# }



