variable "general_config" {
  type = map(any)
  default = {
    vpc_cidr             = ""
    zone_1               = ""
    region               = ""
    enable_dns_hostnames = ""
    enable_nat_gateway   = ""
    enable_vpn_gateway   = ""
    single_nat_gateway   = ""
  }
}

variable "private_subnet_cidr" {
  type    = list(any)
  default = [""]

}

variable "public_subnet_cidr" {
  type    = list(any)
  default = [""]

}

variable "vpc_azs" {
  type    = list(any)
  default = [""]

}

variable "subnets_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}
