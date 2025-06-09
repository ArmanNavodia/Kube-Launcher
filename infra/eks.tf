module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  depends_on      = [module.vpc]
  cluster_name    = "eks-cluster"
  cluster_version = "1.31"

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = false

  vpc_id                           = module.vpc.vpc_id
  subnet_ids                       = module.vpc.public_subnets
  create_kms_key                   = false
  attach_cluster_encryption_policy = false
  enable_kms_key_rotation          = false
  kms_key_enable_default_policy    = false
  cluster_encryption_config        = []
  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 3
    }
  }
}