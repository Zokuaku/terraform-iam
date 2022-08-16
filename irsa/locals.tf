/*
  locals.tf
*/

/*
  Locals defined at runtime for use in
  the respective modules.
*/
locals {
  /*
    Local variable for performing the trimprefix function on the eks 
    cluster identity so that it can be parsed for use in the iam_role.tf.
    Get the EKS OIDC Issuer without https:// prefix for use by the iam_role.tf
  */
  oidc_issuer = trimprefix(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://")

  /*
    Flatten with nested "For" loops to
    parse out Policy values from the 
    nested List "policies" in the map
    object "roles" for use to add 
    individual policy string values to
    the respective role defined in
    "irsa.tfvars.json", utilized in
    "irsa.tf"
  */
  role_policies = flatten([
    for role_key, role in var.roles : [
      for index, policy in role.policies : {
        role_name = role.name
        policy    = policy
      }
    ]
  ])
}

/*
  Get the caller identity so that we can get the AWS Account ID
*/
data "aws_caller_identity" "current" {

}

/*
  Get the EKS cluster we want to target based on the value
  provided in the variables.tfvars file
*/
data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}