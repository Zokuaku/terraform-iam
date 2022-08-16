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
    object "roles" for use to add 
    individual policy string values to
    the respective role defined in
    "roles.tfvars.json", utilized in
    "iam_role.tf"
  */
  role_policies = flatten([
    for role_key, role in var.roles : [
      for index, policy in role.policies : {
        role_name = role.name
        policy    = policy
      }
    ]
  ])
}