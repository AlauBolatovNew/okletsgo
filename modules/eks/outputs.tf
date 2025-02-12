output "certificateAuthority" {
  value = aws_eks_cluster.demo.certificate_authority[0].data
}

output "apiServerEndpoint" {
  value = aws_eks_cluster.demo.endpoint
}