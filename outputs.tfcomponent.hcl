output "vault_namespace" {
  description = "Kubernetes namespace where Vault is deployed."
  type        = string
  value       = component.vault_cluster.vault_namespace
}

output "vault_service_name" {
  description = "Kubernetes service name for the Vault API service."
  type        = string
  value       = component.vault_cluster.vault_service_name
}

output "vault_api_addr" {
  description = "Address for the Vault API load balancer."
  type        = string
  value       = component.vault_cluster.vault_loadbalancer_hostname
}

output "vault_ui_addr" {
  description = "Address for the Vault UI load balancer."
  type        = string
  value       = component.vault_cluster.vault_ui_loadbalancer_hostname
}

output "vso_vault_auth_name" {
  description = "VaultAuth resource name consumed by Vault Secrets Operator."
  type        = string
  value       = component.vault_cluster.vso_vault_auth_name
}

output "ldap_mount_path" {
  description = "Vault LDAP secrets engine mount path published to downstream stacks."
  type        = string
  value       = component.vault_ldap_secrets.ldap_secrets_mount_path
}

output "ldap_secrets_mount_path" {
  description = "Compatibility alias for the Vault LDAP secrets engine mount path."
  type        = string
  value       = component.vault_ldap_secrets.ldap_secrets_mount_path
}

output "vault_app_auth_role_name" {
  description = "Vault Kubernetes auth role name used by the app for direct Vault polling."
  type        = string
  value       = component.vault_ldap_secrets.vault_app_auth_role_name
}

output "ldap_dual_account" {
  description = "Whether dual-account LDAP rotation is enabled for this deployment."
  type        = bool
  value       = var.ldap_dual_account
}

output "grace_period" {
  description = "Dual-account rotation grace period in seconds."
  type        = number
  value       = var.grace_period
}

output "static_role_rotation_period" {
  description = "Password rotation period in seconds for LDAP static roles."
  type        = number
  value       = var.static_role_rotation_period
}

output "vault_initialized" {
  description = "Indicates whether the Vault init job completed successfully."
  type        = bool
  value       = component.vault_cluster.vault_initialized
}

output "vault_root_token" {
  description = "Vault root token for demo operations."
  type        = string
  sensitive   = true
  value       = component.vault_cluster.vault_root_token
}

output "vault_unseal_keys" {
  description = "Vault unseal keys for demo operations."
  type        = list(string)
  sensitive   = true
  value       = component.vault_cluster.vault_unseal_keys
}
