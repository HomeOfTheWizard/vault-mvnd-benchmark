#!/bin/bash

echo "launching monitoring stack containers"
docker compose -f monitoring/docker-compose-monitoring.yaml up --build -d

#VERSION=v0.49.1 # use the latest release version from https://github.com/google/cadvisor/releases
#docker run \
#  --volume=/:/rootfs:ro \
#  --volume=/var/run:/var/run:ro \
#  --volume=/sys:/sys:ro \
#  --volume=/var/lib/docker/:/var/lib/docker:ro \
#  --volume=/dev/disk/:/dev/disk:ro \
#  --publish=8080:8080 \
#  --detach=true \
#  --name=cadvisor \
#  --privileged \
#  --device=/dev/kmsg \
#  gcr.io/cadvisor/cadvisor:$VERSION