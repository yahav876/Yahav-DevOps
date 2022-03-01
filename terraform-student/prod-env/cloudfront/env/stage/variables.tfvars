general_config = {

  region              = "us-east-2"
  backend_region      = "eu-west-3"
  backend_bucket_name = "cloudteam-tf-circles"

}
cf = {


  aliases             = ["stage.dev.circlesup.com"]
  comment             = "stage-cloudfront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_200"
  retain_on_delete    = false
  wait_for_deployment = false

  acm_certificate_arn      = "arn:aws:acm:us-east-1:1112223334444:certificate/deeb71a2-9dad-40a7-9f5e-6e93cabe8943"
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"

}

first_origin = {

  name                   = "website"
  domain_name            = "circles-website-stage.s3-website.us-east-2.amazonaws.com"
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
  domain_name            = "circles-apanel-stage.s3-website.us-east-2.amazonaws.com"
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
  domain_name            = "circles-webapp-stage.s3-website.us-east-2.amazonaws.com"
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





