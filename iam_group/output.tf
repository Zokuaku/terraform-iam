/*
  output.tf
*/

/*
  Outputs the values of the provided arguments
  below.
*/

output "groups" {
  value       = aws_iam_group.groups[*]
  description = "Outputs the configuration details for all the Groups"
}

output "policies" {
  value       = aws_iam_group_policy_attachment.group_policy_attach[*]
  description = "Outputs all the policies that are going to be applied to a each Group."
}