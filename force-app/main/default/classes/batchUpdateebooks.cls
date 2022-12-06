global class batchUpdateebooks implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Member_EMail__c from eBook_Key__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<eBook_Key__c> scope){
       
        for(eBook_Key__c objOpp : scope)
        {
            objOpp.Member_EMail__c = '';
           
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}