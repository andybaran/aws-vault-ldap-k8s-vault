---
applyTo: "*.tf,*.hcl,*.md"
---

# Project: aws-vault-ldap-k8s-vault

## Goal

Own the Vault slice of the demo. The overall demo still uses Terraform Cloud Stacks to show Vault rotating AD credentials for an app on EKS, and this repo should hold the Vault runtime, LDAP secrets engine configuration, and app-facing auth contracts.

## Scope

- Vault deployment on Kubernetes
- Vault Secrets Operator, auth wiring, and LDAP secrets engine configuration
- outputs consumed by the app stack

## Guardrails

- Keep using Terraform Stacks root files and explicit linked-stack contracts.
- Keep this repo focused on Vault concerns. Do not absorb EKS platform ownership, AD infrastructure ownership, or app code.
- Model upstream dependencies on both the k8s and ad repos clearly in variables, outputs, and README text.
- Keep secrets out of git and prefer references to generated secrets over hard-coded values in docs.
- When the Vault/app contract changes, update README and output descriptions in the same change.
