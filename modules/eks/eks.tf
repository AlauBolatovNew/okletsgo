resource "aws_eks_cluster" "demo" {
  name     = "alau-cluster"
  role_arn = var.role_arn

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  version = "1.31"

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = var.security_group_ids

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  compute_config {
    enabled       = true
    node_pools    = ["system"]
    node_role_arn = var.node_role_arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  bootstrap_self_managed_addons = false
}
