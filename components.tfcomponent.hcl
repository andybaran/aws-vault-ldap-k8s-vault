locals {
  vault_runtime_image     = var.ldap_dual_account ? "ghcr.io/andybaran/vault-with-openldap-plugin:dual-account-rotation" : var.vault_image
  effective_ldap_bindpass = component.ad_bootstrap.ldap_bindpass != null ? component.ad_bootstrap.ldap_bindpass : var.ldap_bindpass
  effective_static_roles  = component.ad_bootstrap.static_roles_json != null ? jsondecode(nonsensitive(component.ad_bootstrap.static_roles_json)) : (var.static_roles_json != null ? jsondecode(nonsensitive(var.static_roles_json)) : nonsensitive(var.static_roles))
}

component "eks_auth" {
  source = "./modules/eks_auth"

  inputs = {
    cluster_name = var.eks_cluster_name
  }

  providers = {
    aws = provider.aws.this
  }
}

component "ad_bootstrap" {
  source = "./modules/ad_bootstrap_secret"

  inputs = {
    secret_arn = var.ldap_bootstrap_secret_arn
  }

  providers = {
    aws = provider.aws.this
  }
}

component "vault_cluster" {
  source = "./modules/vault"

  inputs = {
    kube_namespace    = var.kube_namespace
    vault_image       = local.vault_runtime_image
    ldap_dual_account = var.ldap_dual_account
  }

  providers = {
    helm       = provider.helm.this
    kubernetes = provider.kubernetes.this
  }
}

component "vault_ldap_secrets" {
  source = "./modules/vault_ldap_secrets"

  inputs = {
    ldap_url                    = var.ldap_url
    ldap_binddn                 = var.ldap_binddn
    ldap_bindpass               = local.effective_ldap_bindpass
    ldap_userdn                 = var.ldap_userdn
    secrets_mount_path          = "ldap"
    kubernetes_host             = var.kube_cluster_endpoint
    kubernetes_ca_cert          = var.kube_cluster_certificate_authority_data
    kube_namespace              = var.kube_namespace
    static_roles                = local.effective_static_roles
    static_role_rotation_period = var.static_role_rotation_period
    ldap_dual_account           = var.ldap_dual_account
    grace_period                = var.grace_period
  }

  providers = {
    vault = provider.vault.this
  }
}
