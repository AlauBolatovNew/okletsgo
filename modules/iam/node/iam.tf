resource "aws_iam_role" "cluster_role" {
  name = "alau-AmazonEKSAutoNodeRole"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = [
        "sts:AssumeRole"
      ]
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodeMinimalPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.cluster_role.name
}
