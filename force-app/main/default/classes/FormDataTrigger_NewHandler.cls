/**
* Class FormDataTrigger_NewHandler
*
* Trigger Handler for the Contact SObject. This class implements the TriggerAbstract
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public without sharing class FormDataTrigger_NewHandler implements TriggerAbstract {
    
    static boolean stopRecurssion = false;
    static List<String> emailList = new List<String>();
    
    static Map<String,String> contactIdMap = new Map<String,String>(); 
    static Map<String,String> busContactIdMap = new Map<String,String>();
    static Map<String,String> leadIdMap = new Map<String,String>();
    Id businessrecordId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Business Relationship').getRecordTypeId();
    static Map<String,Lead> leadMapList = new Map<String,Lead>();
    
    
    static Map<string,SubscriptionManagement__c> settingMap = SubscriptionManagement__c.getAll();    
    static Set<Id> formIds = new Set<Id>();
    static Set<Id> campaignIds = new Set<Id>();
    static set<String> emailListAfter = new set<String>();   
    static Map<id,Contact> contactMap = new Map<id,Contact>(); 
    static Map<id,Lead> leadMap = new Map<id,Lead>(); 
    static Map<Id,String> statusMap = new Map<Id,String>();
    static Map<Id, Form__c> formsByIdMap = new Map<Id, Form__c>();
    static MAP<Id,String> mapLeadCampByForm = new MAP<Id,String>();
    static MAP<String,CampaignMember> mapCampMem = new MAP<String,CampaignMember>();
    static Map<Id,Campaign> lstConvCamp = new Map<Id,Campaign>();
    static List<CampaignMember> campMemUpdate = new List<CampaignMember>();
    static List<CampaignMember> campMemToUpsert = new List<CampaignMember>();
    static List<Contact> ContactToUpdate = new List<Contact>();
    static List<Lead> LeadToUpdate = new List<Lead>();
    
    // Constructor
    public FormDataTrigger_NewHandler(){}
    
    
    public void bulkBefore() {
        if(!stopRecurssion){
            for(sobject fd : trigger.new) { 
                if(((String)fd.get('Email__c') !=null && (Boolean)fd.get('Bulk_Load__c') == false && (String)fd.get('Status__c')=='Completed')){
                    emailList.add((String)fd.get('Email__c')); 
                }
            }
            
            for(Contact c:[Select Id,Email, RecordTypeId from Contact where Email in:emailList]){
                contactIdMap.put(c.Email,c.Id); 
                if(c.recordtypeid == businessrecordId){
                    busContactIdMap.put(c.Email,c.Id); 
                }
            }
            system.debug('contactIdMap: '+contactIdMap);
            system.debug('busContactIdMap: '+busContactIdMap);
            
            for(Lead ld:[Select Id,Email,Company,IsConverted from Lead where Email in:emailList]){
                leadIdMap.put(ld.Email,ld.Id); 
            }
            system.debug(leadIdMap.size());
            system.debug('leadIdMap: '+leadIdMap);
            
        }
        
    }
    
    public void bulkAfter(){ 
        for(sobject fd : trigger.new) { 
            if(((String)fd.get('Email__c') !=null && (Boolean)fd.get('Bulk_Load__c') == false && (String)fd.get('Status__c')=='Completed')){
                emailList.add((String)fd.get('Email__c')); 
            }
            
            formIds.add((String)fd.get('form__c'));
            
            if( (String)fd.get('Subscriptions__c')!=null){
                statusMap.put((String)fd.get('id'),(String)fd.get('Subscriptions__c'));
            }
            if((String)fd.get('Email__c') != NULL) {
                emailListAfter.add((String)fd.get('Email__c'));
            }
        }
        system.debug('formIds==:'+formIds);
        system.debug('statusMap==:'+statusMap);
        system.debug('emailListAfter==:'+emailListAfter);
        
        for(Contact c:[Select Id,Email, RecordTypeId from Contact where Email in:emailList]){
            contactIdMap.put(c.Email,c.Id); 
            if(c.recordtypeid == businessrecordId){
                busContactIdMap.put(c.Email,c.Id); 
            }
        }
        system.debug('contactIdMap: '+contactIdMap);
        system.debug('busContactIdMap: '+busContactIdMap);
        
        for(Lead ld:[Select Id,Email,Company,IsConverted from Lead where Email in:emailList]){
            leadIdMap.put(ld.Email,ld.Id); 
        }
        system.debug(leadIdMap.size());
        system.debug('leadIdMap: '+leadIdMap);
        
        
        
        for(form__c fm:[Select Id, Subscriptions__c, Campaign__c, Campaign__r.IsActive from form__c where Id In:formIds]){ 
            if(fm.Subscriptions__c != null){
                statusMap.put(fm.id,fm.Subscriptions__c);
            }
            if(fm.Campaign__c != NULL && fm.Campaign__r.IsActive == True) {
                mapLeadCampByForm.put(fm.Id, fm.Campaign__c);
                campaignIds.add(fm.Campaign__c);
            }
            
            formsByIdMap.put(fm.Id, fm);
        }
        system.debug('statusMap123==:'+statusMap);
        system.debug('mapLeadCampByForm:'+mapLeadCampByForm);
        system.debug('formsByIdMap: '+formsByIdMap);
        
        
        // If this a Conversion?
        // FD -> Pro.Form__c, Camp -> Conv Form :  mapConvCampByForm(FormID,Camp), Find CampMem: mapCampMem(Email+CampID,CM)
        // 
        // Is Lead Form existing CM
        // FD -> Pro.Form__c, Camp -> Lead Form : mapLeadCampByForm(FormID,Camp), Find CampMem: mapCampMem(Email+CampID,CM)
        
        if(Test.isRunningTest()){
            lstConvCamp = new Map<Id,Campaign>([select Id, Status, Conversion_Form__c from Campaign LIMIT 1]); 
        }else{
            lstConvCamp = new Map<Id,Campaign>([select Id, Status, Conversion_Form__c from Campaign where IsActive = True AND Conversion_Form__c in :formsByIdMap.keySet()]);
        }
        campaignIds.addAll(lstConvCamp.keyset());
        system.debug('lstConvCamp: '+lstConvCamp);
        system.debug('campaignIds: '+campaignIds);
        
        // Get all members from Forms submitted and Conversion Forms            
        List<CampaignMember> lstCM = [select Id, Email, CampaignId, Conversion_Form__c, Original_Form__c, Status from CampaignMember where CampaignId in :campaignIds AND Email in :emailList];
        system.debug('lstCM======>'+lstCM);
        system.debug('emailList=======>'+emailList);
        for(CampaignMember cm :lstCM) {
            String key = cm.Email.toLowerCase() + '~' + cm.CampaignId;
            mapCampMem.put(key, cm);
        }
        system.debug('mapCampMem: '+mapCampMem);
        
        
    }
    
    public void beforeInsert(SObject so){
        form_data__c newFD = (form_data__c)so;
        fromBeforeInsertUpdate(newFD);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        form_data__c newFD = (form_data__c)so;
        form_data__c oldFD = (form_data__c)oldSo;
        fromBeforeInsertUpdate(newFD);
    }
    
    public void fromBeforeInsertUpdate(form_data__c newFD){
        formDataTriggerHelper_New.beforeinsertUpdate(newFD, contactIdMap, leadIdMap);
    }
    
    public void beforeDelete(SObject so){
    }
    
    public void afterInsert(SObject so){
        form_data__c newFD = (form_data__c)so;
        fromAfterInsertUpdate(newFD);
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        form_data__c newFD = (form_data__c)so;
        fromAfterInsertUpdate(newFD);
    }
    
    public void fromAfterInsertUpdate(form_data__c newFD){
        if(newFD.Bulk_Load__c == false && newFD.Status__c =='Completed' && String.isNotBlank(newFD.Email__c)  && String.isNotBlank(newFD.Upload_Lead_Key__c) && newFD.lead__C == null){
            Lead newLead = formDataTriggerHelper_New.beforeinsertUpdateLead(newFD);
            leadMapList.put(newFD.Upload_Lead_Key__c,newLead);
        }
        
        List<CampaignMember> cm = formDataTriggerHelper_New.afterInsertUpdateCampaignMember(newFD,lstConvCamp,mapCampMem,mapLeadCampByForm,formsByIdMap);
        campMemToUpsert.addAll(cm);
        
        List<Contact> con = formDataTriggerHelper_New.afterInsertUpdateContact(newFD,statusMap,settingMap);
        ContactToUpdate.addAll(con);
        
        if(newFD.Bulk_Load__c == false && newFD.Status__c=='Completed'){
            List<Lead> ld = formDataTriggerHelper_New.afterInsertUpdateLead(newFD,statusMap,settingMap);
            LeadToUpdate.addAll(ld);
        }
    }
    
    public void afterDelete(SObject so){
    }
    
    /**
* andFinally
*
* This method is called once all records have been processed by the trigger. Use this
* method to accomplish any final operations such as creation or updates of other records.
*/
    public void andFinally(){
        if(!stopRecurssion){
            if(trigger.isAfter){
                if(trigger.isUpdate){
                    stopRecurssion = true;
                }
                
                
                if(leadMapList.size() > 0){
                    insert leadMapList.values();
                }
                
                if(campMemToUpsert.size() > 0){
                    upsert campMemToUpsert;
                }
                
                if(ContactToUpdate.size() > 0){
                    Map<Id, contact> ContactMap = new Map<Id, contact>();
                    ContactMap.putall(ContactToUpdate);
                    update ContactMap.values();
                }
                
                if(LeadToUpdate.size() > 0){
                    Map<Id, Lead> LeadMap = new Map<Id, Lead>();
                    LeadMap.putall(LeadToUpdate);
                    Update LeadMap.values();
                }
            }
        }
    }
}