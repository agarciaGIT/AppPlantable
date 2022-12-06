global class batchUpdateCandidateRequirement implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Candidate_Email__c,Email_GARP_Member__c,Supervisor_Email__c from Candidate_Requirement__c where Supervisor_Email__c!=null');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Candidate_Requirement__c> scope){
       
        for(Candidate_Requirement__c objOpp : scope)
        {
            objOpp.Candidate_Email__c = '';
            objOpp.Email_GARP_Member__c ='';
            objOpp.Supervisor_Email__c ='';
           
            
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}