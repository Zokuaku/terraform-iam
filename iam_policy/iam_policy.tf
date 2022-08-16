/*
  iam_policy.tf
*/

/*
  Creates a new IAM Policy based on the contents provided 
  in the roles map in variables.tfvars.json. It iterates 
  over the respective key values to fill the contents for
  the tags information.
*/
resource "aws_iam_policy" "iam_policy" {
  for_each = var.policies

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

  policy = data.aws_iam_policy_document.iam_policy[each.key].json
}

/*
  Create an IAM policy utilizing the values provided in the 
  "roles" map. Loops through and creates a policy for each
  listed role based on their respective values for the
  "actions" and "resources" lists.
*/
data "aws_iam_policy_document" "iam_policy" {
  for_each = var.policies

  statement {
    actions   = [for action in each.value.actions : "${action}"]
    resources = [for resource in each.value.resources : "${resource}"]
  }
}