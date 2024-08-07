#!/bin/sh

docker compose -f vault/docker-compose-vault.yaml up --build -d
docker exec -d vault ./vault/configure-vault.sh