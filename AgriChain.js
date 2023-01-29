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
                EntityName : "Farmer1",
                Location : Chattarpur,
                Role: 'Farmer'
            },
            {
                EntityID : '20001',
                EntityName : "Wholesaler1",
                Location : Rajapur,
                Role: 'Wholesaler'
            },
            {
                EntityID : '30001',
                EntityName : "Distributor1",
                Location : Sangli,
                Role: 'Distributor'
            },
            {
                EntityID : '40001',
                EntityName : "Retailer1",
                Location : Kolhapur,
                Role: 'Retailer'
            },
            {
                EntityID : '50001',
                EntityName : "Transporter1",
                Location : Nagpur,
                Role: 'Transporter'
            }
        ];

        for (const entity of entities) {
            entity.docType = 'entity';
            await ctx.stub.putState(entity.entityID, Buffer.from(JSON.stringify(entity)));
            console.info(`Entity ${entity.entityID} intitialized`);
        }
    }

    //exist check for entity
    async entityExists(ctx, entityId) {
        const assetJSON = await ctx.stub.getState(entityId);
        return assetJSON && assetJSON.length > 0;
    }

    //exist check for batch
    async batchExists(ctx, batchId, cropName) {
        const batchKey = ctx.stub.createCompositeKey('batch', [batchId, cropName]);
        const batchAsBytes = await ctx.stub.getState(batchKey);
        return batchAsBytes && batchAsBytes.length > 0;
    }
    
    //delete entity
    async deleteEntity(ctx, entityId) {
        const exists = await this.AssetExists(ctx, entityId);
        if (!exists) {
            throw new Error("the entity does not exist");
        }
        return ctx.stub.deleteState(id);
    }

    //register entity
    async registerEntity(ctx, args) {
        const entityExists = await this.entityExists(ctx, args[0]);
        if (args.length != 4 || entityExists) {
            throw new Error("insufficient information or entity already exists");
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
    

    
    //add a batch only by farmer
    async addBatch(ctx, args) {
        const batchExists = await this.batchExists(ctx, args[0], args[1]);
        if (args.length != 6 || batchExists) {
            throw new Error("insufficient information or batch already exists");
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
            const compositeKey = ctx.stub.createCompositeKey('batch', [batch.BatchID, batch.CropName]);
            await ctx.stub.putState(compositeKey);
        } else {
            throw new Error("batch can only be added by a farmer");
        }
    }
    
    //transfer a batch
    async transferBatch(ctx, buyerId, batchId, cropName) {
        const batchExists = await this.batchExists(ctx, batchId, cropName);
        if (!batchExists) {
            throw new Error("batch does not exist");
        }
        const batchKey = ctx.stub.createCompositeKey('batch', [batchId, cropName]);
        const batchAsBytes = await ctx.stub.getState(batchKey);
        const batch = JSON.parse(batchAsBytes.toString());
        if (batch.Stage === 0 && batch.Role === 'Farmer') {
            batch.EntityID = buyerId;
            batch.Stage += 1;
            batch.Role = 'Wholesaler';
            await ctx.stub.putState(batchId, Buffer.from(JSON.stringify(batch)));
        } else if (batch.Stage === 1 && batch.Role === 'Wholesaler') {
                batch.EntityID = buyerId;
                batch.Stage += 1;
                batch.Role = 'Distributor';
                await ctx.stub.putState(batchId, Buffer.from(JSON.stringify(batch)));
        } else if (batch.Stage === 2 && batch.Role === 'Distributor') {
            batch.EntityID = buyerId;
            batch.Stage += 1;
            batch.Role = 'Retailer';
            await ctx.stub.putState(batchId, Buffer.from(JSON.stringify(batch)));
        } else {
            throw new Error("invalid transaction");
        }
    }

    //retail a batch
    async retailBatch(ctx, transporterId, batchId, cropName) {
        const batchExists = await this.batchExists(ctx, batchId, cropName);
        if (!batchExists) {
            throw new Error("batch does not exist");
        }
        const batchKey = ctx.stub.createCompositeKey('batch', [batchId, cropName]);
        const batchAsBytes = await ctx.stub.getState(batchKey);
        const batch = JSON.parse(batchAsBytes.toString());
        if (batch.Stage === 3 && batch.Role === 'Retailer') {
            batch.EntityID = transporterId;
            batch.Stage += 1;
            await ctx.stub.putState(batchId, Buffer.from(JSON.stringify(batch)));
        } else {
            throw new Error("invalid transaction");
        }
    }

    //delete batch
    async deleteBatch(ctx, batchId, cropName) {
        const batchExists = await this.batchExists(ctx, batchId, cropName);
        if (!batchExists) {
            throw new Error("batch does not exist");
        }
        const batchKey = ctx.stub.createCompositeKey('batch', [batchId, cropName]);
        await ctx.stub.deleteState(batchKey);
    }
    
    //view batch history
    async viewBatchHistory(ctx, batchID, cropName) {
        const batchExists = await this.batchExists(ctx, batchId, cropName);
        if (!batchExists) {
            throw new Error("batch does not exist");
        }
        const batchKey = ctx.stub.createCompositeKey('batch', [batchID, cropName]);
        const history = await ctx.stub.getHistoryForKey(batchKey);
    
        const results = [];
        for (let i = 0; i < history.length; i++) {
            const batch = JSON.parse(history[i].value.toString());
            results.push({
                transaction_id: history[i].tx_id,
                batchID: batch.batchID,
                cropName: batch.cropName,
            });
        }
    }

    //view batch current state
    async viewBatchCurrentState(ctx, batchId, cropName) {
        const batchExists = await this.batchExists(ctx, batchId, cropName);
        if (!batchExists) {
            throw new Error("batch does not exist");
        }
        const batchKey = ctx.stub.createCompositeKey('batch', [batchId, cropName]);
        const batchAsBytes = await ctx.stub.getState(batchKey);
        const batch = JSON.parse(batchAsBytes.toString());
        return batch;
    }
}

