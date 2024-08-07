#!/bin/sh

vault login "00000000-0000-0000-0000-000000000000"

echo "Adding secrets to Vault..."
vault kv put secret/fruit-basket producer_name=bob producer_password=tasty producer_fruit=apple

echo "enable appRole and create token files"
vault policy write dev-policy /vault/dev-policy.hcl

vault auth enable approle
vault write auth/approle/role/dev-role token_policies=dev-policy
vault read auth/approle/role/dev-role/role-id | tail -n 1 | sed 's/ /\n/g' | tail -n 1 | sed 's/\(.*\)/\1/' >> /home/vault/role_id
vault write -f auth/approle/role/dev-role/secret-id | sed -n '3{p;q}' | sed 's/ /\n/g' | tail -n 1 | sed 's/\(.*\)/\1/' >> /home/vault/secret_id