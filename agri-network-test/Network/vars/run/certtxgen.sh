#!/bin/bash
cd $FABRIC_CFG_PATH
# cryptogen generate --config crypto-config.yaml --output keyfiles
configtxgen -profile OrdererGenesis -outputBlock genesis.block -channelID systemchannel

configtxgen -printOrg distributor-example-com > JoinRequest_distributor-example-com.json
configtxgen -printOrg farmer-example-com > JoinRequest_farmer-example-com.json
configtxgen -printOrg retailer-example-com > JoinRequest_retailer-example-com.json
configtxgen -printOrg transporter-example-com > JoinRequest_transporter-example-com.json
configtxgen -printOrg wholesaler-example-com > JoinRequest_wholesaler-example-com.json
