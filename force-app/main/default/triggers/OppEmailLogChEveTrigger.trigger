trigger OppEmailLogChEveTrigger on OpportunityChangeEvent (after insert) {
    
    //canDoUpdate -  it gives the status of update  
    static boolean canDoUpdate;
    //RC_fields -  Set of Rule Criteria Field names
    Set<String> RC_fields= new Set<String> {'Account.RecordTypeId','Attending_Exam_Registration_Name__c',
        'Auto_Renew__c','Billing_mail__c','Email_URL__c','Email_WebSite_URL__c','Event_Order__c',
        'Exam_Registration_Modiication__c','Frm1__c','Frm2__c','Has_Books__c','Invoice_Paid_status__c',
        'Is_Exam_Canceled__c','Membership_Emails__c','Alternate_Method_of_Payment__c','Name','RecordType',
        'Payent_Method_New__c','Payment_Method__c','ChargentSFA__Payment_Status__c','Previous_Memership__c',
        'Risk_net__c','Ship_Check__c','StageName','Type','Yardstick_Welcome_Email_SentDate__c'};
            
	Set<String> oppIds = new Set<String>();
    
    for (OpportunityChangeEvent change : Trigger.new) {
        // Get all Record Ids for this change and add to the set
        List<String> recordIds = change.ChangeEventHeader.getRecordIds();
        oppIds.addAll(recordIds);
    }
    
    // Iterate through each event message.
    for (OpportunityChangeEvent event : Trigger.New) {
        
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        System.debug('Received change event for ' + header.entityName +' for the ' + header.changeType + ' operation.');         

        	if (header.changetype == 'UPDATE') {
            	canDoUpdate = false;
            
                for (String field : header.changedFields) {
                System.debug('field::'+field);
                if(event.get(field) != null && RC_fields.contains(field))
                {
                    canDoUpdate = true;  
                    break;
                }
            }
                
            if (canDoUpdate == true)
            {   
                Email_Log_ID_Carry__e OppLog = new Email_Log_ID_Carry__e(); 
                OppLog.Oppid__c = [SELECT id FROM Opportunity WHERE Id IN :oppIds].id;
                Eventbus.publish(OppLog); 
            }
        }       
    }
}