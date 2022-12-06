global class batchUpdateWebcastRegistration implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Email__c from Webcast_Registration__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Webcast_Registration__c> scope){
       
        for(Webcast_Registration__c objOpp : scope)
        {
            objOpp.Email__c = '';
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}