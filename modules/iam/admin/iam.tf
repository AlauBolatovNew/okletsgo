resource "aws_eks_access_entry" "example" {
  cluster_name  = "alau-cluster"
  principal_arn = "arn:aws:iam::864899873372:root"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "ss" {
  cluster_name  = "alau-cluster"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::864899873372:root"

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "s5" {
  cluster_name  = "alau-cluster"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = "arn:aws:iam::864899873372:root"

  access_scope {
    type = "cluster"
  }
}
