variable "general_config" {
    type = map
    default = {
        zone_2 = ""
        zone_1 = ""
    }
}

variable "subnets_id" {
    type = string
    default = ""
}

variable "vpc_id" {
    type = string
    default = ""
}

