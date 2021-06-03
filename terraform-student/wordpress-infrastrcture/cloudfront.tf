
locals {
   s3origin = "mys3OriginWP"
}

data "aws_s3_bucket" "selected" {
  bucket = "media-yahav"
  depends_on = [aws_s3_bucket.media-yahav]
}

resource "aws_cloudfront_distribution" "wp-cloudfront" {
  count = var.cloudfront["cdn"] == [""] ? 1 : 0
  enabled = false
  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.s3origin
    viewer_protocol_policy = ""
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
      viewer_protocol_policy = "allow-all"
      min_ttl                = 0
      default_ttl            = 3600
      max_ttl                = 86400
    }
  }
  origin {
    domain_name = data.aws_s3_bucket.selected.bucket_domain_name
    origin_id   = "s3-selected-bucket"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {}
}
