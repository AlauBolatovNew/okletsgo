output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "security_group_id" {
  value = aws_security_group.eks_sg.id
}
