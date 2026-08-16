module "vault" {
  source = "../../modules/vault"

  cluster_name       = "epd-client-a"
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider_url  = module.eks.oidc_provider_url

  tags = local.common_tags
}