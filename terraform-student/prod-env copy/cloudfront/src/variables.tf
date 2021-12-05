variable "general_config" {
    type = map
    default = {
        asg_ec2_size = ""
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

