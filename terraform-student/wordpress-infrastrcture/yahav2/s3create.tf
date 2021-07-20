variable "bucket-name" {
  type    = list(any)
  default = ["media-yahav", "code-yahav"]
}

resource "aws_s3_bucket" "media-yahav" {
#  provider = var.region-master
  count    = var.buckets-num["bucket"] == [""] ? 2 : 0
  bucket   = "${var.bucket-name[count.index]}"
  acl      = "public-read"

   tags = {
     Name = var.bucket-name[1]  ## for itay
  }
}