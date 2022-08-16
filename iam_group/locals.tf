/*
  locals.tf
*/

/*
  Locals defined at runtime for use in
  the respective modules.
*/
locals {
  /*
    Flatten with nested "For" loops to
    parse out Policy values from the 
    nested List "policies" in the map
    object "groups" for use to add 
    individual policy string values to
    the respective group defined in
    "groups.tfvars.json", utilized in
    "iam_group.tf"
  */
  group_policies = flatten([
    for group_key, group in var.groups : [
      for index, policy in group.policies : {
        group_name = group.name
        policy     = policy
      }
    ]
  ])
}