#!/bin/bash

function GenerateMSP() {
  echo "##########################################################"
  echo "####### Generating OrgX OrgY config material #############"
  echo "##########################################################"
  
  PATH=$PATH:/root/gopath/src/github.com/hyperledger/fabric/.build/bin
  cd orgX-artifacts
  cryptogen generate --config=./orgX-crypto.yaml
  export FABRIC_CFG_PATH=$PWD && configtxgen -printOrg OrgXMSP > ../channel-artifacts/orgX.json
  cd ../ && cp -r crypto-config/ordererOrganizations orgX-artifacts/crypto-config/
  cd orgY-artifacts
  cryptogen generate --config=./orgY-crypto.yaml
  export FABRIC_CFG_PATH=$PWD && configtxgen -printOrg OrgYMSP > ../channel-artifacts/orgY.json
  cd ../ && cp -r crypto-config/ordererOrganizations orgY-artifacts/crypto-config/
}

GenerateMSP
# ChangeUser OrgXMSP orgX Admin
docker exec -it cli scripts/interop/addorg.sh Org1MSP org1 Admin add_orgX OrgXMSP channel-artifacts/orgX.json this_is_orgx
docker exec -it cli scripts/interop/signproposal.sh Org1MSP org1 Admin add_orgX
#
docker exec -it cli scripts/interop/addorg.sh Org2MSP org2 Admin add_orgY OrgYMSP channel-artifacts/orgY.json this_is_orgy
docker exec -it cli scripts/interop/signproposal.sh Org2MSP org2 Admin add_orgY
docker exec -it cli scripts/interop/signproposal.sh Org2MSP org2 Admin add_orgX

docker exec -it cli scripts/interop/getproposal.sh add_orgX
docker exec -it cli scripts/interop/getproposal.sh add_orgY

docker exec -it cli scripts/interop/commitproposal.sh add_orgX

docker exec -it cli scripts/interop/getproposal.sh add_orgX
docker exec -it cli scripts/interop/getproposal.sh add_orgY

docker exec -it cli scripts/interop/updateproposals.sh
docker exec -it cli scripts/interop/getproposal.sh add_orgX
docker exec -it cli scripts/interop/getproposal.sh add_orgY
