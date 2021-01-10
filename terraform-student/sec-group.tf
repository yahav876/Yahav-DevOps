#Create SecGroup for ALB , Only TCP/80 ,TCP/443 and outbound access.
resource "aws_security_group" "lb-sg" {
  provider    = aws.region-master
  name        = "lb-sg"
  description = "Allow 443 and traffic to Jenkins SG"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection" # The ALB will redirect traffic from port 80 to 443
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow outboud to internet world"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # In terraform you spcify "-1" to allowing all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}




#Create SecGroup for Jenkins Master allowing TCP/8080 from Anywhere and TCP/22 from your IP in us-east-1
resource "aws_security_group" "jenkins-sg" {
  provider    = aws.region-master
  name        = "jenkins-sg"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow TCP/22 from our public IP" # This rule for the ssh between master&worker
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip] # Note we have here a variable that we need to create in order it wo work.(variables.tf)
  }
  ingress {
    description     = "Allow anyone on port 8080"
    from_port       = var.webserver-port # the ALB will serve traffic from 443(after redirect from 80 to 443) to 8080
    to_port         = var.webserver-port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id] # The secgroup from which we expect to see the traffic from (the ALB in that case)
  }
  ingress {
    description = "Allow traffic from us-west-2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

#Create a SecGroup for Jenkins Worker allowing TCP/22 from your IP in us-west-2
resource "aws_security_group" "jenkins-sg-oregon" {
  provider = aws.region-worker
  name     = "jenkins-sg-oregon"
  vpc_id   = aws_vpc.vpc_worker_oregon.id
  ingress {
    description = "Allowing 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description = "Allowing traffic from us-east-1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}
