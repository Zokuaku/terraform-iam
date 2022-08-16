/*
  locals.tf
*/

/*
  Local variable for performing the trimprefix function on the eks 
  cluster identity so that it can be parsed for use in the iam_role.tf.
*/

locals {
  # Get the EKS OIDC Issuer without https:// prefix for use by the iam_role.tf
  #oidc_issuer = trimprefix(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://")

  group_policies = flatten([
    for group_key, group in var.groups : [
      for index, policy in group.policies : {
        group_name = group.name
        policy     = policy
      }
    ]
  ])

  credential_files = "${path.module}/User_Credentials/"
}