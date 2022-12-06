global class batchUpdateeventregistration implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Alternate_Email_Address__c, Member_Email__c  from Event_Registration__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Event_Registration__c> scope){
       
        for(Event_Registration__c objOpp : scope)
        {
            objOpp.Alternate_Email_Address__c = '';
            objOpp.Member_Email__c = '';
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}