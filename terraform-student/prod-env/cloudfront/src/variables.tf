variable "general_config" {

  type = any
  default = {
    region              = ""
    backend_region      = ""
    backend_bucket_name = ""
  }
}

variable "cf" {

  type = any
  default = {

    aliases                       = ""
    comment                       = ""
    enabled                       = ""
    is_ipv6_enabled               = ""
    price_class                   = ""
    retain_on_delete              = ""
    wait_for_deployment           = ""
    create_origin_access_identity = ""

    acm_certificate_arn      = ""
    ssl_support_method       = ""
    minimum_protocol_version = ""

  }
}

variable "first_origin" {
  type = any
  default = {
    name                   = ""
    domain_name            = ""
    http_port              = ""
    https_port             = ""
    origin_protocol_policy = ""
    origin_ssl_protocols   = ""

    target_origin_id         = ""
    viewer_protocol_policy   = ""
    cache_policy_id          = ""
    origin_request_policy_id = ""
    allowed_methods          = ""
    cached_methods           = ""
    compress                 = ""
  }
}

variable "second_origin" {
  type = any

  default = {
    name                   = ""
    domain_name            = ""
    http_port              = ""
    https_port             = ""
    origin_protocol_policy = ""
    origin_ssl_protocols   = ""

    target_origin_id         = ""
    viewer_protocol_policy   = ""
    cache_policy_id          = ""
    origin_request_policy_id = ""
    allowed_methods          = ""
    cached_methods           = ""
    compress                 = ""

  }
}

variable "third_origin" {
  type = any
  default = {
    name                   = ""
    domain_name            = ""
    http_port              = ""
    https_port             = ""
    origin_protocol_policy = ""
    origin_ssl_protocols   = ""

    target_origin_id         = ""
    viewer_protocol_policy   = ""
    cache_policy_id          = ""
    origin_request_policy_id = ""
    allowed_methods          = ""
    cached_methods           = ""
    compress                 = ""

  }
}
