/*
  variables.tf
*/

/*
  Predefined variables for use within other
  localized Terraform Modules to generate
  Users, Groups, Policies, etc. Each variables
  comment lists which Terrform Module it is
  utilized in.
*/

/*
  Profile variable defines the AWS Profile to
  use for running commands. Used in "main.tf"
*/
variable "default_profile" { type = string }

/*
  Variable region defining default working region.
  Used in "main.tf"
*/
variable "default_region" { type = string }

/*
  Variable kube_config defining the location of
  the "~/.kube/config" file for use in the K8s
  provider. Used in "main.tf"

variable "kube_config" { type = string }
*/

/*
  Variable kube_context defines which "context"
  in the "~/.kube/config" file should be used
  for the K8s provider. If this is not defined
  it will default to the "default" context.
  Used in "main.tf"

variable "kube_context" { type = string }
*/

/*
  Variable that defines the AWS EKS Cluster we are
  targetting in the K8s provider for Pod provisioning.
  Used in "main.tf"

variable "cluster_endpoint" { type = string }
*/

/*
  Variable containing the contents of the 
  PEM-encoded root certificate for TLS 
  authentication with our AWS EKS K8s Cluster.
  Used in "main.tf"

variable "cluster_ca_cert" { type = string }
*/

/*
  Variables for Safecloud AWS IAM admin users from 
  "iam_variables.tfvars" currently only building 
  DevOps Admin accounts.

variable "cluster_name" { type = string }
*/

/*
  Users map defines the variable type associated
  with each key and structure based on the content
  provided in users.tfvars.json
*/
variable "users" {
  type = map(
    object({
      name      = string,
      email     = string,
      path      = string,
      destroy   = string,
      tags      = map(any),
      passreset = string,
      cipher    = string,
      group     = list(string)
    })
  )
}

/*
  Groups map defines the variable type associated
  with each key and structure based on the content
  provided in groups.tfvars.json
*/
variable "groups" {
  type = map(
    object({
      name     = string,
      path     = string,
      policies = list(string)
    })
  )
}

/*
  Roles map defines the variable type associated
  with each key and structure based on the content
  provided in roles.tfvars.json

variable "roles" {
  type = map(
    object({
      name      = string,
      namespace = string,
      path      = string,
      tags      = map(any),
      actions   = list(string),
      resources = list(string),
      ami       = string
    })
  )
  default = {
  }
}
*/

/*
  Policies map defines the variable type associated
  with each key and structure based on the content
  provided in policies.tfvars.json
*/
variable "policies" {
  type = map(
    object({
      name      = string,
      path      = string,
      tags      = map(any),
      actions   = list(string),
      resources = list(string)
    })
  )
  default = {
  }
}