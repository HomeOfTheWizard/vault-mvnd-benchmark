#!/bin/bash

echo "starting vault server container"
docker compose -f vault/docker-compose-vault.yaml up --build -d

read -r -p "Wait 5 seconds for the server to startup, or press any key to continue immediately" -t 5 -n 1 -s

echo "configuring the vault server and setup up some secrets in kv engine"
docker exec -d vault ./vault/configure-vault.sh