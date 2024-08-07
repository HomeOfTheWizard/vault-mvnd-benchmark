pid_file = "/vault/.pidfile"

vault {
  address = "$VAULT_ADDR"
  tls_skip_verify = true
}

auto_auth {
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
  destination = "/vault/secrets/application.yaml"
  contents = <<EOT
  {{- with secret "kv/data/fruit-basket" }}
PRODUCER_NAME: {{ Data.data.producer_name }}
PRODUCER_PSW: {{ Data.data.producer_password }}
PRODUCER_FRUIT: {{ Data.data.producer_fruit }}
  {{ end }}
  EOT
}