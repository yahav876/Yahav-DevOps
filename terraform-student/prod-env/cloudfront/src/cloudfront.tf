module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = var.cf.aliases

  comment             = var.cf.comment
  enabled             = var.cf.enabled
  is_ipv6_enabled     = var.cf.is_ipv6_enabled
  price_class         = var.cf.price_class
  retain_on_delete    = var.cf.retain_on_delete
  wait_for_deployment = var.cf.wait_for_deployment


  origin = {

    website = {
      domain_name = var.first_origin.domain_name

      custom_origin_config = {
        http_port              = var.first_origin.http_port
        https_port             = var.first_origin.https_port
        origin_protocol_policy = var.first_origin.origin_protocol_policy
        origin_ssl_protocols   = var.first_origin.origin_ssl_protocols


      }
    }

    apanel = {
      domain_name = var.second_origin.domain_name

      custom_origin_config = {
        http_port              = var.second_origin.http_port
        https_port             = var.second_origin.https_port
        origin_protocol_policy = var.second_origin.origin_protocol_policy
        origin_ssl_protocols   = var.second_origin.origin_ssl_protocols
      }
    }

    webapp = {
      domain_name = var.third_origin.domain_name

      custom_origin_config = {
        http_port              = var.third_origin.http_port
        https_port             = var.third_origin.https_port
        origin_protocol_policy = var.third_origin.origin_protocol_policy
        origin_ssl_protocols   = var.third_origin.origin_ssl_protocols

      }

    }
  }

  default_cache_behavior = {
    target_origin_id         = var.first_origin.target_origin_id
    viewer_protocol_policy   = var.first_origin.viewer_protocol_policy
    cache_policy_id          = var.first_origin.cache_policy_id
    origin_request_policy_id = var.first_origin.origin_request_policy_id
    allowed_methods          = var.first_origin.allowed_methods
    cached_methods           = var.first_origin.cached_methods
    compress                 = var.first_origin.compress
    use_forwarded_values = false

  }

  ordered_cache_behavior = [
    {
      path_pattern             = var.second_origin.path_pattern
      target_origin_id         = var.second_origin.target_origin_id
      viewer_protocol_policy   = var.second_origin.viewer_protocol_policy
      cache_policy_id          = var.second_origin.cache_policy_id
      origin_request_policy_id = var.second_origin.origin_request_policy_id
      use_forwarded_values = false

      allowed_methods = var.second_origin.allowed_methods
      cached_methods  = var.second_origin.cached_methods
      compress        = var.second_origin.compress
    },
    {
      path_pattern             = var.third_origin.path_pattern
      target_origin_id         = var.third_origin.target_origin_id
      viewer_protocol_policy   = var.third_origin.viewer_protocol_policy
      cache_policy_id          = var.third_origin.cache_policy_id
      origin_request_policy_id = var.third_origin.origin_request_policy_id
      use_forwarded_values = false

      allowed_methods = var.third_origin.allowed_methods
      cached_methods  = var.third_origin.cached_methods
      compress        = var.third_origin.compress
    }
  ]

  viewer_certificate = {
    acm_certificate_arn      = var.cf.acm_certificate_arn
    ssl_support_method       = var.cf.ssl_support_method
    minimum_protocol_version = var.cf.minimum_protocol_version
  }
}

