# agri-network

------------------------------------------------------------------------------------------------------


Creating a supply chain management system for a specific industry, such as a food traceability system. The system would be able to track the origin, movement, and quality of food products from farm to table.

The project would involve creating a Hyperledger Fabric network with multiple organizations, such as farmers, processors, distributors, retailers, and regulators. Each organization would have their own nodes on the network, and they would be able to share information and update the ledger with new data as the food products move through the supply chain.

The chaincode could be used to track the movement of products, update the quality of the products, and ensure that all the stakeholders are in compliance with the regulations. The smart contract could also be used to automate some of the processes like payments, dispute resolutions, and certifications.



BatchId - Unique
Items - 

1. Organic Farmers - They will be adding the {crops, vegetables} supplied to the wholesaler.
2. Wholesaler - They will supply the batch received from farmers to the distributors.
3. Distributors - They will purchase the batch directly from wholesalers.
4. Retailers - They will receive batch consignments from the distributors.
5. Transporters - They will be responsible for shipment of the batch from one point to another.


1. Farmer registration
2. Batch registration
3. Batch transfer
4. view batch lifecycle

Network Setup
----------------------------------------------

1. Each org will have 2 peers
2. Network - Agrinetwork , Single channel network
3. Each org has one admin as a user.
4. certificates - cryptogen/fabric-ca
5. tls - disabled
6. orderer type - raft
7. Channel name - agrichannel
8. chaincode name - agrinet
9. Both peers of orgs should have chaincode installed.
10. Endorsement policy - Any endorsement

----------------------------------------------------
Chaincode Functions

1. registerEntity (farmerID, farmerName, Location, Role)
//role will define the part of this entity on the network(farmer, wholesaler, distributor, retailer, transporter).

2. addBatch (Crop name, batch id, harvest date, apprxExpriy date, farmerID)
//transaction should be invoked by farmer registered on network.

3. transferBatch (buyerID, sellerId, cropname, batch id, role).

   retailBatch (crop name, batch id, retailerId, transporterID)// this function will be called by retailer while shipping it to the transporter.

4. deleteBatch (farmerID, farmerName, cropname, batchId).
// this will delete the batch, this should be executed by farmer before the transfer of the batch.

5. viewBatchHistory (crop name, batch id)
// this function should return transaction id along with the details of the batch for every txn linked with it.
   viewBatchCurrentState (crop name, batch id)
// this will return current state of the asset.

-------------------------------------------------------------

Fabric SDK 

Single application - used by organisations to interact with functions defined inside the smart contract.
create ccp for each participant in the network.
create a wallet to store identity of the admin user for each org.

create node server using express library and expose node modules as service endpoints.

send HTTP requests on these endpoints using postman/ui.
