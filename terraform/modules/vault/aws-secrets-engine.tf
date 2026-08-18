resource "aws_iam_policy" "vault_aws_secrets_engine" {
  name        = "${var.cluster_name}-vault-aws-secrets-policy"
  description = "Allows Vault to manage dynamic IAM users for the AWS secrets engine"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "iam:CreateUser",
        "iam:DeleteUser",
        "iam:GetUser",
        "iam:PutUserPolicy",
        "iam:DeleteUserPolicy",
        "iam:AttachUserPolicy",
        "iam:DetachUserPolicy",
        "iam:CreateAccessKey",
        "iam:DeleteAccessKey",
        "iam:ListAccessKeys",
        "iam:ListUserPolicies",
        "iam:ListAttachedUserPolicies",
        "sts:AssumeRole"
      ]
      Resource = "*"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "vault_aws_secrets_engine" {
  role       = aws_iam_role.vault_kms.name
  policy_arn = aws_iam_policy.vault_aws_secrets_engine.arn
}
