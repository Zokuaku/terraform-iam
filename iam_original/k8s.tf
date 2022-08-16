/*
  kubernetes.tf
*/

/*
  Create the Kubernetes service account which will be able to assume 
  the AWS IAM role created for it.

resource "kubernetes_service_account" "k8s_service_acct" {
  for_each = var.roles

  metadata {
    name      = each.value["name"]
    namespace = each.value["namespace"]

    annotations = {
      */
/*
        This annotation is needed to tell the service account which IAM
        role it should assume
      
      "eks.amazonaws.com/role-arn" = aws_iam_role.iam_role[each.key].arn
    }
  }
}
*/

/*
    Deploy Kubernetes Pod with the Service Account that can assume an AWS
    IAM role

resource "kubernetes_pod" "k8s_service_pod" {
  for_each = var.roles

  metadata {
    name      = each.value["name"]
    namespace = each.value["namespace"]
  }

  spec {
    service_account_name = each.value["name"]
    container {
      name  = each.value["name"]
      image = each.value["ami"]
      */
/*
        Sleep so that the container stays alive with continuous-sleeping
      
      command = ["/bin/bash", "-c", "--"]
      args    = ["while true; do sleep 5; done;"]
    }
  }
}
*/