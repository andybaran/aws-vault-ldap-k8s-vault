variable "region" {
  description = "AWS region hosting the shared EKS cluster and Vault demo"
  type        = string
  default     = "us-east-2"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key"
  type        = string
  ephemeral   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret access key"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "AWS_SESSION_TOKEN" {
  description = "AWS session token"
  type        = string
  sensitive   = true
  ephemeral   = true
  default     = ""
}

variable "vault_license_key" {
  description = "Vault Enterprise license key"
  type        = string
  sensitive   = true
}

variable "eks_cluster_name" {
  description = "EKS cluster name or an aws eks update-kubeconfig command string published by the k8s stack"
  type        = string
}

variable "kube_namespace" {
  description = "Kubernetes namespace where Vault and VSO are deployed"
  type        = string
  default     = "default"
}

variable "vault_image" {
  description = "Default Docker image for Vault Enterprise (repository:tag)"
  type        = string
  default     = "hashicorp/vault-enterprise:1.21.2-ent"
}

variable "vault_dual_account_image" {
  description = "Vault image that includes the dual-account LDAP plugin"
  type        = string
  default     = "ghcr.io/andybaran/vault-with-openldap-plugin:dual-account-rotation"
}

variable "ldap_dual_account" {
  description = "Enable dual-account LDAP rotation using the custom Vault plugin"
  type        = bool
  default     = true
}

variable "grace_period" {
  description = "Grace period in seconds for dual-account rotation"
  type        = number
  default     = 20
}

variable "static_role_rotation_period" {
  description = "LDAP static role rotation period in seconds"
  type        = number
  default     = 100
}

variable "ldap_mount_path" {
  description = "Path where the LDAP secrets engine is mounted in Vault"
  type        = string
  default     = "ldap"
}

variable "ldap_url" {
  description = "LDAP or LDAPS URL for the Active Directory endpoint"
  type        = string
}

variable "ldap_binddn" {
  description = "Distinguished name used by Vault to bind to LDAP"
  type        = string
  default     = "CN=Administrator,CN=Users,DC=mydomain,DC=local"
}

variable "ldap_bindpass" {
  description = "Password for the LDAP bind account"
  type        = string
  sensitive   = true
}

variable "ldap_userdn" {
  description = "Base DN under which Vault searches for users"
  type        = string
  default     = "CN=Users,DC=mydomain,DC=local"
}

variable "active_directory_domain" {
  description = "Active Directory domain name used by the LDAP secrets engine"
  type        = string
  default     = "mydomain.local"
}

variable "static_roles" {
  description = "Static role seed data from the AD stack"
  type = map(object({
    username = string
    password = string
    dn       = string
  }))
  sensitive = true
}
