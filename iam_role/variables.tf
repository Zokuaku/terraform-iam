/*
  variables.tf
*/

/*
  Predefined variables for use within other
  localized Terraform Modules to generate
  AWS IAM Roles.
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
  Roles map defines the variable type associated
  with each key and structure based on the content
  provided in roles.tfvars.json
*/
variable "roles" {
  type = map(
    object({
      name       = string,
      path       = string,
      destroy    = string,
      tags       = map(any),
      action     = string,
      type       = string,
      identifier = string,
      policies   = list(string)
    })
  )
  default = {
  }
}