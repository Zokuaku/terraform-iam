/*
  output.tf
*/

/*
  Outputs the values of the provided arguments
  below. Can be used for passing argument later
  if this becomes part of a Terraform Module.
*/

output "s3_bucket" {
  value       = aws_s3_bucket.s3_bucket[*]
  description = "Outputs all details pertaining to the AWS S3 bucket details"
}

output "s3_bucket_acl" {
  value       = aws_s3_bucket_acl.s3_bucket_acl[*]
  description = "Defines the access control policies (acl), owners and permissions for the AWS S3 buckets"
}

output "s3_key" {
  value       = aws_kms_key.s3_key[*]
  description = "Discloses the Amazon Resource Names (arn) and other relevant details around key management"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.dynamodb_terraform_locks[*]
  description = "Outputs all details pertaining to the AWS DynamoDB table"
}