global class batchFontevaRemoveBadges implements Database.Batchable<SObject>
{

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select Id FROM OrderApi__Badge__c where OrderApi__Is_Active__c = FALSE');
    }
    
    
    global void execute(Database.BatchableContext BC, List<OrderApi__Badge__c> scope){
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}