#!/bin/bash

vault login "00000000-0000-0000-0000-000000000000"

echo "Adding secrets to Vault..."
vault kv put secret/fruit-basket producer_name=bob producer_password=tasty producer_fruit=apple

