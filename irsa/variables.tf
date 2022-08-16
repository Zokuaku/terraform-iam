/*
  variables.tf
*/

/*
  Predefined variables for use within other
  localized Terraform Modules to generate
  AWS IRSA Roles.
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
*/
variable "kube_config" { type = string }

/*
  Variable kube_context defines which "context"
  in the "~/.kube/config" file should be used
  for the K8s provider. If this is not defined
  it will default to the "default" context.
  Used in "main.tf"
*/
variable "kube_context" { type = string }

/*
  Variable that defines the AWS EKS Cluster we are
  targetting in the K8s provider for Pod provisioning.
  Used in "main.tf"
*/
variable "cluster_endpoint" { type = string }

/*
  Variable containing the contents of the 
  PEM-encoded root certificate for TLS 
  authentication with our AWS EKS K8s Cluster.
  Used in "main.tf"
*/
variable "cluster_ca_cert" { type = string }

/*
  Variable containing the name of the EKS Cluster
  for Service Account and Pod provisioning.
  Used in locals.tf
*/
variable "cluster_name" { type = string }

/*
  Roles map defines the variable type associated
  with each key and structure based on the content
  provided in roles.tfvars.json
*/
variable "roles" {
  type = map(
    object({
      name        = string,
      namespace   = string,
      path        = string,
      destroy     = string,
      tags        = map(any),
      actions     = list(string),
      type        = string,
      identifiers = list(string),
      policies    = list(string),
      ami         = string,
    })
  )
  default = {
  }
}