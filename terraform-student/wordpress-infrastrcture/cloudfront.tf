resource "aws_s3_bucket" "mdeia-code" {
  count =  var.buckets-num["1"]["bucket"] == [""] ? 2 : 0
  bucket = "${element(var.bucket-name, )}"

}