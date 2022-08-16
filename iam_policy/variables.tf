/*
  variables.tf
*/

/*
  Predefined variables for use within other
  localized Terraform Modules to generate
  AWS IAM Policies.
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
  Policies map defines the variable type associated
  with each key and structure based on the content
  provided in policies.tfvars.json
*/
variable "policies" {
  type = map(
    object({
      name      = string,
      path      = string,
      tags      = map(any),
      actions   = list(string),
      resources = list(string)
    })
  )
  default = {
  }
}