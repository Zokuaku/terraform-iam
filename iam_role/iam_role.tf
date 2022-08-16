/*
  iam_role.tf
*/

/*
  This creates the AWS IAM User roles defined in
  "roles.tfvars.json" and adds the policies also 
  defined in "roles" for each respective group
*/

/*
  Get the caller identity so that we can get the AWS 
  Account ID
*/
data "aws_caller_identity" "current" {

}

/*
  Create the IAM role that will be assumed by the service account.
  Populates tag values with contents provided in the roles map in
  "roles.tfvars.json".
*/
resource "aws_iam_role" "iam_role" {
  for_each = var.roles

  name                  = each.value["name"]
  path                  = each.value["path"]
  force_detach_policies = each.value["destroy"]

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
  Create IAM policy that is assumed by the AWS IAM Role.
*/
data "aws_iam_policy_document" "iam_role_policy" {
  for_each = var.roles

  statement {
    actions = [
      each.value["action"]
    ]

    principals {
      type = each.value["type"]
      identifiers = [
        each.value["identifier"]
      ]
    }
  }
}

/*
  Attaches policies that where defined in the policies list 
  defined in the "roles.tfvars.json" "roles" map. Iteration 
  happens for each role in the roles map.
*/
resource "aws_iam_role_policy_attachment" "iam-policy-attach" {
  count = length(local.role_policies)

  role       = local.role_policies[count.index].role_name
  policy_arn = local.role_policies[count.index].policy

  depends_on = [
    aws_iam_role.iam_role
  ]
}