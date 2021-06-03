data "aws_ssm_parameter" "linuxAmi" {
  provider = local.aws-region
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}