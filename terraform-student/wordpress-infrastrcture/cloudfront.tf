variable "bucket-name" {
  type    = list
  default = ["mdeia-yahav", "code-yahav" ]
}

resource "aws_s3_bucket" "mdeia-code" {
  count  =  var.buckets-num["1"]["bucket"] == [""] ? 2 : 0
  bucket = "${element(var.bucket-name, count.index )}"
  acl    = "public-read"

}