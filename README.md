# aws-vault-ldap-k8s-vault

Terraform Cloud Stacks repo for the Vault slice of the `aws-vault-ldap-k8s` demo.

This stack owns the Vault runtime on EKS, Vault Secrets Operator integration, and the LDAP secrets engine configuration that bridges Active Directory credentials into the demo workloads. It intentionally stays focused on Vault concerns and consumes upstream contracts from the sibling Kubernetes and Active Directory stacks.

## Scope

- deploy Vault Enterprise on the shared EKS cluster
- initialize Vault and install Vault Secrets Operator
- configure the LDAP secrets engine and Vault Kubernetes auth
- publish the app-facing Vault contract for downstream stacks

## Upstream stacks

This stack is wired to these upstream Terraform Stacks addresses in `deployments.tfdeploy.hcl`:

- k8s: `app.terraform.io/andybaran/ldap-stack/aws-vault-ldap-k8s-k8s`
- ad: `app.terraform.io/andybaran/ldap-stack/aws-vault-ldap-k8s-ad`

The current deployment logic expects:

### From the k8s stack

- `region`
- `cluster_id` or `cluster_name`
- `kube_namespace` (defaults to `default` if not published)

The Vault stack derives live EKS auth data locally from AWS with `modules/eks_auth` instead of consuming a published EKS bearer token.

### From the ad stack

- `static_roles`
- `active_directory_domain` (or the source defaults)
- either `ldap_url` or `dc_private_ip`
- either `ldap_bindpass` or `password`
- optionally `ldap_binddn` and `ldap_userdn`

## Components

- `modules/eks_auth` derives EKS endpoint, CA data, and a short-lived auth token from the AWS provider.
- `modules/vault` deploys Vault, writes the license secret, initializes the cluster, and installs VSO.
- `modules/vault_ldap_secrets` configures the LDAP secrets engine and Vault Kubernetes auth roles after Vault is available.

## Defaults preserved from the source demo

- `ldap_dual_account = true`
- `grace_period = 20`
- `static_role_rotation_period = 100`
- official Vault Enterprise image by default, switching to the dual-account plugin image only when dual-account mode is enabled

## Downstream published outputs

This stack publishes the values the app stack needs:

- `ldap_mount_path`
- `vso_vault_auth_name`
- `vault_app_auth_role_name`
- `ldap_dual_account`
- `grace_period`
- `static_role_rotation_period`
- `vault_service_name`
- `vault_api_addr`
- `vault_ui_addr`

Operator-focused values like the Vault root token remain regular stack outputs only and are not published as linked-stack contracts.

## Validation

Run from the repository root:

```bash
terraform stacks fmt
terraform stacks init
terraform stacks validate
```
