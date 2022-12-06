global class batchSiteCodeUpdateChinaFeeSage implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date newDate = Date.newInstance(2020, 12, 01);
        Set<String> prodCodes = new Set<String>{'CHNDF','CHLF'};
        return Database.getQueryLocator([Select Id, OpportunityId,Exam_Registration__c,Batches_Updated__c from OpportunityLineItem where ProductCode IN: prodCodes and OpportunityId != null and Opportunity.StageName = 'Closed' and Exam_Registration__c != null and Exam_Registration__r.Result__c = null and Exam_Registration__r.cancelled__c = false and createddate >=: newDate]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<OpportunityLineItem> scope){
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        
        for(OpportunityLineItem oli : scope){
            string siteId = Sage_Default_Records_Ref__mdt.getInstance('Unallocated_Site_Id').value__c;
            oli.Site_Code__c = siteId;
            
            if(oli.Batches_Updated__c != null){
                List<String> batches = oli.Batches_Updated__c.split(';');
                batches.add('Site Code Batch');
                oli.Batches_Updated__c = String.join(batches, ';');
            }else{
                oli.Batches_Updated__c = 'Site Code Batch';
            }
            oliList.add(oli);
        }
        
        update oliList;
    }

    
    global void finish(Database.BatchableContext bc){
        
    }
}