/*
  k8s_pod.tf
*/

/*
  Used to build a Pod in a Kubernetes Cluster
  based on the name and namespace provided in
  the "irsa.tfvars.json" file. This Pod effectively
  acts like a "Service Account" Pod that carries
  out defined tasks based on the allocated permissions
  from the iam_policies created in "policies.tfvars.json"

  Note: This is not required to execute it is just
  a mechanism to restrict actions and traffic to a 
  defined pod.
*/

/*
    Deploy Kubernetes Pod with the Service Account that can
    assume an AWS IRSA Role.
*/
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

      /*
        Sleep so that the container stays alive with continuous-sleeping
      */
      command = ["/bin/bash", "-c", "--"]
      args    = ["while true; do sleep 5; done;"]
    }
  }
}