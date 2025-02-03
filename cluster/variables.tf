variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1" 
}

variable "name" {
  description = "Our name (to be reused)"
  type        = string
  default     = "eks_mari_pablo"
}

variable "role_arn" {
  description = "The ARN of the IAM role to use for the EKS cluster and nodes"
  type        = string
  default     = "" # set TF_VAR_role_arn
}

variable "eks_ng_desired_size" {
  description = "The desired size of the EKS node group"
  type        = number
  default     = 2
}

variable "eks_ng_max_size" {
  description = "The maximum size of the EKS node group"
  type        = number
  default     = 3
}

variable "eks_ng_min_size" {
  description = "The minimum size of the EKS node group"
  type        = number
  default     = 1
}

variable "eks_ng_instance_types" {
  description = "The instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.small"]
}
