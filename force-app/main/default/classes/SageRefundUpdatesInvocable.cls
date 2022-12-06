global class SageRefundUpdatesInvocable {
    @InvocableMethod(label='Sage Refunds Process')
    global static void updateOpps(List<Id> transactionItemIds){
        Map<String,String> oppIdMap = new Map<String,String>();
        List<Order_Transaction_Item__c> items = [Select Id,Transaction__c,Opportunity__c from Order_Transaction_Item__c where Id IN: transactionItemIds];
        
        for(Order_Transaction_Item__c item : items){
            oppIdMap.put(item.Opportunity__c,item.Transaction__c);
        }
        
        Map<Id,Set<Id>> oppToRefundProdsMap = new Map<Id,Set<Id>>();
        Map<Id,Id> switchTransactionMap = new Map<Id,Id>();
        
        if(!oppIdMap.isEMpty()){
            for(Product_Refunds__c pr : [SELECT Id,status__C,Opportunity__c,Reason__c,Product__c FROM Product_Refunds__c WHERE Opportunity__c IN: oppIdMap.keySet() and status__c ='Approved']){
                if(pr.Reason__c != 'Switch'){
                    if(oppToRefundProdsMap.containsKey(pr.Opportunity__c)){
                        Set<Id> prodIds = oppToRefundProdsMap.get(pr.Opportunity__c);
                        prodIds.add(pr.Product__c);
                        oppToRefundProdsMap.put(pr.Opportunity__c,prodIds);
                    }else{
                        oppToRefundProdsMap.put(pr.Opportunity__c,new Set<Id>{pr.Product__c});
                    }
                }else if(pr.Reason__c == 'Switch'){
                    switchTransactionMap.put(oppIdMap.get(pr.Opportunity__c),pr.Opportunity__c);
                }
            }
            
            if(oppToRefundProdsMap != null || switchTransactionMap != null){
                //SageRefundProcessQueueable sageQueue = new SageRefundProcessQueueable(oppToRefundProdsMap,oppIdMap,switchTransactionMap);
                //ID jobID = System.enqueueJob(sageQueue);
            }
        }
    }
}