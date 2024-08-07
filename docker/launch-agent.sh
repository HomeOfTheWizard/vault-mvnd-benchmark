#!/bin/bash

echo "launching vault agent"
docker compose -f vault/docker-compose-vault-agent.yaml up --build -d