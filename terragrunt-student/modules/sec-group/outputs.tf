output "sec-group-jenkins-sg" {
  value = aws_security_group.jenkins-sg.id
}

output "sec_group_jenkins_sg_oregon" {
  value = aws_security_group.jenkins-sg-oregon.id
}

output "sec_group_lb" {
  value = aws_security_group.lb-sg.id
}
