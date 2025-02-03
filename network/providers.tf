provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Managed-by = "Terraform"
    }
  }
}
