variable "cluster_name" {
  description = "Name of the EKS cluster Vault is deployed into"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN from the eks-aws module, for IRSA trust policy"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL (no https://) from the eks-aws module"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
