variable "bucket-name" {
  type    = list(any)
  default = ["mdeia-yahav", "code-yahav"]
}

resource "aws_s3_bucket" "mdeia-code" {
#  provider = var.region-master
  count    = var.buckets-num["bucket"] == [""] ? 2 : 0
  bucket   = "${var.bucket-name[count.index]}"
  acl      = "public-read"
  }
data "aws_s3_bucket" "selected" {
  bucket = "media-yahav"
}

resource "aws_cloudfront_distribution" "wp-cloudfront" {
  count = var.cloudfront["cdn"] == [""] ? 1 : 0
  enabled = false
  default_cache_behavior {
    allowed_methods = []
    cached_methods = []
    target_origin_id = ""
    viewer_protocol_policy = ""
    forwarded_values {
      query_string = false
      cookies {
        forward = ""
      }
    }
  }
  origin {
    domain_name = data.aws_s3_bucket.selected.bucket_domain_name
    origin_id   = "s3-selected-bucket"
  }
  restrictions {
    geo_restriction {
      restriction_type = ""
    }
  }
  viewer_certificate {}
}
