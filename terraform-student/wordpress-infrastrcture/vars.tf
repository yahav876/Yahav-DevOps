variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}


variable "buckets-num" {
  type = map(any)
  default = {

    bucket  = [""]
    bucket2 = [""]
  }
}

variable "cloudfront" {
  type = map
  default = {
    cdn   = [""]
  } cdn2  = [""]
}
