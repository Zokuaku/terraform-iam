/*
  iam_group.tf
*/

/*
  This creates the AWS IAM User groups defined in
  "groups.tfvars.json" and adds the policies also 
  defined in "groups" for each respective group
*/

/*
  Creates the group(s) defined in "groups.tfvars.json" 
  from the map variable "groups"
*/
resource "aws_iam_group" "groups" {
  for_each = var.groups

  name = each.value["name"]
  path = each.value["path"]
}

/*
  Attaches the policies from "groups.tfvars.json" in 
  list "policies" to the respective group defined in 
  "groups.tfvars.json"
*/
resource "aws_iam_group_policy_attachment" "group_policy_attach" {
  count = length(local.group_policies)

  group      = local.group_policies[count.index].group_name
  policy_arn = local.group_policies[count.index].policy
}