/*
  iam_user.tf
*/

/*
  This creates AWS IAM Users defined in "users.tfvars.json" 
  "users" map and sets them up with AWS Console access, assigns 
  them to the defined group in "groups" and then generates the 
  users encrypted password, access key id and encyrpted access 
  key secret, outputting the results to a file named after the
  user in the "User_Credentials" folder locally and then copies
  it up to the respective S3 bucket. 
*/

/*
  Function to create IAM Users based on what is currently listed 
  in the "users" map from "users.tfvars.json"
*/
resource "aws_iam_user" "user" {
  for_each = var.users

  name          = each.value["name"]
  path          = each.value["path"]
  force_destroy = each.value["destroy"]
  tags = {
    task      = each.value.tags["task"]
    purpose   = "${each.value.tags["purpose"]} ${each.value["name"]}"
    team      = each.value.tags["team"]
    created   = each.value.tags["created"]
    createdby = each.value.tags["createdby"]
    owner     = each.value.tags["owner"]
  }
}

/*
  Creates the necessary PGP Key for securely encrypting the
  new user password and secret key provided in the user 
  credential files.
*/
resource "pgp_key" "user_login_key" {
  for_each = var.users

  name    = each.value["name"]
  email   = each.value["email"]
  comment = "PGP Key for ${each.value["name"]}"
}

/*
  Gives the defined user accounts AWS Console access and sets
  whether the requirement that the password needs to be reset 
  on first login.
*/
resource "aws_iam_user_login_profile" "user_profile" {
  for_each = var.users

  user                    = each.value["name"]
  password_reset_required = each.value["passreset"]
  pgp_key                 = pgp_key.user_login_key[each.key].public_key_base64
  depends_on              = [aws_iam_user.user, pgp_key.user_login_key]
}

/*
  Generates the necessary Secret Key for remote AWS CLI
  accessibility for the newly created user.
*/
resource "aws_iam_access_key" "user_key" {
  for_each = var.users

  user       = each.value["name"]
  pgp_key    = pgp_key.user_login_key[each.key].public_key_base64
  depends_on = [aws_iam_user.user, pgp_key.user_login_key]
}

/*
  Decrypts the end user password to write out in plain text
  to the user credentials csv.
*/
data "pgp_decrypt" "user_password_decrypt" {
  for_each = var.users

  ciphertext          = aws_iam_user_login_profile.user_profile[each.key].encrypted_password
  ciphertext_encoding = each.value["cipher"]
  private_key         = pgp_key.user_login_key[each.key].private_key
}

/*
  Decrypts the end user secret key to write out in plain text
  to the user credentials csv.
*/
data "pgp_decrypt" "user_key_decrypt" {
  for_each = var.users

  ciphertext          = aws_iam_access_key.user_key[each.key].encrypted_secret
  ciphertext_encoding = each.value["cipher"]
  private_key         = pgp_key.user_login_key[each.key].private_key
}

/*
  Adds the new users to the respective aws iam groups defined
  in "groups" from "users.tfvars.json"
*/
resource "aws_iam_user_group_membership" "user_group_add" {
  for_each = var.users

  user   = each.value["name"]
  groups = each.value["groups"]

  depends_on = [
    aws_iam_user.user
  ]
}

/*
  Outputs Username, Password, Access Key and Secret Key to a file
  labelled "<end_user>_user_credentials.csv" that is stored in a 
  local folder called "User_Credentials".

  Note: In the future this will likely be distributed by SQS/SNS
  instead of from the local desktop or defined s3 bucket via the
  End User running these HCL scripts.
*/
resource "local_file" "user_credentials" {
  for_each = var.users

  content  = <<EOT
  Username,Password,Access_Key,Secret_Key
  ${aws_iam_user.user[each.key].name~},${data.pgp_decrypt.user_password_decrypt[each.key].plaintext~},${aws_iam_access_key.user_key[each.key].id~},${data.pgp_decrypt.user_key_decrypt[each.key].plaintext~}
  EOT
  filename = "${path.module}/User_Credentials/${aws_iam_user.user[each.key].name}_user_credentials.csv"
}

/*
  Creates a copy of the User Credentials files in the defined
  encrypted S3 bucket with the intent to eventually deliver the
  files via SQS/SNS. 
*/
resource "aws_s3_object" "files" {
  for_each = fileset("${local.credential_files}", "*")

  bucket      = var.s3_user_cred_folder
  key         = "iam/User_Credentials/${each.value}"
  source      = "${local.credential_files}${each.value}"
  source_hash = filemd5("${local.credential_files}${each.value}")
}