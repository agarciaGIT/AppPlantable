global class batchUpdateAccountEmailAddress implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
       String test = '%@Garp.com';
    global Database.QueryLocator start(Database.BatchableContext BC){
      String query1 = 'select id, Member_Email__c, GARP_ID__c from account where';
               
        query1 +=' (NOT Member_Email__c  like  \''+test+'\')';
        return Database.getQueryLocator(query1);
     }
    
    
    global void execute(Database.BatchableContext BC, List<account> scope){
        String strPostFix = '@Garp.com';
        for(account ct : scope)
        {
            ct.Member_Email__c = ct.GARP_ID__c + strPostFix;
            
        }
        
       if(!scope.isEmpty())
            update scope;
       
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}