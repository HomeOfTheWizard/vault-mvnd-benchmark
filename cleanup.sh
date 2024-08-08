# stop vault and cAdvisor after test reports are created
docker compose -f vault/docker-compose-vault.yaml down -v
docker compose -f agent/docker-compose-vault-agent.yaml down -v
docker compose -f monitoring/docker-compose-monitoring.yaml down -v

# cleanup files
sudo rm docker/agent/secrets/application-agent.yaml
sudo rm docker/mvnd/secrets/.env