### ACM 
#DNS configuration
data "aws_route53_zone" "dns" {
 # provider = aws.region-master
  name     = var.data-dns-name
}

#Create ACM Certificate and requests validation via DNS(Route53)
resource "aws_acm_certificate" "jenkins-lb-https" {
  #provider          = aws.region-master
  domain_name       = join(".", [var.domain-name, data.aws_route53_zone.dns.name])
  validation_method = "DNS"
  tags = {
    Name = var.acm-name
  }
}

#Validates ACM issued certificate via Route53
resource "aws_acm_certificate_validation" "cert" {
  #provider                = aws.region-master
  certificate_arn         = aws_acm_certificate.jenkins-lb-https.arn
  for_each                = aws_route53_record.cert_validation
  validation_record_fqdns = [aws_route53_record.cert_validation[each.key].fqdn]
}

##############################################################################################


##ALB 
#Create ALB
resource "aws_lb" "application-lb" {
 # provider           = aws.region-master
  name               = var.lb-name
  internal           = false
  load_balancer_type = var.lb-type
  security_groups    = [var.sec-group-lb]
  subnets            = [var.subnet-1, var.subnet-2]
  tags = {
    Name = var.lb-name
  }
}

#Create targer group
resource "aws_lb_target_group" "app-lb-tg" {
 # provider    = aws.region-master
  name        = var.lb-tg-name
  port        = var.webserver-port
  target_type = var.target-type
  vpc_id      = var.vpc-master
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.webserver-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = var.lb-tg-name
  }
}

#Create a listener for ALB
resource "aws_lb_listener" "jenkins-listener-http" {
 #provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#Create listener on port 443
resource "aws_lb_listener" "jenkins-listener-https" {
 # provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = aws_acm_certificate.jenkins-lb-https.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.arn
  }
}







#Create target group attachment for LB
resource "aws_lb_target_group_attachment" "jenkins-master-attach" {
 # provider         = aws.region-master
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = var.jenkins-master-id
  port             = var.webserver-port
}







##DNS
#Create alias record to this hosted zone to point to DNS name for the ALB!
resource "aws_route53_record" "cert_validation" {
#  provider = aws.region-master
  for_each = {
    for val in aws_acm_certificate.jenkins-lb-https.domain_validation_options : val.domain_name => {
      name   = val.resource_record_name
      record = val.resource_record_value
      type   = val.resource_record_type
    }
  }
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = data.aws_route53_zone.dns.zone_id
}


#Create Alias record towards ALB from route53
resource "aws_route53_record" "jenkins" {
#  provider = aws.region-master
  zone_id  = data.aws_route53_zone.dns.zone_id
  name     = join(".", [var.domain-name, data.aws_route53_zone.dns.name])
  type     = var.record-type
  alias {
    name                   = aws_lb.application-lb.dns_name
    zone_id                = aws_lb.application-lb.zone_id
    evaluate_target_health = true
  }
}


