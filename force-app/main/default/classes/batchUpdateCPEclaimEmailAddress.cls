global class batchUpdateCPEclaimEmailAddress implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    String test = '%@Garp.com';
    global Database.QueryLocator start(Database.BatchableContext BC){
    
    String query1 = 'select id, Contact_Email__c from CPE_Claim__c where Contact_Email__c !=null';
               
       
        return Database.getQueryLocator(query1);
     }
    
    
    global void execute(Database.BatchableContext BC, List< CPE_Claim__c > scope){
        String strPostFix = '@Garp.com';
        for(CPE_Claim__c ct : scope)
        {
            ct.Contact_Email__c = '';
            
        }
        
       if(!scope.isEmpty())
            update scope;
       
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}