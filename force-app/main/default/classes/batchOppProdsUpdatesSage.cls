global class batchOppProdsUpdatesSage implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date newDate = Date.newInstance(2020, 12, 01);
        return Database.getQueryLocator([Select Id,ProductCode,Product_ID__c,Product2.Location__c,Product2.Department__c,Batches_Updated__c from OpportunityLineItem where Opportunity.Amount >0 and Opportunity.StageName = 'Closed' and ((Product2.Location__c != null and ia_crm__Intacct_Location__c = null) OR (Product2.Department__c != null and ia_crm__Department__c  = null)) and CreatedDate >=: newDate]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<OpportunityLineItem> scope){
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        Map<String,String> departmentMap = new Map<String,String>();
        Map<String,String> IntacctEntityMap = new Map<String,String>();
        Map<String,Site_Code_MDT__mdt> siteCodeMap = new map<String,Site_Code_MDT__mdt>();
        
        for(ia_crm__Department__c dep : [SELECT ia_crm__Department_ID__c,Id FROM ia_crm__Department__c WHERE ia_crm__Status__c = 'Active' LIMIT 2000]){
			departmentMap.put(dep.ia_crm__Department_ID__c,dep.Id);
		}
        
        for(ia_crm__Intacct_Entity__c ent : [Select ID,ia_crm__Intacct_Entity_ID__c from ia_crm__Intacct_Entity__c]){
            IntacctEntityMap.put(ent.ia_crm__Intacct_Entity_ID__c, ent.Id);
        }
        
        for(OpportunityLineItem oli : scope){
            oli.ia_crm__Intacct_Location__c = IntacctEntityMap.containskey(oli.Product2.Location__c) ? IntacctEntityMap.get(oli.Product2.Location__c) : null;
            oli.ia_crm__Department__c = departmentMap.containskey(oli.Product2.Department__c) ? departmentMap.get(oli.Product2.Department__c) : null;
            
            if(oli.Batches_Updated__c != null){
                List<String> batches = oli.Batches_Updated__c.split(';');
                batches.add('Location Batch');
                oli.Batches_Updated__c = String.join(batches, ';');
            }else{
                oli.Batches_Updated__c = 'Location Batch';
            }
            
            oliList.add(oli);
            
        }
        
        update oliList;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}