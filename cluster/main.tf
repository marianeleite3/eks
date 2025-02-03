resource "aws_eks_cluster" "eks_cluster" {
  name     = local.cluster_name
  role_arn = var.role_arn
  version  = "1.30"

  vpc_config {
    subnet_ids = data.aws_subnets.private_subnets.ids
  }

  tags = {
    Name = "${var.name}-eks"
  }
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.name}-eks-node-group"
  node_role_arn   = var.role_arn
  subnet_ids      = data.aws_subnets.private_subnets.ids

  scaling_config {
    desired_size = var.eks_ng_desired_size
    max_size     = var.eks_ng_max_size
    min_size     = var.eks_ng_min_size
  }

  instance_types = var.eks_ng_instance_types

  tags = {
    Name = "${var.name}-eks-node-group"
  }

  labels = {
    Name = "${var.name}-eks-node-group"
  }
}

resource "aws_eks_addon" "coredns" {
  depends_on = [aws_eks_node_group.eks_nodes]

  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "coredns"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name = "${var.name}-eks-addon-coredns"
  }
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name = "${var.name}-eks-addon-kube-proxy"
  }
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name = "${var.name}-eks-addon-vpc-cni"
  }
}

resource "helm_release" "metrics_server" {
  depends_on = [aws_eks_node_group.eks_nodes]

  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  version    = "3.12.1"
  namespace  = "kube-system"
  timeout    = 900

  set {
    name  = "hostNetwork.enabled"
    value = "true"
  }

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "containerPort"
    value = "10443"
  }
}
