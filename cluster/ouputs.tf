output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "region" {
  value = var.region
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}
