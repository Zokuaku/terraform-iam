/*
  iam_role.tf
*/

/*
  Get the caller identity so that we can get the AWS Account ID

data "aws_caller_identity" "current" {

}
*/

/*
  Create the IAM role that will be assumed by the service account.
  Populate tag values with contents provided in the roles map in
  variables.tfvars.json.

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
*/

/*
  Create IAM policy allowing the k8s service account to assume the 
  IAM role
 
data "aws_iam_policy_document" "iam_role_policy" {
  for_each = var.roles

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [var.trusted_role_arn]
    }
  }
}
*/

/*
  Attaches iam_policies that where built in the iam_policy.tf as defined
  in the variables.tfvars.json file. Iteration happens for each role in
  the roles map.

resource "aws_iam_role_policy_attachment" "my-policy-attach" {
  for_each = var.roles

  role       = aws_iam_role.iam_role[each.key].name
  policy_arn = aws_iam_policy.iam_policy[each.key].arn
}
*/

/*
  Attaches the policies from "groups.tfvars.json" in 
  list "policies" to the respective group defined in 
  "groups.tfvars.json"

resource "aws_iam_group_policy_attachment" "group_policy_attach" {
  count = length(local.group_policies)

  group      = local.group_policies[count.index].group_name
  policy_arn = local.group_policies[count.index].policy
}
*/