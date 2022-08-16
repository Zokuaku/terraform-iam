/*
  locals.tf
*/

/*
  Locals defined at runtime for use in
  the respective modules.
*/
locals {
  /*
    Defines the path for where the User Credential
    files are stored so that they can be copied to
    the desired s3 bucket. 
  */
  credential_files = "${path.module}/User_Credentials/"
}