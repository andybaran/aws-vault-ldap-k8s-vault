# Dual-Account (Blue/Green) LDAP Secrets Engine Configuration
# These resources are only created when ldap_dual_account = true.
# They register and configure a custom Vault plugin that supports
# dual-account rotation with grace periods.

# Register the custom plugin in Vault's plugin catalog
resource "vault_generic_endpoint" "register_plugin" {
  count = var.ldap_dual_account ? 1 : 0

  path = "sys/plugins/catalog/secret/ldap_dual_account"

  disable_read   = true
  disable_delete = false

  data_json = jsonencode({
    sha256  = var.plugin_sha256
    command = "vault-plugin-secrets-openldap"
    version = "v0.17.0-dual-account.1"
  })
}

# Mount the custom plugin as a secrets engine
resource "vault_mount" "ldap_dual_account" {
  count = var.ldap_dual_account ? 1 : 0

  path        = var.secrets_mount_path
  type        = "ldap_dual_account"
  description = "Dual-account LDAP secrets engine for Active Directory"

  depends_on = [vault_generic_endpoint.register_plugin]
}

# Configure the LDAP backend connection
resource "vault_generic_endpoint" "ldap_config" {
  count = var.ldap_dual_account ? 1 : 0

  path = "${var.secrets_mount_path}/config"

  disable_read   = true
  disable_delete = true

  data_json = jsonencode({
    binddn       = var.ldap_binddn
    bindpass     = var.ldap_bindpass
    url          = var.ldap_url
    schema       = "ad"
    insecure_tls = true
    userattr     = "cn"
    userdn       = var.ldap_userdn
  })

  depends_on = [vault_mount.ldap_dual_account]
}

locals {
  dual_account_role_pairs = var.ldap_dual_account ? {
    (var.dual_account_static_role_name) = ["svc-rotate-a", "svc-rotate-b"]
    "vault-agent-dual-role"             = ["svc-rotate-c", "svc-rotate-d"]
    "csi-dual-role"                     = ["svc-rotate-e", "svc-rotate-f"]
  } : {}

  single_account_role_keys = var.ldap_dual_account ? {
    "svc-single" = "svc-single"
    "svc-lib"    = "svc-lib"
  } : {}
}

# Create dual-account static roles from the AD stack seed data.
resource "vault_generic_endpoint" "dual_account_static_roles" {
  for_each = local.dual_account_role_pairs

  path = "${var.secrets_mount_path}/static-role/${each.key}"

  disable_read   = true
  disable_delete = false

  data_json = jsonencode({
    username          = var.static_roles[each.value[0]].username
    dn                = var.static_roles[each.value[0]].dn
    username_b        = var.static_roles[each.value[1]].username
    dn_b              = var.static_roles[each.value[1]].dn
    rotation_period   = "${var.static_role_rotation_period}s"
    dual_account_mode = true
    grace_period      = "${var.grace_period}s"
  })

  depends_on = [vault_generic_endpoint.ldap_config]
}

# Single-account static roles for svc-single and svc-lib.
resource "vault_generic_endpoint" "ldap_single_static_role" {
  for_each = local.single_account_role_keys

  path = "${var.secrets_mount_path}/static-role/${each.key}"

  disable_read   = true
  disable_delete = false

  data_json = jsonencode({
    username        = var.static_roles[each.value].username
    dn              = var.static_roles[each.value].dn
    rotation_period = "${var.static_role_rotation_period}s"
  })

  depends_on = [vault_generic_endpoint.ldap_config]
}
