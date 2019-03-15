#!/bin/bash

# ./signproposal.sh Org1MSP org1 Admin add_orgX
source $(dirname $(readlink -f "$0"))/util.sh

ChangeUser $1 $2 $3
# ChangeUser Org1MSP org1 Admin

echo "##########################################################"
echo "####### SignProposal $4 #############"
echo "##########################################################"
set -x
peer chaincode query -C $CHANNEL_NAME -n cmscc -c "{\"function\":\"GetProposal\", \"Args\":[\"$4\"]}" | jq '.config_update_to_sign' | sed 's/^"//g' | sed 's/\"//g' > config_update_to_sign.b64

base64 -d config_update_to_sign.b64 > config_update_to_sign.pb

peer channel signconfigtx -f config_update_to_sign.pb

configtxlator proto_decode --input config_update_to_sign.pb --type common.Envelope --output config_update_signed.json

jq '.payload.data.signatures[0]' config_update_signed.json > signature_to_submit.json

jq "{\"function\":\"AddSignature\", \"Args\":[\"$4\", (. | tostring)]}" -c signature_to_submit.json > ccargs.json

peer chaincode invoke -o $ORDERER_ADDR --peerAddresses $ORG1_PEER_ADDR --tlsRootCertFiles $ORG1_TLS_ROOT --peerAddresses $ORG2_PEER_ADDR --tlsRootCertFiles $ORG2_TLS_ROOT --tls --cafile $ORDERER_CA  -C $CHANNEL_NAME -n cmscc -c "`cat ccargs.json`"
set +x
sleep 2
EnterToContinue
echo ""