pid_file = "/vault/.pidfile"

vault {
  address = "$VAULT_ADDR"
  tls_skip_verify = true
}

auto_auth {
#   method {
#     type = "approle"
#     config = {
#       role_id_file_path = "/vault/token/role_id"
#       secret_id_file_path = "/vault/token/secret_id"
#       remove_secret_id_file_after_reading = false
#     }
#   }
  method {
    type = "token_file"
    config = {
      token_file_path = "/vault/token/.vault-token"
    }
  }
  sink "file" {
    config = {
      path = "/vault/token/vault-token-via-agent"
    }
  }
}

template {
  destination = "/vault/secrets/application-agent.yaml"
  contents = <<EOT
  {{- with secret "secret/data/fruit-basket" }}
PRODUCER_NAME: {{ .Data.data.producer_name }}
PRODUCER_PSW: {{ .Data.data.producer_password }}
PRODUCER_FRUIT: {{ .Data.data.producer_fruit }}
  {{ end }}
  EOT
}