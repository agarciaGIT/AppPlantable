global without sharing class EventRegistration {
    
    global class returnData {
        public List < Event__c > idsOfMainAndRelatedEvents { get; set; }
        public List < Event__c > eventDetails { get; set; }
        public List < Event_Rate__c > eventRateDetails { get; set; }
        public List < Event__c > mainAndRelatedEventDetails { get; set; }
        public List < cdrive__Cloud_Files__c > eventImages { get; set; }
        public List < Event_Contact__c > eventContacts { get; set; }
    } 
    
    global class returnAllEventData {
        public List < Event__c > allEventInformation { get; set; }
        public List < cdrive__Cloud_Files__c  > eventBackgroundInformation { get; set; }
        public List < Event_Combo_Rate__c  > eventComboRateInformation { get; set; }
        public List < Event_Contact__c  > eventContactInformation { get; set; }
        
    }
    
    global class conventionReturnData {
        public List < Event__c > conventionEventInformation { get; set; }      
    }
    
    global class returnDiscountCodeData {
        public List < Product_Discount__c > discountCodeData { get; set; } 
    }
    
    global class returnPromoCodeData {
        public List<Map<String, Event_Discount__c>> result = new List<Map<String, Event_Discount__c>>();
    }
    
    public static returnDiscountCodeData confirmDiscountCode(String promocode, String eventId) {
        
        returnDiscountCodeData rd = new returnDiscountCodeData();
        
        String[] inputtedPromocodeAndProductCodes = promocode.split('~');
        
        String discountCode = inputtedPromocodeAndProductCodes[0];
        
        String productCode = inputtedPromocodeAndProductCodes[1];   
        
        // Query Codes within Date Rages if Given
        List<Product_Discount__c> discountCodeData = [
            SELECT Id, Name, Product__r.ProductCode, Event_Discount__r.Discount_Code__c, Event_Discount__r.Discount_To_Fixed_Price__c, Event_Discount__r.Fixed_Amount_Discount__c, Event_Discount__r.Fixed_Percentage_Discount__c, Event_Discount__r.Start_Date__c, Event_Discount__r.End_Date__c, Event_Discount__r.Max_Allowed_Usage__c, Event_Discount__r.Registration_Type__c
            FROM Product_Discount__c 
            WHERE 
            Event_Discount__r.Discount_Code__c =: discountCode AND 
            Event_Discount__r.Event__c = :eventId AND
            (Event_Discount__r.Start_Date__c = NULL OR Event_Discount__r.Start_Date__c <= TODAY) AND
            (Event_Discount__r.End_Date__c = NULL OR Event_Discount__r.End_Date__c >= TODAY)
        ];
        
        // Check Max usage is needed
        if(discountCodeData != NULL && discountCodeData.size() > 0 && discountCodeData[0].Event_Discount__r.Max_Allowed_Usage__c != NULL) {
            List < Event_Registration__c > lstEventReg = [select Id, Status__c from Event_Registration__c where Event__c = :eventId AND Discount_Code_Used__c = :discountCode AND Status__c != 'Cancelled'];
            // If over max usage
            if(lstEventReg != NULL && lstEventReg.size() >= discountCodeData[0].Event_Discount__r.Max_Allowed_Usage__c) {
                // Clear result so it can not be used
                discountCodeData = new List < Product_Discount__c >();
            }            
        }
        
        rd.discountCodeData = discountCodeData;
        
        return rd;
        
    }
    
    public static conventionReturnData getCurrentConventionInformation() {
        conventionReturnData rd = new conventionReturnData();
        
        // Fetch all the events with the record type convention
        List < Event__c > conventionEventInformation = [select Name, RecordTypeId, RecordType.Name FROM Event__c WHERE (Status__c = 'Active' and RecordType.Name = 'Convention')];
        rd.conventionEventInformation = conventionEventInformation;
        
        return rd;
        
    }
    
    public static returnAllEventData getAllEventInformation(String eventId) {
        returnAllEventData rd = new returnAllEventData();
        List<Id> idsOfParentEventsForMasterClass = new List<Id>();
        
        List < Event__c > allEventInformation = [
            SELECT Id, ON24_Event_Id__c, ON24_URL__c, Online_Meeting_URL__c, Online_Meeting_Notes__c, Short_Title__c,Hide_Address_fields__c,Overview__c, Is_GDPR_Compliant_Event__c, Is_Sponsored_Event__c, RecordType.Name, Certified_get_Member_Rate__c, VenueName__c, Invite_Only__c, Content__r.Form__r.Form_Name__c, Content__r.Custom_Header__c, Content__r.Custom_Footer__c, Title__c, Parent_Event__r.Id, Name, Alumni_Product__r.GL_Code__c, Alumni_Product__r.ProductCode, Alumni_Discount_Percentage__c, Can_Pay_By_wire__c, Event_Background_Image__c, Registration_Type__c, Event_Color_Palette__c, Sub_Title__c, Can_Register__c, Description__c, Cancellation_Policy__c, Program_Change__c, Events_Photography_Release__c, Last_Date_For_Registration__c, Last_Date_for_Wire_Check_Registration__c, Chapter_Meeting__c, Start_Date__c, End_Date__c, Address__c, AddressMap_Image_URL__c, RSVP_Copy__c, Approval_Required__c, Time_Zone__c, Max_Capacity_Met__c, RSVP_Waitlist_Copy__c, Time_Zone__r.Name, Time_Zone__r.Abbreviation__c, Time_Zone__r.Add_This_Event_Zone__c ,Delivery_Method__c,
            (SELECT Id, Name, Start_Date__c, Product_Member_Code__r.GL_Code__c, Product_Non_Member_Code__r.GL_Code__c, Product_Member_Code__r.ProductCode, Product_Non_Member_Code__r.ProductCode, Product_Alumni_Code__r.GL_Code__c, Product_Alumni_Code__r.ProductCode, End_Date__c, Member_Rate__c, Non_Member_Rate__c, Alumni_Rate__c from Event_Rates__r WHERE (Start_Date__c <= TODAY and End_Date__c >= TODAY)), 
            (SELECT Name, Combo_Event__c, Is_Membership_Combo__c, Combo_Member_Product_Code__r.Id, Combo_Member_Product_Code__r.ProductCode, Combo_Non_Member_Product_Code__r.ProductCode, Combo_Member_Product_Code__r.GL_Code__c, Combo_Non_Member_Product_Code__r.GL_Code__c, Combo_Member_Product_Code__c, Combo_Non_Member_Product_Code__c, Main_Event_Rate__r.Event__c, Member_Rate__c, Non_Member_Rate__c, Status__c FROM Event_Combo_Rates__r WHERE Main_Event_Rate__r.Start_Date__c <= TODAY and Main_Event_Rate__r.End_Date__c >= TODAY) 
            FROM Event__c 
            WHERE (Id = :eventId or Parent_Event__c = :eventId)
        ];    
        
        List < cdrive__Cloud_Files__c > eventBackgroundInformation = [select Id, cdrive__contextID__c, cdrive__File_Name__c from cdrive__Cloud_Files__c where cdrive__contextID__c = :eventId ];
        List < Event_Combo_Rate__c > eventComboRateInformation = [SELECT Name, Combo_Event__c, Is_Membership_Combo__c, Combo_Member_Product_Code__c, Combo_Non_Member_Product_Code__c, Main_Event_Rate__r.Event__c, Member_Rate__c, Non_Member_Rate__c, Status__c FROM Event_Combo_Rate__c WHERE (Main_Event_Rate__r.Start_Date__c <= TODAY and Main_Event_Rate__r.End_Date__c >= TODAY) and (Main_Event_Rate__r.Event__c = :eventId)];
        
        List < Event_Contact__c  > eventContactInformation = [SELECT First_Name__c, Last_Name__c, Email__c, Type__c from Event_Contact__c where Event__c = :eventId];
        
        for(Event__c event : allEventInformation) {
            idsOfParentEventsForMasterClass.add(event.Parent_Event__c);
        }
        
        List < Event__c > masterClassEventInfo = [select Id, Parent_Event__r.Id, Name, Alumni_Product__r.GL_Code__c, Alumni_Product__r.ProductCode, Alumni_Discount_Percentage__c, Can_Pay_By_wire__c, Event_Background_Image__c, Registration_Type__c, Event_Color_Palette__c, Sub_Title__c, Can_Register__c, Description__c, Cancellation_Policy__c, Program_Change__c, Events_Photography_Release__c, Last_Date_For_Registration__c, Last_Date_for_Wire_Check_Registration__c, Chapter_Meeting__c, Start_Date__c, End_Date__c, Address__c, AddressMap_Image_URL__c, (SELECT Id, Name, Start_Date__c, Product_Member_Code__r.GL_Code__c, Product_Non_Member_Code__r.GL_Code__c, Product_Member_Code__r.ProductCode, Product_Non_Member_Code__r.ProductCode, End_Date__c, Member_Rate__c, Non_Member_Rate__c from Event_Rates__r WHERE (Start_Date__c <= TODAY and End_Date__c >= TODAY)), (SELECT Name, Combo_Event__c, Is_Membership_Combo__c, Combo_Member_Product_Code__r.Id, Combo_Member_Product_Code__r.ProductCode, Combo_Non_Member_Product_Code__r.ProductCode, Combo_Member_Product_Code__r.GL_Code__c, Combo_Non_Member_Product_Code__r.GL_Code__c, Combo_Member_Product_Code__c, Combo_Non_Member_Product_Code__c, Main_Event_Rate__r.Event__c, Member_Rate__c, Non_Member_Rate__c, Status__c FROM Event_Combo_Rates__r WHERE Main_Event_Rate__r.Start_Date__c <= TODAY and Main_Event_Rate__r.End_Date__c >= TODAY) FROM Event__c WHERE (Id = :idsOfParentEventsForMasterClass)];
        allEventInformation.addAll(masterClassEventInfo);
        
        rd.eventBackgroundInformation = eventBackgroundInformation;
        rd.allEventInformation = allEventInformation;
        rd.eventComboRateInformation = eventComboRateInformation;
        rd.eventContactInformation = eventContactInformation;
        return rd;
    }
    
    public static returnData eventInformation(String eventId) {
        
        List<Id> idsOfRelatedEvents = new List<Id>();
        
        Set<Id> onlyIdsOfMainAndRelatedEvents = new Set<Id>();
        
        DateTime currentDate = DateTime.now();
        
        returnData rd = new returnData();
        
        // List of ALL event IDs need to be Queried from the input 'eventId'.
        List < Event__c > idsOfMainAndRelatedEvents = [select Id, Parent_Event__r.Id from Event__c where Parent_Event__c = :eventId or Id = :eventId];
        for(Event__c event : idsOfMainAndRelatedEvents) {
            onlyIdsOfMainAndRelatedEvents.add(event.Id);
            onlyIdsOfMainAndRelatedEvents.add(event.Parent_Event__c);
        }
        
        // Fetch all Event Details from an inputed LIST of Ids.
        List < Event__c > mainAndRelatedEventDetails = [select Id,Hide_Address_fields__c,Name, Alumni_Product__r.GL_Code__c, Alumni_Product__r.ProductCode, Alumni_Discount_Percentage__c, Can_Pay_By_wire__c, Event_Background_Image__c, Registration_Type__c, Event_Color_Palette__c, Sub_Title__c, Can_Register__c, Description__c, Cancellation_Policy__c, Program_Change__c, Events_Photography_Release__c, Last_Date_For_Registration__c, Last_Date_for_Wire_Check_Registration__c, Chapter_Meeting__c, Start_Date__c, End_Date__c, VenueName__c, Address__c, AddressMap_Image_URL__c, GL_Code__c, Product_Code__c , Invite_Only__c from Event__c where Id = :onlyIdsOfMainAndRelatedEvents];
        rd.mainAndRelatedEventDetails = mainAndRelatedEventDetails;
        
        // Fetch all EventRate Details from an inputed LIST of Ids.
        List < Event_Rate__c > eventRateDetails = [select Id, Name, Start_Date__c, Product_Member_Code__r.GL_Code__c, Product_Member_Code__r.ProductCode, Product_Non_Member_Code__r.GL_Code__c, Product_Non_Member_Code__r.ProductCode, End_Date__c, Member_Rate__c, Non_Member_Rate__c, (SELECT Id, Name, Combo_Non_Member_Product_Code__r.GL_Code__c, Combo_Non_Member_Product_Code__r.ProductCode, Combo_Member_Product_Code__r.GL_Code__c, Combo_Member_Product_Code__r.ProductCode, Combo_Event__c, End_Date__c, Is_Membership_Combo__c, Main_Event_Rate__c, Member_Rate__c, Non_Member_Rate__c, Start_Date__c, Status__c FROM Event_Combo_Rates__r) from Event_Rate__c where Event__r.id =:onlyIdsOfMainAndRelatedEvents];
        List < Event_Rate__c > currentEventRateDetails  = new List<Event_Rate__c>();        
        for(Event_Rate__c eventRate : eventRateDetails) {
            if((eventRate.Start_Date__c < currentDate) && (eventRate.End_Date__c > currentDate)){
                currentEventRateDetails.add(eventRate);
            }
        }
        
        rd.eventRateDetails = currentEventRateDetails;
        
        for(Event__c event : idsOfMainAndRelatedEvents) {
            idsOfRelatedEvents.add(event.Id);
        }
        
        if(idsOfRelatedEvents.size() > 0){
            List < cdrive__Cloud_Files__c > eventImages = [select Id, cdrive__contextID__c, cdrive__File_Name__c from cdrive__Cloud_Files__c where cdrive__contextID__c = :idsOfRelatedEvents ];
            rd.eventImages = eventImages;
        } else {
            rd.eventImages = null;
        }
        
        List<Event_Contact__c> eventContacts = [select Id, First_Name__c, Last_Name__c, Email__c from Event_Contact__c where Type__c = 'General' AND Event__c = :onlyIdsOfMainAndRelatedEvents];
        
        rd.eventContacts = eventContacts;
        
        return rd;
        
    }
    
    @RemoteAction
    public static Response.Envelope rsvpInviteOnlyDecline(String eventId, String userEmail){

        Response.Detail res = new Response.Detail();
        
        try{
                        
            Event__c event = null;
            
            List<Event__c> events = [SELECT Id, Name, Invite_Only__c,Hide_Address_fields__c, Event_Participant_Login__c, Content__r.Custom_Header__c, Content__r.Custom_Footer__c FROM Event__c WHERE Id = :eventId LIMIT 1];
            
            //Ensure the event exists and is $0.00/Invite Only
            if(events.isEmpty()){          
                res.errors = new List<String>{'Event with the ID ' + eventId + ' was not found.'};
                res.status = 404;
                return res;
            }else if(!events[0].Invite_Only__c){
                res.errors = new List<String>{'The Event ID provided is not a free event.'};
                res.status = 400;
                return res;            
            }
            
            event = events[0];
                        
            Event_Registration__c eventRegistration = null;
            
            List<Event_Registration__c> existingEventRegistrations = [SELECT Id, Contact__c, Event__c, Member_Email__c, Status__c FROM Event_Registration__c WHERE Member_Email__c = :userEmail AND Event__c = :event.Id];
            if(existingEventRegistrations.isEmpty()){    
                
                eventRegistration = new Event_Registration__c();
                
                //eventRegistration.Contact__c = contact.Id;
                eventRegistration.Event__c   = event.Id;     
                eventRegistration.Member_Email__c  = userEmail;  
                eventRegistration.Status__c = 'RSVP Decline';
                
                INSERT eventRegistration;     
                
            } else {
                    
                eventRegistration = existingEventRegistrations[0];
                eventRegistration.Status__c = 'RSVP Decline';
                
                UPDATE eventRegistration;
            }            
            
            res.data = eventRegistration;
            res.status = 200;
            return res;  
            

        }catch(Exception e){
            
            res.errors = new List<String>{e.getMessage(), e.getStackTraceString()};
            res.status = 400;
            return res;
                       
        }
        
    }
    
    
    @RemoteAction
    public static Response.Envelope createInviteOnlyEventRegistration(TempAccount wrapper){
        
        Response.Detail res = new Response.Detail();
        
        try{
            
            Id eventId          = wrapper.eventId;
            Id entityId         = wrapper.id;        
            Id accountId        = null;
            String companyName  = wrapper.Company;
            
            Event__c event = null;
            
            List<Event__c> events = [
                SELECT Id, Name, Invite_Only__c, Max_Capacity_Met__c,Hide_Address_fields__c, Event_Participant_Login__c, Content__r.Custom_Header__c, Content__r.Custom_Footer__c 
                FROM Event__c 
                WHERE Id = :eventId 
                LIMIT 1
            ];
            
            //Ensure the event exists and is $0.00/Invite Only
            if(events.isEmpty()){          
                res.errors = new List<String>{'Event with the ID ' + eventId + ' was not found.'};
                res.status = 404;
                return res;
            }else if(!events[0].Invite_Only__c){
                res.errors = new List<String>{'The Event ID provided is not a free event.'};
                res.status = 400;
                return res;            
            }
            
            event = events[0];
            
            List<Lead> leads       = [SELECT Id FROM Lead WHERE Id = :entityId LIMIT 1];
            List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Id = :entityId LIMIT 1];
            
            List<Account> relatedAccounts = [SELECT Id, Name FROM Account WHERE Customer_Company_List__c = TRUE AND Name = :companyName LIMIT 1]; 
            if(relatedAccounts.isEmpty()){
                accountId = Default_Record_References__c.getAll().get('UNMATCHED-BUSINESS-ACCOUNT').Record_Reference_ID__c;
            }else{
                accountId = relatedAccounts[0].Id;
            }
            
            Contact contact = null;
            
            if(!leads.isEmpty()){
                
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
                if(event.Event_Participant_Login__c) {
                    contact.Event_Participant__c = TRUE;
                }
                
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
            
            Event_Registration__c eventRegistration = null;
            
            List<Event_Registration__c> existingEventRegistrations = [SELECT Id, Contact__c, Event__c, Member_Email__c FROM Event_Registration__c WHERE Member_Email__c = :wrapper.Email AND Event__c = :event.Id];
            if(existingEventRegistrations.isEmpty()){    
                
                eventRegistration = new Event_Registration__c();
                
                eventRegistration.Contact__c = contact.Id;
                eventRegistration.Event__c   = event.Id;     
                eventRegistration.Member_Email__c  = contact.Email;     
                eventRegistration.Status__c = 'RSVP Accept';
                if(event.Max_Capacity_Met__c){
                    eventRegistration.Status__c = 'Waitlisted';
                }
                
                INSERT eventRegistration;     
                
            }else{
                
                eventRegistration = existingEventRegistrations[0];
                eventRegistration.Contact__c = contact.Id;
                eventRegistration.Status__c = 'RSVP Accept';
                if(event.Max_Capacity_Met__c){
                    eventRegistration.Status__c = 'Waitlisted';
                }
                
                UPDATE eventRegistration;
                
            }


            // Call ON24 for Virtual RSVP Event
            List<Event_Registration__c> eventRegistrationDetail = [SELECT Id,Event__r.ON24_Event_Id__c,Event__r.ON24_API_Key__c FROM Event_Registration__c where (Contact__c =: contact.Id and 
            Event__c =: event.Id)];   
            if(!eventRegistrationDetail.isEmpty() && eventRegistrationDetail[0].Event__r.ON24_Event_Id__c != null){
                API_Transaction__c trans = on24API.createAPITransactionRecord('event',eventRegistrationDetail[0].Id , contact.Id,
                eventRegistrationDetail[0].Event__r.ON24_Event_Id__c, eventRegistrationDetail[0].Event__r.ON24_API_Key__c);
                    if(trans != null){
                    on24API.SendRequest(null, trans.Id);
                } 
            }
            
            res.data = eventRegistration;
            res.status = 200;
            return res;  
            
        }catch(Exception e){
            
            res.errors = new List<String>{e.getMessage(), e.getStackTraceString()};
            res.status = 400;
            return res;
                       
        }
        
    }
    
    @RemoteAction
    public static Response.Envelope createContributorEventRegistration(TempAccount wrapper){
        
        Response.Detail res = new Response.Detail();
        
        try{
            
            Id eventId          = wrapper.eventId;
            Id entityId         = wrapper.id;        
            Id accountId        = null;
            String companyName  = wrapper.Company;
            
            Event__c event = null;
            String promocodesUsed = NULL;
            String registrationType = NULL;
            if(wrapper.promocodesUsed != NULL) {
                promocodesUsed = wrapper.promocodesUsed[0];
            }
            
            List<Event__c> events = [SELECT Id, Name,Hide_Address_fields__c, Invite_Only__c, Content__r.Custom_Header__c, Content__r.Custom_Footer__c FROM Event__c WHERE Id = :eventId LIMIT 1];
            if(promocodesUsed != NULL) {
                List<Event_Discount__c> lstDisc = [Select Id, Name, Discount_Code__c, Registration_Type__c from Event_Discount__c where Discount_Code__c = :promocodesUsed and Event__c = :eventId];
                if(lstDisc != NULL && lstDisc.size() > 0) {
                    registrationType = lstDisc[0].Registration_Type__c;
                }
            }
            
            //Ensure the event exists and is $0.00/Invite Only
            if(events.isEmpty()){          
                res.errors = new List<String>{'Event with the ID ' + eventId + ' was not found.'};
                res.status = 404;
                return res;
            }
            
            event = events[0];
            
            List<Lead> leads       = [SELECT Id FROM Lead WHERE Id = :entityId LIMIT 1];
            List<Contact> contacts = [SELECT Id, Name, Event_Contributor__c  FROM Contact WHERE Id = :entityId LIMIT 1];
            
            List<Account> relatedAccounts = [SELECT Id, Name FROM Account WHERE Customer_Company_List__c = TRUE AND Name = :companyName LIMIT 1]; 
            if(relatedAccounts.isEmpty()){
                accountId = Default_Record_References__c.getAll().get('UNMATCHED-BUSINESS-ACCOUNT').Record_Reference_ID__c;
            }else{
                accountId = relatedAccounts[0].Id;
            }
            
            Contact contact = null;
            
            if(!leads.isEmpty()){
                
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
                    contact = [SELECT Id, Name FROM Contact WHERE Id = :convertedLead.ConvertedContactId LIMIT 1];
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
                contact.Title               = wrapper.Title;
                contact.Company__c          = wrapper.Company;
                
                contact.Corporate_Title__c          = wrapper.Title;
                contact.Job_Function__c             = wrapper.JobFunction;
                contact.Risk_Specialty__c           = wrapper.RiskSpecialty;
                contact.Area_of_Concentration__c    = wrapper.Industry;
                
                contact.Event_Contributor__c = TRUE;
                
                // Assign MC Unique ID
                contact.MC_Unique_Id__c = lead.id;   
                
                UPDATE contact;
                
                // Move Form Data
                Utilities.migrateLeadFormDataToContact(lead.id, contact.Id, wrapper.formName, null);  
                
            } else if(!contacts.isEmpty()){
                
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

                contact.Event_Contributor__c = TRUE;
                
                UPDATE contact;

                // Move Form Data
                Utilities.migrateLeadFormDataToContact(null, contact.Id, wrapper.formName, null);
                  
            }else{
                
                res.errors = new List<String>{'No Lead or Contact exists for the individual attempting to register.'};
                res.status = 404;
                return res;  
                 
            }
            
            Event_Registration__c eventRegistration = null;
            
            List<Event_Registration__c> existingEventRegistrations = [SELECT Id, Contact__c, Event__c FROM Event_Registration__c WHERE Contact__c = :contact.Id AND Event__c = :event.Id];
            if(existingEventRegistrations.isEmpty()){    
                
                eventRegistration = new Event_Registration__c();
                
                String regName = contact.Name + ' / ' + event.Name;
                if(regName.length() > 80) {
                    eventRegistration.Name = regName.substring(0, 80);        
                } else {
                    eventRegistration.Name = regName;        
                }
                eventRegistration.Contact__c = contact.Id;
                eventRegistration.Event__c   = event.Id; 
                
                if(promocodesUsed != NULL) {
                    eventRegistration.Discount_Code_Used__c = promocodesUsed;
                }
                
                eventRegistration.Member_Email__c = wrapper.Email;
                
                eventRegistration.Attendee_Type__c = 'Contributor';
                if(registrationType != NULL) {
                    eventRegistration.Registration_Type__c = registrationType;
                }
                eventRegistration.Status__c = 'Registered and Paid';
                
                INSERT eventRegistration;     
                
            }else{
                
                eventRegistration = existingEventRegistrations[0];
                
            }
            
            res.data = eventRegistration;
            res.status = 200;
            return res;  
            
        }catch(Exception e){
            
            res.errors = new List<String>{e.getMessage(), e.getStackTraceString()};
            res.status = 400;
            return res;
                       
        }
        
    }    
    
}