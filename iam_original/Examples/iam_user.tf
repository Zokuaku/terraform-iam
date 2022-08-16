# iam_user.tf

/*
    This is a sample of what you need for generating
    a user in the AWS IAM Console
*/

resource "aws_iam_user" "user" {
  name = "kennedy.john"
  path = "/"
}