/*
  output.tf
*/

/*
  Outputs the values of the provided arguments
  below.
*/

output "requesting_user" {
  value       = data.aws_caller_identity.current
  description = "Outputs the Identity of the user calling the Terraform HCL Scripts."
}

output "irsa_role" {
  value       = aws_iam_role.iam_role
  description = "Outputs the name of the newly created IRSA Role"
}

output "service_accounts" {
  value       = var.roles[*]
  description = "Lists the names of the roles/service accounts in the irsa.tfvars.json"
}

output "kube_serv_acct" {
  value       = kubernetes_service_account.k8s_service_acct
  description = "Lists the Kubernetes Service Account Name"
}

output "kube_pod_name" {
  value       = kubernetes_pod.k8s_service_pod
  description = "Lists the Kubernetes Pod Name"
}

output "kube_config" {
  value       = var.kube_config
  description = "Lists the location of the .kube config file"
}

output "kube_context" {
  value       = var.kube_context
  description = "Lists the context we wish to use to identify access in the .kube config file."
}

output "cluster_name" {
  value       = var.cluster_name
  description = "Lists the name of the cluster we are trying to apply the following Service Account creation to."
}

output "cluster_endpoint" {
  value       = var.cluster_endpoint
  description = "Lists the AWS API Cluster Access Point so that we can use Terraform and Kubectl to manage the device and create our Pods/Service Accounts."
}

output "cluster_ca_cert" {
  value       = var.cluster_ca_cert
  description = "TLS based certificate utilized to authenticate with the AWS endpoint so that we can make our requests/changes"
}