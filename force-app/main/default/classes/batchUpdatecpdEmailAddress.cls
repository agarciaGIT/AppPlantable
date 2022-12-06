global class batchUpdatecpdEmailAddress implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    String test = '%@Garp.com';
    global Database.QueryLocator start(Database.BatchableContext BC){
    
    
    String query1 = 'select id, GARP_ID__c,Contact_Email__c from CPE_Claim__c where';
               
        query1 +=' (NOT Contact_Email__c  like  \''+test+'\')';
        return Database.getQueryLocator(query1);
        
     }
    
    
    global void execute(Database.BatchableContext BC, List<CPE_Claim__c> scope){
        String strPostFix = '@Garp.com';
        for(CPE_Claim__c ct : scope)
        {
            ct.Contact_Email__c = ct.GARP_ID__c + strPostFix;
            
        }
        
       if(!scope.isEmpty())
            update scope;
       
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}