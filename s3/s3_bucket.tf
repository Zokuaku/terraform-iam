/*
  s3_bucket.tf
*/

/*
  Module that is used to create S3 buckets in AWS.
  Presently this is only being utilized to define one for
  storing the global infrastructure for safecloud by 
  safely storing our IAM and S3 Terraform.tfstate file(s) 
  but could have others defined through 
  "s3_buckets.tvfars.json"
*/

/*
  Function to create S3 buckets based on what values are
  currently listed in the "buckets" map from 
  "s3_buckets.tvfars.json"
*/
resource "aws_s3_bucket" "s3_bucket" {
  for_each = var.buckets

  bucket        = each.value["name"]
  force_destroy = each.value["destroy"]

  tags = {
    task      = each.value.tags["task"]
    purpose   = "${each.value.tags["purpose"]} ${each.value["name"]} content"
    team      = each.value.tags["team"]
    created   = each.value.tags["created"]
    createdby = each.value.tags["createdby"]
    owner     = each.value.tags["owner"]
  }
}

/*
  Sets S3 Bucket Access Control List based on defined
  ACL requirements listed in the "s3_bucket.tvfars.json"
*/
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  for_each = var.buckets

  bucket = each.value["name"]

  acl = each.value["acl"]
}

/*
  Sets versioning argument to determine if we want to
  maintain revision history or not of files.
*/
resource "aws_s3_bucket_versioning" "s3_versioning" {
  for_each = var.buckets

  bucket = each.value["name"]

  versioning_configuration {
    status = each.value["ver_stat"]
  }
}

/*
  Sets the value for AWS KMS key for use with server-side
  encryption being enabled on the s3 bucket.
*/
resource "aws_kms_key" "s3_key" {
  for_each = var.buckets

  description             = each.value["key_desc"]
  deletion_window_in_days = each.value["key_del"]
}

/*
  Leverages the generated key from '"aws_kms_key" "s3_key"'
  with details provided from "s3_buckets.tfvars.json" about
  the bucket "name" and desired "sse_algorithm".
*/
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_server_side_encryption" {
  for_each = var.buckets

  bucket = each.value["name"]

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_key[each.key].arn
      sse_algorithm     = each.value["sse_algo"]
    }
  }
}