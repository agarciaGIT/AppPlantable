global class getEmailDuplicateLeads implements Database.Batchable<sObject>, Database.Stateful {
    
    
    List<lead> duplicateLeads = new List<lead>();
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        return Database.getQueryLocator('SELECT Id, Email FROM Lead WHERE Email !=null And IsConverted = false Order By Email');
        
    }
    global void execute(Database.BatchableContext bc, List<Lead> scopeLeads){ 
        if(scopeLeads.size()>0){
            Map<String,List<Lead>> emailLeadMap= new Map<String,List<Lead>>();
            for(Lead ld:scopeLeads){
                if(emailLeadMap.containsKey(ld.Email)) {
                    List<Lead> leadId = emailLeadMap.get(ld.Email);
                    leadId.add(ld);
                    emailLeadMap.put(ld.Email, leadId);
                } else {
                    emailLeadMap.put(ld.Email, new List<Lead> {ld});
                }
            }
            
           for(String key:emailLeadMap.keyset()){
               if(emailLeadMap.get(key).size()> 1){
                   duplicateLeads.addAll(emailLeadMap.get(key)); 
               }
           }
        }
    }
    global void finish(Database.BatchableContext bc){
      
       
       
        if(duplicateLeads.size()>0){ 
            // CSV file Creation
            String finalstr = 'Id, Email \n';
            String subject = 'Lead - Duplicage Leads';
            String attName = 'Lead.csv';
            String body = 'Duplicate Leads';
            String toAddress = UserInfo.getUserEmail();
            for(Lead ld  : duplicateLeads){ 
                string recordString = '"'+ld.id+'","'+ld.Email+'"\n';
                finalstr = finalstr +recordString;
            } 
            
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            
            // attachment creation for email   
            Messaging.EmailFileAttachment    efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            
            // parameter setting for email
            email.setSubject( subject );
            email.setToAddresses( new String[] {toAddress} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
            //email sending
            Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        } 
    } 
}