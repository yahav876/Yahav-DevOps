variable "general_config" {
    type = map
    default = {
        vpc_name = ""
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