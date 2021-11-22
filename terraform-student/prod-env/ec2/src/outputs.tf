output "ec2-prod-id-website" {
  value = module.ec2_instance_1.id
  depends_on = [
    module.ec2_instance_1
  ]
}
output "ec2-prod-id-all-in-one" {
    value = module.ec2_instance_2.id
    depends_on = [
      module.ec2_instance_2
    ]
  
}

output "key_pair" {
  value = aws_key_pair.master-key.key_name
  
}


output "network_interface_prod" {
  depends_on = [
    module.ec2_instance_1
  ]
  value = module.ec2_instance_1.primary_network_interface_id
}