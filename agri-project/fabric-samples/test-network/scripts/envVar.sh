#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=false
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_FARMER_CA=${PWD}/organizations/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/ca.crt
export PEER1_FARMER_CA=${PWD}/organizations/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/ca.crt
export PEER0_WHOLESALER_CA=${PWD}/organizations/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/ca.crt
export PEER1_WHOLESALER_CA=${PWD}/organizations/peerOrganizations/wholesaler.example.com/peers/peer1.wholesaler.example.com/tls/ca.crt
export PEER0_DISTRIBUTORS_CA=${PWD}/organizations/peerOrganizations/distributors.example.com/peers/peer0.distributors.example.com/tls/ca.crt
export PEER1_DISTRIBUTORS_CA=${PWD}/organizations/peerOrganizations/distributors.example.com/peers/peer1.distributors.example.com/tls/ca.crt
export PEER0_RETAILERS_CA=${PWD}/organizations/peerOrganizations/retailers.example.com/peers/peer0.retailers.example.com/tls/ca.crt
export PEER1_RETAILERS_CA=${PWD}/organizations/peerOrganizations/retailers.example.com/peers/peer1.retailers.example.com/tls/ca.crt
export PEER0_TRANSPORTERS_CA=${PWD}/organizations/peerOrganizations/transporters.example.com/peers/peer0.transporters.example.com/tls/ca.crt
export PEER1_TRANSPORTERS_CA=${PWD}/organizations/peerOrganizations/transporters.example.com/peers/peer1.transporters.example.com/tls/ca.crt


# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="FarmerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_FARMER_CA
    export CORE_PEER_ADDRESS=localhost:7151
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="WholesalerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_WHOLESALER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/wholesaler.example.com/users/Admin@wholesaler.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_WHOLESALER_CA
    export CORE_PEER_ADDRESS=localhost:9151

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="DistributorsMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_DISTRIBUTORS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/distributors.example.com/users/Admin@distributors.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9251
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_DISTRIBUTORS_CA
    export CORE_PEER_ADDRESS=localhost:9351
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="RetailersMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILERS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/retailers.example.com/users/Admin@retailers.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9451
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_RETAILERS_CA
    export CORE_PEER_ADDRESS=localhost:9551
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="TransportersMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_TRANSPORTERS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/transporters.example.com/users/Admin@transporters.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9651
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_TRANSPORTERS_CA
    export CORE_PEER_ADDRESS=localhost:9751
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.farmer.example.com:7051
    export CORE_PEER_ADDRESS=peer1.farmer.example.com:7151
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.wholsaler.example.com:9051
    export CORE_PEER_ADDRESS=peer1.wholsaler.example.com:9151
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.distributors.example.com:9251
    export CORE_PEER_ADDRESS=peer1.distributors.example.com:9351
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_ADDRESS=peer0.retailers.example.com:9451
    export CORE_PEER_ADDRESS=peer1.retailers.example.com:9551

  elif [ $USING_ORG -eq 5 ]; then
    export CORE_PEER_ADDRESS=peer0.transporters.example.com:9651
    export CORE_PEER_ADDRESS=peer1.transporters.example.com:9751
    
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}