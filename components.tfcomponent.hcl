locals {
  effective_vault_image = var.ldap_dual_account ? var.vault_dual_account_image : var.vault_image
}

component "eks_context" {
  source = "./modules/eks_auth"

  inputs = {
    eks_cluster_name = var.eks_cluster_name
  }

  providers = {
    aws = provider.aws.this
  }
}

component "vault_runtime" {
  source = "./modules/vault"

  inputs = {
    kube_namespace    = var.kube_namespace
    vault_image       = local.effective_vault_image
    vault_license_key = var.vault_license_key
    ldap_dual_account = var.ldap_dual_account
  }

  providers = {
    helm       = provider.helm.this
    kubernetes = provider.kubernetes.this
    time       = provider.time.this
  }
}

component "vault_ldap_secrets" {
  source = "./modules/vault_ldap_secrets"

  inputs = {
    ldap_url                    = var.ldap_url
    ldap_binddn                 = var.ldap_binddn
    ldap_bindpass               = var.ldap_bindpass
    ldap_userdn                 = var.ldap_userdn
    secrets_mount_path          = var.ldap_mount_path
    active_directory_domain     = var.active_directory_domain
    kubernetes_host             = component.eks_context.cluster_endpoint
    kubernetes_ca_cert          = component.eks_context.cluster_certificate_authority_data
    kube_namespace              = var.kube_namespace
    static_roles                = var.static_roles
    static_role_rotation_period = var.static_role_rotation_period
    ldap_dual_account           = var.ldap_dual_account
    grace_period                = var.grace_period
  }

  providers = {
    vault = provider.vault.this
  }
}
