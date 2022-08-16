/*
  variables.tfvars
*/

/*
  Predefined variables for use within other
  localized Terraform Modules to populate main.tf
  requirements.
*/

/*
    Main Variables
*/
#default_profile = "default"
default_profile = "aws-free"
default_region  = "us-west-2"

/*
  Location of the local .kube config file that has the authentication
  information for accessing your remote cluster.

kube_config = "~/.kube/config"
*/

/*
  Which kube profile you should utilize from the .kube config where
  multiple potential configurations are defined.

kube_context = "arn:aws:eks:us-east-2:835698210033:cluster/education-eks-UR9OKgvz"
*/

/*
  This is the name of the AWS EKS Cluster you want this applied to.

cluster_name = "education-eks-UR9OKgvz"
*/

/*
  AWS API Server Cluster endpoint access control for managing with
  kubectl.

cluster_endpoint = "https://C3A9E3F38B47D8402A91F907C73EDDBF.gr7.us-east-2.eks.amazonaws.com"
*/

/*
  TLS Authentication Certificate utilized to authenticate with the EKS
  Cluster in order to create Service Accounts and Pods in the environment.

cluster_ca_cert = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1EY3hNakUxTVRNek1Wb1hEVE15TURjd09URTFNVE16TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTVc3Cmlmei9sY0pSV3hkY0RXQm9CZmRtVzF6UWlwMkdkK2IzTk1jM0xEVjVIeHp5c1JXTFlLTlUvek0rK2FIMHMzS0YKZXNLd3lDbVVzMTBuR3pLUkFSQ1pVSXVMdUsvZjgybU5GeThueEo2WGhualJWNlpVUFJRcDVXUlhFODg0czJTbQowTXRQWHVMaFgyaGxDVnVGR2lGUTF0NmlSdVgwVUJtR2tIZ2cwc2dHUWFHR0t2NzRYOTh5M0U3bCtNWndXYU5MCmdncEthV0Ezd0w5SC9FODJ4UVEzb0JTNGY1YzloZ2RuTGR6ZmYxeGE1WU15c2x6a0ViREpMZkx3clpyMU1DZlkKOS94bWhKRjFBZHkzVHlNb0xERFhNY3VGNGU4QjhoZVVjdldiOVA2d1c1d1dabGZNc2htWktPN3R6b3VGWUJ5VgpSNTBjVXg2OHJHcEsvUmp2TDU4Q0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZKZVRrVG94UlFaWmNrVlE5dkR6VnFEbzRxcmtNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRnJVMVVwdnRuMnFBVVBkbW9VQQoxTFMvam44eFRwbzlYS3JFY1Q0clNzWUxQemZNc3U3QWV2MTRSMjMzNnlPOHZqMDBRamZheEJtMlZQVEZNbUcyClcwTnAvYXd5NWZFb2xkVG0rUTBTMU5oWUY0TlV1VXNIWXpudklmK21DZVlXOWMrSWFlY0hUN3pmaTAraE5GWUoKbnBSMWorUit4QkdlU2FqK1ZIcDhBOXBPYk9xRTA4YmVkamxhb1dKbkVVY0xUNFdLUGp6QjZVemM0bE1ORWNWbwowbWwwSllaSERuTENaVXpOT2pqRlNjUTk4cWo5S0kxRGNka2prc0hzZWgvZmJ3QXR3R1U5N1p3MUEwc3FVeDZECnN2M1NIaVJmVjJIUEFKSTRvcUljS2d3Q0lUQ2Y4VjFwdkcvKy9SOUdLNzZwYm9QeEt3elN1azlxSmNlRThoamMKb0xjPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
*/