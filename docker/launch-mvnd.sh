#!/bin/bash

#echo "building mvnd image"
#docker build -f docker/mvnd/Dockerfile -t homeofthewizard/mvnd:1.0.0 .
#docker push homeofthewizard/mvnd:1.0.0

echo "running mvnd container with deamon already running"
docker run -d \
  -e 'VAULT_ADDR=http://vault:8200' \
  -e 'VAULT_DEV_ROOT_TOKEN_ID=00000000-0000-0000-0000-000000000000' \
  -v ./mvnd:/project \
  -w /project \
  --network vault_my-network \
  --name mvnd \
  homeofthewizard/mvnd:1.0.0

echo "first run of mvnd client"
time docker exec -it mvnd mvnd clean install

echo "second run of mvnd client"
time docker exec -it mvnd mvnd clean install