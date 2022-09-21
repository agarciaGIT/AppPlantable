global class batchUpdateInventory implements Database.Batchable<sObject>, Database.AllowsCallouts{
        
    public String mode;  

    global batchUpdateInventory (String mode){
        this.mode = mode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  

        System.debug('mode:' + mode);
        
        if(mode != NULL) {
            return Database.getQueryLocator('select ID, Account__c, Opportunity__c , Batch__c, Request_Type__c from API_Request__c where Study_ID__c != NULL AND Batch__c = True AND ID = :mode');    
        } else {
            return Database.getQueryLocator('select ID, Account__c, Opportunity__c , Batch__c, Request_Type__c from API_Request__c where Study_ID__c != NULL AND Batch__c = True');    
        }
        
    }    
                                            
    global void execute(Database.BatchableContext BC, List<API_Request__c> scope){

         for(API_Request__c ar :scope) {     
            if(ar.Request_Type__c == 'Create Order') {
              shopifyClass.updateInventory(ar.Opportunity__c, false);    
            }         
         }
        
    }
    
    global void finish(Database.BatchableContext BC){
        Database.executebatch(new batchUpdateBitlyLinks(NULL));
    }     
    
}