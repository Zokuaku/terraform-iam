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
  below. "ekristen/pgp" is for handling
  AWS pgp key requirements for 
  "aws_iam_access_key"
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.24.0"
    }
    pgp = {
      source  = "ekristen/pgp"
      version = ">= 0.2.4"
    }
  }
  required_version = ">= 1.2.3"
}