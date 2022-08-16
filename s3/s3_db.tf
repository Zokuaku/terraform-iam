/*
  s3_db.tf
*/

/*
  Module that is used to define a DynamoDB Table in AWS.
  Presently this is only being utilized to define one for
  managing locking on the Safecloud infrastructure 
  Terraform.tfstate file(s) but could have other tables 
  defined through "s3_database.tvfars.json" in the future.
*/

/*
  Creates DynamoDB Table for managing Terraform tfstate
  locks to prevent multiple members from overwriting each
  others work. Table Name, Billing Type, Hash Key and Table
  Type are all defined in the following function. Function
  can be extended for creating additional tables, etc. it 
  just needs to be defined in the "s3_database.tvfars.json"
  file.
*/
resource "aws_dynamodb_table" "dynamodb_terraform_locks" {
  for_each = var.tables

  name         = each.value["name"]
  billing_mode = each.value["bill"]
  hash_key     = each.value["hash_key"]

  tags = {
    task      = each.value.tags["task"]
    purpose   = "${each.value.tags["purpose"]} ${each.value["name"]}"
    team      = each.value.tags["team"]
    created   = each.value.tags["created"]
    createdby = each.value.tags["createdby"]
    owner     = each.value.tags["owner"]
  }

  attribute {
    name = each.value["hash_key"]
    type = each.value["db_type"]
  }
}