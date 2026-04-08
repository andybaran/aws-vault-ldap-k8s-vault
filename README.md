# aws-vault-ldap-k8s-vault

Terraform Cloud Stacks repo for the Vault slice of the `aws-vault-ldap-k8s` demo.

This repository owns the Vault runtime on Kubernetes, Vault Secrets Operator integration, and the LDAP secrets engine configuration that turns the Active Directory seed data into app-facing Vault contracts. It intentionally stays focused on Vault concerns and consumes the shared EKS and AD context from sibling stacks.

## Stack purpose

- deploy Vault Enterprise onto the shared EKS platform
- derive EKS authentication locally from AWS instead of depending on a published upstream token
- configure the LDAP secrets engine and Vault Kubernetes auth using AD seed data
- publish the Vault outputs the app stack needs while keeping operator-only secrets as regular stack outputs

## Repository layout

- `modules/vault` - copied from the source repo and kept focused on the Vault Helm/VSO deployment
- `modules/vault_ldap_secrets` - copied from the source repo for LDAP secrets engine and Vault auth configuration
- `modules/eks_auth` - small helper module that derives an EKS auth token via the AWS provider
- `components.tfcomponent.hcl` - Vault component graph and split-repo wiring
- `providers.tfcomponent.hcl` - AWS, Kubernetes, Helm, and Vault provider configuration
- `variables.tfcomponent.hcl` - deployment inputs for AWS, EKS context, and LDAP seed data
- `outputs.tfcomponent.hcl` - operator outputs and downstream app-facing contracts
- `deployments.tfdeploy.hcl` - linked-stack dependencies, shared varset usage, and published outputs

## Upstream linked-stack contract

This stack consumes linked-stack outputs from:

- `app.terraform.io/andybaran/ldap stack/aws-vault-ldap-k8s-k8s`
- `app.terraform.io/andybaran/ldap stack/aws-vault-ldap-k8s-ad`

Expected inputs from the k8s stack:

- `region`
- `cluster_endpoint`
- `cluster_ca_data`
- `cluster_name` or `cluster_id`
- `kube_namespace`

Expected inputs from the ad stack:

- `ldap_url`
- `ldap_binddn`
- `ldap_userdn`
- `ldap_bootstrap_secret_arn`

## Downstream linked-stack contract

This stack publishes the app-facing outputs below:

- `ldap_mount_path`
- `vso_vault_auth_name`
- `vault_app_auth_role_name`
- `ldap_dual_account`
- `grace_period`
- `static_role_rotation_period`
- `vault_service_name`
- `vault_api_addr`
- `vault_ui_addr`

It also publishes `ldap_secrets_mount_path` as a compatibility alias.

## Demo defaults preserved from the source repo

- `ldap_dual_account = true`
- `grace_period = 20`
- `static_role_rotation_period = 100`
- base Vault image default remains `hashicorp/vault-enterprise:1.21.2-ent`, with the dual-account demo automatically switching to the custom plugin image from the monolith

The development deployment uses the shared AWS credentials varset `varset-oUu39eyQUoDbmxE1` and does not default to destroy mode.

## Operator outputs

Useful operator outputs such as the Vault root token and unseal keys remain regular stack outputs for the demo, but they are not published as linked-stack contracts.

## Local validation

```bash
terraform fmt -recursive
terraform stacks fmt
terraform stacks init
terraform stacks validate
```
