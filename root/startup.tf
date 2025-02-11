module "vpc" {
  source = "../modules/vpc"

  cidr_block                 = var.vpc_cidr_block
  azs                        = var.azs
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  project                    = var.project
}
