public class GARP_BC_Webcasts {
    
	public class returnWebcastInformation {
        public List < Webcast__c > webcastInformation { get; set; }
        public List < Presenter__c > presentersAtWebcast { get; set; }
        public List < String  > allWebcastParticipantsMediaURLs { get; set; }
        public Boolean isAutenticated { get; set; }
    } 

    public class wrapperCreateWebcastRegistration {
        public Id contactId {
            get;
            set;
        }
        
        public String webcastRegistrationId {
            get;
            set;
        } 
    }
    
    public static returnWebcastInformation getWebcastInformation(String webcastId){
        returnWebcastInformation rd = new returnWebcastInformation();
        
        rd.isAutenticated = GARP_BC_Authentication.isAuthenticated();
        
        List < Webcast__c > allWebcastInformation = [SELECT Name, Id, Description__c, Duration__c, Start_Time__c, End_Time__c, Start_Date__c, End_Date__c, Image__c, Status__c, Title__c, Is_Sponsored__c, Content__r.Form__r.Form_Name__c, On_Demand_URL__c, Time_Zone__r.Name FROM Webcast__c where Id = :webcastId];
        List < Presenter__c > allWebcastParticipants = [SELECT Id, Name, Role__c, Contact__r.GARP_Profile__r.Bio__c, Contact__r.GARP_Profile__r.Id, Contact__r.Name, Contact__r.GARP_Profile__r.Qualifications__c, Contact__r.GARP_Profile__r.Default_Image__c, Webcast__r.Name, Webcast__r.Title__c, Webcast__r.Status__c, Webcast__r.Start_Date__c, Webcast__r.End_Date__c, Webcast__r.Description__c FROM Presenter__c where Webcast__r.Id = :webcastId];
        List<String> GARPProfileIDsOfWebcastParticipants = new List<String>();
        List<String> allWebcastParticipantsMediaURLs = new List<String>();
        
        for(Presenter__c webcastParticipant: allWebcastParticipants){
            GARPProfileIDsOfWebcastParticipants.add(webcastParticipant.Contact__r.GARP_Profile__r.Id);
        }
        
        List < cdrive__Cloud_Files__c > allWebcastParticipantsMedia = [SELECT Id, cdrive__contextID__c, cdrive__File_Name__c from cdrive__Cloud_Files__c where cdrive__contextID__c = :GARPProfileIDsOfWebcastParticipants]; 
        for(cdrive__Cloud_Files__c webcastParticipantMedia: allWebcastParticipantsMedia){
            allWebcastParticipantsMediaURLs.add('https://s3-us-west-2.amazonaws.com/garpsalesforcepublic/GARP_Profile__c/' + webcastParticipantMedia.cdrive__contextID__c + '/' + webcastParticipantMedia.Id + '_' + webcastParticipantMedia.cdrive__File_Name__c);
        }
        rd.webcastInformation = allWebcastInformation;
        rd.presentersAtWebcast = allWebcastParticipants;
        rd.allWebcastParticipantsMediaURLs = allWebcastParticipantsMediaURLs;
        return rd;
    }
    
    public static wrapperCreateWebcastRegistration createWebcastRegistration(TempAccount objData,String contactId) {
        wrapperCreateWebcastRegistration returnWebcastWrapper = new wrapperCreateWebcastRegistration();
        Registration.wrapperCreateOrder newAffiliateOrder = new Registration.wrapperCreateOrder();
        String userContactId = null;
        
        System.Debug('***objData:'+objData);
        System.Debug('***contactId:'+contactId);
        
        List<Webcast__c> lstWebcasts = [select ID, Name, EventId__c, X0n24_API_Key__c from Webcast__c where ID = :objData.webcastId];
        if(lstWebcasts != null && lstWebcasts.size() > 0) {
            
            Webcast__c webCast = lstWebcasts[0];
            
            System.Debug('***webCast :'+webCast );
            
            if(contactId != null){
                // PORTAL
                userContactId = contactId;
                insertWebcastRegistration(objData, contactId);
            } else if(contactId == null){
                // PUBLIC
                if(objData.Membership_Type == 'Affiliate') {
                    newAffiliateOrder = Registration.CreateOrder(objData);
                    userContactId = newAffiliateOrder.contactId;
                    insertWebcastRegistration(objData, newAffiliateOrder.contactId);
                } else {
                    Response.Detail ret = (Response.Detail)GARP_BC_Webcasts.createNonMemberWebcastRegistration(objData);
                    if(ret != NULL && ret.data != NULL) {
                        Webcast_Registration__c wcr = (Webcast_Registration__c)ret.data;
                        userContactId = wcr.Contact__c;
                    }
                }
            }
            
            System.Debug('Insert Done');
            
           // List < Webcast_Registration__c  > webcastRegistration = [SELECT Id FROM Webcast_Registration__c where (Contact__c =: userContactId and Webcast__c =: objData.webcastId)];
           List < Webcast_Registration__c  > webcastRegistration = [SELECT Id,Lead__r.Id FROM Webcast_Registration__c where (Contact__c =: userContactId and Webcast__c =: objData.webcastId)];        
            if(webcastRegistration != null && webcastRegistration.size() > 0) {
                // API_Transaction__c trans = on24API.createAPITransactionRecord(webcastRegistration[0].Id, userContactId, webCast.EventId__c, webCast.X0n24_API_Key__c);
                API_Transaction__c trans = on24API.createAPITransactionRecord('webcast',webcastRegistration[0].Id, userContactId, webCast.EventId__c, webCast.X0n24_API_Key__c);
                
                if(trans != null)
                    on24API.SendRequest(null, trans.Id);
                
                returnWebcastWrapper.webcastRegistrationId = webcastRegistration[0].Id;
                returnWebcastWrapper.contactId = userContactId;
            }
        }
        
        return returnWebcastWrapper;
    }
    
    public static void insertWebcastRegistration(TempAccount objData,Id contactId){
        Webcast_Registration__c  newWebcastRegistration = new Webcast_Registration__c();
        
        String objName = objData.FirstName + ' ' + objData.LastName + '/' + objData.webcastId;
        
        newWebcastRegistration.Name = objName;
        newWebcastRegistration.Contact__c = contactId;
        newWebcastRegistration.Status__c = 'Registered';
        newWebcastRegistration.Webcast__c = objData.webcastId;       
        newWebcastRegistration.Agree_To_Sponsor_Contact__c = objData.sponsorInformationExchangeAttestation ? DateTime.Now() : NULL;
        
        System.debug('newWebcastRegistratione:' + newWebcastRegistration);
        
        
        if(objData.Company != NULL || objData.jobtitle != NULL) {
            GARP_MS_MemberProfile.memberProfileUpdate profileUpdate = new GARP_MS_MemberProfile.memberProfileUpdate();
            profileUpdate.profileParts.CompanyTitle = True;
            profileUpdate.ContactId = contactId;
            profileUpdate.Company = objData.Company;
            profileUpdate.Title = objData.jobtitle;
            
            System.debug('profileUpdate:' + profileUpdate);
            
            GARP_MS_MemberProfile.setMemberProfile(profileUpdate);
        }
        
        insert newWebcastRegistration;
    }

    public static Response.Envelope createNonMemberWebcastRegistration(TempAccount wrapper){
        
        Response.Detail res = new Response.Detail();
        
        try{
            
            Id eventId          = wrapper.webcastId;
            Id entityId         = wrapper.id;        
            Id accountId        = null;
            String companyName  = wrapper.Company;
            
            Webcast__c webcast = null;
            
            List<Webcast__c> webcasts = [select ID, Name, Status__c, EventId__c, X0n24_API_Key__c from Webcast__c where ID = :eventId];
            
            //Ensure the Webcast exists and is Active
            if(webcasts.isEmpty()){          
                res.errors = new List<String>{'Event with the ID ' + eventId + ' was not found.'};
                res.status = 404;
                return res;
            } else if(webcasts[0].Status__c != 'Active'){
                res.errors = new List<String>{'Webcast is not active.'};
                res.status = 400;
                return res;            
            }
            
            webcast = webcasts[0];
            
            List<Lead> leads       = [SELECT Id FROM Lead WHERE Id = :entityId LIMIT 1];
            List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Id = :entityId LIMIT 1];
            
            List<Account> relatedAccounts = [SELECT Id, Name FROM Account WHERE Customer_Company_List__c = TRUE AND Name = :companyName LIMIT 1]; 
            if(relatedAccounts.isEmpty()){
                accountId = Default_Record_References__c.getAll().get('UNMATCHED-BUSINESS-ACCOUNT').Record_Reference_ID__c;
            }else{
                accountId = relatedAccounts[0].Id;
            }
            
            Contact contact = null;
            
            if(!leads.isEmpty()) {
                
                Lead lead = leads[0];
                
                Database.LeadConvert convertLead = new Database.LeadConvert();            
                convertLead.setLeadId(entityId);
                
                LeadStatus ls = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = TRUE LIMIT 1];
                convertLead.setConvertedStatus(ls.MasterLabel);
                
                convertLead.setAccountId(accountId);
                convertLead.setDoNotCreateOpportunity(true);
                
                Database.LeadConvertResult lcr = Database.convertLead(convertLead);               
                if (lcr.isSuccess()){
                    Lead convertedLead = [SELECT ConvertedAccountId, ConvertedContactId FROM Lead WHERE Id = :entityId LIMIT 1];
                    contact = [SELECT Id, Name, Email FROM Contact WHERE Id = :convertedLead.ConvertedContactId LIMIT 1];
                }else{
                    
                    res.errors = new List<String>{'Lead conversion failed.'};
                    res.status = 400;
                    return res; 
                    
                }
                               
                contact.RecordTypeId        = [SELECT Id, Name, sObjectType FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'Business Relationship' LIMIT 1].Id;
                
                contact.MailingStreet       = wrapper.MailingStreet;
                contact.MailingCity         = wrapper.MailingCity;
                contact.MailingState        = wrapper.MailingState;
                contact.MailingPostalCode   = wrapper.MailingPostalCode;
                contact.MailingCountry      = wrapper.MailingCountry;
                
                contact.Email               = wrapper.Email;
                contact.FirstName           = wrapper.FirstName;
                contact.LastName            = wrapper.LastName;
                contact.Title               = wrapper.jobtitle;
                contact.Company__c          = wrapper.Company;
                
                contact.Corporate_Title__c          = wrapper.Title;
                contact.Job_Function__c             = wrapper.JobFunction;
                contact.Risk_Specialty__c           = wrapper.RiskSpecialty;
                contact.Area_of_Concentration__c    = wrapper.Industry;
                
                // If Event has Participant Login enable add Role to Contact which will trigger User creation
                //if(event.Event_Participant_Login__c) {
                //    contact.Event_Participant__c = TRUE;
                //}
                
                // Assign MC Unique ID
                contact.MC_Unique_Id__c = lead.id;                
                
                UPDATE contact;
                
                // Move Form Data
                Utilities.migrateLeadFormDataToContact(lead.id, contact.Id, wrapper.formName, null);
                
            }else if(!contacts.isEmpty()){
                
                contact = contacts[0];
                
                contact.MailingStreet       = wrapper.MailingStreet;
                contact.MailingCity         = wrapper.MailingCity;
                contact.MailingState        = wrapper.MailingState;
                contact.MailingPostalCode   = wrapper.MailingPostalCode;
                contact.MailingCountry      = wrapper.MailingCountry;
                
                contact.Email               = wrapper.Email;
                contact.FirstName           = wrapper.FirstName;
                contact.LastName            = wrapper.LastName;
                contact.Title               = wrapper.jobtitle;
                contact.Company__c          = wrapper.Company;
                
                contact.Corporate_Title__c          = wrapper.Title;
                contact.Job_Function__c             = wrapper.JobFunction;
                contact.Risk_Specialty__c           = wrapper.RiskSpecialty;
                contact.Area_of_Concentration__c    = wrapper.Industry;
                
                UPDATE contact;
                
                Utilities.migrateLeadFormDataToContact(null, contact.Id, wrapper.formName, null);
                
            }else{
                
                res.errors = new List<String>{'No Lead or Contact exists for the individual attempting to register.'};
                res.status = 404;
                return res;  
                
            }
            
            Webcast_Registration__c webcastRegistration = null;
            
            List<Webcast_Registration__c> existingWebcastRegistrations = [SELECT Id, Contact__c, Webcast__c FROM Webcast_Registration__c WHERE Contact__c = :contact.Id AND Webcast__c = :webcast.Id];
            if(existingWebcastRegistrations.isEmpty()){    
                
                webcastRegistration = new Webcast_Registration__c();
                
                webcastRegistration.Contact__c = contact.Id;
                webcastRegistration.Webcast__c = webcast.Id;     
                webcastRegistration.Webcast_Registration_Date__c = Date.today();     
                webcastRegistration.Status__c = 'Registered';
                
                system.debug('wrapper.sponsorInformationExchangeAttestation:' + wrapper.sponsorInformationExchangeAttestation);
                
                webcastRegistration.Agree_To_Sponsor_Contact__c = wrapper.sponsorInformationExchangeAttestation ? DateTime.Now() : NULL;
                
                system.debug('webcastRegistration:' + webcastRegistration);
                
                INSERT webcastRegistration;     
                
            }else{
                
                //webcastRegistration = existingWebcastRegistrations[0];
                //eventRegistration.Contact__c = contact.Id;
                //eventRegistration.Status__c = 'RSVP Accept';
                //if(event.Max_Capacity_Met__c){
                //    eventRegistration.Status__c = 'Waitlisted';
                //}
                
                //UPDATE eventRegistration;
                
            }
            
            res.data = webcastRegistration;
            res.status = 200;
            return res;  
            
        }catch(Exception e){
            
            res.errors = new List<String>{e.getMessage(), e.getStackTraceString()};
            res.status = 400;
            return res;
                       
        }
        
    }
}