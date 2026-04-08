output "ldap_mount_path" {
  description = "Vault LDAP secrets engine mount path"
  type        = string
  value       = component.vault_ldap_secrets.ldap_secrets_mount_path
}

output "vso_vault_auth_name" {
  description = "VaultAuth resource name used by Vault Secrets Operator"
  type        = string
  value       = component.vault_runtime.vso_vault_auth_name
}

output "vault_app_auth_role_name" {
  description = "Vault Kubernetes auth role name for app direct polling"
  type        = string
  value       = component.vault_ldap_secrets.vault_app_auth_role_name
}

output "ldap_dual_account" {
  description = "Whether dual-account LDAP rotation is enabled"
  type        = bool
  value       = var.ldap_dual_account
}

output "grace_period" {
  description = "Grace period in seconds for dual-account rotation"
  type        = number
  value       = var.grace_period
}

output "static_role_rotation_period" {
  description = "LDAP static role rotation period in seconds"
  type        = number
  value       = var.static_role_rotation_period
}

output "vault_service_name" {
  description = "Vault Kubernetes service name"
  type        = string
  value       = component.vault_runtime.vault_service_name
}

output "vault_api_addr" {
  description = "External Vault API address"
  type        = string
  value       = component.vault_runtime.vault_loadbalancer_hostname
}

output "vault_ui_addr" {
  description = "External Vault UI address"
  type        = string
  value       = component.vault_runtime.vault_ui_loadbalancer_hostname
}

output "vault_namespace" {
  description = "Kubernetes namespace where Vault is deployed"
  type        = string
  value       = component.vault_runtime.vault_namespace
}

output "vault_initialized" {
  description = "Whether the Vault init job completed"
  type        = bool
  value       = component.vault_runtime.vault_initialized
}

output "static_role_names" {
  description = "LDAP static role names configured in Vault"
  type        = map(string)
  value       = component.vault_ldap_secrets.static_role_names
}

output "vault_root_token" {
  description = "Vault root token for operating the demo"
  type        = string
  sensitive   = true
  value       = component.vault_runtime.vault_root_token
}
