#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  # provider = aws.region-master
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Get Linux AMI ID using SSM Parameter endpoint in us-west-2
data "aws_ssm_parameter" "linuxAmiOregon" {
  # provider = aws.region-worker
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  # provider   = aws.region-master
  key_name   = var.master-key-name
  public_key = file("~/.ssh/ec2_ansible_terraform.pub")
}

##Create key-pair for logging into EC2 in us-west-2
#resource "aws_key_pair" "worker-key" {
#  key_name   = var.master-key-name
#  public_key = file("~/.ssh/ec2_ansible_terraform.pub")
#}



#Create and boostrap EC2 in us-east-1
resource "aws_instance" "jenkins-master" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sec-group-jenkins-sg]
  subnet_id                   = var.subnet-1

  tags = {
    Name = var.jenkins-master-tf
  }
  depends_on = [var.main-route-table-1]

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id}
ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible-playbooks/jenkins-master-sample.yaml
EOF
  }

}


#Create and boostrap EC2 in us-west-2
resource "aws_instance" "jenkins-worker-oregon" {
  # provider                    = aws.region-worker
  count                       = var.workers-count
  ami                         = data.aws_ssm_parameter.linuxAmiOregon.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sec-group-jenkins-sg-oregon]
  subnet_id                   = var.subnet-1-oregon

  tags = {
    Name = join("_", ["jenkins_worker_tf", count.index + 1]) 
  }
  depends_on = [var.main-route-table-1, aws_instance.jenkins-master]

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-worker} --instance-ids ${self.id}
ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible-playbooks/jenkins-worker-sample.yaml
EOF
  }

}

