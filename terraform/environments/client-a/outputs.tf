output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.eks.oidc_provider_url
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "vault_kms_key_id" {
  value = module.vault.kms_key_id
}

output "vault_iam_role_arn" {
  value = module.vault.vault_iam_role_arn
}
