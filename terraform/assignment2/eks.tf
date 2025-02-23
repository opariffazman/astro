module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name    = local.project_name
  cluster_version = "1.32"

  vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnets

  enable_irsa = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  tags = local.tags
}

resource "aws_eks_node_group" "on_demand" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "on-demand-node-group"
  node_role_arn   = module.eks.node_iam_role_arn
  subnet_ids      = data.terraform_remote_state.network.outputs.private_subnets
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = 0
    max_size     = 1
    min_size     = 0
  }
}

resource "aws_eks_node_group" "spot" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "spot-node-group"
  node_role_arn   = module.eks.node_iam_role_arn
  subnet_ids      = data.terraform_remote_state.network.outputs.private_subnets
  capacity_type   = "SPOT"

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 0
  }
}