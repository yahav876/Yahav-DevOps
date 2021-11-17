variable "general_config" {
    type = map
    default = {
        vpc_name = ""
    }
}


# variable "vpc_id" {
#     type = string
#     default = module.vpc.aws_vpc.id
# }