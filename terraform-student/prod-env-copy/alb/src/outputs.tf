output "elb_zone_id" {
    value = module.alb.lb_zone_id
    depends_on = [
      module.alb
    ]
}

output "elb_dns_name" {
    value = module.alb.lb_dns_name
    depends_on = [
      module.alb
    ] 
}

output "lb_target_group" {
  value = module.alb.target_group_arns
  depends_on = [
    module.alb
  ]
  
}


output "sec-group-ec2" {
  value = module.sec-group-ec2.security_group_id
  depends_on = [
    module.alb
  ]
}

output "sec-group-ec2-stage" {
  value = module.sec-group-ec2-stage.security_group_id
  depends_on = [
    module.alb
  ]
}

output "sec-group-ec2-website-stage" {
  value = module.sec-group-ec2-website-stage.security_group_id
}

output "sec-group-ec2-allinone-stage" {
  value = module.sec-group-ec2-allinone-stage.security_group_id
}


output "sec-group-db" {
  value = module.sec-group-db.security_group_id
  depends_on = [
    module.alb
  ]
}

output "elb_ip_1" {
  value = data.aws_network_interface.elb-ip-1.private_ip
}

output "elb_ip_2" {
  value = data.aws_network_interface.elb-ip-2.private_ip
}




