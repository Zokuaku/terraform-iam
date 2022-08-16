# Terraform IRSA Infrastructure

Infrastructure-as-code for the AWS Identity and Access Management Role for Service Accounts (IRSA).

## Table of contents
- [Terraform IRSA Infrastructure](#terraform-irsa-infrastructure)
  - [Table of contents](#table-of-contents)
  - [Overview](#overview)
  - [Technologies](#technologies)
  - [Configuration Files](#configuration-files)
    - [config.s3.tfbackend](#configs3tfbackend)
    - [irsa.tfvars.json](#irsatfvarsjson)
  - [Initialization](#initialization)
    - [Remote - Live](#remote---live)
    - [Local - Testing](#local---testing)
  - [Working](#working)
    - [Validate](#validate)
    - [Format](#format)
    - [Plan](#plan)
  - [Committing](#committing)
    - [Apply](#apply)
  - [Cleanup](#cleanup)
    - [Migrate](#migrate)
    - [Destroy](#destroy)
  - [Extra](#extra)
  - [Navigation](#navigation)

## Overview
This folder contains all the configuration files required to create IRSA Roles. This README will walk you through the configuration and initialization steps in order to use and maintain the respective Terraform HCL.

## Technologies
Project is created with:
* Terraform 1.2.3

## Configuration Files

### config.s3.tfbackend

The backend values have been pulled out and writen to an external file called `config.s3.tfbackend` (prescribed naming convention and other practices provided by <a href="https://www.terraform.io/language/settings/backends/configuration">Terraform Documentation - Backend Configuration</a>).

By modifying the respective values in the file `config.s3.tfbackend` you can set a different s3 bucket, or respectively copy the file and fill it out to support running the script with a different s3 backend location. (Look to local copy for a working example)

    bucket               = <s3_bucket_name>
    key                  = <desired_subfolder_for_tfstate>
    region               = <desired_aws_region>
    workspace_key_prefix = <desired_prefix_applied_to_state_path>
    dynamodb_table       = <dyanmoDB_table_name>
    encrypt              = <encyrption_true_or_false>

### irsa.tfvars.json

`irsa.tfvars.json` defines the configuration of IRSA Roles using a Map(Object) expressed as JSON. The contents enclosed in curly brackets for `role1` are a single object, if you wish to create more simply add a trailing comma after the closing curly bracket for `role1` copy the text and paste it below giving it the title `role(x)` based on the level of iteration and modify the arguments to support your new object. (Look to the local copy for a working example)

For resources and examples on `aws_irsa` they can be found at the following link(s) <a href="https://dev.to/arpanadhikari/reusable-aws-iam-role-for-service-accounts-irsa-for-k8s-terraform-module-2og2">Blog - IRSA for k8s</a>, <a href="https://shipit.dev/posts/setting-up-eks-with-irsa-using-terraform.html">Blog - EKS cluster with IAM/IRSA integration</a>

    "roles":{
        "role1":{
            "name":      <irsa_role_name>,
            "namespace": <k8s_namespace>,
            "path":      <relative_location>,
            "destroy":   <true_or_false>,
            "tags": {
                "task":      <related_safe_task>,
                "purpose":   <purpose_this_bucket_was_built_to_facilitate>,
                "team":      <team_creating_this_resource>,
                "created":   <date_script_is_ran_to_generate_this_resource>,
                "createdby": <who_is_requesting/generating_this_resource>,
                "owner":     <Manager_of_resource_creator>
            },
            "actions": [
                         <mechanism_by_which_role_assumption_occurs>
            ],
            "type":      <means_of_authentication>,
            "identifiers": [
                         <individual_rights_are_being_provided_to>
            ],
            "policies": [
                         <iam_policies_being_attached_to_the_role>
            ],
            "ami":       <k8s_pod_image>
        }
    }

## Initialization

### Remote - Live

> :warning: When pulling from the Github repo the configuration will be setup to utilize the remote S3 backend by default. If you are wanting to work on a local copy you will need to follow the steps defined in [S3 Initialization (Local - testing)](#s3-initialization-local---testing).

To initialize Terraform and start working with the remote `terraform.tfstate` file based on the defined configuration input the following command:

    terraform init -backend-config="config.s3.tfbackend"

> :information_source: For resources and examples on `init` they can be found at the following link <a href="https://www.terraform.io/cli/commands/init">Terraform Command - Initialize</a>

### Local - Testing

To create a localized instance of the `s3` `terraform.tfstate` open the respective `main.tf` and comment out the following line(s):

    backend "s3" {}

You will also need to navigate to the `variables.tfvars` file and modify the values for `default_profile` and `default_region` to fit your testing credentials.

> :key: The variable values are making calls to the `config` and `credentials` files found in your `.aws` folder. (File path for the `.aws` folder in Windows is `C:\Users\<user_account>\.aws`)

    /*
        Main Variables
    */
    default_profile = "default"
    default_region  = "us-west-2"

Once you have that modified as desired simply run the following command to initialize local testing:

    terraform init

## Working

### Validate

After making any changes to your Terraform files verify that they are succinct and the functions are clearly defined by using the validate command as follows:

    terraform validate

> :information_source: For resources and examples on `validate` they can be found at the following link <a href="https://www.terraform.io/cli/commands/validate">Terraform Command - Validate</a>

### Format

As a best practice to keep the code readable Terraform provides a format tool to cleanup the HCL script(s) formatting using the command as follows:

    terraform fmt

> :information_source: For resources and examples on `fmt` they can be found at the following link <a href="https://www.terraform.io/cli/commands/fmt">Terraform Command - Format</a>

### Plan

After making desired changes to the Terraform files, verify that Terraform will be able to compile them correctly for deployment by running the following command:

    terraform plan -var-file="./variables/variables.tfvars" -var-file="./variables/irsa.tfvars.json" -out="tfplan"

The output will tell you what actions will be taken on the resources defined in the Terraform files, specifically whether they will be `created`, `modified`, or `destroyed`. Take time to review this whenever applying a new change.

The `-out` argument will generate a file called `tfplan` (this can be named whatever is desired by changing the value in the quotations) for use when applying to save on passing all of the variable files and ensure consistency of the output generated when running `terraform plan`.

> :information_source: For resources and examples on `plan` they can be found at the following link <a href="https://www.terraform.io/cli/commands/plan">Terraform Command - Plan</a>

## Committing

### Apply

Once all configuration and variable changes are completed as desired, run the following command to apply it all:

    terraform apply "tfplan"

> :key: To apply changes to the live environment you will need to revert changes made to the `main.tf` files for localized testing so that the updated `terraform.tfstate` can be appropriately pushed to it's respective `s3` bucket.

> :warning: Make sure to cleanup your testing environment before updating the `main.tf` file for a remote push as you do not wish to attempt to push/overwrite the remote `terraform.tfstate` file the intent is to update the working state as it stands. 

> :information_source: For resources and examples on `apply` they can be found at the following link <a href="https://www.terraform.io/cli/commands/apply">Terraform Command - Apply</a>

## Cleanup

### Migrate

There may be a time in the future that the S3 structure needs to be redefined or these scripts are no longer relevant and the infrastructure needs to be destroyed. In order to do this the `terraform.tfstate` will need to be moved back to a local system. In order to do this you will need modify the `main.tf` HCL script and comment out the following line(s):

    backend "s3" {}

And then you will want to run the following command to re-initialize the `terraform.tfstate` on your local system:

    terraform init -migrate-state

> :information_source: For resources and examples about the argument `-migrate-state` look to the subsection `Backend Initialization` found at the following link <a href="https://www.terraform.io/cli/commands/init">Terraform Command - Initialize</a>

### Destroy

After migrating the state back to your local system you can destroy the IRSA Roles found in `irsa.tfvars.json` by running the following command:

    terraform destroy -var-file="./variables/variables.tfvars" -var-file="./variables/irsa.tfvars.json" 

> :information_source: For resources and examples about `destroy` they can be found at the following link <a href="https://www.terraform.io/cli/commands/destroy">Terraform Command - Destroy</a>

## Extra

These are commands that have been useful for troubleshooting and working with the Terraform and AWS environments.

The first command below is useful for figuring out which `.aws` profile you are presently operating under as well as your default region. If you are having issues with `403` error's kicking back to you in your command prompt when running Terraform check that your command prompt `AWS_PROFILE` is the same as your `default_profile` in your `variables.tfvars` file by running the following command:

    aws configure list

If you need to change your `AWS_PROFILE` or `AWS_REGION` you can temporarily do so in your command prompt by setting them accordingly:

    set AWS_PROFILE=aws-free
    set AWS_REGION=us-west-1

> :warning: The commands for setting your `AWS_PROFILE` and `AWS_REGION` are only temporary and are limited to the explicitly defined `command prompt` that you input this in.

## Navigation

Relative links to each of the respective sub-folders README files for directions on how to configure and utilize them based on their individual structures.

[Main |](../README.md)[ S3 |](../s3/README.md)[ IAM Policy |](../iam_policy/README.md)[ IAM Role |](../iam_role/README.md)[ IAM Group |](../iam_group/README.md)[ IAM User |](../iam_user/README.md)[ IAM Original](../iam_original/README.md)
