global class batchstudycontact implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Study_Contact_Email__c from Study_Contact__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Study_Contact__c> scope){
       
        for(Study_Contact__c objOpp : scope)
        {
            objopp.Study_Contact_Email__c = '';
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}