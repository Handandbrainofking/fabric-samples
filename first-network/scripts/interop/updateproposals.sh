#!/bin/bash

# ./updateproposals.sh
source $(dirname $(readlink -f "$0"))/util.sh


echo "##########################################################"
echo "####### UpdateProposals $1 #############"
echo "##########################################################"
set -x
peer chaincode invoke -o $ORDERER_ADDR --peerAddresses $ORG1_PEER_ADDR --tlsRootCertFiles $ORG1_TLS_ROOT --peerAddresses $ORG2_PEER_ADDR --tlsRootCertFiles $ORG2_TLS_ROOT --tls --cafile $ORDERER_CA  -C $CHANNEL_NAME -n cmscc -c "{\"function\":\"UpdateProposals\", \"Args\":[\"7\"]}"
set +x
sleep 2
EnterToContinue
echo ""