global class batchUpdateSmeRegistration implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Email__c, GARP_Member_ID__c from SME_Registration__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<SME_Registration__c> scope){
       String strPostFix = '@Garp.com';
        for(SME_Registration__c objOpp : scope)
        {
            objOpp.Email__c = objOpp.GARP_Member_ID__c + strPostFix;
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}