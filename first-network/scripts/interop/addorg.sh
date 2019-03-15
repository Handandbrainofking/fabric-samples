#!/bin/bash

# ./addorg.sh Org1MSP org1 Admin add_orgX OrgXMSP channel-artifacts/orgX.json this_is_orgx

source $(dirname $(readlink -f "$0"))/util.sh


ChangeUser $1 $2 $3
# ChangeUser Org1MSP org1 Admin

echo "##########################################################"
echo "####### Add orgnization $5 #############"
echo "####### Proposal id $4 #############"
echo "##########################################################"

# jq '{"function":"AddOrgnization", "Args":["add_orgX", "OrgXMSP", (. | tostring), "this_is_orgx"]}' -c channel-artifacts/orgX.json > ccargs.json
set -x
jq "{\"function\":\"AddOrgnization\", \"Args\":[\"$4\", \"$5\", (. | tostring), \"$6\"]}" -c channel-artifacts/orgX.json > ccargs.json

peer chaincode invoke -o $ORDERER_ADDR --peerAddresses $ORG1_PEER_ADDR --tlsRootCertFiles $ORG1_TLS_ROOT --peerAddresses $ORG2_PEER_ADDR --tlsRootCertFiles $ORG2_TLS_ROOT --tls --cafile $ORDERER_CA  -C $CHANNEL_NAME -n cmscc -c "`cat ccargs.json`"
set +x
sleep 2
EnterToContinue
echo ""