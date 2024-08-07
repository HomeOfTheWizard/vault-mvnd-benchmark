#!/bin/sh
# start vault and cAdvisor before launching tests
cd docker || exit
./launch-cadvisor.sh
./launch-vault.sh

# launch agent container
./launch-agent.sh

# launch mvnd vault plugin container

# save reports

# stop vault and cAdvisor after tests
docker compose -f vault/docker-compose-vault.yaml down -v
docker container stop cadvisor
docker container rm cadvisor