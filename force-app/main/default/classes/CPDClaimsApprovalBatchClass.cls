global class CPDClaimsApprovalBatchClass implements Database.Batchable<sObject>, Database.Stateful {
    Global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator(
            'SELECT ID,Name,Member__c,Garp_ID__c,Credits_Earned__c,CPD_Activity__c,Approved__c from CPE_Claim__c WHERE CPD_Activity__c!= null and Approved__c=false and(( Credits_Earned__c <=20 and CreatedDate != Last_N_Days:2) OR (To_Be_Approved__c=true ))');
    }
    
    global void execute(Database.BatchableContext BC, List<CPE_Claim__c> Scope){
        for(CPE_Claim__c ce:Scope){
         
             
                ce.Approved__c= True;
                
           
        }
        Update Scope;
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}