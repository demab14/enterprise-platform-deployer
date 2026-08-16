output "kms_key_id" {
  description = "KMS key ID for Vault auto-unseal, used in Helm values"
  value       = aws_kms_key.vault_unseal.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.vault_unseal.arn
}

output "vault_iam_role_arn" {
  description = "IAM role ARN for the Vault service account, annotate this in the Helm chart"
  value       = aws_iam_role.vault_kms.arn
}
