store varset "aws_creds" {
  id       = "varset-oUu39eyQUoDbmxE1"
  category = "env"
}

upstream_input "k8s_stack" {
  type   = "stack"
  source = "app.terraform.io/andybaran/ldap stack/aws-vault-ldap-k8s-k8s"
}

upstream_input "ad_stack" {
  type   = "stack"
  source = "app.terraform.io/andybaran/ldap stack/aws-vault-ldap-k8s-ad"
}

deployment "development" {
  inputs = {
    region                                  = upstream_input.k8s_stack.region
    kube_namespace                          = upstream_input.k8s_stack.kube_namespace
    kube_cluster_endpoint                   = upstream_input.k8s_stack.cluster_endpoint
    kube_cluster_certificate_authority_data = upstream_input.k8s_stack.cluster_ca_data
    eks_cluster_name                        = try(upstream_input.k8s_stack.cluster_name, upstream_input.k8s_stack.cluster_id)

    ldap_url          = upstream_input.ad_stack.ldap_url
    ldap_binddn       = upstream_input.ad_stack.ldap_binddn
    ldap_bindpass     = upstream_input.ad_stack.ldap_bindpass
    ldap_userdn       = upstream_input.ad_stack.ldap_userdn
    static_roles_json = upstream_input.ad_stack.static_roles_json

    ldap_dual_account           = true
    grace_period                = 20
    static_role_rotation_period = 100

    AWS_ACCESS_KEY_ID     = store.varset.aws_creds.AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY = store.varset.aws_creds.AWS_SECRET_ACCESS_KEY
    AWS_SESSION_TOKEN     = store.varset.aws_creds.AWS_SESSION_TOKEN
  }
}

publish_output "ldap_mount_path" {
  value = deployment.development.ldap_mount_path
}

publish_output "ldap_secrets_mount_path" {
  value = deployment.development.ldap_secrets_mount_path
}

publish_output "vso_vault_auth_name" {
  value = deployment.development.vso_vault_auth_name
}

publish_output "vault_app_auth_role_name" {
  value = deployment.development.vault_app_auth_role_name
}

publish_output "ldap_dual_account" {
  value = deployment.development.ldap_dual_account
}

publish_output "grace_period" {
  value = deployment.development.grace_period
}

publish_output "static_role_rotation_period" {
  value = deployment.development.static_role_rotation_period
}

publish_output "vault_service_name" {
  value = deployment.development.vault_service_name
}

publish_output "vault_api_addr" {
  value = deployment.development.vault_api_addr
}

publish_output "vault_ui_addr" {
  value = deployment.development.vault_ui_addr
}
