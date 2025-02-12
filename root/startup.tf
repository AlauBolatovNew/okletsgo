module "vpc" {
  source = "../modules/vpc"

  cidr_block                 = var.vpc_cidr_block
  azs                        = var.azs
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  project                    = var.project
}

module "cluster" {
  source = "../modules/iam/cluster"
}

module "node" {
  source = "../modules/iam/node"
}

module "admin" {
  source     = "../modules/iam/admin"
  
  depends_on = [module.eks]
}

module "group" {
  source = "../modules/iam/group"
}

module "eks" {
  source = "../modules/eks"

  role_arn           = module.cluster.role_arn
  node_role_arn      = module.node.role_arn
  private_subnets    = module.vpc.private_subnets
  security_group_ids = [module.vpc.security_group_id]

  depends_on = [module.vpc, module.cluster, module.node, module.group]
}

module "asg" {
  source = "../modules/asg"

  security_group_ids   = [module.vpc.security_group_id]
  apiServerEndpoint    = module.eks.apiServerEndpoint
  certificateAuthority = module.eks.certificateAuthority
  subnets              = module.vpc.public_subnets
}
