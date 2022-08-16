# Terraform Safecloud Infrastructure

Infrastructure-as-code implementation for AWS IAM and S3 buckets to be used for Safe Softwares Safecloud.

## Table of Contents
- [Terraform Safecloud Infrastructure](#terraform-safecloud-infrastructure)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Technologies](#technologies)
  - [General Info](#general-info)
    - [AWS IAM User](#aws-iam-user)
    - [AWS IAM Group](#aws-iam-group)
    - [AWS IAM Role](#aws-iam-role)
    - [AWS IAM Policy](#aws-iam-policy)
    - [AWS IRSA](#aws-irsa)
    - [AWS S3](#aws-s3)
    - [AWS IAM Original](#aws-iam-original)
  - [Directory Structure](#directory-structure)
    - [`/iam_user`](#iam_user)
    - [`/iam_group`](#iam_group)
    - [`/iam_role`](#iam_role)
    - [`/iam_policy`](#iam_policy)
    - [`/irsa`](#irsa)
    - [`/s3`](#s3)
    - [`/iam_original`](#iam_original)
  - [Getting Started](#getting-started)
  - [Navigation](#navigation)

## Overview
These folders contains all the configuration files required to create AWS IAM User Accounts, Groups, Roles, Policies, IRSA Roles and S3 storage for Safecloud. Folders are disseminated into S3, IAM_User, IAM_Group, IAM_Role, IAM_Policy and IRSA repsectively to fit Terraform recommended folder heirarchy and best practice. Workspaces are not leveraged as these parameters are largely considered to be Global variables except for IRSA Roles (No independant Production/Staging/QA).

## Technologies
Project is created with:
* Terraform 1.2.3

## General Info

### AWS IAM User
This section generates the AWS IAM User account and add's it to the list respective group(s) defined in `users.tfvars.json`.

Ideally this section would add SQS/SNS forwarding to automate User account forwarding with no need for third-party distribution by DevOps or TechOps.
> :warning: Not fully defined

Existing features are:
* User Account Creation for (AWS Console, CLI and Service Accounts)
* Password, Access Key and Secret Key generation with PGP encryption
* add user to desired AWS IAM Group
* Utilizes `policies.tf` to enforce Password Enforcement Policy defined in Safes ISMS-POL-106 Password and Access Policy
* Generate CSV User Account Credentials files named based on `[Username]_user_credentials.csv`
* Creates a copy of the `[Username]_user_credentials.csv` files in the S3 Bucket `safecloud-global-infrastructure/iam/User_Credentials/`

### AWS IAM Group
This section generates and applies values to AWS IAM Group based on what is defined in `groups.tfvars.json` file.

Existing features are:
* Creates AWS IAM Group(s) based on the values provided in `groups.tfvars.json` file
* Applies desired Policies defined in `groups` map in `groups.tfvars.json` file

### AWS IAM Role
Not currently in use, this piece would eventually be more universal to merge the contents of AWS IRSA into it. It needs to be able to handle different role types, actions, etc. to facilitate this purpose.

> :warning: Not fully defined

Existing features are:
* Presently capable of generating more generic AWS IAM Roles based on the values provided in `roles.tfvars.json` (presently there is a test role defined as a template)

### AWS IAM Policy
Builds AWS IAM Policies based on the values provided in the `policies.tfvars.json`.

Existing features are:
* Ability to generate custom AWS IAM Policies with clearly defined actions and resources to properly enforce "Least Privilege" accessibility

### AWS IRSA
Currently, this is built to support per EKS Cluster requirements and lacks modularity to make it fully universal. Ideally, this would eventually get merged with the AWS IAM Role in the future by making the logic handle different role types (e.g. AWS, Federated, etc.).

> :warning: Not fully defined

Existing features are:
* Creates an IAM Role that is setup as Federated with an OIDC Provider for assumption by an AWS EKS Cluster Service Account. Created by `irsa.tf` based on the values defined in `irsa.tfvars.json`
* Creates a K8s Service Account of the same name as the IAM Role that it is assuming. Created by `k8s_sa.tf`
* Creates a K8s Pod using the AMI to define desired image (Presently defined to Amazon Linux). Created by `k8s_pod.tf`

### AWS S3
Creates S3 buckets and DynamoDB tables based on the values defined in `s3_buckets.tfvars.json` and `s3_database.tfvars.json`.

Existing features are:
* generates a private, encrypted, s3 storage space with a dynamoDB table for managing `terraform.tfstate` locking
* able to generate multiple s3 buckets by adding the details to `s3_buckets.tfvars.json`

### AWS IAM Original
This is the original body of work that I used to learn and re-develop the associated folders above. As this has evolved it appears there is an opportunity to develop this into a proper Terraform Module. (Note this can be used, but it needs to be run multiple times or be adapted to include the "depends-on" argument for resources to be generated in a desired order).

## Directory Structure

### `/iam_user`

The iam scripts that are used for managing the Safecloud/AWS IAM User Infrastructure are included in the `iam_user/` folder. They are as follows:

|                 Script               |                                                Description                                               |
|--------------------------------------|----------------------------------------------------------------------------------------------------------|
| `config.s3.tfbackend`                | Contains the key values for the S3 backend defined in main.tf
| `iam_user.tf`                        | Creates an AWS IAM User, generates a PGP Key, generates random first password for AWS Console access with password reset enforcement, access key and secret key generation for AWS CLI, Password/Access/Secret Key decryption, group membership addition and User Credential file generation and file copy to desired s3 bucket.
| `locals.tf`                          | Contains local values processed at run time with the rest of the HCL scripts.
| `main.tf`                            | Sets Local/Remote backend values and defines AWS provider desired AWS profile and working region.
| `output.tf`                          | Terminal output of User Name, ARN, Fingerprint, Access Key, Access Key Secret (Hashed), Password (Hashed)
| `policies.tf`                        | Presently defines Password Enforcement Policy for AWS Accounts based on Safes ISMS-POL-106 Password and Access Policy.
| `README.md`                          | Used to explain the steps of configuration, testing and deployment of the HCL scripts.
| `variables.tf`                       | Defines variables and their respective types for Terraform to process.
| `versions.tf`                        | Contains all the required providers for the Terraform HCL scripts to operate.
| `variables/users.tfvars.json`        | Contains desired state configurations in a JSON/Map to be passed through to respective modules for processing.
| `variables/variables.tfvars`         | Means of storing variables to operate in a private state that is not disclosed upon processing in the tfstate.
| `User_Crentials/`                    | Folder that stores the output from `iam_user.tf` to then be copied up to the appropriate s3 bucket.

### `/iam_group`

The iam scripts that are used for managing the Safecloud/AWS IAM Group Infrastructure are included in the `iam_group/` folder. They are as follows:

|                 Script               |                                                Description                                               |
|--------------------------------------|----------------------------------------------------------------------------------------------------------|
| `config.s3.tfbackend`                | Contains the key values for the S3 backend defined in main.tf
| `iam_group.tf`                       | Generates AWS IAM Group and attach's desired AWS IAM Policies.
| `main.tf`                            | Sets Local/Remote backend values and defines AWS provider desired AWS profile and working region.
| `output.tf`                          | Terminal output for Group Names and the Policies attached to them.
| `README.md`                          | Used to explain the steps of configuration, testing and deployment of the HCL scripts.
| `variables.tf`                       | Defines variables and their respective types for Terraform to process.
| `versions.tf`                        | Contains all the required providers for the Terraform HCL scripts to operate.
| `variables/variables.tfvars`         | Means of storing variables to operate in a private state that is not disclosed upon processing in the tfstate.
| `variables/groups.tfvars.json`       | Contains desired state configurations in a JSON/Map to be passed through to respective modules for processing.

### `/iam_role`

The iam scripts that are used for managing the Safecloud/AWS IAM Role Infrastructure are included in the `iam_role/` folder. They are as follows:

|                 Script               |                                                Description                                               |
|--------------------------------------|----------------------------------------------------------------------------------------------------------|
| `config.s3.tfbackend`                | Contains the key values for the S3 backend defined in main.tf
| `iam_role.tf`                        | Creates an AWS IAM Role and attaches defined AWS IAM Policies.
| `locals.tf`                          | Contains local values processed at run time with the rest of the HCL scripts.
| `main.tf`                            | Sets Local/Remote backend values and defines AWS provider desired AWS profile and working region.
| `output.tf`                          | Terminal output for Role Names and Policies attached to the Roles.
| `README.md`                          | Used to explain the steps of configuration, testing and deployment of the HCL scripts.
| `variables.tf`                       | Defines variables and their respective types for Terraform to process.
| `versions.tf`                        | Contains all the required providers for the Terraform HCL scripts to operate.
| `variables/variables.tfvars`         | Means of storing variables to operate in a private state that is not disclosed upon processing in the tfstate.
| `variables/roles.tfvars.json`        | Contains desired state configurations in a JSON/Map to be passed through to respective modules for processing.

### `/iam_policy`

The iam scripts that are used for managing the Safecloud/AWS IAM Policy Infrastructure are included in the `iam_policy/` folder. They are as follows:

|                 Script               |                                                Description                                               |
|--------------------------------------|----------------------------------------------------------------------------------------------------------|
| `config.s3.tfbackend`                | Contains the key values for the S3 backend defined in main.tf
| `iam_policy.tf`                      | Generates AWS IAM Policies with defined actions and resources.
| `main.tf`                            | Sets Local/Remote backend values and defines AWS provider desired AWS profile and working region.
| `output.tf`                          | Prints out the actions and resources allocated to each of the Policies.
| `README.md`                          | Used to explain the steps of configuration, testing and deployment of the HCL scripts.
| `variables.tf`                       | Defines variables and their respective types for Terraform to process.
| `versions.tf`                        | Contains all the required providers for the Terraform HCL scripts to operate.
| `variables/variables.tfvars`         | Means of storing variables to operate in a private state that is not disclosed upon processing in the tfstate.
| `variables/policies.tfvars.json`     | Contains desired state configurations in a JSON/Map to be passed through to respective modules for processing.

### `/irsa`

The iam scripts that are used for managing the configuration of IRSA roles for use with our EKS clusters are included in the `irsa/` folder. They are as follows:

|                 Script               |                                                Description                                               |
|--------------------------------------|----------------------------------------------------------------------------------------------------------|
| `config.s3.tfbackend`                | Contains the key values for the S3 backend defined in main.tf
| `irsa.tf`                            | Creates an AWS IAM Role with `sts:AssumeRoleWithWebIdentity` so that we can configure it for use with an EKS Service Account.
| `k8s_pod.tf`                         | Creates a k8s pod with the same name as the irsa role for limiting accessibility and use.
| `k8s_sa.tf`                          | Creates a k8s service account that can assume the defined IRSA Role.
| `locals.tf`                          | Contains local values processed at run time with the rest of the HCL scripts.
| `main.tf`                            | Sets Local/Remote backend values and defines AWS provider desired AWS profile and working region.
| `output.tf`                          | Outputs details for the k8s cluster, certificate, etc. as well as the k8s pod information, k8s service account and the irsa role.
| `README.md`                          | Used to explain the steps of configuration, testing and deployment of the HCL scripts.
| `variables.tf`                       | Defines variables and their respective types for Terraform to process.
| `versions.tf`                        | Contains all the required providers for the Terraform HCL scripts to operate.
| `variables/variables.tfvars`         | Means of storing variables to operate in a private state that is not disclosed upon processing in the tfstate.
| `variables/irsa.tfvars.json`         | Contains desired state configurations in a JSON/Map to be passed through to respective modules for processing.

### `/s3`

The s3 scripts that are used for managing the Safecloud/AWS S3 Bucket and Database Infrastructure are included in the `s3/` folder. They are as follows:

|                 Script               |                                                Description                                               |
|--------------------------------------|----------------------------------------------------------------------------------------------------------|
| `config.s3.tfbackend`                | Contains the key values for the S3 backend defined in main.tf
| `main.tf`                            | Sets Local/Remote backend values and defines AWS provider desired AWS profile and working region.
| `output.tf`                          | Output's the ARN for our S3 buckets and the name of our DynamoDB table
| `README.md`                          | Used to explain the steps of configuration, testing and deployment of the HCL scripts.
| `s3_bucket.tf`                       | Create and tags buckets based on values from `s3_buckets.tvfars`, sets bucket value to private, enables versioning, sets key life, and enables server side encyrption.
| `s3_db.tf`                           | Creates a DynamoDB table called `safecloud-terraform-locks` for moderating accessibility to respective `terraform.tfstate` files
| `variables.tf`                       | Contains passthrough variables from `s3_buckets.tvfars` for default region and default profile
| `versions.tf`                        | Contains all the required providers for the Terraform HCL scripts to operate.
| `variables/variables.tfvars`         | Means of storing variables to operate in a private state that is not disclosed upon processing in the tfstate.
| `variables/s3_buckets.tfvars.json`   | Contains desired state configurations in a JSON/Map to be passed through to respective modules for processing.
| `variables/s3_database.tfvars.json`  | Contains desired state configurations in a JSON/Map to be passed through to respective modules for processing.

### `/iam_original`

The legacy iam/s3 scripts that were used for managing the Safecloud/AWS IAM Infrastructure are included in the `iam_original/` folder. These have largely been modified and included in the associated folders listed above.

## Getting Started

> :warning: This terraform configuration was initially developed with Terraform version `1.2.3`. Be wary of some compatibility issues if using an older or newer version.

To work with the IAM and S3 terraform configurations, you will need to install Terraform https://learn.hashicorp.com/tutorials/terraform/install-cli

> :key: You will need to have access to AWS credentials in your environment to proceed

The work done by Terraform requires an IAM user with sufficient permissions to create/destroy many objects on AWS. To request a proper account with desired permissions contact Johnathan Kerssens or John Kennedy to use the respective IAM Terraform scripts to generate it for you per (https://safesoftware.atlassian.net/browse/DEVOPS-1989). Or in lieu of a proper locked down account, you can also reach out to Jackie Huynh for the information for the user `baradmin` for these operations for the time being.

Once Terraform is installed, navigate to your local `safecloud_infrastructure` directory in your terminal to work with either the various `IAM` or `S3` folders to modify and update their configurations.

## Navigation

Relative links to each of the respective sub-folders README files for directions on how to configure and utilize them based on their individual structures.

[S3 |](s3/README.md)[ IAM Policy |](iam_policy/README.md)[ IRSA |](irsa/README.md)[ IAM Role |](iam_role/README.md)[ IAM Group |](iam_group/README.md)[ IAM User |](iam_user/README.md)[ IAM Original](iam_original/README.md)