data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  tags = {
    Name = "${var.name}-vpc"
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}

data "aws_eks_cluster" "default" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.eks_cluster.name
}

locals {
  cluster_name = "${var.name}-eks"
  eks_connection = {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}
