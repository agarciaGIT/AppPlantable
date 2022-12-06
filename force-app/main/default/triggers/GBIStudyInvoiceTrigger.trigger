trigger GBIStudyInvoiceTrigger on Study_Disclose_Protocol_Submission__c (after insert) {
   
   //List<Study_Disclose_Protocol_Submission__c> cs = New List <Study_Disclose_Protocol_Submission__c>();
      
    System.enqueueJob(new GBIStudyInvoicesClass(Trigger.New));
}