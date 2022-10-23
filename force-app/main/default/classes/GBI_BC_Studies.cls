public class GBI_BC_Studies {

    public static GBI_MS_Studies.retStudiesInfo getListStudies(GBI_MS_Studies.reqStudiesList reqWrapper) {
        GBI_MS_Studies.retStudiesInfo retInfo = new GBI_MS_Studies.retStudiesInfo();
        
        Set<String> statuses = GBI_Common.getPickListValues('Study__c','Status__c');
        Set<String> types = GBI_Common.getPickListValues('Study__c','Type__c');
        Set<String> risktypes = GBI_Common.getPickListValues('Study__c','Risk_Type__c');
        
        if(reqWrapper.status != NULL && !statuses.contains(reqWrapper.status) ||
           reqWrapper.riskBucket != NULL && !types.contains(reqWrapper.riskBucket) ||
           reqWrapper.riskType != NULL && !risktypes.contains(reqWrapper.riskType)
          ) {
              retInfo.statusCode = 500;
              retInfo.statusMsg = 'Invalid Filter';
              return retInfo;
          }
        
        String userId = UserInfo.getUserId();
        //String userId = '00578000000imgx';
        List<User> lstUser = [SELECT Id, ContactId FROM User WHERE Id = :userId];
        
        if(lstUser.isEmpty()) {
            retInfo.statusCode = 500;
            retInfo.statusMsg = 'Invalid user';
            return retInfo;
        }

        String query =
        	'SELECT Id, Name, Parent_Study__c, Parent_Study__r.Name, Type__c, Description__c, Status__c, ' +
            'Start_Date__c, End_Date__c, Conference_Call_Status__c, Conference_Call_Details__c, FAQ_Category__c, ' +
            'Document_Folder_Name__c, Risk_Type__c, Study_Objective__c, Data_Provided__c,  ' +
            'Reference_Study__c, Number_of_Participants__c, Data_Types_Supported__c, Qualtrics_Survey_Integration_Status__c, ' +
            'Payment_Required__c,Study_Fee__c, ' +
            '(SELECT Id, Name, Account__c, Role__c, Status__c,Payment_Agreed_Date__c FROM Study_Accounts__r) ' +
			'FROM Study__c WHERE ';

/*  For Testing  
        String query =
        	'SELECT Id,' +
            '(SELECT Id, Name, Account__c, Role__c, Status__c,Payment_Agreed_Date__c FROM Study_Accounts__r) ' +
			'FROM Study__c WHERE Status__c not in (\'Draft\',\'Suspended\')';
*/
        
        if(reqWrapper.status != NULL) {
            query+= ' AND Status__c = ' + reqWrapper.status;
        }
        if(reqWrapper.riskBucket != NULL) {
            query+= ' AND Type__c = ' + reqWrapper.riskBucket;
        }
        if(reqWrapper.riskType != NULL) {
            query+= ' AND Risk_Type__c = ' + reqWrapper.riskType;
        }
        if(reqWrapper.year != NULL) {
            query+= ' AND Start_Date__c >= ' + Date.newInstance(reqWrapper.year, 1, 1) + ' AND Start_Date__c <= ' + Date.newInstance(reqWrapper.year, 12, 31);
        }
        
        System.debug('query:' + query);
        List<Study__c> allStudies = Database.query(query);
        System.debug('allStudies:' + allStudies);
        
        Contact cont = getUserContactData();
        if(cont != NULL && !allStudies.isEmpty()) {
            
            String contactId  = cont.id;
            String accountId = cont.AccountId;
            Boolean isGARPEmployee = false;
            
            // Study Id to DP_Not_Required__c map. Used only for Non-GARP employee.
            Map<Id, Boolean> mapDPNotRequired = new Map<Id, Boolean>();
            // Study Id to Study Account Id map. Used only for Non-GARP employee.
            Map<Id, Id> mapStudyIdToStudyAccountId = new Map<Id, Id>();
            
            // Direct Parent Account of Conatct
            List<Account> lstAccount = [SELECT Id, Name, RecordTypeID, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c, Phone FROM Account WHERE Id = :accountId];
            if( lstAccount != null && lstAccount.size() > 0 ) {
                Account acct = lstAccount[0];
                if(acct.Name == 'GARP')
                    isGARPEmployee = true;
            }
            
            // If direct Parent Account not GARP, check AccountContactRole to see if they are GARP related
            if(isGARPEmployee == false) {
                List<AccountContactRelation> lstAcctContRoles = [select Id, AccountId, Account.Name, ContactId, IsDirect from AccountContactRelation where ContactId = :contactId];
                if( lstAcctContRoles != null && lstAcctContRoles.size() > 0 ) {
                    for(AccountContactRelation acr : lstAcctContRoles) {
                        if(acr.Account.Name == 'GARP') {
                            isGARPEmployee = true;
                            break;
                        }
                    }
                }
            }
            System.debug('isGARPEmployee:' + isGARPEmployee);
            retInfo.isGARPEmployee = isGARPEmployee;
            
            // Studies Contacts from Studies I participated In
            List<Study_Contact__c> lstStudyContact;
            if(isGARPEmployee) {
                lstStudyContact = [SELECT Id, Name, Role__c, Status__c, Study__c, Contact__c, Contact__r.Name, Contact__r.Photo_URL__c, Contact__r.AccountId, Study_Account__r.Account__c, Study_Account__c, Study_Account__r.Status__c, Study_Account__r.Name, Study_Account__r.Id 
                                   FROM Study_Contact__c WHERE Status__c IN ('Active','Confirmed') AND Study__c in :allStudies];
                // Simulate GARP Employee are in all Studies
                for(Study__c s :allStudies) {
                    Study_Contact__c newSc = new Study_Contact__c();
                    newSc.Study__c = s.Id;
                    newSc.Contact__c = contactId;
                    newSc.Study_Account__c = accountId;
                    lstStudyContact.add(newSc);
                }                    
            }else {
                lstStudyContact = [SELECT Id, Name, Role__c, Status__c, Study__c, Contact__c, Contact__r.Name, Contact__r.Photo_URL__c, Contact__r.AccountId, Study_Account__r.Account__c, Study_Account__c, Study_Account__r.Status__c, Study_Account__r.Name, Study_Account__r.Role__c, Study_Account__r.Id, Study_Account__r.DP_Not_Required__c
                                   FROM Study_Contact__c WHERE Contact__c = :contactId AND Status__c IN ('Active','Confirmed') 
                                   AND Study_Account__r.Status__c = 'Active'];
                
            }
            System.debug('lstStudyContact:' + lstStudyContact);
            
            MAP<ID,Study_Contact__c> myStudiesAccounts = new MAP<ID,Study_Contact__c>(); // Study_Account__c Id
            Set<ID> myStudiesAccountIds = new Set<ID>();    // Account Id on Study_Account__c

            MAP<ID,Study_Contact__c> myOrgStudiesAccounts = new MAP<ID,Study_Contact__c>(); // Study_Account__c Id
			Set<ID> myOrgsStudiesAccountIds = new Set<ID>();    // Account Id on Study_Account__c

            MAP<ID,Study_Contact__c> otherStudiesAccounts = new MAP<ID,Study_Contact__c>(); // Study_Account__c Id
			Set<ID> otherStudiesAccountIds = new Set<ID>();    // Account Id on Study_Account__c
            
            Set<ID> allStudyAccountIDs = new Set<ID>();
            
            for(Study_Contact__c sc :lstStudyContact) {
                System.debug('sc:' + sc);
                
                allStudyAccountIDs.add(sc.Study_Account__r.Account__c);
                if(sc.Contact__c == contactId) {
                    myStudiesAccounts.put(sc.Study_Account__c, sc);
                    myStudiesAccountIds.add(sc.Study_Account__r.Account__c);
                } else if(sc.Study_Account__c == accountId) {
                    myOrgStudiesAccounts.put(sc.Study_Account__c, sc);
                    myOrgsStudiesAccountIds.add(sc.Study_Account__r.Account__c);                    
                } else {
                    otherStudiesAccounts.put(sc.Study_Account__c, sc);
                    otherStudiesAccountIds.add(sc.Study_Account__r.Account__c);                                        
                }
            }
            system.debug('allStudyAccountIDs:' + allStudyAccountIDs);
            
            system.debug('myStudiesAccounts:' + myStudiesAccounts);          
            system.debug('myStudiesAccountIds:' + myStudiesAccountIds);          
            system.debug('myOrgStudiesAccounts:' + myOrgStudiesAccounts);          
            system.debug('myOrgsStudiesAccountIds:' + myOrgsStudiesAccountIds);          
            system.debug('otherStudiesAccounts:' + otherStudiesAccounts);          
            system.debug('otherStudiesAccountIds:' + otherStudiesAccountIds);          
            
            MAP<String, Study__c> mapMyStudies = new MAP<String, Study__c>();
            MAP<String, Study__c> mapOrgStudies = new MAP<String, Study__c>();
            MAP<String, Study__c> otherStudies = new MAP<String, Study__c>();
            for(Study__c s :allStudies) {
                for(Study_Account__c sa :s.Study_Accounts__r) {
                    if(myStudiesAccountIds.contains(sa.Id)) {
                        mapMyStudies.put(s.id, s);
                        break;
                    } else if(myOrgsStudiesAccountIds.contains(sa.Id)) {
                        mapOrgStudies.put(s.id, s);
                        break;
                    }
                }
                if(mapMyStudies.get(s.id) == NULL && mapOrgStudies.get(s.id) == NULL) {
                    otherStudies.put(s.id, s);
                }
            }
            system.debug('mapMyStudies:' + mapMyStudies);    
            system.debug('mapOrgStudies:' + mapOrgStudies);    
            system.debug('otherStudies:' + otherStudies);    
            
            retInfo.myStudies = mapMyStudies.values();
            retInfo.myOrgStudies = mapOrgStudies.values();
            retInfo.otherStudies = otherStudies.values();
            
            retInfo.discloseProtocolSubmissions = [select Id, Study_Account__c, Study_Contact__c, Disclosure_Protocol__r.DP_Status__c 
                                                   from Study_Disclose_Protocol_Submission__c
                                                   WHERE Study__c in :allStudies];
            
            system.debug('retInfo.discloseProtocolSubmissions:' + retInfo.discloseProtocolSubmissions);
         
            retInfo.studyNDAs = [
                    SELECT Id, Account__c, Status__c, Latest_NDA_Dated_Date__c, Next_NDA_Review_Date__c
                    FROM Study_NDA__c 
                    WHERE Account__c IN :allStudyAccountIDs and Status__c IN ('Signed','Expired')
                    ORDER BY Latest_NDA_Dated_Date__c DESC NULLS LAST
                ];
            system.debug('retInfo.studyNDAs:' + retInfo.studyNDAs);
            
        }
        
        return retInfo;
    }
    
    public static List<Study__c> getAllActiveStudies() {
        return [SELECT Id, Name, Parent_Study__c, Parent_Study__r.Name, Type__c, Description__c, Status__c, 
                                                  Start_Date__c, End_Date__c, Conference_Call_Status__c, Conference_Call_Details__c, FAQ_Category__c, 
                                                  Document_Folder_Name__c, Risk_Type__c, Study_Objective__c, Data_Provided__c, 
                                                  Reference_Study__c, Number_of_Participants__c, Data_Types_Supported__c, Qualtrics_Survey_Integration_Status__c,
                                                  Payment_Required__c,Study_Fee__c,
                                           (SELECT Id, Name, Account__c, Role__c, Status__c,Payment_Agreed_Date__c FROM Study_Accounts__r)
                                           FROM Study__c WHERE Status__c IN ('In Progress','Completed')];
    }

    public static Contact getUserContactData(){
        String userId = UserInfo.getUserId();
        //String userId = '00578000000imgx';
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
    
    public static String setUserPhoto(Id attachmentId) {
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
                uf = ufs[0];
                list<Attachment> phattachments = [SELECT Id, Body FROM Attachment WHERE ParentId =: uf.Id];
                if(phattachments != NULL && phattachments.size() > 0) {
                    delete phattachments;
                }
            } else {
                uf = New User_Photo__c(Name=usr.Name, Contact__c=usr.ContactID);
                insert uf;
            }
            
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
    
    public static Id uploadAttachment(Id attachmentId, String fileText, String fileName) {
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
    
    public static GBI_MS_Studies.faqReturnData getFAQInformation(){
        
        GBI_MS_Studies.faqReturnData rd = new GBI_MS_Studies.faqReturnData();
        Set<ID> faqCategoryIds = new Set<ID>();
        
        List<Study__c> lstStudy = getAllActiveStudies();
        for(Study__c study :lstStudy) {
            faqCategoryIds.add(study.FAQ_Category__c);
        }
        
        List<FAQ_Category__c> allFAQCates = [SELECT Id, Name, FAQ_Category__c,
                                             (SELECT Id, Name, FAQ_Category__c, Section_Order_Number__c FROM FAQ_Section_del__r),
                                             (SELECT Id, Name, FAQ_Category__c, FAQ_Section__c, Related_Section_Order_Number__c, Subsection_Order_Number__c FROM FAQ_Subsection__r),
                                             (SELECT Id, Name, FAQ_Category__c, FAQ_Section__c, FAQ_Subsection__c, FAQ_Rank__c, FAQ_Question__c, FAQ_Answer__c, FAQ_Section_Order__c, FAQ_Subsection_Order__c, Related_Subsection__c FROM Frequently_Asked_Questions_del__r)
                                             FROM FAQ_Category__c WHERE Name = 'GBI' OR Id IN :faqCategoryIds];        
        
        List<FAQ_Category__c> faqCategories = new List<FAQ_Category__c>();
        List<FAQ_Section__c>  listFAQSections = new List<FAQ_Section__c>();
        List<FAQ_Subsection__c> listFAQSubSections = new List<FAQ_Subsection__c>();
        List<Frequently_Asked_Questions__c> FAQs = new List<Frequently_Asked_Questions__c>();
        
        for(FAQ_Category__c oneCat : allFAQCates) {
            faqCategories.add(new FAQ_Category__c(Id=oneCat.Id, Name=oneCat.Name, FAQ_Category__c=oneCat.FAQ_Category__c));
            listFAQSections.addAll(oneCat.FAQ_Section_del__r);
            listFAQSubSections.addAll(oneCat.FAQ_Subsection__r);
            FAQs.addAll(oneCat.Frequently_Asked_Questions_del__r);
        }
        
        rd.faqCategories =faqCategories;
        rd.listFAQSections = listFAQSections;
        rd.listFAQSubSections = listFAQSubSections;
        rd.FAQs = FAQs;
        
        return rd;
    }
    
    public static List<Study_Account__c> getParticipantInformation(){

        Set<ID> allStudies = new Set<ID>();
        
        List<Study__c> lstStudy = getAllActiveStudies();        
        for(Study__c study :lstStudy) {
            allStudies.add(study.Id);
        }                            
        
        // Study Account from all studies
        List<Study_Account__c> lstStudyAccounts = [SELECT Id, Name, Role__c, Status__c, Study__c, Account__c, Account__r.Name, Account__r.Alternate_Name__c, Account__r.Firm_Type__c, Account__r.Number_of_Studies__c, Account__r.Region__c, Account__r.BillingCountry, Account__r.CPE_Provider_Logo__c, Account__r.Description, Account__r.GBI_Region__c, Account__r.GBI_Country_Code__c,Payment_Agreed_Date__c,
                                                   Account__r.GBI_Pillar_Start_Date__c, Account__r.GBI_Pillar_Impact_Start_Date__c, Account__r.GBI_Pillar_Impact_End_Date__c
                                                   FROM Study_Account__c WHERE (Status__c = 'Active' OR Status__c = 'Confirmed') AND Study__c in :allStudies];        
        return lstStudyAccounts;
    }
    
    
    public static GBI_MS_Studies.getSudiesReturnData getStudies(){
        GBI_MS_Studies.getSudiesReturnData rd = new GBI_MS_Studies.getSudiesReturnData();
        
        Contact cont = getUserContactData();
        if(cont != NULL) {
            rd.ContactData = cont;
            
            String contactId  = cont.id;
            String accountId = cont.AccountId;
            Boolean isGARPEmployee = false;
            
            // Direct Parent Account of Conatct
            List<Account> lstAccount = [SELECT Id, Name, RecordTypeID, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c, Phone FROM Account WHERE Id = :accountId];
            if( lstAccount != null && lstAccount.size() > 0 ) {
                rd.accountData = lstAccount[0];
                if(rd.accountData.Name == 'GARP')
                    isGARPEmployee = true;
            }
            rd.isGARPEmployee = isGARPEmployee;
            
            // If direct Parent Account not GARP, check AccountContactRole to see if they are GARP related
            if(isGARPEmployee == false) {
                List<AccountContactRelation> lstAcctContRoles = [select Id, AccountId, Account.Name, ContactId, IsDirect from AccountContactRelation where ContactId = :contactId];
                if( lstAcctContRoles != null && lstAcctContRoles.size() > 0 ) {
                    for(AccountContactRelation acr : lstAcctContRoles) {
                        if(acr.Account.Name == 'GARP') {
                            isGARPEmployee = true;
                            break;
                        }
                    }
                }
            }
            
            Set<ID> allStudies = new Set<ID>();
            
            Set<ID> myStudies = new Set<ID>();
            MAP<ID,Study_Contact__c> myStudiesAccounts = new MAP<ID,Study_Contact__c>();        // Study_Account__c Id
            Set<ID> myStudiesAccountIds = new Set<ID>();    // Account Id on Study_Account__c
            
            List<Study__c> lstStudy = getAllActiveStudies();
            rd.studies = lstStudy;
            
            rd.disclosureProtocols  = [select Id, Name, Study__c, DP_Status__c, CurrencyIsoCode,
                (select Id, Name FROM Study_Disclosure_Protocol_Submissions__r WHERE Study_Contact__r.Contact__c = :contactId)
                 from Disclosure_Protocol__c WHERE DP_Status__c = 'Active'];
            
            List<Study_NDA__c> lstNDAs = [
                SELECT Id, Account__c, Status__c, Latest_NDA_Dated_Date__c, Next_NDA_Review_Date__c, 
                (SELECT Id, Name FROM Attachments)
                FROM Study_NDA__c 
                WHERE Account__c IN :myStudiesAccountIds and Status__c IN ('Signed','Expired')
                ORDER BY Latest_NDA_Dated_Date__c DESC NULLS LAST
            ];
            
            system.debug('lstNDAs:' + lstNDAs);
            
            List<Study_NDA__c> lstNDAFinal = new List<Study_NDA__c>();
            Study_NDA__c lastNDA;
            Date lastNDADate = Date.newInstance(1900, 1, 1);
            
            if(lstNDAs.size() > 0) {
                lastNDA = lstNDAs[0];
                lastNDADate = lstNDAs[0].Latest_NDA_Dated_Date__c;
            }
            
            if(lastNDA != null)
                lstNDAFinal.add(lastNDA);
            
            rd.studyNDAs = lstNDAFinal;
        }

        return rd;
    }
    
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
                    lstEmailAddress=[select Id, Address from OrgWideEmailAddress WHERE Address='pillar3support@garp.com'];
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
}