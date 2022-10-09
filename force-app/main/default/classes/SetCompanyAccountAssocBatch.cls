global class SetCompanyAccountAssocBatch implements Database.Batchable<sObject>{

    public String mode;  
    
	global SetCompanyAccountAssocBatch(String mode){
        this.mode= mode;        
    }    
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query;
        if(mode == 'frm')
        	query = 'SELECT Id, RecordTypeId, Company_Clean_Name__c, Company_Association_Processed__c FROM Contact WHERE KPI_FRM_Certified__c = true and Company_Association_Processed__c = false AND RecordTypeId = \'' + RecordTypeHelper.GetRecordTypeId('Contact', 'Member') + '\'';
        else if(mode == 'delete')
        	query = 'SELECT Id, RecordTypeId, Company_Clean_Name__c, Company_Association_Processed__c FROM Contact WHERE Company_Association_Processed__c = true';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> contacts){
        if(this.mode == 'delete') {
            List<Contact> lstContact = new List<Contact>();
            for(Contact c: contacts){
                c.Company_Association_Processed__c = false;
                lstContact.add(c);
            }
            update lstContact;
        } else {
            Set<Id> contactIds = new Set<Id>();
            for(Contact c: contacts){
                if(c.Company_Clean_Name__c != null){
                    contactIds.add(c.Id);
                }
            }
            SetCompanyAccountAssocUtil.updateInsertContactCompanyAccount(contactIds);            
        }
       
    }
    
    global void finish(Database.BatchableContext bc){
        //new EmailMessageUtil(new List<String>{'david.lappert@garp.com'}).sendBatchFinishedNotification(bc);
    }
    
}