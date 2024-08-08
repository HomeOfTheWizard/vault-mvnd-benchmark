#!/bin/bash

echo "launching vault agent"
docker compose -f agent/docker-compose-vault-agent.yaml up --build -d

echo "launching vault agent"
docker compose -f mvnd/docker-compose-vault-mvnd.yaml up --build -d

