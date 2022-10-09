global class batchJobActivateStudyContacts implements Database.Batchable<sObject>,Database.StateFul{
      
    public String mode;  
    public String studyId;  
    public String testId;
    
    global batchJobActivateStudyContacts (String mode, String studyId, String testId){
        this.mode = mode;
        this.studyId = studyId;
        this.testId = testId;
        
        system.debug('batchJobActivateProctorRegistrations:' + studyId + ':' + mode + ':' + testId);
    }
     
   global Database.QueryLocator start(Database.BatchableContext BC){         
       String statusActive = 'Active';
       String studyStatus = 'In Progress';
       if(mode == null) {
           if(testId != null)
               return Database.getQueryLocator('select Id, Name, Contact__c, Study_Contact_Email__c, Role__c, Study__c, Study_Account__r.Account__c from Study_Contact__c where Study__c = :studyId and Status__c = :statusActive and ID = :testId order by Study_Contact_Email__c');    
           else return Database.getQueryLocator('select Id, Name, Contact__c, Study_Contact_Email__c, Role__c, Study__c, Study_Account__r.Account__c from Study_Contact__c where Study__c = :studyId and Status__c = :statusActive order by Study_Contact_Email__c');    
       } else if(mode == 'all') {
			return Database.getQueryLocator('select Id, Name, Contact__c, Study_Contact_Email__c, Role__c, Study__c, Study_Account__r.Account__c from Study_Contact__c where Study__r.Status__c = :studyStatus and Status__c = :statusActive order by Study_Contact_Email__c');
       }
       return null;
   }

   global void execute(Database.BatchableContext BC, List<Study_Contact__c> scope){
       
       ActivateStudyContactsService.activateStudyContacts(scope);
       
   }
    
    
   global void finish(Database.BatchableContext BC){
   
   }
}