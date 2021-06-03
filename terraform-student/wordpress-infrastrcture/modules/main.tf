provider "aws" {
  region = local.aws-region
}

resource "aws_instance" "wordpress" {
  ami = data.aws_ssm_parameter.linuxAmi.value
  instance_type = "t2.micro"
}