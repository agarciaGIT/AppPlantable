trigger onCaseInsert on Case (before insert, before update) {

    ID customerRecordType = RecordTypeHelper.getRecordTypeId('Case', 'Customer');

    //Create a set of Amail Addresses
    Set<String> emailAddressSet = new Set<String>();
    for(Case c: Trigger.new){
        if(c.SuppliedEmail != null){
            emailAddressSet.add(c.SuppliedEmail);
        }
    }
    
    //Create a map of Contacts by their Email Address
    Map<String, Contact> contactByEmailMap = new Map<String, Contact>();
    for(Contact c: [SELECT Id, Name, Email FROM Contact WHERE Email IN :emailAddressSet]){
        contactByEmailMap.put(c.Email, c);
    }
   
    //Create a map of Contacts by their assocatied GARP Member ID
    Map<String, Case> caseByContactGarpIdMap = new Map<String, Case>();
    for(Case c: Trigger.new){
        
        //If the case if of type "Customer"
        if(c.recordTypeId == customerRecordType){
            
            /**
             * If a Contact with the Email Address provided exists set the Case.ContactId to the Contact.Id
             * of the associated Contact provied in the the contactByEmailMap
             */
            if(c.SuppliedEmail != null && contactByEmailMap.containsKey(c.SuppliedEmail) && c.ContactId == NULL){
                
                c.ContactId = contactByEmailMap.get(c.SuppliedEmail).Id;
             
            //If the Description is search for a GARP ID
            }else if(c.Description != null && c.ContactId == NULL){
                
                String subject = c.Subject;
                String description = c.Description;        
                                
                String[] textArgsv = description.split('\n'); 
                
                if(subject != null) textArgsv.add(subject);          

                if(!textArgsv.isEmpty()) {                   
                    for(String line :textArgsv) {

                        String regexPattern = '(?ims)(GARP ID:)(\\s*)([0-9]+)';
                        
                        Matcher m = Pattern.compile(regexPattern).matcher(line);

                        if(m.find() && m.group(3) != null) {
                            String gi = m.group(3);
                            if(gi.length() > 4)
                            	caseByContactGarpIdMap.put(m.group(3), c); 
                            break;
                        }
               
                    }
                }
                               
            }
            
            if(c.Description != null && c.Description.length() > 250){
                c.Description = c.Description.substring(0, 250);
            }
            
        }
                   
    }

    Map<String, Contact> contactByGarpIdMap = new Map<String, Contact>();    
    for(Contact c: [SELECT Id, Name, Email, GARP_Member_ID__c  FROM Contact WHERE GARP_Member_ID__c IN :caseByContactGarpIdMap.keySet()]){
        contactByGarpIdMap.put(c.GARP_Member_ID__c , c);
    }

    for(Contact contact: contactByGarpIdMap.values()){

        Case c = caseByContactGarpIdMap.get(contact.GARP_Member_ID__c );
        
        c.ContactId = contact.Id;

    }
    
}