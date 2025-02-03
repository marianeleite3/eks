provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Managed-by = "Terraform"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = local.eks_connection.host
    cluster_ca_certificate = local.eks_connection.cluster_ca_certificate
    token                  = local.eks_connection.token
  }
}
