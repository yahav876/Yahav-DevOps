general_config = {

  region              = "us-east-2"
  backend_region      = "eu-west-3"
  backend_bucket_name = "cloudteam-tf-circles"

}
cf = {


  aliases             = ["demo.dev.circlesup.com"]
  comment             = "demo-cloudfront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_200"
  retain_on_delete    = false
  wait_for_deployment = false

  acm_certificate_arn      = "arn:aws:acm:us-east-1:1112223334444:certificate/023b69c9-e86a-4f78-932a-d4304a6c8de2"
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"

}

first_origin = {

  name                   = "website"
  domain_name            = "circles-website-demo.s3-website.us-east-2.amazonaws.com"
  http_port              = 80
  https_port             = 443
  origin_protocol_policy = "http-only"
  origin_ssl_protocols   = ["TLSv1.2", "TLSv1", "TLSv1.1", "SSLv3"]

  target_origin_id         = "website"
  viewer_protocol_policy   = "redirect-to-https"
  cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  origin_request_policy_id = "acba4595-bd28-49b8-b9fe-13317c0390fa"
  allowed_methods          = ["GET", "HEAD"]
  cached_methods           = ["GET", "HEAD"]
  compress                 = true


}

second_origin = {

  name                   = "apanel"
  domain_name            = "circles-apanel-demo.s3-website.us-east-2.amazonaws.com"
  http_port              = 80
  https_port             = 443
  origin_protocol_policy = "http-only"
  origin_ssl_protocols   = ["TLSv1.2", "TLSv1", "TLSv1.1", "SSLv3"]

  path_pattern             = "/apanel/*"
  target_origin_id         = "apanel"
  viewer_protocol_policy   = "redirect-to-https"
  cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  origin_request_policy_id = "acba4595-bd28-49b8-b9fe-13317c0390fa"

  allowed_methods = ["GET", "HEAD"]
  cached_methods  = ["GET", "HEAD"]
  compress        = true


}
third_origin = {

  name                   = "webapp"
  domain_name            = "circles-webapp-demo.s3-website.us-east-2.amazonaws.com"
  http_port              = 80
  https_port             = 443
  origin_protocol_policy = "http-only"
  origin_ssl_protocols   = ["TLSv1.2", "TLSv1", "TLSv1.1", "SSLv3"]

  path_pattern             = "/app/*"
  target_origin_id         = "webapp"
  viewer_protocol_policy   = "redirect-to-https"
  cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  origin_request_policy_id = "acba4595-bd28-49b8-b9fe-13317c0390fa"

  allowed_methods = ["GET", "HEAD"]
  cached_methods  = ["GET", "HEAD"]
  compress        = true


}





