output "vault_kms_key_id" {
  value = module.vault.kms_key_id
}

output "vault_iam_role_arn" {
  value = module.vault.vault_iam_role_arn
}