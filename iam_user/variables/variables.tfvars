/*
  variables.tfvars
*/

/*
  Predefined variables for use within other
  localized Terraform Modules to populate 
  main.tf requirements.
*/

/*
  Main Variables
*/
default_profile = "default"
default_region  = "us-west-2"

/*
  S3 Bucket for Credentials Storage
*/
s3_user_cred_folder = "safecloud-global-infrastructure"