/*
  variables.tf
*/

/*
  Predefined variables for use within other
  localized Terraform Modules to generate
  AWS IAM Users.
*/

/*
  Profile variable defines the AWS Profile to
  use for running commands. Used in "main.tf"
*/
variable "default_profile" { type = string }

/*
  Variable region defining default working region.
  Used in "main.tf"
*/
variable "default_region" { type = string }

/*
  Variable used to set the destination of where
  the User Credentials files should be stored in
  S3.
*/
variable "s3_user_cred_folder" { type = string }

/*
  Users map defines the variable type associated
  with each key and structure based on the content
  provided in users.tfvars.json
*/
variable "users" {
  type = map(
    object({
      name      = string,
      email     = string,
      path      = string,
      destroy   = string,
      tags      = map(any),
      passreset = string,
      cipher    = string,
      groups    = list(string),
    })
  )
  default = {
  }
}