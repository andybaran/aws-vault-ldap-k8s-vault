resource "kubernetes_secret_v1" "vault_license" {
  data = {
    license = var.vault_license_key
  }

  metadata {
    name      = "vault-license"
    namespace = var.kube_namespace
  }

  type = "Opaque"
}
