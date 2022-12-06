global class batchUpdatetransactiontoken implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c  from ChargentSFA__Transaction__c where  ChargentSFA__Tokenization__c!=null');
     }
    
    
    global void execute(Database.BatchableContext BC, List<ChargentSFA__Transaction__c> scope){
       
        for(ChargentSFA__Transaction__c objOpp : scope)
        {
            objOpp.ChargentSFA__Gateway_ID__c = '';
            objOpp.ChargentSFA__Tokenization__c = '';
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}