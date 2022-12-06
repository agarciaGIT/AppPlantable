global class batchProductClassChinaFeeUpdateSage implements database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date newDate = Date.newInstance(2020, 12, 01);
        Set<String> prodCodes = new Set<String>{'CHLF','CHNDF'};
        return Database.getQueryLocator([Select Id,ProductCode,ia_crm__Class__c,Exam_Registration__c,Exam_Registration__r.RPT_Administration_Month__c,Batches_Updated__c from OpportunityLineItem where ia_crm__Class__c = null and Exam_Registration__c != null and ProductCode IN: prodCodes and Opportunity.StageName = 'Closed' and  CreatedDate >=: newDate]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<OpportunityLineItem> scope){
        List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
        Map<String,String> classMap = new Map<String,String>();
        
        for(ia_crm__Class__c cls : [SELECT ia_crm__Class_ID__c,ia_crm__Status__c,Id,Name FROM ia_crm__Class__c LIMIT 2000]){
			classMap.put(cls.Name,cls.Id);
		}
        
        for(OpportunityLineItem oli :scope ){
            String examMonth = oli.Exam_Registration__r.RPT_Administration_Month__c.substring(0,3);
            String regClass = examMonth+' Registration';
            oli.ia_crm__Class__c = classMap.containskey(regClass) ? classMap.get(regClass) : null;
            if(oli.Batches_Updated__c != null){
                List<String> batches = oli.Batches_Updated__c.split(';');
                batches.add('Class Batch');
                oli.Batches_Updated__c = String.join(batches, ';');
            }else{
                oli.Batches_Updated__c = 'Class Batch';
            }
            oliToUpdate.add(oli);
        }
        
        if(!oliToUpdate.isEmpty()){
            update oliToUpdate;
        }
        
     }
    
    global void finish(Database.BatchableContext bc){
        
    }
}