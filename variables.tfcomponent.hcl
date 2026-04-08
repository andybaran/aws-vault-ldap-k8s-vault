variable "region" {
  description = "AWS region for the shared EKS platform and local EKS auth derivation."
  type        = string
  default     = "us-east-2"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key."
  type        = string
  ephemeral   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret access key."
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "AWS_SESSION_TOKEN" {
  description = "AWS session token."
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "kube_namespace" {
  description = "Kubernetes namespace where Vault is deployed."
  type        = string
}

variable "kube_cluster_endpoint" {
  description = "EKS control plane endpoint from the k8s stack."
  type        = string
}

variable "kube_cluster_certificate_authority_data" {
  description = "Base64-encoded EKS cluster CA bundle published by the k8s stack."
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name or ID derived from the k8s stack for local auth."
  type        = string
}

variable "ldap_url" {
  description = "LDAP or LDAPS URL for the Active Directory domain controller."
  type        = string
}

variable "ldap_binddn" {
  description = "Bind DN for Vault's LDAP connection."
  type        = string
}

variable "ldap_bindpass" {
  description = "Password for Vault's LDAP bind account."
  type        = string
  sensitive   = true
}

variable "ldap_userdn" {
  description = "Base DN that contains the demo LDAP users."
  type        = string
}

variable "static_roles" {
  description = "Demo LDAP service accounts and passwords used to seed Vault static roles."
  type = map(object({
    username = string
    password = string
    dn       = string
  }))
  sensitive = true
}

variable "vault_image" {
  description = "Base Docker image for Vault Enterprise when dual-account mode is disabled."
  type        = string
  default     = "hashicorp/vault-enterprise:1.21.2-ent"
}

variable "ldap_dual_account" {
  description = "Enable dual-account LDAP rotation using the custom Vault plugin image."
  type        = bool
  default     = true
}

variable "grace_period" {
  description = "Grace period in seconds for dual-account LDAP rotation."
  type        = number
  default     = 20
}

variable "static_role_rotation_period" {
  description = "Password rotation period in seconds for LDAP static roles."
  type        = number
  default     = 100
}
