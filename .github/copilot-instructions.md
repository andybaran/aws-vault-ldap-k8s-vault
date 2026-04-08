---
applyTo: "*.tf,*.hcl,*.md"
---

# Project: aws-vault-ldap-k8s-vault

## Goal

Own the Vault slice of the demo. This repo should deploy Vault on the shared EKS cluster, configure Vault Secrets Operator and the LDAP secrets engine, and publish the contract the downstream app stack consumes.

## Scope

- Vault runtime on Kubernetes
- Vault initialization and licensing prerequisites that used to live in the monolith's `kube1` module
- Vault Secrets Operator and Kubernetes auth wiring
- LDAP secrets engine configuration fed by the AD stack
- linked-stack outputs consumed by the app stack

## Guardrails

- Keep using Terraform Stacks root files and explicit linked-stack contracts.
- Keep this repo focused on Vault concerns. Do not absorb EKS platform ownership, AD infrastructure ownership, or app code.
- Consume k8s and ad dependencies through `upstream_input` blocks in `deployments.tfdeploy.hcl`.
- Derive EKS auth locally from the AWS provider instead of consuming a published EKS auth token.
- Preserve the demo defaults unless a requirement says otherwise:
  - `ldap_dual_account = true`
  - `grace_period = 20`
  - `static_role_rotation_period = 100`
- Do not reintroduce unused monolith variables like `vault_public_endpoint` or `vault_root_namespace` unless they become necessary.
- Keep secrets out of git and prefer Terraform Cloud variable sets or linked-stack outputs for sensitive values.
- Do not publish sensitive operator values like the Vault root token as linked-stack contracts.
- When the Vault/app contract changes, update `README.md`, stack outputs, and `publish_output` blocks in the same change.
