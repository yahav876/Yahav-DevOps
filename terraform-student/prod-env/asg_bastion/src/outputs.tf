output "bastion_sg" {
    value = module.bastion.security_group_id
    depends_on = [
      module.bastion
    ]
}


output "key_pair" {
  value = aws_key_pair.master-key.key_name
}