
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
  vpc_security_group_ids = [aws_security_group.wordpres_sg.id]
  subnet_id = data.aws_subnet.selected.id
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              cd /var/www/html
              echo "yahav-wordpress" > index.html
              chkconfig httpd on
              service httpd start
              EOF
  tags = {
    Name  = "Wordpress"
  }
}

resource "aws_security_group" "wordpres_sg" {
    name = "wpsg"

    ingress {
      from_port = 80
      protocol = "tcp"
      to_port = 80
      cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}