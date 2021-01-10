Deploying to AWS via Terraform And Ansible.

We are creating a distributed multi region environment which built from:

2 VPCs - each on diffrent region.
1 VPC Peering connection.
3 Subnets - 1 for region x and 2 for region y.
3 EC2 instances - 1 for region y and 2 for region x.
2 Route Tables on each VPC.
2 IGW on each VPC.
3 Security Groups - for each VPC and for 1 ALB.
1 ALB.
Route53 records.
ACM Certificate for HTTPS.


ALL I HAVE POST HERE IS TAKEN FROM LinuxAcademy.com , I Have learned their course and it was helpfull to me create everything again to remmember everything.

