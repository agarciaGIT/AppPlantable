global class batchUpdateIntegrationDataemail implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
         return Database.getQueryLocator('select id,Email__c from Integration_Data__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Integration_Data__c> scope){
       
        for(Integration_Data__c objOpp : scope)
        {
            objOpp.Email__c = '';
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}