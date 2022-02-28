output "bastion_sg" {
    value = module.bastion.security_group_id
    depends_on = [
      module.bastion
    ]
}


output "key_pair" {
  value = aws_key_pair.master-key.key_name
}

# output "aws_instance" {
#   value = data.aws_instances.bastion
# }

output "ami_bastion" {
  value = data.aws_ami.bastion.image_id
}