global class batchLoadOrders implements Database.Batchable<sObject>{
        
    global batchLoadOrders(){
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
		return Database.getQueryLocator('select Id, Created_At__c, Batch__c, Enable_Automation__c, Enable_Trigger__c from API_Request__c Where Batch__c = True Order By Created_At__c');            
    }    
    
    global void execute(Database.BatchableContext BC, List<API_Request__c> scope){
        for(API_Request__c ar :scope) {
            ar.Batch__c = False;
            ar.Enable_Automation__c = True;
        }
        update scope;       
    }
    
    global void finish(Database.BatchableContext BC){
    }     
    
}