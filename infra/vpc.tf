locals {
  azs = ["ap-south-1a", "ap-south-1b"]
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                       = "eks-vpc"
  cidr                       = "10.0.0.0/16"
  map_public_ip_on_launch    = true
  azs                        = local.azs
  public_subnets             = [for k, v in local.azs : cidrsubnet("10.0.0.0/16", 4, k)]
  manage_default_network_acl = false
  enable_nat_gateway         = false
  enable_vpn_gateway         = false
  enable_dns_hostnames       = true
  enable_dns_support         = true

  tags = {

    Environment = "dev"
  }
}