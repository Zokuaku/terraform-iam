/*
  variables.tf
*/

/*
  Predefined variables for use within other
  localized Terraform Modules to generate
  S3 Buckets and DynamoDB Tables.
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
  Buckets map defines the variable type associated
  with each key and structure based on the content
  provided in s3_buckets.tfvars.json
*/
variable "buckets" {
  type = map(
    object({
      name     = string,
      destroy  = string,
      tags     = map(any),
      acl      = string,
      ver_stat = string,
      key_desc = string,
      key_del  = string,
      sse_algo = string
    })
  )
  default = {
  }
}

/*
  Tables map defines the variable type associated
  with each key and structure based on the content
  provided in s3_database.tfvars.json
*/
variable "tables" {
  type = map(
    object({
      name     = string,
      bill     = string,
      tags     = map(any),
      hash_key = string,
      db_type  = string
    })
  )
  default = {
  }
}