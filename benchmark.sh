#!/bin/bash
# start vault and cAdvisor before launching tests
cd docker || exit
./launch-cadvisor.sh
./launch-vault.sh

# launch agent container
./launch-agent.sh

# launch mvnd vault plugin container
./launch-mvnd.sh

# get reports
./get-reports.sh