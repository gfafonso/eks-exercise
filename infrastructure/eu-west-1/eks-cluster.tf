data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name = "gaf-tech${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name
  cluster_version = "1.27"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  
}

module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = "eks-managed-group"
  cluster_name    = module.eks.cluster_name
  cluster_version = "1.27"

  subnet_ids = module.vpc.private_subnets

  vpc_security_group_ids            = [module.eks.node_security_group_id]

  min_size     = 1
  max_size     = 3
  desired_size = 2

  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"

}



module "lb_role" {
 source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

 role_name                              = "${local.cluster_name}_eks_lb"
 attach_load_balancer_controller_policy = true

 oidc_providers = {
     main = {
     provider_arn               = module.eks.oidc_provider_arn
     namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
     }
 }
 }

 