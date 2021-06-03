
provider "aws" {
  region = "us-east-1"
}
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "wordpress" {
  ami = data.aws_ssm_parameter.linuxAmi.value
  instance_type = "t2.micro"
  user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd
        cd /var/www/html
        echo "yahav wordpress" > index.html
        service httpd start
        chkconfig httpd on
        EOF

  tags = {
    Name  = "Wordpress"
  }
}