global class batchUpdatecontractEmailAddress implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, Member_Email__c, GARP_ID__c from contract');
     }
    
    
    global void execute(Database.BatchableContext BC, List<contract> scope){
        String strPostFix = '@Garp.com';
        for(contract ct : scope)
        {
            ct.Member_Email__c = ct.GARP_ID__c + strPostFix;
            
        }
        
       if(!scope.isEmpty())
            update scope;
       
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}