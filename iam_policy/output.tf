/*
  output.tf
*/

/*
  Outputs the values of the provided arguments
  below.
*/

output "policies" {
  value       = aws_iam_policy.iam_policy[*]
  description = "Outputs a detailed description of the policies created and actions applied to them."
}