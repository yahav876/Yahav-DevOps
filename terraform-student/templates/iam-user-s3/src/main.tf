resource "aws_iam_user" "user" {
  name = "${var.general_config.user_name}-partner"

    tags = {
      "PartnerContent" = "${var.general_config.first_tag_value}",
      "PartnerName" = "${var.general_config.second_tag_value}"

    }
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "${var.general_config.policy_name}-partner"
  user = aws_iam_user.user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor20",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:ListBucket"
            ],
            
            "Resource": [
                "arn:aws:s3:::${var.general_config.s3_bucket_name}"
            ]
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:AbortMultipartUpload",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${var.general_config.s3_bucket_name}/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.general_config.s3_bucket_name}/*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Deny",
            "Action": "s3:Delete*",
            "Resource": [
                "arn:aws:s3:::${var.general_config.s3_bucket_name}"
            ]
        }
    ]
}
EOF
}