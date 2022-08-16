# iam_access_key.tf

/*
    This is a sample of what you need for generating
    the Access and Secret Key for AWS CLI accessibility
*/

resource "aws_iam_user" "kennedy_john" {
  name = "kennedy_john"
  path = "/"
}

resource "aws_iam_access_key" "kennedy_john_key" {
  user    = aws_iam_user.kennedy_john.name
  pgp_key = "keybase:zokuaku"
}

resource "aws_iam_user_policy" "ec2_policy" {
  name = "ec2_policy"
  user = aws_iam_user.kennedy_john.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}