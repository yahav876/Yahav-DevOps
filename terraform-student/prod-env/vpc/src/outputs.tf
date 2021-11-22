output "vpc_id" {
    value = module.vpc.vpc_id
    depends_on = [
      module.vpc
    ]
  }

output "subnets_id_public" {
     value = module.vpc.public_subnets
     depends_on = [
       module.vpc
     ]
 }

output "subnets_id_private" {
     value =  module.vpc.private_subnets
     depends_on = [
       module.vpc
     ]
 }

 output "sec-group-elb" {

    value = module.sec-group-elb.security_group_id
    depends_on = [
      module.vpc
    ]
 }

output "sec-group-ec2" {
  value = module.sec-group-ec2.security_group_id
  depends_on = [
    module.vpc
  ]
}

output "sec-group-db" {
  value = module.sec-group-db.security_group_id
  depends_on = [
    module.vpc
  ]
}

# output "zone_id" {
#   value = module.zones.route53_zone_zone_id
#   depends_on = [
#     module.zones
#   ]
  
# }