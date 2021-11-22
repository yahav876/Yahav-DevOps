output "elb_zone_id" {
    value = module.alb.lb_dns_name
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