variable "general_config" {
  type = map(any)
  default = {
    asg_ec2_size-allinone = ""
    asg_ec2_size-website  = ""

    zone_1 = ""
  }
}

variable "subnets_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

