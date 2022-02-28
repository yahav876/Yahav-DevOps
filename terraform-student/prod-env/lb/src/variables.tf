variable "general_config" {

  type = any
  default = {
    region              = ""
    backend_region      = ""
    backend_bucket_name = ""

  }
}

variable "sec_group_allinone" {

  type = any
  default = {
    ingress_cidr_blocks = ""
    ingress_rules       = ""
    egress_rules        = ""
    name                = ""
    from_port_1         = ""
    to_port_1           = ""
    protocol_1          = ""
    from_port_2         = ""
    to_port_2           = ""
    protocol_2          = ""
  }
}

variable "sec_group_website" {
  type = any
  default = {
    ingress_cidr_blocks = ""
    ingress_rules       = ""
    egress_rules        = ""
    name                = ""
    from_port_1         = ""
    to_port_1           = ""
    protocol_1          = ""
    from_port_2         = ""
    to_port_2           = ""
    protocol_2          = ""
  }
}

variable "sec_group_db" {

  type = any
  default = {
    name          = ""
    ingress_rules = ""
    egress_rules  = ""
  }
}

variable "lb_website" {
  type = any
  default = {
    name               = ""
    load_balancer_type = ""
    backend_port_1     = ""
    backend_port_2     = ""
    backend_port_3     = ""
    certificate_arn    = ""
    port_1             = ""
    port_2             = ""
    port_3             = ""
    tag_key            = ""
    tag_value          = ""

  }
}

variable "lb_allinone" {
  type = any
  default = {
    name               = ""
    load_balancer_type = ""
    backend_port_1     = ""
    backend_port_2     = ""
    backend_port_3     = ""
    backend_port_4     = ""

    certificate_arn = ""
    port_1          = ""
    port_2          = ""
    port_3          = ""
    port_4          = ""
    tag_key         = ""
    tag_value       = ""

  }
}
