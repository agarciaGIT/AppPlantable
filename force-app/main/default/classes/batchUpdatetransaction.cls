global class batchUpdatetransaction implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
   
        return Database.getQueryLocator('select id, ChargentSFA__Credit_Card_Number__c, ChargentSFA__Tokenization__c  from ChargentSFA__Transaction__c ');
     }
    
    
    global void execute(Database.BatchableContext BC, List<ChargentSFA__Transaction__c> scope){
       
        for(ChargentSFA__Transaction__c objOpp : scope)
        {
            objOpp.ChargentSFA__Credit_Card_Number__c = '';
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}