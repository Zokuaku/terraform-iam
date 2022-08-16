/*
  irsa.tf
*/

/*
  This creates the AWS IAM User roles defined in
  "irsa.tfvars.json" and adds the policies also 
  defined in "roles" for each respective group
*/

/*
  Create the IAM role that will be assumed by the service account.
  Populate tag values with contents provided in the roles map in
  irsa.tfvars.json.
*/
resource "aws_iam_role" "iam_role" {
  for_each = var.roles

  name = each.value["name"]
  path = each.value["path"]

  tags = {
    task      = each.value.tags["task"]
    purpose   = each.value.tags["purpose"]
    team      = each.value.tags["team"]
    created   = each.value.tags["created"]
    createdby = each.value.tags["createdby"]
    owner     = each.value.tags["owner"]
  }

  assume_role_policy = data.aws_iam_policy_document.iam_role_policy[each.key].json
}

/*
  Create IAM policy allowing the k8s service account to assume the 
  IAM role
*/
data "aws_iam_policy_document" "iam_role_policy" {
  for_each = var.roles

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_issuer}",
      ]
    }

    /*
      Limit the scope so that only our desired service account can assume this role
    */
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer}:sub"
      values = [
        "system:serviceaccount:${each.value["namespace"]}:${each.value["name"]}"
      ]
    }
  }
}

/*
  Attaches policies that where defined in the policies list 
  defined in the "irsa.tfvars.json" "roles" map. Iteration 
  happens for each role in the roles map.
*/
resource "aws_iam_role_policy_attachment" "my-policy-attach" {
  count = length(local.role_policies)

  role       = local.role_policies[count.index].role_name
  policy_arn = local.role_policies[count.index].policy
}