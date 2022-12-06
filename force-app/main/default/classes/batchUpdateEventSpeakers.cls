global class batchUpdateEventSpeakers implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Email__c from Event_Speaker__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Event_Speaker__c> scope){
       
        for(Event_Speaker__c objOpp : scope)
        {
            objOpp.Email__c = '';
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}