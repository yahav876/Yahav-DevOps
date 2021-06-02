variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}


buckets-num = {
  1 = {
    bucket            = [""]               #list of IPs
    bucket2           = [""] #list of IPs
  }
  2 = {
    publicA            = [""]               #list of IPs
    privateA           = [""] #list of IPs

  }
}
