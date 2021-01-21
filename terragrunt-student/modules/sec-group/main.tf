#Create SecGroup for ALB , Only TCP/80 ,TCP/443 and outbound access.
resource "aws_security_group" "lb-sg" {
  #provider    = aws.region-master
  name        = var.lb-sg-name
  description = var.lb-sg-description
  vpc_id      = var.master-vpc-id
  ingress {
    description = var.lb-sg-ingress-description-1
    from_port   = var.from-port-lb-1
    to_port     = var.to-port-lb-1
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection" 
    from_port   = var.from-port-lb-2
    to_port     = var.to-port-lb-2
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
  # provider    = aws.region-master
  name        = var.master-sg-name
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = var.master-vpc-id
  ingress {
    description = "Allow TCP/22 from our public IP" # This rule for the ssh between master&worker
    from_port   = var.from-port-master-1
    to_port     = var.to-port-master-1
    protocol    = "tcp"
    cidr_blocks = [var.external-ip]
  }
  ingress {
    description     = "Allow anyone on port 8080"
    from_port       = var.from-port-master-2 
    to_port         = var.to-port-master-2
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id] 
  }
  ingress {
    description = "Allow traffic from us-west-2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.master-cidr]
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
  # provider = aws.region-worker
  name     = var.worker-sg-name
  vpc_id   = var.worker-vpc-id
  ingress {
    description = "Allowing 22 from our public IP"
    from_port   = var.from-port-worker-1
    to_port     = var.to-port-worker-1
    protocol    = "tcp"
    cidr_blocks = [var.external-ip]
  }
  ingress {
    description = "Allowing traffic from us-east-1"
    from_port   = var.from-port-worker-2
    to_port     = var.to-port-worker-2
    protocol    = "-1"
    cidr_blocks = [var.worker-cidr]
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
