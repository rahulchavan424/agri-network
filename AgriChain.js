/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class AgriChain extends Contract {
    async InitLedger(ctx){
        const entities = [
            {
                EntityID : '10001',
                EntityName : "Raju bhau",
                Location : Chattarpur,
                Role: 'Farmer'
            },
            {
                EntityID : '10001',
                EntityName : "Raju bhau",
                Location : Chattarpur,
                Role: 'Wholesaler'
            },
            {
                EntityID : '10001',
                EntityName : "Raju bhau",
                Location : Chattarpur,
                Role: 'Distributor'
            },
            {
                EntityID : '10001',
                EntityName : "Raju bhau",
                Location : Chattarpur,
                Role: 'Retailer'
            },
            {
                EntityID : '10001',
                EntityName : "Raju bhau",
                Location : Chattarpur,
                Role: 'Transporter'
            }
        ];

        for (const entity of entities) {
            entity.docType = 'entity';
            await ctx.stub.putState(farmer.farmerID, Buffer.from(JSON.stringify(farmer)));
            console.info(`Farmer ${farmer.farmerID} intitialised`);
        }
    }
    
    // Register
    async registerEntity(ctx, args) {
        if (args.length != 4) {
            throw new Error("insufficient info");
        }
        const entity = {
            EntityID : args[0],
            EntityName : args[1],
            Location : args[2],
            Role: args[3]
        };
        await ctx.stub.putState(batchId, Buffer.from(JSON.stringify(entity)));
        return JSON.stringify(entity);
    }
    
    // Addbatch for issuing new assets like crop, batchid, harvestdate, expdate, farmerID .
    async addBatch(ctx, args) {
        if (args.length != 6) {
            throw new Error("insufficient info");
        }
        if (role == 'Farmer') {
            const batch ={
                BatchID: args[0],
                CropName: args[1],
                HarvestDate: args[2],
                ExpiryDate: args[3],
                EntityID: args[4],
                Role: args[5],
                Stage: 0
            };
            const batchAsBytes = Buffer.from(JSON.stringify(batch));
            //composite key for multiple properties
            const compositeKey = ctx.stub.createCompositeKey('batch', [batch.BatchID, batch.CropName]);
            await ctx.stub.putState(compositeKey)
        } else {
            throw new Error("not a farmer");
        }
    }
    // Transfer buyerid, sellerid, cropname,batchid, role
    async transferBatch(ctx, buyerId, batchId, cropName) {
        const batchKey = ctx.stub.createCompositeKey('batch', [batchId, cropName]);
        const batchAsBytes = await ctx.stub.getState(batchKey);
        const batch = JSON.parse(batchAsBytes.toString());
        if (batch.Stage == 0 && batch.Role == 'Farmer') {
            batch.EntityID = buyerId;
            batch.Stage += 1;
            await ctx.stub.putState(batchId, Buffer.from(JSON.stringify(batch)));
        } else if (batch.Stage == 1 && batch.Role == 'Wholesaler') {
                batch.EntityID = buyerId;
                batch.Stage += 1;
                await ctx.stub.putState(batchId, Buffer.from(JSON.stringify(batch)));
        } else if (batch.Stage == 2 && batch.Role == 'Distributor') {
            batch.EntityID = buyerId;
            batch.Stage += 1;
            await ctx.stub.putState(batchId, Buffer.from(JSON.stringify(batch)));
        } else {
            throw new Error("invalid transaction");
        }
    }

    async retailBatch(ctx, transporterId, batchId, cropName) {
        const batchKey = ctx.stub.createCompositeKey('batch', [batchId, cropName]);
        const batchAsBytes = await ctx.stub.getState(batchKey);
        const batch = JSON.parse(batchAsBytes.toString());
        if (batch.Stage == 3 && batch.Role == 'Retailer') {
            batch.EntityID = transporterId;
            batch.Stage += 1;
            await ctx.stub.putState(batchId, Buffer.from(JSON.stringify(batch)));
        } else {
            throw new Error("invalid transaction");
        }
    }

    async deleteBatch(ctx, batchId, cropName) {
        const batchKey = ctx.stub.createCompositeKey('batch', [batchId, cropName]);
        await ctx.stub.deleteState(batchKey);
    } 
}

