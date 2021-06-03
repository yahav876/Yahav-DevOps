
data  "template_file" "user-data" {
  template = "./user-data.tpl"
}

data "aws_subnet"  "selected" {
  tags = {
    Public  = yes
  }
}