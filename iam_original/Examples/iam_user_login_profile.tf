# iam_user_login_profile.tf

/*
    This is a sample of what you need for generating
    the an AWS IAM user with AWS Console access and 
    encrypted password generation.
*/

resource "aws_iam_user" "admin" {
  name          = var.administrators
  path          = "/"
  force_destroy = true
  tags = {
    Name = "DevOps Server Administrator"
  }
}

resource "aws_iam_user_login_profile" "admin_profile" {
  user                    = aws_iam_user.admin.name
  password_reset_required = true
  pgp_key                 = "keybase:zokuaku"
}