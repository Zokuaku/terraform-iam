/*
  policies.tf
*/

/*
  Defined requirements to build AWS Policies to be
  applied to Users, Groups and Roles in the AWS
  IAM Console.
*/

/*
  AWS IAM Account Password Policy defined per Safe
  Softwares ISMS-POL-106 Password & Access Policy
  Section 3.2 Passphrase/Password Construction
  Guidelines
*/
resource "aws_iam_account_password_policy" "strict" {
  password_reuse_prevention      = 6
  minimum_password_length        = 14
  max_password_age               = 365
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  allow_users_to_change_password = true
}