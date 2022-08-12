
resource "vault_kmip_secret_backend" "kmip_secret_engine" {
  path                        = var.kmip_path
  description                 = "Vault KMIP backend"
  listen_addrs                = ["0.0.0.0:5696"]
  tls_ca_key_type             = "rsa"
  tls_ca_key_bits             = 4096
  default_tls_client_key_type = "rsa"
  default_tls_client_key_bits = 4096
  default_tls_client_ttl      = 86400
}

resource "vault_kmip_secret_scope" "kmip_scope" {
  path  = vault_kmip_secret_backend.kmip_secret_engine.path
  scope = var.kmip_scope
  force = true
}

resource "time_sleep" "wait_for_scope" {
  depends_on = [vault_kmip_secret_scope.kmip_scope]

  create_duration = "10s"
}


resource "vault_kmip_secret_role" "kmip_role" {
  depends_on = [vault_kmip_secret_scope.kmip_scope,time_sleep.wait_for_scope]
  path                     = vault_kmip_secret_scope.kmip_scope.path
  scope                    = vault_kmip_secret_scope.kmip_scope.scope
  role                     = var.kmip_role
  tls_client_key_type      = "ec"
  tls_client_key_bits      = 256
  operation_all       = true
}


resource "vault_generic_endpoint" "kmip_credentials" {
   depends_on = [vault_kmip_secret_role.kmip_role]
  path = "${var.kmip_path}/scope/${var.kmip_scope}/role/${var.kmip_role}/credential/generate"
  disable_read = true
  disable_delete = true
  write_fields = ["certificate"]
  data_json = <<EOT
{
    "format": "pem_bundle"
}
EOT
}

resource "local_file" "kmip_cert" {
    content = vault_generic_endpoint.kmip_credentials.write_data["certificate"]
    filename = "kmip.pem"
}