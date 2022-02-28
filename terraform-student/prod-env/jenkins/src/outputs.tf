output "security_group_id" {

  value = module.sec-group-jenkins.security_group_id

}

# output "asg_allinone_instance_id" {
#   value      = asg-qa-1
#   depends_on = []
# }
