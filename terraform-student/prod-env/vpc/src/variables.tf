variable "general_config" {
    type = map
    default = {
        vpc_cidr = ""
        zone_1 = ""
    }
}

variable "vpc_private_subnets" {
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

