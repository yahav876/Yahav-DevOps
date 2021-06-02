variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}


variable "buckets-num" {
  type = map
  default = {

    bucket = [""]
    bucket2 = [""]
  }
}
