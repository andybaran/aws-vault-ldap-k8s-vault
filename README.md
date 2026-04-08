# aws-vault-ldap-k8s-vault

Terraform Cloud Stacks scaffold for the Vault slice of the `aws-vault-ldap-k8s` demo.

This repository is intended to own the Vault runtime on Kubernetes, Vault Secrets Operator integration, and the LDAP secrets engine wiring that bridges Active Directory to the demo workloads. It should stay focused on Vault and its immediate Kubernetes integration points.

## Stack purpose

- deploy and configure Vault in the shared Kubernetes platform
- integrate Vault with Active Directory through the LDAP secrets engine
- publish Vault auth and secret-delivery outputs for the demo application stack

## Upstream linked-stack contract

Current scaffold assumption: this stack will consume linked-stack outputs from both sibling foundation repos.

Planned upstream inputs from `aws-vault-ldap-k8s-k8s`:

- cluster endpoint, CA data, namespace, and other Kubernetes platform metadata
- shared naming/prefix values and any ingress or service prerequisites

Planned upstream inputs from `aws-vault-ldap-k8s-ad`:

- LDAPS endpoint details
- Active Directory domain/bind metadata
- secret references or bootstrap metadata needed for Vault's LDAP integration

## Downstream linked-stack contract

Planned outputs for `aws-vault-ldap-k8s-app`:

- Vault service and UI access metadata
- Vault auth role and connection details used by workload delivery methods
- LDAP secrets engine mount path and role names
- secret reference metadata for the app deployment flow

## Terraform Cloud Stacks

This repo is scaffolded around Terraform Stacks root files:

- `components.tfcomponent.hcl`
- `providers.tfcomponent.hcl`
- `variables.tfcomponent.hcl`
- `deployments.tfdeploy.hcl`

The HCL files are placeholders only. Later todos should add the real Vault components, provider configuration, and linked-stack attachments.
