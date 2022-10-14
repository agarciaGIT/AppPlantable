public with sharing class DashboardController {
    
    @AuraEnabled(cacheable=true)
    public static User getUserDetails(){
        User userObj = [SELECT Id,Name,Contact.FirstName,Contact.LastName,Contact.GARP_Member_ID__c,
                        Contact.KPI_FRM_Certified__c,Contact.KPI_ERP_Certified__c FROM User WHERE Id=:UserInfo.getUserId()];

        return userObj;
    }

    @AuraEnabled(cacheable=true)
    public static string getImageUrl(){
        String imageUrl = '/resource/1659519089000/sfdcApp/img/user.png';
        User userObj = [SELECT Id,ContactId FROM User WHERE Id=:UserInfo.getUserId()];
        
        if(userObj.ContactId!=null){
            String contactId = userObj.ContactId;
            User_Photo__c userPhotoObj = new User_Photo__c();
            try{
                userPhotoObj = [SELECT Id,Contact__c FROM User_Photo__c WHERE Contact__c=:contactId];
                if(userPhotoObj.Id!=null){
                    Attachment attachmentObj = new Attachment();
                    attachmentObj = [SELECT Id,Name,ContentType 
                                    FROM Attachment WHERE parentid=:userPhotoObj.Id 
                                    AND ContentType in ('image/png', 'image/jpeg', 'image/gif')];
                    if(attachmentObj.Id!=null){
                        return '/servlet/servlet.FileDownload?file='+attachmentObj.id;
                    }
                }
            }catch(Exception ex){
                system.debug('exception in getImageUrl Method'+ex.getMessage());
                return imageUrl;
            }
        }
        return imageUrl;
    }

    @AuraEnabled(cacheable=true)
    public static Contact getMembershipDetails(){
        User userObj = [SELECT Id,ContactId FROM User WHERE Id=:UserInfo.getUserId()];
        Contact conObj = new Contact();
        
        if(userObj.ContactId!=null){
            String contactId = userObj.ContactId;
            try{
                conObj = [SELECT Id,Membership_Type__c,Date_Joined_view__c,GARP_Member_ID__c,
                        KPI_Membership_Expiration_Date__c,KPI_Membership_Payment_Status__c,
                        KPI_Primary_Chapter_Name__c,KPI_Secondary_Chapter_Name__c,
                        GBI_Analytics_Participant__c
                        FROM Contact WHERE Id=:contactId];
                
                return  conObj;      
            }catch(Exception ex){
                system.debug('exception in getMembershipDetails Method'+ex.getMessage());
                return conObj;
            }
        }
        return conObj;
    } 

    @AuraEnabled(cacheable=true)
    public static List<Participant> getParticipantInformation(){
        Set<ID> allStudies = new Set<ID>();
        
        List<Study__c> lstStudy = GBI_BC_Studies.getAllActiveStudies();        
        for(Study__c study :lstStudy) {
            allStudies.add(study.Id);
        }                            
        
        List<Participant> participantList = new List<Participant>();
        // Study Account from all studies
        List<Study_Account__c> lstStudyAccounts = new List<Study_Account__c>();
        lstStudyAccounts = [SELECT Id,Name,Account__c,Account__r.Firm_Type__c,Account__r.Name,Account__r.GBI_Country_Code__c,Account__r.GBI_Region__c,
                                                    Account__r.Number_of_Studies__c FROM Study_Account__c 
                                                    WHERE (Status__c = 'Active' OR Status__c = 'Confirmed')
                                                    AND Study__c in :allStudies];   
        
        if(lstStudyAccounts.size()>0){
            for(Study_Account__c studyObj : lstStudyAccounts){
                Participant participantObj = new Participant();
                participantObj.firmType = studyObj.Account__r.Firm_Type__c;
                participantObj.accountName = studyObj.Account__r.Name;
                participantObj.accountNameUrl = '/'+studyObj.Account__c;
                participantObj.region = studyObj.Account__r.GBI_Region__c;
                participantObj.country = studyObj.Account__r.GBI_Country_Code__c;
                participantObj.studies = studyObj.Account__r.Number_of_Studies__c;
                participantList.add(participantObj);
            }
        }
        return participantList;
    }

    @AuraEnabled
    public static Boolean sendSupportEmail(String subject, String description, Boolean isPillar3){
        
        String userId = UserInfo.getUserId();
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            
            List<Contact> lstContact = [SELECT Id, Name, Email, Phone FROM Contact WHERE Id = :contactId];
            
            if( lstContact != null && lstContact.size() > 0 ) {
                
                List<Messaging.SingleEmailMessage> lstMail=new List<Messaging.SingleEmailMessage>();
                List<OrgWideEmailAddress> lstEmailAddress = new List<OrgWideEmailAddress>();
                // Query from Organization-Wide Email Address       
                if(isPillar3)
                    lstEmailAddress=[select Id, Address from OrgWideEmailAddress WHERE Address='karan.sharma@garp.com'];
                else
                    lstEmailAddress=[select Id, Address from OrgWideEmailAddress WHERE Address='gbi@garp.com'];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();   
                String[] toAddresses = new String[] {lstEmailAddress[0].Address}; 
                mail.setToAddresses(toAddresses); 
                // Set Organization-Wide Email Address Id
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
                mail.setSubject(isPillar3 ? 'GBI Pillar 3 Support Request' : 'GBI Support Request'); 
                mail.setBccSender(false); 
                mail.setUseSignature(false); 
                mail.setHtmlBody('Name: '+lstContact[0].Name+'<br>Email: '+lstContact[0].Email+'<br>Phone: '+lstContact[0].Phone+'<br><br>Subject: '+subject+'<br><br>Description: '+description);
                lstMail.add(mail);   
                if(!Test.isRunningTest()){
                    if(lstMail.size() > 0){
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMail);
                        return results[0].isSuccess();
                    }
                    else{
                        return false;
                    }
                }
                else{
                    return true;
                }   
            }
            else{
                return false;
            }  
        }
        else{
            return false;
        }  
    }

    @AuraEnabled(cacheable=true)
    public static Contact getUserContactData(){
        String userId = UserInfo.getUserId();
        List<User> lstUser = [SELECT u.Id, u.ContactId, FullPhotoUrl FROM User u WHERE u.Id = :userId];
                
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            
            List<Contact> lstContact = [SELECT Id, Name, FirstName, FullName__c, LastName, Email, Phone, HomePhone, OtherPhone, Title, Risk_Manager_of_the_Year_Bio__c,
                                        MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Mailing_Address_Company__c, Account.BillingCountry,
                                        RPT_Clean_Country__c, AccountId, GARP_ID__c, Membership_Type__c, Job_Function__c, Company__c, GBI_Analytics_Participant__c,
                                        GBI_Pillar_3_Attestation__c,Area_of_Concentration__c, Corporate_Title__c, Company_Account__r.Name,Photo_URL__c
                                        FROM Contact WHERE Id = :contactId AND GBI_Participant__c = True];
            if(!lstContact.isEmpty()) {
                return lstContact[0];
            }
        }
        return null;
    }

    @AuraEnabled
    public static String updateContactInfo(String firstName, String lastName, String title, String phone, String altphone, String email) {
        
        FINAL Id userId = UserInfo.getUserId();        
        
        List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
        if( lstUser != null && !lstUser.isEmpty()) {
            
            FINAL Id contactId = lstUser[0].ContactId;   
             
            List<Contact> lstContact = [
                SELECT Id, Name, AccountId, FirstName, LastName, Phone, OtherPhone, Title, Email
                FROM Contact 
                WHERE Id = :contactId
            ];
            
            if( lstContact != null && lstContact.size() > 0 ) {
                
                lstContact[0].FirstName = firstName;
                lstContact[0].LastName = lastName;
                lstContact[0].Title = title;
                lstContact[0].Phone = phone;
                lstContact[0].OtherPhone = altphone;
                lstContact[0].Email = email;
                               
                UPDATE lstContact[0];
                
                return '';
            }
            return 'Contact not found';
        }
        return 'User not found';
    }

    @AuraEnabled
    public static String getImageFromAttachment(){
        String userId = UserInfo.getUserId();
        List<User> lstUser = [SELECT u.Id, u.ContactId, FullPhotoUrl FROM User u WHERE u.Id = :userId];
                
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            
            List<Contact> lstContact = [SELECT Id,Photo_URL__c FROM Contact WHERE Id = :contactId];
            if(!lstContact.isEmpty()) {
                if(lstContact[0].Photo_URL__c!=null){
                    return lstContact[0].Photo_URL__c;
                }
            }
        }
        return null;
    }

    @AuraEnabled
    public static String setUserPhoto(String attachmentId) {
        String userId = UserInfo.getUserId();
        list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attachmentId];
        if(!attachments.isEmpty()) {
            ConnectApi.BinaryInput binInput = new ConnectApi.BinaryInput(attachments[0].body, 'image/jpg', 'fileName');
            delete attachments;
            
            // Replace Photo
            User usr = [Select id, Name, FullPhotoUrl, ContactId from User where id = :userId];
            
            List<User_Photo__c> ufs = [select id from User_Photo__c where Contact__c = :usr.ContactId];
            User_Photo__c uf;
            if(ufs != NULL && ufs.size() > 0) {
                delete ufs;
            }

            uf = New User_Photo__c(Name=usr.Name, Contact__c=usr.ContactID);
            insert uf;
            
            Attachment a = new Attachment();
            a.body = binInput.getBlobValue();
            a.ParentId = uf.ID;
            a.contentType = 'image/jpeg';
            a.name = 'photo';                                
            insert a;         
            
            Contact updateContact = [Select id, Photo_URL__c from contact where id = :usr.ContactId];
            updateContact.Photo_URL__c = '/servlet/servlet.FileDownload?file=' + a.id;
            Update updateContact;
            
            return updateContact.Photo_URL__c;
            
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static Id uploadAttachment(String attachmentId, String fileText, String fileName) {
        String userId = UserInfo.getUserId();
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) { 
                list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attachmentId];
                if(attachments.isEmpty()) {
                    Attachment att = new Attachment();
                    att.Body = EncodingUtil.base64Decode(fileText);
                    att.Name = fileName;
                    att.parentId = lstContact[0].Id;
                    insert att;
                    return att.Id;
                } else {
                    String newBody = '';
                    Attachment att = attachments[0];
                    if(att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);
                    }
                    newBody += fileText;
                    att.Body = EncodingUtil.base64Decode(newBody);
                    upsert att;
                    return att.Id;
                }   
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static Boolean removeUserPhoto(){
        Boolean ret = false;
        
        String userId = UserInfo.getUserId();
        List<User> lstUser = [Select id, FullPhotoUrl, ContactId from User where id = :userId];
                
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            
            List<User_Photo__c> ufs = [select id from User_Photo__c where Contact__c = :contactId];
            if(ufs != NULL && ufs.size() > 0) {
                User_Photo__c uf = ufs[0];
                list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE ParentId =: uf.Id];
                if(attachments != NULL && attachments.size() > 0) {
                    delete attachments;
                }
            }
            
            List<Contact> updateContacts = [Select id, Photo_URL__c from contact where id = :contactId];
            if(!updateContacts.isEmpty()) {
                updateContacts[0].Photo_URL__c = NULL;
                Update updateContacts;
                ret = true;
            }

        }
        return ret;
    }

    @AuraEnabled(cacheable=true)
    public static List<Study__c> getAllActiveStudies() {
        return [SELECT Id, Name FROM Study__c WHERE Status__c IN ('In Progress','Completed')];
    }

    public class Participant{
        @AuraEnabled public String firmType;
        @AuraEnabled public String accountName;
        @AuraEnabled public String accountNameUrl;
        @AuraEnabled public String region;
        @AuraEnabled public String country;
        @AuraEnabled public Decimal studies;
    }
}