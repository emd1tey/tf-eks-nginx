module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.name
  cluster_version = "1.31"

  create_cloudwatch_log_group = false
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  cluster_encryption_config = {}

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    vm_test = {
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      
      min_size = 1
      max_size = 3
      desired_size = 1
    }
  }
}
