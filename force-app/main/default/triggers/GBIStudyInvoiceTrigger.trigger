trigger GBIStudyInvoiceTrigger on Study_Disclose_Protocol_Submission__c (after insert,After Update) {
    
    Study_Disclose_Protocol_Submission__c cs = Trigger.New[0];
    
    //  for(Study_Disclose_Protocol_Submission__c cs:Trigger.New){
     
         // if (Trigger.oldMap.get(cs.Id).Disclosure_Protocol__c != Trigger.newMap.get(cs.Id).Disclosure_Protocol__c && (cs.Disclosure_Protocol__c != Null    && cs.Disclosure_Protocol__r.DP_Status__c=='Active')) {
                GBIStudyInvoicesClass.Save(cs.Id);
           // }
      
       // if (cs.Disclosure_Protocol__c != Null    && cs.Disclosure_Protocol__r.DP_Status__c=='Active'){
            
           // GBIStudyInvoicesClass.Save(cs.Id);
            
       // }
        
    //}
    
    
}