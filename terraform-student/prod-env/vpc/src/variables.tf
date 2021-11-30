variable "general_config" {
    type = map
    default = {
        vpc_cidr = ""
        zone_1 = ""
    }
}

variable "private_subnet_cidr" {
    type = list
    default = [""]
  
}

variable "public_subnet_cidr" {
    type = list
    default = [""]
  
}

variable "vpc_azs" {
    type = list
    default = [""]
  
}

variable "subnets_id" {
    type = string
    default = ""
}

variable "vpc_id" {
    type = string
    default = ""
}
