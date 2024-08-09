# stop vault and cAdvisor after test reports are created
docker compose -f docker/agent/docker-compose-vault-agent.yaml down -v
docker container stop mvnd-vault
docker container rm mvnd-vault
docker compose -f docker/vault/docker-compose-vault.yaml down -v
docker compose -f docker/monitoring/docker-compose-monitoring.yaml down -v
docker volume rm $(docker volume ls -q -f dangling=true)

# cleanup files
sudo rm docker/agent/secrets/application-agent.yaml
sudo rm docker/mvnd/project/.env