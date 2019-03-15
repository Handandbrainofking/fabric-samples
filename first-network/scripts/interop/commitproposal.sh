#!/bin/bash

# ./commitproposal.sh add_orgX
source $(dirname $(readlink -f "$0"))/util.sh


echo "##########################################################"
echo "####### CommitProposal $1 #############"
echo "##########################################################"
set -x
peer chaincode query -C $CHANNEL_NAME -n cmscc -c "{\"function\":\"GetProposal\", \"Args\":[\"$1\"]}" | jq '.config_update_envelope_to_submit' | sed 's/^"//g' | sed 's/\"//g' > config_update_envelope_to_submit.b64
base64 -d config_update_envelope_to_submit.b64 > config_update_envelope_to_submit.pb
peer channel update -f config_update_envelope_to_submit.pb -c $CHANNEL_NAME -o $ORDERER_ADDR --tls --cafile $ORDERER_CA
set +x
sleep 2
EnterToContinue
echo ""