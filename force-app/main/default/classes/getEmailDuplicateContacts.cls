global class getEmailDuplicateContacts implements Database.Batchable<sObject>, Database.Stateful {
    
    
    List<Contact> duplicateContacts = new List<Contact>();
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        return Database.getQueryLocator('SELECT Id, Email FROM Contact WHERE Email !=null Order By Email');
        
    }
    global void execute(Database.BatchableContext bc, List<Contact> scopeContacts){ 
        if(scopeContacts.size()>0){
            Map<String,List<Contact>> emailContactMap= new Map<String,List<Contact>>();
            for(Contact con:scopeContacts){
                if(emailContactMap.containsKey(con.Email)) {
                    List<Contact> ContactId = emailContactMap.get(con.Email);
                    ContactId.add(con);
                    emailContactMap.put(con.Email, ContactId);
                } else {
                    emailContactMap.put(con.Email, new List<Contact> {con});
                }
            }
            
           for(String key:emailContactMap.keyset()){
               if(emailContactMap.get(key).size()> 1){
                   duplicateContacts.addAll(emailContactMap.get(key)); 
               }
           }
        }
    }
    global void finish(Database.BatchableContext bc){
      
       
       
        if(duplicateContacts.size()>0){ 
            // CSV file Creation
            String finalstr = 'Id, Email \n';
            String subject = 'Contact - Duplicage Contacts';
            String attName = 'Contact.csv';
            String body = 'Duplicate Contacts';
            String toAddress = UserInfo.getUserEmail();
            for(Contact con  : duplicateContacts){ 
                string recordString = '"'+con.id+'","'+con.Email+'"\n';
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