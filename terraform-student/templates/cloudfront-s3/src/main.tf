module "s3_one" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket        = "yahav-testing"
  force_destroy = true
}


resource "aws_cloudfront_origin_access_control" "example" {
  name                              = "yahav-example"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["yahav-test.vi.com"]

  comment             = "My awesome CloudFront managed by terraform"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

#   create_origin_access_identity = true
#   origin_access_identities = {
#     s3_bucket_one = "My awesome CloudFront can access terraform"
#   }

#   logging_config = {
#     bucket = "logs-my-cdn.s3.amazonaws.com"
#   }

  origin = {
    # yahav-testing = {
    #   domain_name = "yahav-test.vidaahub.com"
    #   custom_origin_config = {
    #     http_port              = 80
    #     https_port             = 443
    #     origin_protocol_policy = "match-viewer"
    #     origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    #     default_root_object = "index.html"
    #   }
    # }

    yahav-test = {
      domain_name = "yahav-testing.s3.us-east-1.amazonaws.com"
      s3_origin_config = {
        origin_access_control_id = "E327GJI25M56DG"
        default_root_object = "index.html"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id           = "yahav-test"
    viewer_protocol_policy     = "redirect-to-https"
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    use_forwarded_values = false
    # query_string    = true
  }

#   ordered_cache_behavior = [
#     {
#       path_pattern           = "/*"
#       target_origin_id       = "yahav-test"
#       viewer_protocol_policy = "redirect-to-https"

#       allowed_methods = ["GET", "HEAD", "OPTIONS"]
#       cached_methods  = ["GET", "HEAD"]
#       compress        = true
#       query_string    = true
#     }
#   ]

  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:c:certificate/cad4dc01-0086-4b3c-a20f-c3809da8c4e4"
    ssl_support_method  = "sni-only"
  }
}