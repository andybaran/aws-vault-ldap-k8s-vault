output "ldap_bindpass" {
  description = "LDAP bind password recovered from the AD bootstrap secret."
  value       = local.payload == null ? null : local.payload.ldap_bindpass
  sensitive   = true
}

output "static_roles" {
  description = "Static role seed data recovered from the AD bootstrap secret."
  value       = local.payload == null ? null : local.payload.static_roles
  sensitive   = true
}
