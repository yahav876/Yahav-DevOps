output "data_ami" {

  value = data.aws_ami.allinone.image_id

}

output "data_ami_website" {

  value = data.aws_ami.website.image_id

}

# output "asg_allinone_instance_id" {
#   value      = asg-qa-1
#   depends_on = []
# }
