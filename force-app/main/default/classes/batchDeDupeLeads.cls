global class batchDeDupeLeads implements Database.Batchable<SObject>{

    public String mode;
    public List<Lead> delLeadList;
    public MAP<string,List<LEAD>> mapRestLeads;
	public MAP<string,LEAD> mapFirstLeads = new MAP<string,LEAD>();
    
    global batchDeDupeLeads (String modeIn){
        
        system.debug('Function: batchDeDupeLeads ');
        system.debug('mode:' + modeIn);
        
        this.mode= modeIn;        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        if(this.mode == 'batch') {
            return Database.getQueryLocator('select ID,Email from Lead where Batch_Dedupe__c = True');
        } else if(this.mode != null) {
            return Database.getQueryLocator('select ID,Email from Lead where email = :mode');            
        } else {
        	return Database.getQueryLocator('select ID,Email from Lead where Email != NULL AND IsConverted = False AND IsDeleted = False AND CreatedDate > YESTERDAY');    
        }
        
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope){
        
        System.debug('scope:' + scope);
        
        MAP<String,ID> emails = new MAP<String,ID>();
        for(LEAD l :scope) {
            emails.put(l.email, l.id);
        }
        System.debug('emails:' + emails);
        
        List<Lead> lstLead = [select id, email, Is_Test__c from Lead where Email != NULL AND IsDeleted = False 
                              AND email in :emails.keySet() Order By CreatedDate DESC];
        System.debug('lstLead:' + lstLead);
        
        mapRestLeads = new MAP<string,List<LEAD>>();
        mapFirstLeads = new MAP<string,LEAD>();
        emails = new MAP<String,ID>();
        Set<String> testLeads = new Set<String>();
        for(Lead l :lstLead) {
            
            if(l.Is_Test__c) {
                testLeads.add(l.Id);
            } else {
                emails.put(l.email, l.id);
                Lead fndFirstLeads = mapFirstLeads.get(l.email);
                List<LEAD> fndRestLeads = mapRestLeads.get(l.email);
                
                System.debug('fndFirstLeads:' + fndFirstLeads);
                System.debug('fndRestLeads:' + fndRestLeads);
                
                if(fndFirstLeads == NULL) {
                    mapFirstLeads.put(l.email,l);
                    System.debug('Add first:' + l);
                    
                } else {
                    if(fndRestLeads == NULL) {
                        fndRestLeads = new List<LEAD>();
                        fndRestLeads.add(l);
                        mapRestLeads.put(l.email, fndRestLeads);
                        System.debug('New Rest first:' + fndRestLeads);
                        
                    } else {
                        fndRestLeads.add(l);
                        mapRestLeads.put(l.email, fndRestLeads);
                        System.debug('Add Rest:' + fndRestLeads);
                    }
                }
                
            }

        }
        
        System.debug('mapFirstLeads:' + mapFirstLeads);
        System.debug('mapRestLeads:' + mapRestLeads);
        System.debug('testLeads:' + testLeads);
        
        for(Lead l :mapFirstLeads.values()) {
            
            System.debug('merge L:' + l);
            
            List<LEAD> fndRestLeads = mapRestLeads.get(l.email);
            System.debug('fndRestLeads:' + fndRestLeads);
            
            if(fndRestLeads != NULL) {
                Database.MergeResult[] results = Database.merge(l, fndRestLeads, false);
                System.debug('merge results:' + results);   
            }
        }

        List<Contact> lstCont = [select id, email from Contact where Email != NULL AND IsDeleted = False AND email in :emails.keySet()];
        System.debug('lstCont:' + lstCont);
        
        Set<ID> delLeads = new Set<ID>();
        Set<String> delLeadsContactIds = new Set<String>();
        MAP<String,String> mapContEmail = new MAP<String,String>();
        for(Contact c :lstCont) {
            
            System.debug('c:' + c);
            mapContEmail.put(c.email, c.id);
            
            Lead fndLead = mapFirstLeads.get(c.email);
            System.debug('fndLead:' + fndLead);
            
            if(fndLead != NULL) {
                delLeads.add(fndLead.Id);
                System.debug('Add delLeads:' + delLeads);
                delLeadsContactIds.add(c.id);
            }
        }
        System.debug('mapContEmail:' + mapContEmail);
        
        // Move Form Data to Contact
        list<Form_Data__c> lstFD = [select Id, Email__c, Contact__c, Lead__c, Lead__r.Email from Form_Data__c where Lead__c in :delLeads];
        System.debug('lstFD:' + lstFD);
        for(Form_Data__c fd :lstFD) {
            String contID = mapContEmail.get(fd.Lead__r.Email);
            System.debug('contID:' + contID);
            
            if(contID != NULL) {
                fd.Contact__c = contID;
            }
        }
        System.debug('update lstFD:' + lstFD);
        update lstFD;
        
        if(!testLeads.isempty()) {
            list<Form_Data__c> lstFDDel = [select Id, Email__c, Contact__c, Lead__c, Lead__r.Email from Form_Data__c where Lead__c in :testLeads];
            System.debug('lstFDDel:' + lstFDDel);
            delete lstFDDel;
            
            for(String l :testLeads) {
                delLeads.add(l);
            }
        }
        
        
        System.debug('delLeads:' + delLeads);
        delLeadList = [select id, email from Lead where id in :delLeads];
        delete delLeadList;

        // Touch contacts to sync with HubSpot
        list<Contact> lstContTouch = [select Id, Name from Contact where Id in :delLeadsContactIds];
        System.debug('lstContTouch:' + lstContTouch);
        update lstContTouch;
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String receipientList = 'alberto.garcia@garp.com'; //system.label.Exception_Recipient_List;
        List<String> toAddresses = new list<string>();
        toAddresses.addall(receipientList.split(','));
        message.setToAddresses(toAddresses);
        message.setSubject('Merge Leads');
        
        String messageBody = 'Deletes:\n';
        
        for(Lead l :delLeadList) {
            messageBody = messageBody + l.id + '~' + l.email + '\n';
        }
        
        messageBody = messageBody + '\n\n' + 'Merge First:\n' + mapFirstLeads + '\n\nMerge Rest:';
        
        for(String em :mapRestLeads.keySet()) {
            List<LEAD> fndLead = mapRestLeads.get(em);
            for(LEAD l :fndLead) {
                messageBody = messageBody + l.id + '~' + l.email + '\n';
            }
            messageBody = messageBody + '\n';
        }
        
        message.setPlainTextBody(messageBody);
        mails.add(message);
        system.debug('message ==='+message);
        
        if(!Test.isRunningTest() && (!delLeadList.isEmpty() || !mapRestLeads.isEmpty())) {
            Messaging.sendEmail(mails);
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
                
    }
}