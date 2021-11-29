output "bastion_sg" {
    value = module.bastion.security_group_id
    depends_on = [
      module.bastion
    ]
}