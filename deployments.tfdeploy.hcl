store varset "aws_creds" {
  id       = "varset-oUu39eyQUoDbmxE1"
  category = "env"
}

store varset "vault_license" {
  id       = "varset-fMrcJCnqUd6q4D9C"
  category = "terraform"
}

upstream_input "k8s" {
  type   = "stack"
  source = "app.terraform.io/andybaran/ldap-stack/aws-vault-ldap-k8s-k8s"
}

upstream_input "ad" {
  type   = "stack"
  source = "app.terraform.io/andybaran/ldap-stack/aws-vault-ldap-k8s-ad"
}

locals {
  region                     = try(upstream_input.k8s.region, "us-east-2")
  kube_namespace             = try(upstream_input.k8s.kube_namespace, "default")
  eks_cluster_name           = try(upstream_input.k8s.cluster_id, upstream_input.k8s.cluster_name)
  active_directory_domain    = try(upstream_input.ad.active_directory_domain, "mydomain.local")
  active_directory_domain_dn = join(",", [for label in split(".", local.active_directory_domain) : "DC=${label}"])
  ldap_binddn                = try(upstream_input.ad.ldap_binddn, "CN=Administrator,CN=Users,${local.active_directory_domain_dn}")
  ldap_userdn                = try(upstream_input.ad.ldap_userdn, "CN=Users,${local.active_directory_domain_dn}")
  ldap_url                   = try(upstream_input.ad.ldap_url, "ldaps://${upstream_input.ad.dc_private_ip}")
}

deployment_auto_approve "successful_plans" {
  check {
    condition = context.success == true
    reason    = "Operation failed and requires manual intervention."
  }
}

deployment_group "auto_approve" {
  auto_approve_checks = [
    deployment_auto_approve.successful_plans,
  ]
}

deployment "development" {
  inputs = {
    region                      = local.region
    eks_cluster_name            = local.eks_cluster_name
    kube_namespace              = local.kube_namespace
    vault_license_key           = store.varset.vault_license.stable.vault_license_key
    ldap_dual_account           = true
    grace_period                = 20
    static_role_rotation_period = 100
    ldap_mount_path             = "ldap"
    ldap_url                    = local.ldap_url
    ldap_binddn                 = local.ldap_binddn
    ldap_bindpass               = try(upstream_input.ad.ldap_bindpass, upstream_input.ad.password)
    ldap_userdn                 = local.ldap_userdn
    active_directory_domain     = local.active_directory_domain
    static_roles                = upstream_input.ad.static_roles
    AWS_ACCESS_KEY_ID           = store.varset.aws_creds.AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY       = store.varset.aws_creds.AWS_SECRET_ACCESS_KEY
    AWS_SESSION_TOKEN           = try(store.varset.aws_creds.AWS_SESSION_TOKEN, "")
  }

  deployment_group = deployment_group.auto_approve
}

publish_output "ldap_mount_path" {
  type  = string
  value = deployment.development.ldap_mount_path
}

publish_output "vso_vault_auth_name" {
  type  = string
  value = deployment.development.vso_vault_auth_name
}

publish_output "vault_app_auth_role_name" {
  type  = string
  value = deployment.development.vault_app_auth_role_name
}

publish_output "ldap_dual_account" {
  type  = bool
  value = deployment.development.ldap_dual_account
}

publish_output "grace_period" {
  type  = number
  value = deployment.development.grace_period
}

publish_output "static_role_rotation_period" {
  type  = number
  value = deployment.development.static_role_rotation_period
}

publish_output "vault_service_name" {
  type  = string
  value = deployment.development.vault_service_name
}

publish_output "vault_api_addr" {
  type  = string
  value = deployment.development.vault_api_addr
}

publish_output "vault_ui_addr" {
  type  = string
  value = deployment.development.vault_ui_addr
}
