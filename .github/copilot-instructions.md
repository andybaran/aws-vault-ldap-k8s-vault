---
applyTo: "*.tf,*.hcl,*.md"
---

# Project: aws-vault-ldap-k8s-vault

## Goal

Own the Vault slice of the Terraform Cloud Stacks split demo. This repo deploys Vault onto the shared EKS platform, configures Vault Secrets Operator plus the LDAP secrets engine, and publishes the Vault/app contract consumed by the app stack.

## Scope

- Vault Helm deployment and supporting Kubernetes resources
- Vault Secrets Operator, VaultConnection, VaultAuth, and Vault Kubernetes auth wiring
- LDAP secrets engine configuration backed by the Active Directory stack's seed data
- local derivation of EKS auth data from the AWS provider
- documentation for linked-stack contracts and useful operator outputs

## Linked-stack contract

Expected upstream stack sources:

- `app.terraform.io/andybaran/ldap stack/aws-vault-ldap-k8s-k8s`
- `app.terraform.io/andybaran/ldap stack/aws-vault-ldap-k8s-ad`

Expected upstream outputs from the k8s stack:

- `region`
- `cluster_endpoint`
- `cluster_ca_data`
- `cluster_name` or `cluster_id`
- `kube_namespace`

Expected upstream outputs from the ad stack:

- `ldap_url`
- `ldap_binddn`
- `ldap_userdn`
- `ldap_bootstrap_secret_arn`

Expected published outputs for the app stack:

- `ldap_mount_path`
- `vso_vault_auth_name`
- `vault_app_auth_role_name`
- `ldap_dual_account`
- `grace_period`
- `static_role_rotation_period`
- `vault_service_name`
- `vault_api_addr`
- `vault_ui_addr`

## Guardrails

- Keep using Terraform Stacks root files and explicit `upstream_input` plus `publish_output` blocks.
- Keep this repo limited to Vault concerns. Do not absorb EKS platform ownership, AD infrastructure ownership, or app workload ownership.
- Derive the EKS auth token locally via AWS instead of depending on a published upstream token.
- Preserve the demo defaults for dual-account LDAP rotation unless there is a repo-specific reason to change them.
- Keep operator-only secrets such as the Vault root token as regular stack outputs only; do not publish them as linked-stack contracts.
- When the Vault/app contract changes, update this file and the README in the same change.
