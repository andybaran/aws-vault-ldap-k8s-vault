data "kubernetes_secret_v1" "vault_init_data" {
  metadata {
    name      = "vault-init-data"
    namespace = var.kube_namespace
  }
  depends_on = [kubernetes_job_v1.vault_init]
}

locals {
  vault_init_json = jsondecode(data.kubernetes_secret_v1.vault_init_data.data["init.json"])
  unseal_keys_b64 = local.vault_init_json.unseal_keys_b64
  root_token      = local.vault_init_json.root_token
  api_addr        = data.kubernetes_secret_v1.vault_init_data.data["api_addr"]
  ui_addr         = data.kubernetes_secret_v1.vault_init_data.data["ui_addr"]
}

output "vault_unseal_keys" {
  description = "Vault unseal keys (base64 encoded)"
  value       = local.unseal_keys_b64
  sensitive   = true
}

output "vault_root_token" {
  description = "Vault root token"
  value       = local.root_token
  sensitive   = true
}

output "vault_namespace" {
  description = "Kubernetes namespace where Vault is deployed"
  value       = var.kube_namespace
}

output "vault_service_name" {
  description = "Vault service name"
  value       = "vault"
}

output "vault_initialized" {
  description = "Indicates if Vault has been initialized"
  value       = true
  depends_on  = [kubernetes_job_v1.vault_init]
}

data "kubernetes_service_v1" "vault" {
  metadata {
    name      = "vault"
    namespace = var.kube_namespace
  }
  depends_on = [time_sleep.wait_for_vault]
}

data "kubernetes_service_v1" "vault_ui" {
  metadata {
    name      = "vault-ui"
    namespace = var.kube_namespace
  }
  depends_on = [time_sleep.wait_for_vault]
}

output "vault_loadbalancer_hostname" {
  description = "Internal LoadBalancer hostname for Vault API"
  value       = local.api_addr
}

output "vault_ui_loadbalancer_hostname" {
  description = "Internal LoadBalancer hostname for Vault UI"
  value       = local.ui_addr
}

output "vso_vault_auth_name" {
  description = "The name of the VaultAuth resource for VSO"
  value       = "default" # Matches the name defined in vso.tf VaultAuth resource
}
