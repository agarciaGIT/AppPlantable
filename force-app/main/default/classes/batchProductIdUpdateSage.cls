global class batchProductIdUpdateSage implements Database.Batchable<sobject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date newDate = Date.newInstance(2020, 12, 01);
        Set<String> productCodes = new Set<String>{'CBR2A','CBR','FCBR','CBRNM','FBRNM'};
        return Database.getQueryLocator([Select Id,ProductCode,Product2.Class__c,Product2.Product_Id__c,CreatedDate,Product_Id__c,Batches_Updated__c from OpportunityLineItem where ProductCode IN: productCodes and CreatedDate >=: newDate]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<OpportunityLineItem> scope){
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        Map<String,String> classMap = new Map<String,String>();
        
        for(ia_crm__Class__c cls : [SELECT ia_crm__Class_ID__c,ia_crm__Status__c,Id,Name FROM ia_crm__Class__c LIMIT 2000]){
			classMap.put(cls.Name,cls.Id);
		}
        
        for(OpportunityLineItem oli : scope){
            if(String.isBlank(oli.Product_Id__c)){
            	oli.Product_Id__c = oli.Product2.Product_Id__c;
            }
            
            oli.ia_crm__Class__c = classMap.containskey(oli.Product2.Class__c) ? classMap.get(oli.Product2.Class__c) : null;
            if(oli.Batches_Updated__c != null){
                List<String> batches = oli.Batches_Updated__c.split(';');
                batches.add('Product Id Batch');
                batches.add('Class Batch');
                oli.Batches_Updated__c = String.join(batches, ';');
            }else{
                oli.Batches_Updated__c = 'Product Id Batch;Class Batch';
            }
            oliList.add(oli);
        }
        
        update oliList;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}