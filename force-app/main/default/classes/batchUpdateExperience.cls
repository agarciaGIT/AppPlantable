global class batchUpdateExperience implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, Supervisor_Email__c from Experience__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Experience__c> scope){
       
        for(Experience__c objOpp : scope)
        {
           objOpp.supervisor_email__C = '';
                      
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}