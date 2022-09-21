public class SMSSupportAppController {    
    
    @auraEnabled public List<Contact> lstContactData {get;set;}
    @auraEnabled public Contact selectedContact {get;set;}
    
    @auraEnabled public List<Case> lstCaseData {get;set;}
    @auraEnabled public List<SMS_Message__c> lstMsgData {get;set;}
    @auraEnabled public Case currentCase {get;set;}    
    @auraEnabled public Boolean newMsgs {get;set;} 
    @auraEnabled public String sessionId {get;set;} 
    @auraEnabled public String statusMsg {get;set;}
    @auraEnabled public String caseFilter {get;set;}
    @auraEnabled public MAP<String,String> caseOwners {get;set;}
    
    @AuraEnabled
    public static List<Case> getCases(SMSSupportAppController obj) {
        List<Case> lstCaseData;
        lstCaseData = [Select Id, CaseNumber, Subject, Status, DateTimeOpen__c, CreatedDate, Last_SMS_Received_Date_Time__c, Last_SMS_Viewed_Date_Time__c, SMS_New_Msg__c, Contact_Name__c, OwnerId, Owner_Name__c from Case where Last_SMS_Received_Date_Time__c != NULL and Status in ('New','In Progress') order by CreatedDate DESC];            

        List<Case> lstCaseDataOther;
        lstCaseDataOther = [Select Id, CaseNumber, Subject, Status, DateTimeOpen__c, CreatedDate, Last_SMS_Received_Date_Time__c, Last_SMS_Viewed_Date_Time__c, SMS_New_Msg__c, Contact_Name__c, OwnerId, Owner_Name__c from Case where Last_SMS_Received_Date_Time__c != NULL and Status in ('Closed') order by Status DESC, CreatedDate DESC LIMIT 20];            
        for(Case c :lstCaseDataOther) {
            lstCaseData.add(c);
        }

        return lstCaseData;
    }


    @AuraEnabled
    public static List<Contact> getContacts(SMSSupportAppController obj, String filter) {
        List<Contact> lstContactData;
        String likeFilter = '%' + filter + '%';
        lstContactData = [Select Id, Name, Phone, MobilePhone from Contact where Name LIKE :likeFilter];
        return lstContactData;
    }
    
    @AuraEnabled
    public static MAP<String,String> getCaseOwners(SMSSupportAppController obj) {
        MAP<String,String> mapCaseOwners = new MAP<String,String>();
        if(obj != NULL && obj.lstCaseData != NULL) {
            mapCaseOwners.put('All','All');
            for(Case c :obj.lstCaseData) {
                mapCaseOwners.put(c.OwnerId,c.Owner_Name__c);
            }
        }
        return mapCaseOwners;
    }
    
    
    @AuraEnabled
    public static SMSSupportAppController initClass() {
        
        SMSSupportAppController obj = new SMSSupportAppController();
        obj.lstCaseData = new List<Case>();
        obj.lstMsgData = new List<SMS_Message__c>();
        obj.sessionId = UserInfo.getSessionId();
        obj.lstCaseData = getCases(obj);            
        obj.caseOwners = getCaseOwners(obj);
        obj.lstContactData = new List<Contact>();
        
        return obj;
    }    

    @AuraEnabled
    public static SMSSupportAppController findContact(String sObj, String filter) {
        SMSSupportAppController obj = (SMSSupportAppController)JSON.deserialize(sObj, SMSSupportAppController.class); 
        System.debug('obj:' + obj);
        obj.lstContactData = getContacts(obj, filter);
        
        return obj;
    }

    
    @AuraEnabled
    public static SMSSupportAppController closeCase(String sObj) {
        
        SMSSupportAppController obj = (SMSSupportAppController)JSON.deserialize(sObj, SMSSupportAppController.class); 
        System.debug('obj:' + obj);
        
        if(obj.currentCase != null) {
            List<Case> lstCC = [Select Id, Subject, CreatedDate, DateTimeOpen__c, Last_SMS_Received_Date_Time__c, Contact_Name__c from Case where Id = :obj.currentCase.Id]; 
            if(lstCC != NULL && lstCC.size() > 0) {
                lstCC[0].Status = 'Closed';
                Update lstCC;
                
                obj.lstCaseData = getCases(obj);

            } else {
                obj.statusMsg = 'Error Closing case';
            }
            
        } else {
            obj.statusMsg = 'Case not found';
        }
        
        return obj;
    }    
    
    
    @AuraEnabled
    public static SMSSupportAppController refreshCaseData(String sObj) {
        
        System.debug('sObj:' + sObj);
        
        SMSSupportAppController obj = (SMSSupportAppController)JSON.deserialize(sObj, SMSSupportAppController.class); 
        System.debug('obj:' + obj);
        
        obj.lstCaseData = getCases(obj);            
        
        return obj;
    }    


    @AuraEnabled
    public static SMSSupportAppController smsLogin(String appPassword, String sObj) {
        
        SMSSupportAppController obj = (SMSSupportAppController)JSON.deserialize(sObj, SMSSupportAppController.class); 
        System.debug('obj:' + obj);
                
        obj.lstCaseData = getCases(obj);

        return obj;
    }    
    
    @AuraEnabled
    public static SMSSupportAppController selectContact(String contactId, String sObj) {
        System.debug('sObj selectContact:' + sObj);
        
        SMSSupportAppController obj = (SMSSupportAppController)JSON.deserialize(sObj, SMSSupportAppController.class); 
        System.debug('obj:' + obj);

        obj.lstMsgData = [Select Id, Contact__c, CreatedDate, Date_Time__c, From__c, Match_Phone__c, Message__c from SMS_Message__c where Contact__c != NULL AND Contact__c = :contactId order by CreatedDate DESC];
        obj.selectedContact = [Select Id, Name, Phone, MobilePhone from Contact where id = :contactId];
        obj.currentCase=NULL;
            
        return obj;
    }


    @AuraEnabled
    public static SMSSupportAppController selectCase(String caseId, String sObj) {
        System.debug('sObj selectCase:' + sObj);
        
        SMSSupportAppController obj = (SMSSupportAppController)JSON.deserialize(sObj, SMSSupportAppController.class); 
        System.debug('obj:' + obj);
        
        List<Case> lstCase = [Select Id, CaseNumber, ContactId, Subject, Contact_Name__c, CreatedDate, DateTimeOpen__c, Last_SMS_Received_Date_Time__c, Last_SMS_Viewed_Date_Time__c from Case where ID = :caseId];
        if(lstCase != NULL && lstCase.size() > 0) {
            obj.currentCase = lstCase[0];
            lstCase[0].Last_SMS_Viewed_Date_Time__c = DateTime.now();
            update lstCase;
        }
        obj.lstMsgData = [Select Id, Contact__c, CreatedDate, Date_Time__c, From__c, Match_Phone__c, Message__c from SMS_Message__c where Contact__c != NULL AND Contact__c = :obj.currentCase.ContactId order by CreatedDate DESC];
        obj.selectedContact=NULL;
        //obj.lstCaseData = [Select Id, CaseNumber, Subject, DateTimeOpen__c, Last_SMS_Received_Date_Time__c, Contact.Name, OwnerId, Owner.Name from Case where Last_SMS_Received_Date_Time__c != NULL AND Status <> 'Closed' order by CreatedDate DESC];            
        
        return obj;
    }

    @AuraEnabled
    public static SMSSupportAppController checkForNewMSG(String sObj) {
        SMSSupportAppController obj = (SMSSupportAppController)JSON.deserialize(sObj, SMSSupportAppController.class); 
        System.debug('obj:' + obj);
        
        obj.lstCaseData = getCases(obj);


        if(obj.currentCase != NULL && obj.currentCase.Id != NULL) {        
            obj.lstMsgData = [Select Id, Contact__c, CreatedDate, Date_Time__c, From__c, Match_Phone__c, Message__c from SMS_Message__c where Contact__c != NULL AND Contact__c = :obj.currentCase.ContactId order by CreatedDate DESC];
        } else if(obj.selectedContact != null) {        
            obj.lstMsgData = [Select Id, Contact__c, CreatedDate, Date_Time__c, From__c, Match_Phone__c, Message__c from SMS_Message__c where Contact__c = :obj.selectedContact.Id order by CreatedDate DESC];
        }        

        
        return obj;
    }
    
    
    @AuraEnabled
    public static SMSSupportAppController sendSMS(String msg, String sObj) {
        
        SMSSupportAppController obj = (SMSSupportAppController)JSON.deserialize(sObj, SMSSupportAppController.class); 
        System.debug('obj:' + obj);
        System.debug('msg:' + msg);
        
        if(obj.currentCase != null) {
            SMS_Message__c newMsg = new SMS_Message__c();
            newMsg.Name = 'New Msg';
            newMsg.Case__c = obj.currentCase.Id;
            newMsg.Message__c = msg;
            newMsg.Contact__c = obj.currentCase.ContactId;
            newMsg.Enable_Automation__c = True;
            insert newMsg;
            
            RESTSMSController.processSMS(newMsg.Id);
            
            obj.lstMsgData = [Select Id, Contact__c, CreatedDate, Date_Time__c, From__c, Match_Phone__c, Message__c from SMS_Message__c where Contact__c != NULL AND Contact__c = :obj.currentCase.ContactId order by CreatedDate DESC];
        } else if(obj.selectedContact != null) {
            
            SMS_Message__c newMsg = new SMS_Message__c();
            newMsg.Name = 'New Msg';
            newMsg.Case__c = NULL;
            newMsg.Message__c = msg;
            newMsg.Contact__c = obj.selectedContact.Id;
            newMsg.Enable_Automation__c = True;
            insert newMsg;
            
            RESTSMSController.processSMS(newMsg.Id);
            
            obj.lstMsgData = [Select Id, Contact__c, CreatedDate, Date_Time__c, From__c, Match_Phone__c, Message__c from SMS_Message__c where Contact__c = :obj.selectedContact.Id order by CreatedDate DESC];
            
        }
       
        return obj;
    }    
    
    public static void publishNewSMSNotifications(List<SMS_Message__c> msgs) {
        
        List<New_SMS_Message__e> notifications = new List<New_SMS_Message__e>();
        for (SMS_Message__c m: msgs) {
            notifications.add(new New_SMS_Message__e(
                Case_ID__c = (String)m.Case__c,
                Message_ID__c = (String)m.Id
            ));
        }
        System.debug('notifications:' + notifications);

        List<Database.SaveResult> results = EventBus.publish(notifications);

        System.debug('results:' + results);
        
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                for (Database.Error error : result.getErrors()) {
                    System.debug('Error returned: ' +
                        error.getStatusCode() +' - '+
                        error.getMessage());
                }
            }
        }
    }
    
    
}