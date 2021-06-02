variable "bucket-name" {
  type    = list(any)
  default = ["mdeia-yahav", "code-yahav"]
}

resource "aws_s3_bucket" "mdeia-code" {
  provider = var.region-master
  count    = var.buckets-num["bucket"] == [""] ? 2 : 0
  bucket   = element(var.bucket-name, count.index)
  acl      = "public-read"

}