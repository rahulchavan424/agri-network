#!/bin/bash
# Script to create channel block 0 and then create channel
cp $FABRIC_CFG_PATH/core.yaml /vars/core.yaml
cd /vars
export FABRIC_CFG_PATH=/vars
configtxgen -profile OrgChannel \
  -outputCreateChannelTx autochannel.tx -channelID autochannel

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=192.168.0.103:7011
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/farmer.example.com/peers/peer2.farmer.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=farmer-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp
export ORDERER_ADDRESS=192.168.0.103:7030
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
peer channel create -c autochannel -f autochannel.tx -o $ORDERER_ADDRESS \
  --cafile $ORDERER_TLS_CA --tls
