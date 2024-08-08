#!/bin/bash

echo "launching vault agent"

time docker run --rm \
  --cap-add=IPC_LOCK \
  -p 18100:8100 \
  -e 'VAULT_ADDR=http://vault:8200' \
  -v ./vault/secrets:/vault/secrets \
  -v vault_vault-token-volume:/vault/token \
  -v ./vault/agent-config.hcl:/vault/config/agent-config.hcl \
  --network vault_my-network \
  --name vault-agent \
  hashicorp/vault agent -log-level debug -config=/vault/config/agent-config.hcl -exit-after-auth