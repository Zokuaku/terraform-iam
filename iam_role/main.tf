/*
  main.tf
*/

/*
  Used to set Local or Remote TFstate file location
  with backend "s3", it also provides arguments for
  the provider function.
*/

/*
  IAM Terraform backend for remote collaboration and
  management of the terraform.tfstate for live
  environment.
*/
terraform {
  /*
    Comment out "backend "s3"" for local use. In order
    to leverage remote you will need to uncomment and
    type the following command:
    
    "terraform init -backend-config="config.s3.tfbackend""
    
  */
  /*
  backend "s3" {}
  */
}

/*
  Profile Accessibility for AWS CLI and desired
  region for creation.
*/
provider "aws" {
  profile = var.default_profile
  region  = var.default_region
}