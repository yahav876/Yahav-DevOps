general_config = {

  region                 = "us-east-2"
  backend_region         = "eu-west-3"
  backend_bucket_name    = "cloudteam-tf-circles"
  ec2_size_bastion       = "t2.micro"
  bastion_name           = "bastion-server"
  first_tag_key          = "backup-weekly"
  first_tag_value        = "true"
  key_name               = "terraform-circles2.2"
  pub_key                = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDr2DeikQKw2NFPFZd+FeLbia+7kkF2EEDUG9tRdLU46m09Rbqn5hUVV5b7IOuxVymrbygL9oRAQz9K1QHnba8bBkEm3RfgpSoOszM1yrw84l5SmnbI5pGDYLsvOh2l0UntjB+kKoya9uOVi1OGl2ALsx2Hd2mIen3/blQREYahgKF5RJ0DKWgXSwt5fK5n98qn9ASkOYaDuXM0q4Vnt5t+y6hdRiMCGaj3PXXAGUaqmfnV+9E6tZlMpu5e2HgsXCPXJqDkHeRWi232Zb3I2xQiPKzzF3g0KdF5Y320dBVdvwb35+jTdJpr72h6HgajnLTaFs6zCzU+1ZoodYOaKnpJkulF+c8sPqv6eG7GIk+CxAi/3XMCRrAyMNFgqoHMfdZWvLiFOZzSRjHBAuFVnUrzmN+q7BQ8MgNBkLlb65AcWtE15pYiKjJ4kv7d2WXB03G3wsPufA3ujZmIpH5WxeWEKXf+PekVQ+ZmWL7RmGgtSTiWI1lJk5gn+Ft5KvnCwZc= yahavhorev@YahavHorevLP"
  eip_id                 = "eipalloc-071c2af991797984e"
  bastion_name_tag_value = "bastion-server-bastion"
  filter_ami_key         = "Name"
  filter_ami_value       = "bastion-server-bastion"
}

cidr_blocks = ["0.0.0.0/0"]
