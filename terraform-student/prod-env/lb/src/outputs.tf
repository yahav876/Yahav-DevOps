output "elb_zone_id" {
    value = module.lb-website.lb_zone_id
    depends_on = [
      module.lb-website
    ]
}

output "elb_dns_name" {
    value = module.lb-website.lb_dns_name
    depends_on = [
      module.lb-website
    ] 
}

output "lb_target_group_website" {
  value = module.lb-website.target_group_arns
  depends_on = [
    module.lb-website
  ]
  
}

output "lb_target_group_allinone" {
  value = module.lb-allinone.target_group_arns
  depends_on = [
    module.lb-allinone
  ]
  
}


output "sec-group-ec2" {
  value = module.sec-group-allinone.security_group_id
  depends_on = [
    module.lb-website
  ]
}

output "sec-group-ec2-stage" {
  value = module.sec-group-website.security_group_id
  depends_on = [
    module.lb-website
  ]
}

output "sec-group-ec2-website-stage" {
  value = module.sec-group-website.security_group_id
}

output "sec-group-ec2-allinone-stage" {
  value = module.sec-group-allinone.security_group_id
}


output "sec-group-db" {
  value = module.sec-group-db.security_group_id
  depends_on = [
    module.lb-website
  ]
}

output "elb_ip_1" {
  value = data.aws_network_interface.elb-ip-1.private_ip
}

output "elb_ip_2" {
  value = data.aws_network_interface.elb-ip-2.private_ip
}




