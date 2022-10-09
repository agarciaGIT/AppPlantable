global class AutoConvertLeadsbatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return DataBase.getQueryLocator([SELECT Id,Lead__c,Lead__r.FirstName, Lead__r.LastName, Lead__r.Company,Lead__r.Title,Lead__r.Phone,Lead__r.Mobile_Phone__c,Lead__r.Street,Lead__r.City,Lead__r.State,Lead__r.PostalCode,Lead__r.Country, Contact__c,Email__c FROM form_data__c WHERE Lead__c != null and Lead__r.Isconverted =false  and Marketing_Cloud_Conversion__c = true]);
    }
    
    //Execute Method.
    global void execute(Database.BatchableContext BC,List<form_data__c> scopeFormData) { 
        
        list<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();
        string accountId = Default_Record_References__c.getAll().get('UNMATCHED-BUSINESS-ACCOUNT').Record_Reference_ID__c;
         Map<String,String> contactIdMap = new Map<String,String>(); 
        Id businessrecordId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Business Relationship').getRecordTypeId();
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1]; 
        Map<Id,Lead> leadMap = new Map<Id,Lead> (); 
        set<String> emailList = new set<String>(); 
        Set<ID> leadIDs = new Set<ID>();
        for(form_data__c fd : scopeFormData) { 
            if(fd.Email__c !=null){
                emailList.add(fd.Email__c); 
            }
            leadIDs.add(fd.Lead__c);
        }
        
        for(Contact c:[Select Id,Email from Contact where Email in:emailList and Email != null]){
            contactIdMap.put(c.Email,c.Id); 
        }  
        
        for(form_data__c ld : scopeFormData) { 
            if(!contactIdMap.containsKey(ld.Email__c)){
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(ld.Lead__c);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                lc.setDoNotCreateOpportunity(true); 
                lc.setAccountId(accountId); 
                leadConverts.add(lc);
                leadMap.put(ld.Lead__c,ld.Lead__r);
                system.debug('leadMap ==='+leadMap);
            } 
        } 
        system.debug('>>'+leadConverts.size());
        Map<Id,Contact> convertedConMap = new Map<Id,Contact>();
        if(!leadConverts.isEmpty()){ 
            List<Database.LeadConvertResult> lcrList = new  List<Database.LeadConvertResult>();
            lcrList = Database.convertLead(leadConverts,false);  
            for(Database.LeadConvertResult ldresult:lcrList){
                system.debug('>>'+ldresult.isSuccess()); 
                if(ldresult.isSuccess()){ 
                    Contact c= new Contact();
                    c.Id = ldresult.getContactId();
                    c.AccountId = accountId;
                    c.RecordTypeId = businessrecordId; 
                    Lead fndLead = leadMap.get(ldresult.leadid);
                    if(fndLead != NULL){
                        c.Business_Contact_First_Name__c = fndLead.FirstName;
                        c.Business_Contact_Last_Name__c = fndLead.LastName;
                        
                        c.Business_Contact_Company__c = fndLead.Company;
                        c.Business_Contact_Title__c = fndLead.Title;
                        c.Business_Contact_Phone__c = fndLead.Phone;
                        c.Business_Contact_Mobile_Phone__c = fndLead.Mobile_Phone__c;
                        c.Business_Contact_Address_1__c = fndLead.Street;
                        c.Business_Contact_City__c = fndLead.City;
                        c.Business_Contact_State__c = fndLead.State;
                        c.Business_Contact_Zip_Code__c = fndLead.PostalCode;
                        c.Business_Contact_Country__c = fndLead.Country;    
                    } 
                    convertedConMap.put(ldresult.leadid,c); 
                    system.debug('convertedConMap ==='+convertedConMap);
                }
            }
            
            //update Converted Lead Contact
            if(convertedConMap.size()>0){
                update convertedConMap.values();
                system.debug('convertedConMap ==='+convertedConMap);
            }
            
            List<form_data__c> formDataList = new List<form_data__c>();
            for(form_data__c fd:scopeFormData){ 
                if(contactIdMap.containsKey(fd.Email__c)){
                     fd.Contact__c = contactIdMap.get(fd.Email__c);
                     fd.Lead__c = null;
                     fd.Marketing_Cloud_Conversion__c = false;
                }else if(convertedConMap.containsKey(fd.Lead__c)){
                    fd.Contact__c = convertedConMap.get(fd.Lead__c).Id;
                    fd.Member_Contact__c = true;  
                } 
               formDataList.add(fd);  
            }
            
            if(formDataList.size()>0){
                update formDataList;
            }
            
            // Move Object_History__c
            if(leadIDs.size() > 0) {
            	List<Object_History__c> lstObjHist = [select Id, Lead__c, Contact__c from Object_History__c where Lead__c in :leadIDs];
                for(Object_History__c oh :lstObjHist) {
                    Contact fndCont = convertedConMap.get(oh.Lead__c);
                    if(fndCont != NULL) {
                    	oh.Contact__c = fndCont.Id;
                    }
                    
                }
            }
            
            
        }
    } 
    
    global void finish(Database.BatchableContext BC) {
        
    }
        
}