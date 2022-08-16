/*
  main.tf
*/

/*
  Used to set Local/Remote TFstate as well as the
  following:
    
  Set your minimum/maximum versions for Terraform 
  and the AWS CLI. You can also estabilish which 
  AWS CLI Profile to use to interface with AWS and
  your AWS desired default region for deployment.
*/

/*
  IAM Terraform backend for remote collaboration and
  management of the terraform.tfstate for live
  environment.
*/
terraform {
  /*
  backend "s3" {
    bucket               = "safecloud-global-infrastructure"
    key                  = "iam/terraform.tfstate"
    region               = "us-west-2"
    workspace_key_prefix = "safecloud-terraform-infrastructure"

    dynamodb_table = "safecloud-terraform-locks"
    encrypt        = true
  }
  */

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.24.0"
    }

    pgp = {
      source  = "ekristen/pgp"
      version = ">= 0.2.4"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.3.2"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.2.3"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.12.1"
    }
  }
  required_version = ">= 1.2.3"
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

provider "kubernetes" {
  config_path    = var.kube_config
  config_context = var.kube_context

  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_cert)
}
*/