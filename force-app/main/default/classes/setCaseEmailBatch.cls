global class setCaseEmailBatch implements Database.Batchable<sObject>{

 /* id caseRecordType = RecordTypeHelper.GetRecordTypeId('case','customer');
  
    global Database.QueryLocator start(Database.BatchableContext bc){
       return Database.getQueryLocator([SELECT Id, status, RecordTypeId, (Select Id, Status from emailmessages where status = '3') FROM Case WHERE status= 'closed' and recordtypeid =:caseRecordType and id = '50040000010hpTk']); */
       
      global Database.QueryLocator start(Database.BatchableContext bc){
       return Database.getQueryLocator([SELECT Id, status, RecordTypeId, (Select Id, Status from emailmessages where status = '3') FROM Case WHERE status= 'closed' and recordtypeid ='012400000005iFW']); 
        
    }
    
    global void execute(Database.BatchableContext bc, List<case> scope){
        Set<Id> caseIds = new Set<Id>();
        List<Case> caseListToUpdate = new List<Case> ();
        for(Case c: scope){
        
         if(!c.EmailMessages.isEmpty()){
                
                c.No_of_Emails_Sent__c = c.EmailMessages.size();
                caseListToUpdate.add(c);
            }
            }
            
         if(caseListToUpdate.size()>0){
          update caseListToUpdate;
      }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}