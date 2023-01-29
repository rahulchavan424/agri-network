#!/bin/bash
# Script to join a peer to a channel
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=192.168.0.103:7015
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/distributor.example.com/peers/peer2.distributor.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=distributor-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/distributor.example.com/users/Admin@distributor.example.com/msp
export ORDERER_ADDRESS=192.168.0.103:7030
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
if [ ! -f "autochannel.genesis.block" ]; then
  peer channel fetch oldest -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA \
  --tls -c autochannel /vars/autochannel.genesis.block
fi

peer channel join -b /vars/autochannel.genesis.block \
  -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA --tls