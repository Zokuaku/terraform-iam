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
  below. Kubernetes Provider is utilized
  to interface with the desired AWS EKS 
  Cluster defined in variables.tfvars
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.24.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.12.1"
    }
  }
  required_version = ">= 1.2.3"
}