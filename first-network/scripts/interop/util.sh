#!/bin/bash

export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CHANNEL_NAME=mychannel
export ORG1_TLS_ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export ORG2_TLS_ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export ORDERER_ADDR=orderer.example.com:7050
export ORG1_PEER_ADDR=peer0.org1.example.com:7051
export ORG2_PEER_ADDR=peer0.org2.example.com:9051

function EnterToContinue() {
  read -p "Press Enter to continue."
}


#ChangeUser Org1MSP org1 Admin
function ChangeUser() {
  echo "##########################################################"
  echo "####### ChangeUser to $1 $2 $3 #############"
  echo "##########################################################"
  
  CORE_PEER_LOCALMSPID=$1
  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/$2.example.com/peers/peer0.$2.example.com/tls/ca.crt
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/$2.example.com/users/$3@$2.example.com/msp
  if [ $2 == 'org1' ]
  then
    CORE_PEER_ADDRESS=$ORG1_PEER_ADDR
  elif [ $2 == 'org2' ]
  then
    CORE_PEER_ADDRESS=$ORG2_PEER_ADDR
  fi
    
  
  echo "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID"
  echo "CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE"
  echo "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH"
  echo "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS"
  echo ""
}
