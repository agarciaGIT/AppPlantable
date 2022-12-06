public class SageRefundProcessQueueable implements Queueable,Database.AllowsCallouts{
	Map<Id,Set<Id>> opptoProdMap;
    Map<String,ChargentSFA__Transaction__c> oppToTransactionMap;
    Map<Id,Id> switchTransMap;
    public SageRefundProcessQueueable(Map<Id,Set<Id>> inputMap,Map<String,ChargentSFA__Transaction__c> oppTransactionMap,Map<Id,Id> switchTransactionMap){
        this.opptoProdMap = inputMap;
        this.oppToTransactionMap = oppTransactionMap;
        this.switchTransMap = switchTransactionMap;
    }
    public void execute(QueueableContext context) {
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        List<OpportunityLineItem> lineItemsToInsert = new List<OpportunityLineItem>();
        Map<Id,List<OpportunityLineItem>> opptoOliMap = new Map<Id,List<OpportunityLineItem>>();
        List<ChargentSFA__Transaction__c> transUpdate = new List<ChargentSFA__Transaction__c>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        string siteId = Sage_Default_Records_Ref__mdt.getInstance('Unallocated_Site_Id').value__c;
        
        if(opptoProdMap != null){
            Map<Id,Opportunity> oppsMap = new Map<Id,Opportunity>([Select Id,StageName,AccountId,ChargentSFA__Billing_Email__c,ChargentSFA__Payment_Method__c,
                                                                   ChargentSFA__Billing_First__c,ChargentSFA__Billing_Last__c,
                                                                   ChargentSFA__Billing_Phone__c,ChargentSFA__Billing_Company__c,
                                                                   ChargentSFA__Billing_Address__c,ChargentSFA__Billing_City__c,
                                                                   ChargentSFA__Billing_State__c,ChargentSFA__Billing_Zip__c,
                                                                   ChargentSFA__Billing_Country__c,Shipping_First_Name__c,
                                                                   Shipping_Last_Name__c,Shipping_E_mail__c,Shipping_Company_Name__c,
                                                                   Shipping_Phone_No__c,Shipping_Street__c,Shipping_City__c,
                                                                   Shipping_State__c,Shipping_Postal_Code__c,Shipping_Country__c,
                                                                   RecordTypeId,priceBook2Id,ChargentSFA__card_Type__c,Display_Invoice_Number__c
                                                                   from Opportunity where Id IN: opptoProdMap.keySet()]);
            
            List<OpportunityLineItem> prodList = [Select Id,UnitPrice,PricebookEntryId,OpportunityId,Product_Id__c,Product2Id,Quantity,TotalPrice,ProductCode,
                                                  ia_crm__Class__c,ia_crm__Department__c,ia_crm__Intacct_Location__c,Sage_Reporting_Country__c,Site_Code__c,
                                                  Intacct_Template__c,Warehouse__c,Sage_Reporting_State__c,Sage_Shipping_Country__c,Sage_Shipping_State__c,
                                                  Vendor_Id__c,Vendor_Name__c
                                                  from OpportunityLineItem 
                                                  where OpportunityId IN:opptoProdMap.keySet()];
            
            for(OpportunityLineItem oli : prodList){
                Set<Id> prodSet = opptoProdMap.get(oli.OpportunityId);
                if(prodSet.contains(oli.Product2Id)){
                    if(opptoOliMap.containsKey(oli.OpportunityId)){
                        List<OpportunityLineItem> prodIds = opptoOliMap.get(oli.OpportunityId);
                        prodIds.add(oli);
                        opptoOliMap.put(oli.OpportunityId,prodIds);
                    }else{
                        opptoOliMap.put(oli.OpportunityId,new List<OpportunityLineItem>{oli});
                    }
                }
            }
            
            for(Opportunity opp : oppsMap.values()){
                Opportunity objOpp = new Opportunity();
                objOpp.AccountId = opp.AccountId;
                objOpp.ChargentSFA__Billing_Email__c = opp.ChargentSFA__Billing_Email__c;
                objOpp.ChargentSFA__Billing_First__c = opp.ChargentSFA__Billing_First__c;
                objOpp.ChargentSFA__Billing_Last__c = opp.ChargentSFA__Billing_Last__c;
                objOpp.ChargentSFA__Billing_Phone__c = opp.ChargentSFA__Billing_Phone__c;
                objOpp.ChargentSFA__Billing_Company__c = opp.ChargentSFA__Billing_Company__c;
                objOpp.ChargentSFA__Billing_Address__c = opp.ChargentSFA__Billing_Address__c;
                objOpp.ChargentSFA__Billing_City__c = opp.ChargentSFA__Billing_City__c;
                objOpp.ChargentSFA__Billing_State__c = opp.ChargentSFA__Billing_State__c;
                objOpp.ChargentSFA__Billing_Zip__c = opp.ChargentSFA__Billing_Zip__c;
                objOpp.ChargentSFA__Billing_Country__c = opp.ChargentSFA__Billing_Country__c;
                objOpp.Shipping_First_Name__c = opp.Shipping_First_Name__c;
                objOpp.Shipping_Last_Name__c = opp.Shipping_Last_Name__c;
                objOpp.Shipping_E_mail__c = opp.Shipping_E_mail__c;
                objOpp.Shipping_Company_Name__c = opp.Shipping_Company_Name__c;
                objOpp.Shipping_Phone_No__c = opp.Shipping_Phone_No__c;
                objOpp.Shipping_Street__c = opp.Shipping_Street__c;
                objOpp.Shipping_City__c = opp.Shipping_City__c;
                objOpp.Shipping_State__c = opp.Shipping_State__c;
                objOpp.Shipping_Postal_Code__c = opp.Shipping_Postal_Code__c;
                objOpp.Shipping_Country__c = opp.Shipping_Country__c;
                objOpp.StageName = 'New Lead';
                objOpp.CloseDate = system.today();
                objOpp.Name = 'Refund Invoice';
                objOpp.Refund_Opportunity__c = opp.Id;
                objOpp.RecordTypeId = opp.RecordTypeId;
                objOpp.priceBook2Id = opp.priceBook2Id;
                objOpp.ia_crm__Intacct_Transaction__c = 'Salesforce - Refund';
                objOpp.ChargentSFA__Payment_Method__c = oppToTransactionMap.get(opp.Id).ChargentSFA__Payment_Method__c;
                objOpp.ChargentSFA__card_Type__c = oppToTransactionMap.get(opp.Id).ChargentSFA__Credit_Card_Type__c;
                objOpp.ChargentSFA__Tokenization__c = oppToTransactionMap.get(opp.Id).ChargentSFA__Tokenization__c;
                objOpp.Display_Invoice_Number__c = opp.Display_Invoice_Number__c+'CN';
                objOpp.ChargentSFA__Invoice_Number__c = opp.Display_Invoice_Number__c+'CN';
                oppsToInsert.add(objOpp);
            }
            
            if(!oppsToInsert.isEmpty()){
                insert oppsToInsert;
            }
            
            List<Opportunity> insertedOppsList = [Select Id,Refund_Opportunity__c from opportunity where Id IN: oppsToInsert];
            
            Map<Id,Id> refundOppMap = new Map<id,Id>();
            
            for(Opportunity opp : insertedOppsList){
                refundOppMap.put(opp.Refund_Opportunity__c,opp.id);
                opp.StageName = 'Closed';
            }
            
            for(Opportunity opp : oppsMap.values()){
                List<OpportunityLineItem> items = opptoOliMap.get(opp.Id);
                for(OpportunityLineItem oli : items){
                    if(oli.ProductCode == 'MEMA'){
                        continue;
                    }
                    OpportunityLineItem newOli = new OpportunityLineItem();
                    newOli.OpportunityId = refundOppMap.get(opp.Id);
                    newOli.Quantity = oli.Quantity;
                    newOli.UnitPrice = oli.UnitPrice;
                    //newOli.TotalPrice = -1 * oli.TotalPrice;
                    newOli.Product_ID__c = oli.Product_ID__c;
                    newOli.PricebookEntryId = oli.PricebookEntryId;
                    newoli.Product2Id = oli.Product2Id;
                    newOli.For_Sage_Sync_Only__c = true;
                    newOli.ia_crm__Class__c = oli.ia_crm__Class__c;
                    newOli.ia_crm__Department__c = oli.ia_crm__Department__c;
                    newOli.ia_crm__Intacct_Location__c = oli.ia_crm__Intacct_Location__c;
                    newOli.Sage_Reporting_Country__c = oli.Sage_Reporting_Country__c;
                    newOli.Sage_Reporting_State__c = oli.Sage_Reporting_State__c;
                    newOli.Sage_Shipping_Country__c = oli.Sage_Shipping_Country__c;
                    newOli.Sage_Shipping_State__c = oli.Sage_Shipping_State__c;
                    newOli.Vendor_Name__c = oli.Vendor_Name__c;
                    newOli.Vendor_Id__c = oli.Vendor_Id__c;
                    newOli.Warehouse__c = oli.Warehouse__c;
                    newOli.Site_Code__c = siteId;
                    newOli.Intacct_Template__c = oli.Intacct_Template__c;
                    lineItemsToInsert.add(newoli);
                }
                
                ChargentSFA__Transaction__c trans = new ChargentSFA__Transaction__c();
                trans.Id = oppToTransactionMap.get(opp.Id).Id;
                trans.ChargentSFA__Opportunity__c = refundOppMap.get(opp.Id);
                transUpdate.add(trans);
            }
            
            if(!lineItemsToInsert.isEmpty()){
                insert lineItemsToInsert;
            }
            
            update insertedOppsList;
            
        }
        
        if(switchTransMap != null){
            Map<Id,Id> refundOpptoOrigOppMap = new Map<Id,Id>();
            List<Opportunity> refundOpps = [Select Id,Refund_Opportunity__c from Opportunity where Refund_Opportunity__c IN: switchTransMap.values() and StageName = 'New Lead'];
            for(Opportunity opp : refundOpps){
                refundOpptoOrigOppMap.put(opp.Refund_Opportunity__c, opp.Id);
                opp.StageName = 'Closed';
                oppsToUpdate.add(opp);
            }
            
            for(Id transId : switchTransMap.keyset()){
                ChargentSFA__Transaction__c trans = new ChargentSFA__Transaction__c();
                trans.Id = transId;
                trans.ChargentSFA__Opportunity__c = refundOpptoOrigOppMap.get(switchTransMap.get(transId));
                transUpdate.add(trans);
            }
            
            if(!transUpdate.isEmpty()){
                update transUpdate;
            }
            
            if(!oppsToUpdate.isEmpty()){
                update oppsToUpdate;
            }
            
        }
    
    }
    
}