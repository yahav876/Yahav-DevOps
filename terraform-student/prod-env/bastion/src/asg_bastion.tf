# Use this command to retrieve the public key from the private key
# cat .ssh/id.rsa.pub
# Paste the output in pub_key value in env/variables.tfvars
  
  locals {
  user_data_bastion = <<-EOT
  #!/bin/bash
  # Assosiate elastic ip 
  sudo apt install awscli -y
  instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
  allocated_eip=3.136.63.98
  REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
  aws ec2 associate-address --instance-id $instance_id --public-ip $allocated_eip --region $REGION
  EOT
}

resource "aws_key_pair" "master-key" {
  key_name   = var.general_config.key_name
  public_key = var.general_config.pub_key
  # If you with to use local keypair -
  # public_key = file("/circles-test-terraform2.pub")

}


resource "aws_iam_policy" "ec2-describe" {
  name        = "ec2_describe_for_bastion"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "bastion-attachment" {
  name       = "bastion-attachment"
  roles      = [module.bastion.iam_role_id]
  policy_arn = aws_iam_policy.ec2-describe.arn

  depends_on = [
    module.bastion
  ]
}

module "bastion" {
  source  = "umotif-public/bastion/aws"
  version = "~> 2.1.0"

  name_prefix = var.general_config.bastion_name

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets = [
    data.terraform_remote_state.vpc.outputs.subnets_id_public[0],
    data.terraform_remote_state.vpc.outputs.subnets_id_public[1]
  ]

  ssh_key_name           = aws_key_pair.master-key.key_name
  bastion_instance_types = [var.general_config.ec2_size_bastion]
  volume_size            = 8
  # user_data_base64         = base64encode(local.user_data_website)

  ami_id = data.aws_ami.bastion.image_id
  on_demand_base_capacity = 1
  userdata_file_content =  templatefile("./custom-userdata.sh", {})


  tags = {
    "${var.general_config.first_tag_key}" = "${var.general_config.first_tag_value}"
  }
}


resource "aws_security_group_rule" "bastion_vpn" {
  depends_on = [
    module.bastion
  ]
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = var.cidr_blocks
  security_group_id = module.bastion.security_group_id
}

