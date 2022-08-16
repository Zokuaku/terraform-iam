# Terraform Safecloud Infrastructure

Infrastructure-as-code implementation for IAM and S3 buckets to be used for Safe Softwares AWS Safecloud.

## Table of contents
- [Terraform Safecloud Infrastructure](#terraform-safecloud-infrastructure)
  - [Table of contents](#table-of-contents)
  - [Overview](#overview)
  - [Technologies](#technologies)
  - [General Info](#general-info)
    - [AWS IAM User](#aws-iam-user)
    - [AWS IAM Group](#aws-iam-group)
    - [AWS IAM Policies](#aws-iam-policies)
    - [AWS S3](#aws-s3)
  - [Directory Structure](#directory-structure)
    - [`/iam`](#iam)
    - [`/s3`](#s3)
    - [`/variables`](#variables)
  - [Getting Started](#getting-started)
      - [IAM Remote (default - live)](#iam-remote-default---live)
      - [IAM Initialization (local - testing)](#iam-initialization-local---testing)
      - [S3 Remote (default - live)](#s3-remote-default---live)
      - [S3 Initialization (local - testing)](#s3-initialization-local---testing)
  - [Sanitizing](#sanitizing)
      - [Validation](#validation)
      - [Formatting](#formatting)
  - [Deploying](#deploying)
      - [IAM](#iam-1)
      - [S3](#s3-1)
      - [IAM](#iam-2)
      - [S3](#s3-2)

## Overview
These folders contains all the configuration files required to create AWS IAM User Accounts, Groups, Policies and S3 storage for Safecloud. Folders are disseminated into S3 and IAM repsectively to fit Terraform recommended folder heirarchy and best practice. Workspaces are not leveraged as these parameters are largely considered to be Global variables (No independant Production/Staging/QA).

## Technologies
Project is created with:
* Terraform 1.1.0

## General Info

### AWS IAM User
Ideally this section would add generation of the User credentials file to a secure S3 bucket with SQS/SNS forwarding to automate User account generation with no need for third-party distribution by DevOps or TechOps.
> :Warning: Not fully defined

Existing features are:
* User Account Creation for (AWS Console, CLI and Service Accounts)
* Password, Access Key and Secret Key generation with PGP encryption
* add user to desired AWS IAM Group
* Generate CSV User Account Credentials files named based on `[Username]_user_credentials.csv` (Presently stored locally)

### AWS IAM Group
This section could use some expansion to leverage it's own tfvars file to build out more of the desired infrastructure for the Safecloud AWS permissions accessibilty etc. Current policies applied to AWS IAM Group is defined in `variables.tf`
> :Warning: Not fully defined

Existing features are:
* Creates an AWS IAM Group 
* Applies desired Policies defined in `variables.tf` (could be migrated to unique `grp_variables.tfvars` file)

### AWS IAM Policies
Presently limited in scope to just imposing the Password Enforcement Policy defined in Safes ISMS-POL-106 Password and Access Policy. Foresee adding another `policy_variables.tfvars` in the future that would define permissions for various Safe End-users/groups.
> :Warning: Not fully defined

Existing features are:
* Password Enforcement Policy as required for the `iam_admin.tf`

### AWS S3
Opportunity exists to fully define multiple project S3 root directories and exploring a desired state for sub-folder heirarchy that makes the most sense for end-user engagement. Presently limited in scope to defining a root folder structure for `safecloud-global-infrastructure` which is limited in scope to AWS IAM and S3 for safely encrypting and storing the `terraform.tfstate` files for both sets of scripts.
> :Warning: Not fully defined

Existing features are:
* generates a private, encrypted, s3 storage space with a dynamoDB for managing `terraform.tfstate` locking

## Directory Structure

### `/iam`

The iam scripts that are used for managing the Safecloud/AWS IAM Infrastructure are included in the `iam/` folder. They are as follows:

|      Script    |               Description             |
|---------------------|--------------------------|
| `main.tf` | Defines Terraform required providers, desired AWS profile and desired working region.
| `iam_admin.tf` | Creates an AWS IAM User, generates a PGP Key, generates random first password for AWS Console access with password reset enforcement, access key and secret key generation for AWS CLI, Password/Access/Secret Key decryption, group membership addition and User Credential file generation.
| `iam_group.tf` | Generates AWS IAM Group and attach's desired AWS IAM Policies.
| `policies.tf` | Presently defines Password Enforcement Policy for AWS Accounts based on Safes ISMS-POL-106 Password and Access Policy (otherwise this is not fully defined presently).
| `variables.tf` | Contains desired state configurations to be passed through to respective modules for processing.
| `variables/iam_variables.tfvars` | Preferred means of storing variables to operate in a private state that is not disclosed upon processing in the tfstate.
| `output.tf` | Terminal output of User Name, ARN, Fingerprint, Access Key, Access Key Secret (Hashed), Password (Hashed)

### `/s3`

The s3 scripts that are used for managing the Safecloud/AWS S3 Infrastructure are included in the `s3/` folder. They are as follows:

|      Script    |               Description             |
|---------------------|--------------------------|
| `main.tf` | Defines Terraform required providers, desired AWS profile and desired working region.
| `s3_bucket.tf` | Create and tags buckets based on values from `s3_buckets.tvfars`, sets bucket value to private, enables versioning, sets key life, and enables server side encyrption.
| `s3_db.tf` | Creates a DynamoDB table called `safecloud-terraform-locks` for moderating accessibility to respective `terraform.tfstate` files
| `variables.tf` | Contains passthrough variables from `s3_buckets.tvfars` for default region and default profile
| `variables/s3_buckets.tfvars` | Stores the ideal variables and properties we wish to apply to explicitly defined s3 buckets (used to keep values private)
| `output.tf` | Output's the ARN for our S3 buckets and the name of our DynamoDB table

### `/variables`
Variables for `IAM` are used for defining "Default" AWS Profile, Desired working Region, IAM User Accounts, User Emails, IAM Groups and IAM Policies. Terraform. Includes details like resourcec tags, CIDR blocks, and resource names.

Variables for `S3` are used for defining "Default" AWS Profile, Desired working Region and S3 Buckets. Terraform contains required providers, appropriate tagging for AWS resources, respective ACL and Encryption properties and DynamoDB Table properties for tfstate locking.

## Getting Started

> :Warning: This terraform configuration was initially developed with Terraform version `1.1.0`. Be wary of some compatibility issues if using an older or newer version.

To work with the IAM and S3 terraform configurations, you will need to install Terraform https://learn.hashicorp.com/tutorials/terraform/install-cli

> :Key: You will need to have access to AWS credentials in your environment to proceed

The work done by Terraform requires an IAM user with sufficient permissions to create/destroy many objects on AWS. To request a proper account with desired permissions contact Johnathan Kerssens or John Kennedy to use the respective IAM Terraform scripts to generate it for you per (https://safesoftware.atlassian.net/browse/DEVOPS-1989). Or in lieu of a proper locked down account, you can also reach out to Jackie for the information for the user `baradmin` for these operations for the time being.


Once Terraform is installed, navigate to your local `safecloud_infrastructure` directory in your terminal to work with either `IAM` or the `S3` configuration.

#### IAM Remote (default - live)

To initialize Terraform and start working with the remote `terraform.tfstate` input the following:

    terraform init

#### IAM Initialization (local - testing)

Else to create a localized instance of the `iam` `terraform.tfstate` open the respective `main.tf` and comment out the following lines:

    terraform {
        backend "iam" {
            bucket               = "safecloud-global-infrastructure"
            key                  = "iam/terraform.tfstate"
            region               = "us-west-2"
            workspace_key_prefix = "safecloud-terraform-infrastructure"

            dynamodb_table = "safecloud-terraform-locks"
            encrypt        = true
        }
    }

Followed by making sure the following lines are uncommented:

    terraform {
        required_providers {
            aws = {
                source  = "hashicorp/aws"
                version = "~> 3.27"
            }
            pgp = {
                source = "ekristen/pgp"
            }
        }
    required_version = ">= 1.1.0"
    }

You will also need to navigate to the `iam_variables.tfvars` file and modify the values for `safecloud_default_profile` and `safecloud_default_region` to fit your testing parameters.

#### S3 Remote (default - live)

To initialize Terraform and start working with the remote `terraform.tfstate` input the following:

    terraform init

#### S3 Initialization (local - testing)

Else to create a localized instance of the `s3` `terraform.tfstate` open the respective `main.tf` and comment out the following lines:

    terraform {
        backend "s3" {
            bucket               = "safecloud-global-infrastructure"
            key                  = "s3/terraform.tfstate"
            region               = "us-west-2"
            workspace_key_prefix = "safecloud-terraform-infrastructure"

            dynamodb_table = "safecloud-terraform-locks"
            encrypt        = true
        }
    }

Followed by making sure the following lines are uncommented:

    terraform {
        required_providers {
            aws = {
                source  = "hashicorp/aws"
                version = "~> 4.17"
            }
        }
    required_version = ">= 1.1.0"
    }

You will also need to navigate to the `s3_buckets.tfvars` file and modify the values for `safecloud_default_profile` and `safecloud_default_region` to fit your testing parameters.

## Sanitizing

After making any changes to your Terraform files verify that they are succinct and the functions are clearly defined by using the validate command as follows:

#### Validation

    terraform validate

Also, as a best practice to keep the code readable Terraform provides a format tool to cleanup script formatting as follows:

#### Formatting

    terraform fmt

## Deploying

After making any changes to iam or s3 (Terraform files, etc.), verify that Terraform will make the correct changes on deployment. You can do this by running:

#### IAM

    terraform plan -var-file variables/iam_variables.tfvars

#### S3

    terraform plan -var-file variables/s3_buckets.tfvars

The output will tell you what actions will be taken on the resources defined in the Terraform files, specifically whether they will be `created`, `modified`, or `destroyed`. Take time to review this whenever applying a new change.

When you are happy with the changes Terraform outputs, apply the changes by running:

#### IAM

    terraform apply -var-file variables/iam_variables.tfvars

#### S3

    terraform apply -var-file variables/s3_buckets.tfvars

*Note*: To apply changes to the live environment you will need to revert changes made to the `main.tf` files for localized testing so that the updated `terraform.tfstate` can be appropriately pushed to it's respective `s3` bucket. 