output "ec2-prod-id-website" {
  value = module.ec2_instance_11.id
  depends_on = [
    module.ec2_instance_11
  ]
}
output "ec2-prod-id-all-in-one" {
    value = module.ec2_instance_2.id
    depends_on = [
      module.ec2_instance_2
    ]
  
}