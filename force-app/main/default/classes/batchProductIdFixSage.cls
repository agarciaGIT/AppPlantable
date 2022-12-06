global class batchProductIdFixSage implements Database.Batchable<Sobject>{

    global Database.QueryLocator start(Database.BatchableContext bc){
        Date newDate = Date.newInstance(2020, 12, 01);
        set<String> prodIds = new Set<String>{'22FRMNOV1E','22FRMNOV1S','22FRMNOV2E','22FRMNOV2S'};
        return Database.getQueryLocator([Select Id,Product_Id__c,Batches_Updated__c from OpportunityLineItem where Product_Id__c IN: prodIds and createddate >=: newDate]);
    }
    
    global void execute(Database.BatchableContext bc, List<OpportunityLineItem> scope){
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        Pattern pat = Pattern.compile('[0-9][0-9][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][0-9][A-Z]');
		
        for(OpportunityLineItem oli : scope){
            if(!pat.matcher(oli.Product_Id__c).matches()){
                oli.Product_Id__c = oli.Product_Id__c.toUppercase();             
                if(oli.Batches_Updated__c != null){
                    List<String> batches = oli.Batches_Updated__c.split(';');
                    batches.add('Product Id Batch');
                    oli.Batches_Updated__c = String.join(batches, ';');
                }else{
                    oli.Batches_Updated__c = 'Product Id Batch';
                }
                oliList.add(oli);
            }
        }
        system.debug(oliList.size()+'   <<::oliList::>>    '+oliList);
        update oliList;
    }

    
    global void finish(Database.BatchableContext bc){}
}