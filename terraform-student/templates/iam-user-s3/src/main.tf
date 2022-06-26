# module "iam_user" {
#     source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  
#     name          = var.general_config.name
#     create_iam_access_key = true
#     force_destroy = true
  
#     # pgp_key = "keybase:test"
  
#     password_reset_required = false


#     tags = {
#       "PartnerContent" = "value",
#       "PartnerName" = "value"

#     }
#   }

#   module "iam_policy" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

#   name        = "vidaa-partner-exmaple"
#   path        = "/"
#   description = "My example policy"

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": [
#                 "s3:PutObject",
#                 "s3:GetObjectAcl",
#                 "s3:GetObject",
#                 "s3:AbortMultipartUpload",
#                 "s3:PutObjectAcl"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::tremor-partner/*",
#                 "arn:aws:s3:::spearad-partner/*",
#                 "arn:aws:s3:::tremor-partner",
#                 "arn:aws:s3:::spearad-partner"
#             ]
#         },
#         {
#             "Sid": "VisualEditor1",
#             "Effect": "Allow",
#             "Action": "s3:*",
#             "Resource": [
#                 "arn:aws:s3:::tremor-partner/*",
#                 "arn:aws:s3:::spearad-partner/*",
#                 "arn:aws:s3:::tremor-partner",
#                 "arn:aws:s3:::spearad-partner"
#             ]
#         },
#         {
#             "Sid": "VisualEditor2",
#             "Effect": "Deny",
#             "Action": "s3:Delete*",
#             "Resource": [
#                 "arn:aws:s3:::tremor-partner",
#                 "arn:aws:s3:::spearad-partner"
#             ]
#         }
#     ]
# }
# EOF
# }

data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:AbortMultipartUpload",
      "s3:PutObjectAcl",
      "sts:AssumeRole"
    ]

    resources = [
      "arn:aws:s3:::${var.general_config.s3_bucket_name}/*",
      "arn:aws:s3:::${var.general_config.s3_bucket_name}"
    ]
  }

  statement {
    
    effect = "Allow"

    actions = [
      "s3:*",
      "sts:AssumeRole"
    ]

    resources = [
      "arn:aws:s3:::${var.general_config.s3_bucket_name}",
    ]

    # condition {
    #   test     = "StringLike"
    #   variable = "s3:prefix"

    #   values = [
    #     "",
    #     "home/",
    #     "home/&{aws:username}/",
    #   ]
    # }
  }

  statement {

    effect = "Deny"

    actions = [
      "s3:Delete*",
      "sts:AssumeRole"

    ]

    resources = [
      "arn:aws:s3:::${var.general_config.s3_bucket_name}"
    ]
  }
}

resource "aws_iam_policy" "example" {
  name   = "yahav-tf"
  path   = "/"
  policy = data.aws_iam_policy_document.example.json
}


resource "aws_iam_role" "example" {
  name               = "yahav-test-role-tf"
  assume_role_policy = data.aws_iam_policy_document.example.json # (not shown)
}
  # depends_on = [
    
  # ]

  # inline_policy {
  #   name = "my_inline_policy"

  #   policy = jsonencode({
  #     Version = "2012-10-17"
  #     Statement = [
  #       {
  #         Action   = ["ec2:Describe*"]
  #         Effect   = "Allow"
  #         Resource = "*"
  #       },
  #     ]
  #   })
  # }
# }