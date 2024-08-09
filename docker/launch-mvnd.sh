#!/bin/bash

#echo "building mvnd image"
#docker build -f docker/mvnd/Dockerfile -t homeofthewizard/mvnd:1.0.0 .
#docker push homeofthewizard/mvnd:1.0.0
#docker build -f docker/mvnd/DockerfileVault -t homeofthewizard/mvnd-vault:1.0.0 .
#docker push homeofthewizard/mvnd-vault:1.0.0

echo "starting mvnd container with daemon already running"
docker run -d \
  -e 'VAULT_ADDR=http://vault:8200' \
  -e 'VAULT_DEV_ROOT_TOKEN_ID=00000000-0000-0000-0000-000000000000' \
  -v ./mvnd/project:/project \
  -w /project \
  --network vault_my-network \
  --name mvnd-vault \
  homeofthewizard/mvnd-vault:1.0.0

while [ "$(docker inspect -f {{.State.Health.Status}} mvnd-vault)" != "healthy" ]; do sleep 1; done

echo "first run of mvnd client"
time docker exec mvnd-vault mvnd clean install -D"vault.outputMethod=EnvFile"

