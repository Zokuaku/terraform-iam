/*
  versions.tf
*/

/*
  Contains the details for any required
  providers for desired interoperability
  with existing modules.
*/

/*
  Default Providers for AWS CLI included
  below.
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.24.0"
    }
  }
  required_version = ">= 1.2.3"
}