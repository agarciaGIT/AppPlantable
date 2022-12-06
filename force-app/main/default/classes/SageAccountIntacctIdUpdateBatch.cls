global class SageAccountIntacctIdUpdateBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = '';
        Id recordtypeid = RecordTypeHelper.getRecordTypeIdFromSchema('Account', 'Individual');
        if(test.isRunningTest()){
            query = 'SELECT Id,ia_crm__IntacctID__c,GARP_ID__c FROM Account LIMIT 2   ';
        } else {query = 'SELECT Id,ia_crm__IntacctID__c,GARP_ID__c FROM Account WHERE ia_crm__IntacctID__c = null AND GARP_ID__c != null And RecordtypeId =: recordtypeid';}
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        system.debug(scope.size()+'   <<::scope::>>   '+scope);
        List<Account> accListToUpdate = new List<Account>();
        for(Account accData : scope){
            accData.ia_crm__IntacctID__c = accData.GARP_ID__c;
            accListToUpdate.add(accData);
        }
        
        if(accListToUpdate.size() > 0){
            update accListToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC){}
    
}