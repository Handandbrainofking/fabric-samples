#!/bin/bash

# ./getproposal.sh add_orgX
source $(dirname $(readlink -f "$0"))/util.sh


echo "##########################################################"
echo "####### GetProposal $1 #############"
echo "##########################################################"
set -x
peer chaincode query -C $CHANNEL_NAME -n cmscc -c "{\"function\":\"GetProposal\", \"Args\":[\"$1\"]}" | jq '{"status":(.status), "simulation_result":(.simulation_result), "error_message":(.error_message)}'
set +x
echo ""