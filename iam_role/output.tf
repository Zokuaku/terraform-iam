/*
  output.tf
*/

/*
  Outputs the values of the provided arguments
  below.
*/

output "iam_role" {
  value       = aws_iam_role.iam_role[*]
  description = "Outputs the name(s) of the newly created IAM Role(s)"
}

output "attached_policies" {
  value       = aws_iam_role_policy_attachment.iam-policy-attach[*]
  description = "Outputs the policies being attached to each of the IAM Role(s)"
}