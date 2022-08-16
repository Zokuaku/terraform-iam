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

/*
  Provider configuration and accessibility for
  the desired AWS EKS K8s Cluster we are wishing
  to interface with.
*/
provider "kubernetes" {
  config_path    = var.kube_config
  config_context = var.kube_context

  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_cert)
}
