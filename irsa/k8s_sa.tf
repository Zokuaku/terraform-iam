/*
  k8s_sa.tf
*/

/*
  Used to build a Service Account in a Kubernetes
  Cluster based on the name and namespace provided 
  in the "roles.tfvars.json" file. This account is
  configured with the Assume Role functionality so
  that it can assume AWS defined roles as part of
  Identity and Access Management Roles for Service
  Accounts function (IRSA).
   
  Note: This will only work with AWS EKS Clusters.
*/

/*
  Create the Kubernetes service account which will be able to assume 
  the AWS IAM role created for it.
*/
resource "kubernetes_service_account" "k8s_service_acct" {
  for_each = var.roles

  metadata {
    name      = each.value["name"]
    namespace = each.value["namespace"]

    annotations = {
      /*
        This annotation is needed to tell the service account which IAM
        role it should assume
      */
      "eks.amazonaws.com/role-arn" = aws_iam_role.iam_role[each.key].arn
    }
  }
}