global without sharing class sfdcAppRemoter {
    
    public String accountName { get; set; }
    public String accountEmail { get; set; }
    public static Account account { get; set; }
    public String startURL { get; set; }
    public String Examattemptid {get; set;}
    
    public String contactIdLoad { get; set; }
    public String retJobs { get; set; }
    
    global class appData {  
        public string name { get; set; }
        public string phone { get; set; }
    }
    
    global class fieldInfo {
        public string name { get; set; }
        public string type { get; set; }        
        public string label { get; set; }  
        public string description { get; set; }  
        public List<String> pickList { get; set; }   
        public string value { get; set; }  
        public Long epochValue { get; set; } 
        public string refValue { get; set; }  
        public string refOtherField { get; set; }  
        public integer order { get; set; }  
        public integer maxLength { get; set; }
        public boolean isCalculated { get; set; }
        public boolean isNillable { get; set; }
        public boolean readOnly { get; set; }
        public boolean hidden { get; set; }
        public boolean multiSelect { get; set; }
        
    }
    
    global class returnData {
        public List<sObject> recordData { get; set; }
        public Map<string,fieldInfo > fields { get; set; }
    }    
    
    global class groupFileReturnData {
        public List<ContentDocumentLink> lstCDL { get; set; }
        public List<ContentDocument> lstCD { get; set; }
        public List<ContentVersion> lstCV { get; set; }
    }    
    
    global class getUserReturnData {
        public List<User> userData { get; set; }
        public List<Contact> contactData { get; set; }
        public List<Experience> experienceData { get; set; }
        public List<Account> accountData { get; set; }
        public List<Opportunity> opportunityData { get; set; }
        public List<Product_Refunds__c> refundData { get; set; }
        public List<ChargentSFA__Payment_Request__c> paymentRequestData  { get; set; }
        public List<ChargentSFA__Transaction__c> transactionData  { get; set; }        
        public List<ChargentSFA__Email_Notification__c> emailNoteData  { get; set; }        
        public List<PricebookEntry> priceBookEntryData { get; set; }
        public List<Product2> productData { get; set; }
        public List<Exam_Attempt__c> examAttemptData { get; set; }
        public List<Room__c> examRoomData { get; set; }
        public List<Venue__c> venueData { get; set; }
        //public List<Exam_Result__c> examResultsData { get; set; }
        public List<Contract> contractData { get; set; }
        public List<Candidate_Requirement__c> candidateRequirementData { get; set; }                                
        public List<RecordType> candidateRequirementRecordTypes { get; set; }
        public List<RecordType> contractRecordTypes { get; set; }
        public List<CPE_Claim__c> claimsData { get; set; }
        public List<CPE_Activity_Type__c> activityTypeData { get; set; }
        public List<Account> providerData { get; set; }
        public List<Account> customerCompanyData { get; set; }
        public List<CollaborationGroup> collaborationGroupsData { get; set; }
        public List<Chapter__c> chaptersData { get; set; }
        public List<Chapter_Member__c> chapterDirectorData { get; set; }
        public List<Chapter_Member__c> chapterMemberData { get; set; }
        public List<Chapter_Meeting__c> chapterMeetingData { get; set; }
        public List<Chapter_Meeting_Speaker__c> chapterMeetingSpeakerData { get; set; }
        public List<Chapter_Meeting_Registration__c> chapterMeetingRegistrationData { get; set; }
        public List<Exam_Group__c> examGroupData { get; set; }
        public Exam_Group__c scrExamGroupData { get; set; }
        public Exam_Group__c frrExamGroupData { get; set; } 
        public List<Exam_Sites__c> examSitesData { get; set; }   
        //public List<Proctor_Registration__c> proctorRegistrationData { get; set; }
        public List<SME_Registration__c> smeRegistrationData { get; set; }
        public List<Event_Registration__c > eventRegistrationData { get; set; }
        public List<Webcast_Registration__c > webcastRegistrationData { get; set; }        
        public Board_Election__c boardElectionData { get; set; }
        public List<RecordType> contentRecordTypeData { get; set; }
        public List<Membership_Exclusive_Offers__c> membershipOffersData { get; set; }
        public List<eBook_Key__c> eBookData {get;set;}
        public Decimal NJtax {get;set;}
        public Map<String,Mobius_Products__c> mobiusProductConfig {get;set;}
        public List<EPP_Account__c> eppAccountData { get; set; }
        public List<Member_Notification_Recipient__c> examAlerts  { get; set; }
    }    
    
    public  class getExperienceData {
        public id contactid { get; set; }
        public id Accountid { get; set; }
        public string Accountname { get; set; }
        public string ExperienceType { get; set; }
        public string Title { get; set; }
        public string JobDescription { get; set; }
        public Date Enddate { get; set; }
        public Date StateDate { get; set; }
        
    }
    
    public class wrapperProductInfo
    {
        public string strProductCode {get;set;}
        public string strProductName {get;set;}
        public string strGLCode {get;set;}
        public string strDisplayName{get;set;}
        public boolean bFRMActivated{get;set;}
        public boolean bERPActivated{get;set;}
        public boolean bFRM1Deffered{get;set;}
        public boolean bFRM2Deffered{get;set;}
        public boolean bERPDeffered{get;set;}
        public boolean bERP1Deffered{get;set;}
        public boolean bERP2Deffered{get;set;}
        public boolean bFRM1UnDeffered{get;set;}
        public boolean bFRM2UnDeffered{get;set;}
        public boolean bERPUnDeffered{get;set;}
        public boolean bERP1UnDeffered{get;set;}
        public boolean bERP2UnDeffered{get;set;}
        public boolean bFRMSwitch{get;set;}
        public boolean bERPSwitch{get;set;}
        public String strFRMOneBookProdCode{get;set;}
        public String strFRMOneBookGLCode{get;set;}
        public decimal dFRMOneBookAmount{get;set;}
        public String strFRMTwoBookProdCode{get;set;}
        public String strFRMTwoBookGLCode{get;set;}
        public decimal dFRMTwoBookAmount{get;set;}
        public String strFRMOneEnrollmentProdCode{get;set;}
        public String strFRMOneEnrollmentGLCode{get;set;}
        public decimal dFRMOneEnrollmentAmount{get;set;}
        public decimal examPrice{get;set;}
        public String strERPBookProdCode{get;set;}
        public String strERPBookGLCode{get;set;}
        public decimal dERPBookAmount{get;set;}
        public String strERPEnrollmentProdCode{get;set;}
        public String strERPEnrollmentGLCode{get;set;}
        public decimal dERPEnrollmentAmount{get;set;}
        public string strFCBRMemberProdCode{get;set;}
        public string strFCBRNonMemberProdCode{get;set;}
        public string strFCBRMemberGlCode{get;set;}
        public string strFCBRNonMemberGlCode{get;set;} 
        public decimal dFCBRMemberExamAmt{get;set;}
        public decimal dFCBRNonMemberExamAmt{get;set;}
        public string strCBRMemberProdCode{get;set;}
        public string strCBRNonMemberProdCode{get;set;}
        public string strCBRMemberGlCode{get;set;}
        public string strCBRNonMemberGlCode{get;set;}
        public decimal dCBRMemberExamAmt{get;set;}
        public decimal dCBRNonMemberExamAmt{get;set;}
        public string strMemberProdCode{get;set;}
        public string strMemberGLCode{get;set;}
        public decimal dMemberAmt{get;set;}
        public string strWileyProdCode{get;set;}
        public string strWileyGLCode{get;set;}
        public string strRiskNetProdCode{get;set;}
        public string strRiskNetGLCode{get;set;}
        public string strIndividualProdCode{get;set;}
        public string strIndividualGLCode{get;set;}        
        public string strAffiliateGLCode{get;set;}
        public string strAffiliateProdCode{get;set;}
        public string strTaxGLCode{get;set;}
        public string strTaxProdCode{get;set;}
        public string strCanadianTaxGLCode{get;set;}
        public string strCanadianTaxProdCode{get;set;}
        public string strShippingGLCode{get;set;}
        public string strShippingProdCode{get;set;}
        public string strFreeIndividualProdCode{get;set;}
        public string strFreeIndividualGLCode{get;set;} 
        public string strDeferredPaymentGLCode{get;set;}
        public string strDeferrePaymentProdCode{get;set;}
    }
    
    global class productData {
        public List<Product2> product { get; set; }
        public List<PricebookEntry> price { get; set; }
        public List<Content__c> content { get; set; } 
    }
    
    global class productItems {
        public Product2 product { get; set; }
        public PricebookEntry price { get; set; }
    }
    
    global class contentSuggestionData { 
        public List<contentData> topDocs { get; set; }
        public List<contentData> alsoViewed { get; set; }
    }    
    
    global class contentData {
        public Content__c content { get; set; }
        public Attachment attachment { get; set; }
        public List<Related_Content__c> related_content { get; set; }
        public String memberTypeRequiredForAccess { get; set; }
        Integer rank { get; set; }
    }    
    
    global class purchaseData {
        public String Id { get; set; }
        public String Price { get; set; }
    }
    
    global class purchaseCodeData {
        public String prodCode { get; set; }
        public String glCode { get; set; }
        public String price { get; set; }
        public String description { get; set; }
        public Integer months { get; set; }
        public Integer quantity { get; set; }
        public String paymentMethod { get; set; }
    }
    
    
    global class addressData {
        public String Address_1 { get; set; }
        public String Address_2 { get; set; }
        public String Address_3 { get; set; }
        public String City { get; set; }
        public String State_Provence { get; set; }
        public String Postal_Code { get; set; }
        public String Country { get; set; }
    }
    
    global class searchResults {
        public List<Contact> lstContact { get; set; }
        public List<User> lstUser { get; set; }        
        public Integer pages  { get; set; }
    }
    
    public class wrapperChapterMemberDetails
    {
        public Chapter_Member__c chapterMember { get; set; }
        public User user { get; set; }
    }
    
    public class wrapperChapterMeetingDetails
    {
        public Chapter_Meeting__c chapterMeeting { get; set; }
        public Integer registrationCount { get; set; }
        public List<wrapperChapterMemberDetails> chapterMembers { get; set; }
        public List<Chapter_Meeting_Speaker__c> speakers { get; set; }
        public Boolean isAutenticated { get; set; }
    }
    
    public class productList {
        public String GLCode { get; set; }
        public String price { get; set; }
        public String ProductCode { get; set; }
        public String description { get; set; }
    }
    
    public class CPEActivitiesWrapper {
        public List<CPE_Activity__c> activities { get; set; }
        public List<Account> accounts { get; set; }
    }
    
    global class dailyOrdersWrapper { 
        public List<Daily_Orders__c> lstDO { get; set; }
        public List<Daily_Orders__c> lstFRR { get; set; }
    }
    
    private static Id getNetworkID() {
        Network net = [select Id, Name from Network where name = 'My GARP'];
        return net.Id;
    }
    
    public class applicationException extends Exception {}
    
    public class sObjectFieldProperties{
        
        public String   label       { get; set; }
        public String   name        { get; set; }
        public String   type        { get; set; }
        public Object   value       { get; set; }
        public String   helpText    { get; set; }
        public Boolean  required    { get; set; }
        public Integer  maxlength   { get; set; }
        public List<Schema.PicklistEntry> picklistValues { get; set; }
        
    }
    
    public MAP<String,String> mapPublicFields { get; set; }
    
    public sfdcAppRemoter() { 
        
        List<User> users = [SELECT Id, ContactId, Email FROM User WHERE Id = :UserInfo.getUserId()];
        
        if(!users.isEmpty()) {           
            List<Contact> contacts = [SELECT Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c,Email FROM Contact WHERE Id = :users[0].ContactId];
            if( contacts != null && contacts.size() > 0 ) {            
                accountEmail = contacts[0].Email;
            }
        }     
        
    }
    
    public static Boolean verifyPublicField(String objectType, String field) {
        MAP<String,String> mapPublicFields = new MAP<String,String>();
        
        mapPublicFields.put('Email_GARP_Updates__c','Contact');                        
        mapPublicFields.put('Email_Member_Update__c','Contact');   
        mapPublicFields.put('Exam_Prep_Provider_Outreach__c','Contact');                      
        mapPublicFields.put('Email_FRM__c', 'Contact');
        mapPublicFields.put('Email_ERP__c', 'Contact');
        mapPublicFields.put('Email_Webcasts__c', 'Contact');
        mapPublicFields.put('Email_Events__c', 'Contact');
        mapPublicFields.put('Email_Chapter_Meetings__c', 'Contact');
        mapPublicFields.put('Email_The_Week_in_Risk__c', 'Contact');
        mapPublicFields.put('Email_Daily_News__c','Contact');
        mapPublicFields.put('Email_Information_Exchange__c','Contact');
        mapPublicFields.put('Email_InsightAnalysis__c','Contact');
        mapPublicFields.put('Email_CPE_News__c','Contact');
        mapPublicFields.put('Email_Career_Center_Job_Board__c','Contact');
        mapPublicFields.put('Email_CorporateTeamBuilding__c','Contact');
        mapPublicFields.put('Email_Subscription_Change_Source__c','Contact');
        mapPublicFields.put('SCR_Updates__c','Contact'); 
        
        mapPublicFields.put('First_Name__c','SME_Registration__c');
        mapPublicFields.put('Last_Name__c','SME_Registration__c');
        mapPublicFields.put('Phone__c','SME_Registration__c');
        mapPublicFields.put('Email__c','SME_Registration__c');
        mapPublicFields.put('Technology__c','SME_Registration__c');
        mapPublicFields.put('Operational__c','SME_Registration__c');
        mapPublicFields.put('Market_Risk__c','SME_Registration__c');
        mapPublicFields.put('Energy__c','SME_Registration__c');
        mapPublicFields.put('Culture_Governance__c','SME_Registration__c');
        mapPublicFields.put('Credit_Risk__c','SME_Registration__c');
        mapPublicFields.put('Publishing_Experience__c','SME_Registration__c');
        mapPublicFields.put('Teaching_Experience__c','SME_Registration__c');
        mapPublicFields.put('Expert_Participation__c','SME_Registration__c');
        
        
        String fnd = mapPublicFields.get(field);
        if(fnd == null || fnd != objectType)
            return false;
        return true;
    }
    
    @RemoteAction
    public static string getSessionId() {
        return UserInfo.getSessionId();
    }
    
    @RemoteAction
    public static void createON24EngagementHubRegistration(){
        Id userId = UserInfo.getUserId();
        
        List<User> users = [SELECT Id, ContactId, AccountId FROM User WHERE Id = :userId];
        if(users != null && !users.isEmpty()){
            on24API.createON24EngagementHubRegistration(users[0].ContactId);
        }
    }
    
    @RemoteAction
    public static Response.Detail submitRequiredOstaInformation(String jsonString, Id opportunityId){
        try{
            
            Id userId = UserInfo.getUserId();
            
            List<User> users = [SELECT Id, ContactId, AccountId FROM User WHERE Id = :userId];
            
            if(users == null || users.isEmpty()){
                return new Response.Detail('Could not locate user.', 404, new List<Object>{'Could not locate user.'});
            }
            
            User user = users[0];
            
            List<Opportunity> opportunities = [
                SELECT Id, OSTA_Check__c, Amount, ChargentSFA__Transaction_Total__c, StageName
                FROM Opportunity
                WHERE Id = :opportunityId AND AccountId = :user.AccountId
            ];
            
            if(opportunities.isEmpty()){
                return new Response.Detail('Could not locate order.', 404, new List<Object>{'Could not locate order.'});
            }
            
            Contact contact = (Contact)JSON.deserialize(jsonString, Contact.class);
            contact.Id = user.ContactId;
            UPDATE contact;
            
            Opportunity opportunity = opportunities[0];
            opportunity.OSTA_Check__c = false;
            
            // Close order if it is $0
            FINAL Decimal amount = opportunity.Amount - opportunity.ChargentSFA__Transaction_Total__c;
            if(opportunity.StageName == 'New Lead' && amount == 0){
                opportunity.StageName = 'Closed';
            }
            
            UPDATE opportunity;
            
            Response.Detail res = new Response.Detail();
            
            res.data = contact;
            res.status = 200;
            res.message = 'Contact updated successfully.';
            
            return res;
            
        }catch(Response.ResponseException e){
            
            return new Response.Detail(e.getMessage(), e.status, e.errors);
            
        }catch(Exception e){
            
            return new Response.Detail(null, 400, new List<Object>{e.getMessage(), e.getLineNumber(), e.getStackTraceString()});
            
        }
    }
    
    @RemoteAction
    public static Boolean confirmProfileInformation(Id contactId){
        List<Contact> contacts = [SELECT Id, Profile_Information_Confirmed_Date_Time__c FROM Contact WHERE Id = :contactId];
        if(!contacts.isEmpty()){
            Contact contact = contacts[0];
            if(contact.Profile_Information_Confirmed_Date_Time__c == null){
                contact.Profile_Information_Confirmed_Date_Time__c = Datetime.now();
                UPDATE contact;
            }
            return true;
        }else{
            return false;
        }
    }
    
    @RemoteAction
    public static Boolean updateCampaignStatus(String contactID, String campaignName, String status){
        
        List<Campaign> lstCamp = [select Id, Name from Campaign where Name = :campaignName];
        if(lstCamp != NULL && lstCamp.size() > 0) {
            
            List<CampaignMember> lstCM = [select Id, Name, ContactID, CampaignID, Status from CampaignMember where ContactID = :contactID AND CampaignID = :lstCamp[0].Id];
            if(lstCM != NULL && lstCM.size() > 0) {
                lstCM[0].Status = status;
                update lstCM;
                return true;
            }
        }
        return false;
    }
    
    @RemoteAction
    public static Boolean submitErrata(String Category, String StudyMaterial, String Message, String Book, String Solution, String PageNumber){
        Boolean status=False;
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select Id,ContactId,Email from User where Id = :userId];
        if(lstUser != NULL && lstUser.size() > 0 && lstUser[0].ContactId != NULL) {
            if(Category!=NULL && StudyMaterial!=NULL && Message!= NULL) {
                Errata__c erata = new Errata__c(Category__c=Category, Study_Material__c=StudyMaterial, Message__c=Message, Book__c=Book, Solution__c=Solution, Page_Number__c=PageNumber, Contact__c=lstUser[0].ContactId);
                insert erata;
                status=true;
            }
        }        
        return status;               
    }
    
    @RemoteAction
    public static mobiusAPI.mUserLoginResp ssoMobuisEBook(String productId){
        String userId = UserInfo.getUserId(); 
        mobiusAPI.mUserLoginResp mULResp;
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, Email from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {   
                mobiusAPI.mobiusRespWrapper wResp = mobiusAPI.mUserLogin(mobiusAPI.apiVersionGlobal,lstContact[0].Email, Integer.valueOf(productId), 0);
                System.debug('mUserLogin:' + wResp);  
                mULResp = (mobiusAPI.mUserLoginResp)JSON.deserialize(wResp.response, mobiusAPI.mUserLoginResp.class);
                System.debug('mULResp:' + mULResp);        
            }
        }
        return mULResp;
    }  
    
    /*
    @RemoteAction
    public static Proctor_Registration__c saveProctorRegistration(String proctorRegistrationId, String fields){
        
        try{
            
            Map<String, Object> fieldsMap = (Map<String, Object>)JSON.deserializeUntyped(fields);
            
            Proctor_Registration__c pr = [SELECT Id FROM Proctor_Registration__c WHERE Id = :proctorRegistrationId LIMIT 1];
            
            for(Object field: fieldsMap.values()){
                
                Map<String, Object> fieldMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(field));
                
                String type = String.valueOf(fieldMap.get('type'));
                String fieldName = String.valueOf(fieldMap.get('name'));
                
                if(type == 'STRING'){
                    
                    pr.put(fieldName, String.valueOf(fieldMap.get('value')));
                    
                }else if(type == 'BOOLEAN'){
                    
                    pr.put(fieldName,  Boolean.valueOf(fieldMap.get('value')));
                    
                }else if(type == 'PICKLIST'){
                    
                    pr.put(fieldName, String.valueOf(fieldMap.get('value')));
                    
                }else if(type == 'PHONE'){
                    
                    pr.put(fieldName,  String.valueOf(fieldMap.get('value')));
                    
                }else if(type == 'ENCRYPTEDSTRING'){
                    
                    pr.put(fieldName,  String.valueOf(fieldMap.get('value')));
                    
                }
                
            }
            
            UPDATE pr;
            
            return pr;
            
        }catch(Exception e){
            
            return null;
            
        }
        
    }
    */
    
    @RemoteAction
    public static List<Map<String, sObjectFieldProperties>> getSObjectFieldsWithMetadata(String sObjectName, String fields, String predicate, String operator, String parameter){
        
        String query = 'SELECT ' + fields + ' FROM ' + sObjectName;
        if(predicate != null && operator != null && parameter != null){
            query += ' WHERE ' + predicate + ' ' + operator + ' \'' + parameter + '\'';
        }
        
        List<sObject> sObjects = new List<sObject>(Database.query(query));
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        
        List<Map<String, sObjectFieldProperties>> dataset = new List<Map<String, sObjectFieldProperties>>();
        
        for(sObject so: sObjects){
            
            Map<String, Object> unformatted = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(so));
            
            Map<String, Object> keyValues = new Map<String, Object>();            
            for(String key: unformatted.keySet()){
                Object data = unformatted.get(key);
                keyValues.put(key.toLowerCase(), data);
            }
            
            for(String key: fields.split(',')){
                if(keyValues.containsKey(key.trim().toLowerCase())) continue;
                keyValues.put(key.trim().toLowerCase(), null);
            }
            
            System.debug(keyValues);
            
            Map<String, sObjectFieldProperties> fieldMetadataMap = new Map<String, sObjectFieldProperties>();
            
            for(String fieldName: fields.split(',')){
                
                fieldName = fieldName.trim().toLowerCase();
                
                if(keyValues.containsKey(fieldName) && fieldName != 'recordtypeid' && fieldName != 'currencyisocode' && fieldName != 'id'){
                    
                    sObjectFieldProperties sofp = new sObjectFieldProperties();
                    
                    Schema.DescribeFieldResult described = fieldMap.get(fieldName).getDescribe();
                    
                    sofp.label      = described.getLabel();
                    sofp.name       = described.getName();
                    sofp.helpText   = described.getInlineHelpText();
                    sofp.required   = described.isNillable();
                    sofp.maxlength  = described.getLength(); 
                    
                    sofp.type       = String.valueOf(described.getType());
                    sofp.value      = String.valueOf(keyValues.get(fieldName));                  
                    
                    if(sofp.type == 'CURRENCY'){
                        sofp.value          = Integer.valueOf(keyValues.get(fieldName));
                    }
                    
                    if(sofp.type == 'BOOLEAN'){
                        sofp.value          = Boolean.valueOf(keyValues.get(fieldName));
                    }
                    
                    if(sofp.type == 'PICKLIST'){
                        sofp.picklistValues = fieldMap.get(fieldName).getDescribe().getPicklistValues();
                        sofp.value          = String.valueOf(keyValues.get(fieldName));
                    }
                    
                    fieldMetadataMap.put(sofp.name, sofp);  
                    
                }
                
            } 
            
            dataset.add(fieldMetadataMap);
            
        }
        
        return dataset;
        
    }
    /*
    @RemoteAction
    public static Proctor_Registration__c setProctorRegistrationStatus(String proctorRegistrationId, String status){
        
        if(proctorRegistrationId != null && status != null){
            
            Proctor_Registration__c pr = [SELECT Id, Status__c, Completed__c FROM Proctor_Registration__c WHERE Id = :proctorRegistrationId LIMIT 1];
            
            pr.Status__c = status;
            
            if(pr.Status__c == 'Completed'){
                pr.Completed__c = TRUE;
            }
            
            UPDATE pr;
            
            return pr;
            
        }
        
        return null;
        
    }
    */
    public class returnWebcastInformation {
        public List < Webcast__c > webcastInformation { get; set; }
        public List < Presenter__c > presentersAtWebcast { get; set; }
        public List < String  > allWebcastParticipantsMediaURLs { get; set; }
    } 
    
    @RemoteAction
    public static GARP_BC_Webcasts.returnWebcastInformation getWebcastInformation(String webcastId){
        return GARP_BC_Webcasts.getWebcastInformation(webcastId);
    }
    
    @RemoteAction
    public static EventRegistration.returnAllEventData getAllEventInformation(String eventId){
        return EventRegistration.getAllEventInformation(eventId);   
    }
    
    @RemoteAction
    public static Contact getCommunitiesConsent(){
        //  List < Contact > lstContact;
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            String contactId = lstUser[0].ContactId;
            List<Contact> lstContact = [SELECT Id, Name, HL_Code_of_Conduct_Consent__c FROM Contact WHERE Id = :contactId];
            return lstContact[0];
        } else {
            return null;
        }
    }
    
    @RemoteAction
    public static Set < String > getChinaFeeSites(){
        
        Set<String> allSites = new Set<String>();
        
        List<Exam_Sites__c> listOfChinaFeeSites = [
            SELECT Site__r.Name, Site__r.Active__c, Country__c
            FROM Exam_Sites__c 
            WHERE (NOT Site__r.Name LIKE '%HONG KONG%') AND Country__c = 'China' AND Site__r.Active__c = true
        ];
        
        for(Exam_Sites__c eachExamSite: listOfChinaFeeSites){
            allSites.add(eachExamSite.Site__r.Name);
        }
        
        return allSites;
        
    }
    
    @RemoteAction
    public static Contact persistCommunitiesConsent(){
        //  List < Contact > lstContact;
        datetime myDateTime = datetime.now();
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            String contactId = lstUser[0].ContactId;
            List<Contact> lstContact = [SELECT Id, Name, HL_Code_of_Conduct_Consent__c FROM Contact WHERE Id = :contactId];
            // lstContact[0].HL_Code_of_Conduct_Consent__c = myDateTime;
            lstContact[0].put('HL_Code_of_Conduct_Consent__c',myDateTime); 
            UPDATE lstContact[0];
            return lstContact[0];
        } else {
            return null;
        }
    }
    
    @RemoteAction
    public static EventRegistration.returnData getEventInformation(String eventId){
        return EventRegistration.eventInformation(eventId);   
    }
    
    @RemoteAction
    public static List<Opportunity> getOpportunityByContactId(String contactId){
        //        1. Get the Account Number
        List<Opportunity> opportunitiesByContact = new List<Opportunity>();
        
        List < Contact > userContact = [SELECT Name, AccountId FROM Contact where (Id = :contactId)]; 
        
        if(!userContact.isEmpty()){
            //       2. Fetch Opportunities by the account number ONLY for the event
            String accountNumber = userContact[0].AccountId;
            opportunitiesByContact = [select Id, Name, (SELECT Id, Event__c, Event__r.Name, Event__r.Can_Pay_By_wire__c, Event__r.Registration_Type__c, Event__r.Event_Color_Palette__c, Event__r.Sub_Title__c, Event__r.Can_Register__c, Event__r.Description__c, Event__r.Cancellation_Policy__c, Event__r.Program_Change__c, Event__r.Events_Photography_Release__c, Event__r.Last_Date_For_Registration__c, Event__r.Last_Date_for_Wire_Check_Registration__c, Event__r.Start_Date__c, Event__r.End_Date__c, Event__r.Address__c, Event__r.AddressMap_Image_URL__c, Event__r.CurrencyIsoCode FROM OpportunityLineItems where Event__c != NULL) from Opportunity where (AccountId = :accountNumber and Name = 'Event Registration')];
        }    
        
        return opportunitiesByContact;    
    }
    
    @RemoteAction
    public static EventRegistration.conventionReturnData getCurrentConventionInformation(){
        return EventRegistration.getCurrentConventionInformation();   
    }
    
    public class returnGetPortalAds {
        public List < Content__c > returnPortalAds { get; set; }
    } 
    
    @RemoteAction
    public static returnGetPortalAds getPortalAds(){
        returnGetPortalAds rd = new returnGetPortalAds();
        List < Content__c > portalAdsContent = new List< Content__c >();
        DateTime currentDate = DateTime.now();
        List<Id> idsOfPortalAds = new List<Id>();
        List < Content__c > portalAds = [SELECT Name, External_ID__c, Start_Date__c, End_Date__c, Image__c, Btn1_Styling__c, Content_Name__c, Tagline__c, Label__c, Description__c, Btn1__c, Btn1_Class__c, Btn1_Link__c, Visibility_Convention_Alumni__c, Third_Party_URL__c, Raw_HTML__c FROM Content__c where (Is_advertisement__c = true and Ad_Format__c = 'User Portal')]; 
        Integer portalAdsSize = portalAds.size();
        
        if(portalAdsSize > 0){
            for(Content__c ad : portalAds) {
                if((ad.Start_Date__c < currentDate) && (ad.End_Date__c > currentDate)){
                    portalAdsContent.add(ad);
                    idsOfPortalAds.add(ad.Id);
                }
            } 
        }
        
        List<cdrive__Cloud_Files__c> lstCloudFiles = [select Id, cdrive__contextID__c, cdrive__File_Name__c from cdrive__Cloud_Files__c where cdrive__contextID__c in :idsOfPortalAds];
        MAP<String,cdrive__Cloud_Files__c> mapCloudFiles = new MAP<String,cdrive__Cloud_Files__c>();
        for(cdrive__Cloud_Files__c cf :lstCloudFiles) {
            mapCloudFiles.put(cf.cdrive__contextID__c + '~' + cf.cdrive__File_Name__c, cf);
        }
        
        if(lstCloudFiles != null && lstCloudFiles.size() > 0) {
            for(Content__c cont :portalAdsContent) {
                cdrive__Cloud_Files__c fnd = mapCloudFiles.get(cont.id + '~' + cont.Image__c);
                if(fnd != null) {
                    cont.Image__c = 'https://s3-us-west-2.amazonaws.com/garpsalesforcepublic/Content__c/' + cont.Id + '/' + fnd.Id + '_' + cont.Image__c;
                }
            }
        } 
        rd.returnPortalAds = portalAdsContent;
        return rd;
    }
    
    @RemoteAction
    public static EventRegistration.returnDiscountCodeData confirmDiscountCode(String promocode, String eventId){
        return EventRegistration.confirmDiscountCode(promocode, eventId);   
    }
    
    @RemoteAction
    public static Boolean isUserAnAlumni(String email){
        return Registration.isUserAnAlumni(email);   
    }
    
    @RemoteAction
    public static SearchDirectory.searchResults getDirectorySearchResults(Boolean frmOnly, Boolean erpOnly, Boolean scrOnly, String searchText, String industries, String jobFunctions, String riskSpecialties, String corporateTitles, String company, String sortField, String sortOrder, Integer pageSize, Integer pageCurrent){
        return SearchDirectory.searchcontacts(frmOnly, erpOnly, scrOnly, searchText, industries, jobFunctions, riskSpecialties, corporateTitles, company, sortField, sortOrder, pageSize, pageCurrent);   
    }
    
    @RemoteAction
    public static List<Account> getAllCustomerCompanies(){
        return [SELECT Name FROM Account where Customer_Company_List__c=true];   
    }
    
    @RemoteAction
    public static BOTElection.returnelectionCandidates getBoardOfTrusteesElectionCandidates(String contactId){
        return BOTElection.electionCandidates(contactId);   
    }
    
    //   @RemoteAction
    //   public static chapterMeetingPromoCode.returnChapterMeetingPromoCodePrice getPromoCodeForChapterMeetingEvent(String chapterMeetingID, String promoCode){
    //       return chapterMeetingPromoCode.getpromoCodeForChapterMeetingEvent(chapterMeetingID, promoCode);  
    //   }
    
    @RemoteAction
    public static BOTElection.returnVotingResponse voteForBoardElectionCandidates(LIST<String> listOfIds, String voter, String boardYear){
        String userId = UserInfo.getUserId(); 
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {   
                return BOTElection.voteForElectionCandidates(listOfIds, lstContact[0].Id, boardYear);    
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
    
    @RemoteAction    
    public static Boolean updateUserEmail(String emailAddress) {
        
        String userId = UserInfo.getUserId();
        
        User user = null;            
        List<User> users = [
            SELECT Id, Name, Email, ContactId, AccountId, Contact.GARP_Member_ID__c,  Contact.Email, Username 
            FROM User 
            WHERE Id = :userId OR Email = :emailAddress
        ];
        
        for(User u :users) {
            if(u.Name != 'GARP Membership' && u.Id == userId) { 
                user = u; 
            }
        }
        
        if(user != null && users.size() == 1) {
            
            user.Email = emailAddress;
            user.Username = emailAddress;
            
            UPDATE user;
            
            return true;
            
        }
        
        return false;
        
    }
    
    @RemoteAction    
    public static List<GBI_Update__c> fetchAllUpdates() {
        return [select Id, Name from GBI_Update__c];
    }
    
    @RemoteAction    
    public static List<Membership_Exclusive_Offers__c> getOffers() {
        return [select Id, Name, Memb_Offer_Description__c, Memb_Offer_External_Link__c, Memb_Offer_Hashtag__c, Memb_Offer_Logo__c, Memb_Offer_Promo_Code__c, Memb_Offer_Status__c, Memb_Offer_Public_Button_Text__c, Memb_Offer_Portal_Route__c from Membership_Exclusive_Offers__c];
    }
    
    @RemoteAction    
    public static List<Exam_Attempt__c > getExamResults(String examAttemptId) {
        User vUser = utilities.verifyLoggedInUser();
        return [
            SELECT 
            Id, 
            Name, 
            Cancelled__c,
            Opportunity__r.StageName,
            Attending_Exam_Name__c, 
            Other_Exam_Registrations__r.hasViolation__c, 
            Section__c,
            Section_Exam_Name__c, 
            Result__c, 
            Exam_Date__c, 
            Category_1__c, 
            hasViolation__c, 
            Quartile_1__c, 
            Category_2__c, 
            Quartile_2__c, 
            Category_3__c, 
            Quartile_3__c, 
            Category_4__c, 
            Quartile_4__c, 
            Category_5__c, 
            Quartile_5__c, 
            Category_6__c,
            Quartile_6__c, 
            Category_7__c, 
            Quartile_7__c, 
            Category_8__c, 
            Quartile_8__c, 
            Category_9__c, 
            Quartile_9__c,
            Re_score_Status__c,
            RPT_Exam_Mode__c,
            Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c,
            Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c,
            RPT_Administration_Month__c,
            RPT_Administration_Year__c,
            RPT_Exam_Program__c,
            RPT_Exam_Part__c,
            Hide_Exam_Result__c
            FROM Exam_Attempt__c 
            WHERE 
            Id = :examAttemptId AND 
            Member__c = :vUser.ContactId AND
            Result__c != null AND
            ((
                Exam_Administration__r.Exam_Results_Loading__c = FALSE AND
                Exam_Administration__r.Exam_Results_Release_Date__c != NULL AND
                Exam_Administration__r.Exam_Results_Release_Date__c <= TODAY
            ) OR (
                Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c = FALSE AND
                Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c != NULL AND
                Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c <= TODAY
            ))
        ];
        
    }
    
    @RemoteAction    
    public static Registration.verifyBulkOrderReturnData verifyBulkOrder(TempAccount objData) {
        return Registration.verifyBulkOrder(objData);
    }
    
    @RemoteAction    
    public static Registration.bulkOrderReturnData getBulkOrders(String promoCode) {
        return Registration.getBulkOrders(promoCode);
    }
    
    @RemoteAction    
    public static List<Content__c> getJobs() {
        Id recId = RecordTypeHelper.GetRecordTypeId('Content__c','Job');
        List<Content__c> lstJobs = [select Id, Name, Description__c, Third_Party_URL__c, Location__c, Third_Party_Author__c from Content__c where RecordTypeID = :recId];
        return lstJobs;
    }
    
    // Job Wrapper for sorting
    global class JobWrapper implements Comparable {
        public Job__c job;
        
        public JobWrapper(Job__c j) {
            job = j;
        }
        
        // Compare jobs based on Display Sort Order Value
        global Integer compareTo(Object compareTo) {
            // Cast argument to JobWrapper
            JobWrapper compareToJob = (JobWrapper)compareTo;
            Integer displaySortOrderA = Integer.valueOf(job.Display_Sort_Order__c);
            Integer displaySortOrderB = Integer.valueOf(compareToJob.job.Display_Sort_Order__c);
            // 0 means they are equal
            Integer returnValue = 0;
            if (displaySortOrderA > displaySortOrderB) {
                returnValue = 1;
            } else if (displaySortOrderA > displaySortOrderB) {
                returnValue = -1;
            }
            
            return returnValue;
        }
    }
    
    @RemoteAction    
    public static List<Job__c> getHighlightedJobs() {
        List<Job__c> unsortedJobs = [SELECT Id, Title__c, Company__c, City__c, State__c, URL__c, Display_Sort_Order__c FROM Job__c WHERE Display_Sort_Order__c != null LIMIT 6];
        List<Job__c> sortedJobs = new List<Job__c>();
        
        JobWrapper[] jobWrapperList = new List<JobWrapper>();
        for (Job__c job : unsortedJobs) {
            jobWrapperList.add(new JobWrapper(job));
        }
        jobWrapperList.sort();
        for (JobWrapper sortedJob : jobWrapperList) {
            sortedJobs.add(sortedJob.job);
        }
        return sortedJobs;
    }
    
    @RemoteAction
    public static String getOneWireLocations(String location){
        
        HttpRequest req = new HttpRequest();
        req.setBody(location);
        req.setMethod('POST');
        req.setEndpoint('https://www.onewire.com/Geography/SearchCities2');
        req.setHeader('Content-Type', 'application/json');     
        
        Http http = new Http();
        return http.send(req).getBody();
        
    }
    
    @RemoteAction    
    public static String removeUserPhoto() {
        String userId = UserInfo.getUserId();
        
        User usr = [Select id, FullPhotoUrl, ContactId from User where id = :userId];
        
        List<User_Photo__c> ufs = [select id from User_Photo__c where Contact__c = :usr.ContactId];
        if(ufs != NULL && ufs.size() > 0) {
            User_Photo__c uf = ufs[0];
            list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE ParentId =: uf.Id];
            if(attachments != NULL && attachments.size() > 0) {
                delete attachments;
            }
        }
        
        Contact updateContact = [Select id, Photo_URL__c from contact where id = :usr.ContactId];
        updateContact.Photo_URL__c = NULL;
        Update updateContact;
        
        return updateContact.Photo_URL__c;
    }
    
    @RemoteAction    
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
    
    @RemoteAction
    public static List<Note> getNotes(String objectId) {
        return [select Id, Title, Body FROM Note WHERE ParentId = :objectId];
    }
    
    @RemoteAction
    public static Note setNote(String objectId, String title, String body) {
        List<Note> lstNotes = [select Id, Title, Body FROM Note WHERE ParentId = :objectId];
        if(lstNotes != null && lstNotes.size() > 0) {
            lstNotes[0].Title = title;
            lstNotes[0].Body = body;
            update lstNotes;
            return lstNotes[0];
        } else {
            Note newNote = new Note(Title=title, Body=body, ParentId=objectId);
            insert newNote;
            return newNote;
        }
    }
    
    
    @RemoteAction    
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
    
    
    @RemoteAction    
    public static Id uploadAttachmentToObject(Id attachmentId, String fileText, String fileName, String ObjectId) {
        String userId = UserInfo.getUserId();
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attachmentId];
            if(attachments.isEmpty()) {
                Attachment att = new Attachment();
                att.Body = EncodingUtil.base64Decode(fileText);
                att.Name = fileName;
                att.parentId = ObjectId;
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
    }
    
    
    
    
    @RemoteAction
    public static List<Event> getGroupEvents(String groupId) {  
        utilities.verifyGroupMembership(groupId);
        List<Group_Calendars__c> groupCals = Group_Calendars__c.getall().values();
        
        system.debug('groupCals:' + groupCals);
        
        String calendarID;
        for(Group_Calendars__c gc :groupCals) {
            if(gc.Group_ID__c == groupId)
                calendarID = gc.Calendar_ID__c;
        }
        
        system.debug('calendarID:' + calendarID);
        
        if(calendarID != null) {
            Id caledarID = groupCals[0].Calendar_ID__c;
            List<Event> evs = [SELECT Id, Subject, StartDateTime, EndDateTime FROM Event WHERE OwnerId = :calendarID];
            return evs;
        } else {
            return null;
        }
    }
    
    @RemoteAction
    public static groupFileReturnData getGroupFiles(String groupId) {  
        utilities.verifyGroupMembership(groupId);
        groupFileReturnData grd = new groupFileReturnData();
        
        List<ContentDocumentLink> lstCDL = [select Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId = :groupId];
        if(lstCDL != null && lstCDL.size() > 0) {
            grd.lstCDL = lstCDL;
            List<Id> docsIds = new List<Id>();
            for(ContentDocumentLink dc :lstCDL) {
                docsIds.add(dc.ContentDocumentId);
            }
            List<ContentDocument> lstCD = [select Id, Title from ContentDocument where Id in :docsIds];
            if(lstCD != null && lstCD.size() > 0) {
                grd.lstCD = lstCD;
                List<ContentVersion> lstCV = [select Id, Title, ExternalDocumentInfo1 from ContentVersion where ContentDocumentId in :docsIds];
                grd.lstCV = lstCV;
            }
        }
        return grd;
    }
    
    
    
    
    @RemoteAction    
    public static Id addContactAttachment(Id parentId, Id attachmentId, String fileText, String fileName) {
        list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attachmentId];
        if(attachments.isEmpty()) {
            Attachment att = new Attachment();
            att.Body = EncodingUtil.base64Decode(fileText);
            att.Name = fileName;
            att.parentId = parentId;
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
    }
    
    
    
    @RemoteAction
    public static List<Study_App_Lesson_Plan__c> getStudyTopics(String examName, String yearName) {
        List<Study_App_Lesson_Plan__c> lis =  [Select Id, Name, Description__c, Week__c, Exam__c, (Select Id, Name, Year__c, Description__c, Is_Online__c, URL__c, Chapter__c, Page_Start__c, Page_End__c, Pages__c, Book__c, Exam_Registrants_Only__c, Study_Guide_Domain__r.Name, Study_Guide_Domain__r.Area_of_Study__c, Study_Guide_Domain__r.ID__c from Study_Guide_Readings__r) 
                                               from Study_App_Lesson_Plan__c where Exam__c =: examName and Year__c = :yearName order by Week__c];
        return lis;
    }
    
    private static getUserReturnData getOppData(string OppId) {
        
        List<Opportunity> lstOpportunity = [
            SELECT Id, Name, Late_EA_Id__c, StageName, Amount, CreatedDate, Alternate_Method_of_Payment__c, Institutional_Sale__c, Program_Name__c, Program_Abbrev__c, Purchase_Date__c, LEGACY_Purchase_Date__c, Company__c, Shipping_First_Name__c, Shipping_Last_Name__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c, Shipping_E_mail__c, Shipping_Phone_No__c, Shipping_Company_Name__c,  Display_Invoice_Number__c, Renew_Membership__c, ChargentSFA__Payment_Method__c, ChargentSFA__Payment_Received__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c, ChargentSFA__Billing_Phone__c, ChargentSFA__Billing_Email__c, ChargentSFA__Billing_Company__c, ChargentSFA__Billing_Address__c, ChargentSFA__Billing_City__c, ChargentSFA__Billing_State__c, ChargentSFA__Billing_Zip__c, ChargentSFA__Billing_Country__c, ChargentSFA__Billing_Postcode__c, Switch_to_erp__c, Switch_to_frm__c, Purchase_Date_Time__c, ChargentSFA__Transaction_Total__c,
            (
                SELECT Id, ProductCode, Product2.ProductCode, Description, PricebookEntryId, Quantity, UnitPrice, SortOrder, TotalPrice FROM OpportunityLineItems
            ) 
            FROM Opportunity 
            WHERE Id = :OppId ORDER BY Purchase_Date__c
        ];
        
        getUserReturnData rd = new getUserReturnData();
        if( lstOpportunity != null && lstOpportunity.size() > 0 ) {
            
            rd.opportunityData = lstOpportunity;
            set<id> opportunityIds = new set<id>();
            set<id> productIds = new set<id>();
            for(Opportunity o :lstOpportunity){
                opportunityIds.add(o.id); 
                
                for(OpportunityLineItem ol :o.OpportunityLineItems){
                    productIds.add(ol.PricebookEntryId);
                }
            }
            List<PricebookEntry> lstPriceBookEntry = [SELECT Id, Name, Product2Id, ProductCode from PriceBookEntry where Id in :productIds];
            
            rd.priceBookEntryData = lstPriceBookEntry;
            List<Id> prods = new List<Id>();
            for(PricebookEntry pe : lstPriceBookEntry) {
                prods.add(pe.Product2Id);
            }
            
            List<Product2> lstProducts = [select Id, Name, ProductCode, GL_Code__c, Description, Image__c from Product2 where Id in :prods];
            rd.productData = lstProducts;
            
        }
        return rd;
    }    
    
    @RemoteAction
    public static Boolean restoreAMPFee(String oppId) {
        
        ID accountID = utilities.verifyUserAccount();
        
        if(oppId == null || oppId == '' || oppId == 'null')
            return false;
        
        Opportunity opp = [select Id, Name, Amount, ChargentSFA__Tokenization__c, (SELECT Id,Description,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice FROM OpportunityLineItems) from Opportunity where id = :oppId and AccountId =:accountID];
        if(opp != null) {
            PriceBookEntry pricebookEntry = [select Id, unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and product2.productcode = 'PRFEE' and product2.Gl_Code__c = '6110' and isActive = true];
            if(pricebookEntry != null) {
                
                List<OpportunityLineItem> lis = new List<OpportunityLineItem>();
                for(OpportunityLineItem ol :opp.OpportunityLineItems){
                    if(ol.PricebookEntryId == pricebookEntry.Id) {
                        ol.TotalPrice = 50;
                        lis.add(ol);
                    }
                }
                update lis;
                return true;
            }
        }            
        return false;
    }
    
    @RemoteAction
    public static Exam_Attempt__c getExamRegistration(Id examAttemptId) {
        
        User vUser = utilities.verifyLoggedInUser();
        
        Exam_Attempt__c examRegistration = [
            SELECT 
            Id, 
            Name, 
            Other_Exam_Registrations__c,
            Exam_Site__r.Name,
            Exam_Site__r.Site__c, 
            Exam_Site__r.Site__r.Name, 
            Exam_Site__c,Exam_Site__r.Exam__r.Name, 
            Exam_Site__r.Exam__r.Exam__c, 
            Exam_Site__r.Exam_Date__c, 
            Exam_Site__r.Exam__r.Exam_Date__c, 
            Exam_Site__r.Exam__r.Exam_Group__c, 
            Exam_Site__r.Exam__r.Exam_Group__r.Active__c,
            Exam_Site__r.Exam__r.Administration_Time_of_Day__c,
            Exam_Site__r.Exam_Provider__r.Name,
            Active_Integration_Data__c,
            Active_Integration_Data__r.Call_out_Status__c
            FROM Exam_Attempt__c 
            WHERE Id = :examAttemptId AND Member__c = :vUser.ContactID
        ];
        
        return examRegistration;
    }
    
    @RemoteAction
    public static List<Exam_Sites__c> getChangeExamSites(String examAttemptId) {
        
        User vUser = utilities.verifyLoggedInUser();
        
        Exam_Attempt__c ea = [
            SELECT Id, Name, Exam_Site__r.Site__c, Exam_Site__r.Site__r.Name, Exam_Site__c,Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c 
            FROM Exam_Attempt__c 
            WHERE Id = :examAttemptId AND Member__c = :vUser.ContactID
        ];
        if(ea != null) {            
            List<Exam_Sites__c> lstEs = [
                SELECT Id, Name, Site__c, Site_code__c, Site__r.Active__c, Site__r.Name, Exam__c, Exam__r.Exam__c, 
                Site__r.Is_OSTA_Information_Required__c, 
                Site__r.Is_Gender_Required__c 
                FROM Exam_Sites__c 
                WHERE 
                Exam__r.Exam__c = :ea.Exam_Site__r.Exam__r.Exam__c AND 
                Exam__c = :ea.Exam_Site__r.Exam__c AND 
                Site__r.Active__c = true
            ];
            return lstEs;
        }
        return null;
    }
    
    
    @RemoteAction
    public static Boolean setCVSubmission(String progReqId) {            
        String userId = UserInfo.getUserId(); 
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) { 
                Date now = date.today();
                Candidate_Requirement__c cr = [select Id, Name, Date_of_Ready_for_Review__c, Status__c from Candidate_Requirement__c where Id=:progReqId];
                if(cr != null) {
                    cr.Date_of_Ready_for_Review__c = now;
                    cr.Status__c = 'Ready For Review';
                    update cr;
                    return true;
                }
            }
        }
        return false;
    }
    
    @RemoteAction
    public static Boolean setNoTwoyears(String progReqId) {            
        String userId = UserInfo.getUserId(); 
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) { 
                Date now = date.today();
                Candidate_Requirement__c cr = [select Id, Name, Date_No_Two_Years__c from Candidate_Requirement__c where Id=:progReqId];
                if(cr != null) {
                    cr.Date_No_Two_Years__c = now;
                    update cr;
                    return true;
                }
            }
        }
        return false;
    }
    
    @RemoteAction    
    public static Boolean changeExamSite(String examAttemptId, String newExamSiteId) {
        
        String userId = UserInfo.getUserId(); 
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {            
                
                
                //List<Exam_Attempt__c> eas = [select Id, Name, Member__c, Defered__c, Exam_Site__r.Site__c, Exam_Site__r.Site__r.Name, Exam_Site__c,Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where Member__c = :lstContact[0].Id and Defered__c != 'Pending'];
                List<Exam_Attempt__c> eas = [select Id, Name, Member__c, Defered__c, Exam_Site__r.Site__c, Exam_Site__r.Site__r.Name, Exam_Site__c,Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where Member__c = :lstContact[0].Id];
                Id examGroupId = null;
                Exam_Attempt__c inEA = null;
                for(Exam_Attempt__c ea: eas) {
                    if(ea.Id == examAttemptId) {
                        examGroupId = ea.Exam_Site__r.Exam__r.Exam_Group__c;
                        inEA = ea;
                    }
                }
                
                List<Exam_Sites__c> lstEs = [select Id, Name, Site__c, Site__r.Active__c, Site__r.Name, Exam__c, Exam__r.Exam__c from Exam_Sites__c where Exam__r.Exam__c = :inEA.Exam_Site__r.Exam__r.Exam__c and Exam__c = :inEA.Exam_Site__r.Exam__c and Site__r.Active__c = true];
                String siteName = '';                
                for(Exam_Sites__c es :lstEs) {
                    if(es.Id == newExamSiteId)
                        siteName = es.Site__r.Name;
                }
                
                system.debug('* * * examGroupId ...'+ examGroupId);
                
                if(siteName!='') {
                    for(Exam_Attempt__c ea: eas) {
                        if(ea.Exam_Site__r.Exam__r.Exam_Group__c == examGroupId) {
                            
                            system.debug('* * * In examGroupId ...'+ ea.Id + ':');
                            
                            if(ea.Id == examAttemptId) {
                                ea.Exam_Site__c = newExamSiteId;
                            } else {                            
                                List<Exam_Sites__c> lstOtherEs = [select Id, Name, Site__c, Site__r.Active__c, Site__r.Name, Exam__c, Exam__r.Exam__c from Exam_Sites__c where Exam__r.Exam__c = :ea.Exam_Site__r.Exam__r.Exam__c and Exam__c = :ea.Exam_Site__r.Exam__c and Site__r.Active__c = true];
                                for(Exam_Sites__c es :lstOtherEs) {
                                    if(es.Site__r.Name == siteName)
                                        ea.Exam_Site__c = es.Id;
                                }
                            }
                        }
                    }
                }
                update eas;
                return true;
            }
        }        
        return false;
    }
    
    public static Registration.wrapperCreateOrder prepareWCO(Registration.wrapperCreateOrder wco, ID oppID) {
        if(oppID != null) {
            getUserReturnData ird = getOppData(oppID);
            if(ird != null && ird.opportunityData != null && ird.priceBookEntryData != null &&
               ird.opportunityData.size() > 0 && ird.priceBookEntryData.size() > 0) {
                   wco.invoiceNumber = ird.opportunityData[0].Display_Invoice_Number__c;
                   wco.company = ird.opportunityData[0].Company__c;
                   
                   Map<ID,String> mapPrice = new Map<ID,String>();
                   Map<ID,ID> mapPriceID = new Map<ID,ID>();
                   for(PriceBookEntry pe :ird.priceBookEntryData) {
                       mapPrice.put(pe.Id, pe.ProductCode);
                       mapPriceID.put(pe.Id,pe.Product2Id);
                   }
                   system.debug('mapPrice:' + mapPrice);
                   system.debug('mapPriceID:' + mapPriceID);
                   
                   Map<ID,Product2 > mapProd = new Map<ID,Product2 >();
                   for(Product2 prod :ird.productData) {
                       mapProd.put(prod.Id, prod);
                   }
                   system.debug('mapProd:' + mapProd);
                   
                   String productDetails = '';
                   wco.totalCost=0;
                   for(OpportunityLineItem ol :ird.opportunityData[0].OpportunityLineItems){
                       String prodCode = mapPrice.get(ol.PricebookEntryId);
                       ID prodId = mapPriceID.get(ol.PricebookEntryId);
                       if(prodCode != null && prodId != null) {
                           Product2 prod = mapProd.get(prodId);
                           if(prod != null) {
                               system.debug('prodCode:' + prodCode);
                               system.debug('prod:' + prod);
                               system.debug('ol.Quantity:' + ol.Quantity);
                               system.debug('ol.UnitPrice:' + ol.UnitPrice);
                               
                               wco.totalCost += ol.TotalPrice;
                               
                               if(prodCode != NULL && prodCode == 'SLSTX')
                                   wco.tax = ol.TotalPrice;
                               if(prodCode != NULL && prodCode == 'SHIP')
                                   wco.shipping = ol.TotalPrice;
                               
                               Decimal quantity = ol.Quantity;
                               Decimal unitPrice = ol.UnitPrice;
                               if(prodCode != NULL && prodCode == 'MEMR') {
                                   unitPrice = ol.TotalPrice;
                                   quantity = 1;
                               }
                               
                               
                               if(productDetails == '') {
                                   productDetails = prodCode + '~' + prod.GL_Code__c + '~' + prod.Name + '~' + unitPrice + '~' + quantity ;
                               } else {
                                   productDetails = productDetails + '!' + prodCode + '~' + prod.GL_Code__c + '~' + prod.Name + '~' + unitPrice + '~' + quantity ;
                               }
                               
                               system.debug('productDetails:' + productDetails);
                           }
                       }
                   }
                   wco.productDetails = productDetails;
               }                   
        }
        return wco;
    }
    
    @RemoteAction
    public static Registration.wrapperCreateOrder createOtherexams(List<productList> lstProdCodeWithAmount, TempAccount tempAccount){
        system.debug('lstProdCodeWithAmount == '+lstProdCodeWithAmount);
        Map<String,string[]> mapProdDetails = new Map<String,string[]>();
        for(productList objProd : lstProdCodeWithAmount)
        {
            string[] arrayGLPrice = new string[3];
            
            if(objProd.ProductCode == 'SHIP') {
                objProd.ProductCode = 'SHIPFFR';
            }
            
            arrayGLPrice[0] = objProd.GLCode;
            if(objProd.price != null)
                arrayGLPrice[1] = objProd.price;
            if(objProd.description != null)
                arrayGLPrice[2] = objProd.description;
            mapProdDetails.put(objProd.ProductCode + ':' + objProd.GLCode ,arrayGLPrice);
        }
        system.debug('mapProdDetails == '+mapProdDetails);
        Registration.wrapperCreateOrder wco = FBRICBRUtils.generateOrders(mapProdDetails, tempAccount);
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;
    }    
    
    @RemoteAction
    public static Boolean deleteOrder(String oppId){
        return Registration.removeOrder(oppId, true, false);   
    }
    
    // For Registration
    @RemoteAction
    public static Boolean removeOrder(String oppId){
        return Registration.removeOrder(oppId, true, true);   
    }
    
    
    @RemoteAction
    public static Boolean clearIDContactInfo(){
        return Registration.clearIDContactInfo();   
    }
    
    @RemoteAction
    public static Contact setContactInfo(TempAccount tempAccount){
        return Registration.setContactInfo(tempAccount);   
    }
    
    @RemoteAction
    public static Registration.wrapperGetContact getContactInfo(String contactId){
        return Registration.getContactInfo(contactId);   
    }
    
    
    @RemoteAction
    public static Registration.wrapperCreateOrder createOrderForPortalUsers(TempAccount objData){
        
        if(objData.contactId == null){
            
            Id userId = userInfo.getUserId();
            
            List<User> users = [
                SELECT Id, Email, ContactId 
                FROM User 
                WHERE Id = :userId
            ];
            
            if(!users.isEmpty() && users[0].contactId != null){
                objData.contactId = users[0].contactId; 
            }else{
                return null;
            }
            
        }
        
        Registration.wrapperCreateOrder wco = Registration.createOrderForPortalUsers(objData); 
        
        if(wco != null && wco.opportunityId != null){
            wco = prepareWCO(wco, wco.opportunityId);
        }
        
        return wco;
        
    }
    
    @RemoteAction
    public static Registration.wrapperCreateOrder createOrder(TempAccount objData){
        Registration.wrapperCreateOrder wco = Registration.CreateOrder(objData);    
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;
    }
    
    @RemoteAction
    public static Response.Envelope rsvpInviteOnlyDecline(String eventId, String userEmail){
        return EventRegistration.rsvpInviteOnlyDecline(eventId, userEmail);
    }    
    
    @RemoteAction
    public static Response.Envelope createInviteOnlyEventRegistration(TempAccount objData){
        return EventRegistration.createInviteOnlyEventRegistration(objData);
    }    
    
    @RemoteAction
    public static Response.Envelope createContributorEventRegistration(TempAccount objData){
        return EventRegistration.createContributorEventRegistration(objData);
    }    
    
        /*
    @RemoteAction
    public static Registration.wrapperCreateWebcastRegistration createWebcastRegistration(TempAccount objData){
    
        String userId = UserInfo.getUserId();
        String contactId = null;
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            contactId = lstUser[0].ContactId;
        }
        
        Registration.wrapperCreateWebcastRegistration wco = Registration.createWebcastRegistration(objData, contactId);    
        return wco;
    }
    */
    
    @RemoteAction
    public static GARP_BC_Webcasts.wrapperCreateWebcastRegistration createWebcastRegistration(TempAccount objData){
        String userId = UserInfo.getUserId();
        String contactId = null;
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            contactId = lstUser[0].ContactId;
        }
        GARP_BC_Webcasts.wrapperCreateWebcastRegistration wco = GARP_BC_Webcasts.createWebcastRegistration(objData, contactId);    
        return wco;
    }          

    @RemoteAction
    public static createWebcastRegistrationFromMicrosites.Wrapper createWebcastRegistrationFromCalendar(String webcastId){
        String userId = UserInfo.getUserId();
        String contactId = null;
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            contactId = lstUser[0].ContactId;
        }
        createWebcastRegistrationFromMicrosites.Wrapper wco = createWebcastRegistrationFromMicrosites.createWebcastRegistrationFromCalendar(contactId, webcastId);    
        return wco;
    }
    
    
    @RemoteAction
    public static Id setLead(String email, String firstName, String LastName, String leadSource, String cta){
        return Registration.setLead(email, firstName, lastName, leadSource, cta);   
    }
    
    @RemoteAction
    public static Registration.wrapperCheckExistingMember CheckExistingMember(String email){
        return Registration.CheckExistingMember(email);   
    }
    
    @RemoteAction
    public static Id setLeadFromMarketingEmail(String email){
        return Registration.setLeadFromMarketingEmail(email);   
    }
    
    @RemoteAction
    public static Date getTestDate(){
        return Registration.testDate();   
    }
    
    @RemoteAction
    public static Exam_Group__c getRegistrationDate(){
        return Registration.registrationDate();   
    }
    
    @RemoteAction
    public static set<String> getActiveSites(){
        return Registration.getActiveSites();   
    }

    @RemoteAction
    public static Map<String,Registration.wrapperProductInfo> getExamProductsTeams(String strExamName, String email, String teamCode) {            
        return Registration.getProductInternal(strExamName, email, teamCode);
    }
    
    @RemoteAction
    public static Map<String,Registration.wrapperProductInfo> getExamProducts(String strExamName, String email) {            
        return Registration.getProductCodes1(strExamName, email);
    }
    
    @RemoteAction
    public static void autoRenewOff(boolean bAutoOff) {            
        MemberShipAutoRenew.autoRenewOff(bAutoOff);
    }
    
    @RemoteAction
    public static Registration.wrapperCreateOrder autoRenew(boolean bIsCurrentDay,string strProductCode,string AMP,Boolean wiley) {        
        Registration.wrapperCreateOrder wco = MemberShipAutoRenew.autorenew(bIsCurrentDay,strProductCode,AMP,wiley);
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;        
    }
    
    @RemoteAction
    public static String VoidRecurring(String oppid){
        return MemberShipAutoRenew.VoidRecurring(oppid);
    }
    
    @RemoteAction
    public static ID createoppRecurring(String strProductCode){
        return MemberShipAutoRenew.createoppRecurring(strProductCode);
    }
    
    @RemoteAction
    public static String RecurringFuture(id oppid,String cardMonth,String cardYear,String paymentType,String cardType,String cardSecurity,String cardNumber){
        return MembershipAutoRenew.RecurringFuture(oppid,cardMonth, cardYear, paymentType, cardType, cardSecurity, cardNumber);
    }
    
    @RemoteAction
    public static List<wrapperUtils.wrapperProductDetails> renewContractcheck(){
        return PortalClass.checkrenewMemberShip();
    }
    
    @RemoteAction
    public static Registration.wrapperCreateOrder createcontractextension(String strProductCode, String AMP, Boolean includeRiskNet){
        Registration.wrapperCreateOrder wco = PortalClass.extendMembership(strProductCode, AMP, includeRiskNet);
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;        
    }
    
    @RemoteAction 
    public static List<wrapperUtils.upsWrapper> getUPSPrice(string strAddress1,string strAddress2,string strCity,string strCountry,string strStateCode,string strZip,LIST<String> products) {        
        return UPSServices.getUPSPrice(strAddress1,strAddress2,strCity,strCountry,strStateCode,strZip,products);
    }  
    
    @RemoteAction
    public static List<User> verifyAuth() {            
        String userId = UserInfo.getUserId(); 
        Boolean found = false;
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {            
                found=true;
            }
        }
        return lstUser;
    }
    
    @RemoteAction
    public static void logError(String errorObject, String msg, String file, String method, String page, String userAgent) {            
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        Id contactID;
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {        
                contactID = lstContact[0].Id;    
            }            
        }
        AppError__c appError = new AppError__c();
        appError.Error__c = errorObject;
        appError.Contact__c = contactID;
        appError.Message__c = msg;
        appError.File__c = file;
        appError.Method__c = method;
        appError.Page__c = page;
        appError.User_Agent__c = userAgent;
        insert appError;
        
    }
    
    @RemoteAction
    public static String getFormSessionToken() {            
        return Utilities.getFormSessionToken();
    }    
    
    @RemoteAction
    public static void blockSessionUser(String token, String email) {            
        Utilities.blockSessionUser(token, email);
    }
    
    public List<contentData> filterContentDocs(List<Content__c> lstDocs, Integer maxReturn) {
        
        List<User> users = [SELECT Id, ContactId, AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        
        List<Attachment> lstAttachments;
        List<Related_Content__c> lstRelated;
        List<contentData> lstContentData = new List<contentData>();
        
        Map<String, List<Contract>> contractsByRecordTypeName = new Map<String, List<Contract>>();
        
        Boolean bFRMCandidate = false;
        Boolean bFRMHolder = false;
        Boolean bFRMCertified = false;
        
        Boolean bERPCandidate = false;
        Boolean bERPHolder = false;
        Boolean bERPCertified = false;
        
        Boolean bSCRCandidate = false;
        Boolean bSCRHolder = false;
        Boolean bSCRCertified = false;
        
        String memberType = '';
        String frmStatus;
        String erpStatus;
        String memStatus;
        
        Integer cnt = 0;
        
        if(!users.isEmpty()) {
            
            User user = users[0];
            
            List<Contact> lstContact = [
                SELECT Id, Name, KPI_FRM_Candidate_Payment_Status__c, KPI_ERP_Candidate_Payment_Status__c, KPI_Membership_Payment_Status__c, KPI_FRM_Candidate__c, KPI_FRM_Holder__c, KPI_FRM_Certified__c, KPI_ERP_Candidate__c, KPI_ERP_Holder__c, KPI_ERP_Certified__c,Membership_Type__c  
                FROM Contact 
                WHERE Id = :user.ContactId
            ];
            
            List<Contract> contracts = [
                SELECT Id, AccountId, RecordType.Name, Status, All_Requirements_Completed_Date__c
                FROM Contract
                WHERE AccountId = :user.AccountId
            ];
            
            // Group Contracts by Record Type Name
            for(Contract contract: contracts){
                String recordTypeName = contract.RecordType.Name;
                if(contractsByRecordTypeName.containsKey(recordTypeName)){
                    // Add a Contract element to the map array for a given Contract Record Type
                    contractsByRecordTypeName.get(recordTypeName).add(contract);
                }else{
                    // Initialize a list and add a Contract element for a given Contract Record Type
                    contractsByRecordTypeName.put(recordTypeName, new List<Contract>{contract});
                }
            }
            
            if( lstContact != null && lstContact.size() > 0 ) {
                Contact cont = lstContact[0];
                bFRMCandidate = cont.KPI_FRM_Candidate__c;
                bFRMHolder = cont.KPI_FRM_Holder__c;
                bFRMCertified = cont.KPI_FRM_Certified__c;
                
                bERPCandidate = cont.KPI_ERP_Candidate__c;
                bERPHolder = cont.KPI_ERP_Holder__c;
                bERPCertified = cont.KPI_ERP_Certified__c;
                
                bSCRCandidate = false;
                bSCRHolder = false;
                bSCRCertified = false;
                
                memberType = cont.Membership_Type__c;
                frmStatus = cont.KPI_FRM_Candidate_Payment_Status__c;
                erpStatus = cont.KPI_ERP_Candidate_Payment_Status__c;
                memStatus = cont.KPI_membership_Payment_Status__c;
                
                // Data mine SCR Contract
                if(contractsByRecordTypeName.containsKey('SCR Program')){
                    for(Contract scrContract: contractsByRecordTypeName.get('SCR Program')){
                        if(scrContract.Status == 'Activated'){
                            bSCRCandidate = true;
                        }
                    }
                }
                
            }
        }
        
        if( lstDocs != null && lstDocs.size() > 0 ) {           
            lstAttachments = [Select Id, Name, ParentId from Attachment where ParentId in :lstDocs order by LastModifiedDate];
            
            for(Content__c doc :lstDocs){    
                contentData contentData = new contentData();
                contentData.content = doc;
                datetime nowDateTime = datetime.now();
                Boolean addContent = true;
                if(doc.End_Date__c == null && doc.Start_Date__c != null && nowDateTime >= doc.Start_Date__c) {
                    addContent = true;
                } else if(doc.Start_Date__c == null && doc.End_Date__c != null && nowDateTime < doc.End_Date__c) {
                    addContent = true;
                } else if(doc.Start_Date__c != null && doc.End_Date__c != null && nowDateTime >= doc.Start_Date__c && nowDateTime < doc.End_Date__c) {
                    addContent = true;
                } else if(doc.Start_Date__c == null && doc.End_Date__c == null){
                    addContent = true;
                }
                
                Boolean addVisContent = false;
                if(doc.Visibility_FRM__c != null) {
                    if(
                        (doc.Visibility_FRM__c == 'Certified' && bFRMCertified) ||
                        (doc.Visibility_FRM__c == 'Holder' && (bFRMCertified || bFRMHolder)) ||
                        (doc.Visibility_FRM__c == 'Candidate' && bFRMCandidate)
                    ) {
                        if(frmStatus != null && frmStatus == 'In Good Standing') {
                            addVisContent = true;    
                        }
                    }
                }
                if(doc.Visibility_ERP__c != null) {
                    if(
                        (doc.Visibility_ERP__c == 'Certified' && bERPCertified) ||
                        (doc.Visibility_ERP__c == 'Holder' && (bERPCertified || bERPHolder)) ||
                        (doc.Visibility_ERP__c == 'Candidate' && bERPCandidate)
                    ) {
                        if(erpStatus != null && erpStatus == 'In Good Standing') {
                            addVisContent = true;
                        }
                    }
                }
                if(doc.Visibility_SCR__c != null) {
                    if(
                        (doc.Visibility_SCR__c == 'Certified' && bSCRCertified) ||
                        (doc.Visibility_SCR__c == 'Holder' && (bSCRCertified || bSCRHolder)) ||
                        (doc.Visibility_SCR__c == 'Candidate' && bSCRCandidate)
                    ) {
                        addVisContent = true;
                    }
                }
                if(doc.Visibility_Membership__c != null) {
                    if(doc.Visibility_Membership__c == 'Paid' && (memberType == 'Individual' || memberType == 'Student')) {
                        //Membership has lapsed 
                        if(memStatus != null && memStatus == 'In Good Standing') {
                            contentData.memberTypeRequiredForAccess = 'N/A';   
                        }
                        else {
                            contentData.memberTypeRequiredForAccess = doc.Visibility_Membership__c;    
                        }
                    }  
                    else {
                        //Does not have the Requisite permissions to view the article
                        contentData.memberTypeRequiredForAccess = doc.Visibility_Membership__c;   
                    }  
                }
                if(doc.Visibility_FRM__c == null && doc.Visibility_ERP__c == null && doc.Visibility_SCR__c == null && doc.Visibility_Membership__c == null) {
                    contentData.memberTypeRequiredForAccess = 'N/A'; 
                }
                
                if(addContent == true && ((doc.Visibility_FRM__c == null && doc.Visibility_ERP__c == null && doc.Visibility_SCR__c == null) || addVisContent == true)) {
                    for(Attachment att :lstAttachments){
                        if(att.ParentId == doc.Id) {
                            contentData.attachment = att;
                            break;
                        }
                    }
                    
                    lstContentData.add(contentData);
                    cnt++;
                    if(maxReturn != null && cnt >= maxReturn)
                        break;
                }    
            }                
        }                
        return lstContentData;
        
    }
    
    @RemoteAction    
    public static String Charge(Id oppId,String cardMonth,String cardYear,String paymentType,String cardType,String cardSecurity,String cardNumber) {            
        
        List<Opportunity> lstOpp = [select id, Team_Registration__c from Opportunity where
                                    Id = :oppId AND
                                    Team_Registration__c != NULL AND
                                    Team_Registration__r.Payment_Status__c = 'Paid' AND
                                    Team_Registration__r.Start_Date__c <= TODAY AND Team_Registration__r.End_Date__c >= TODAY AND
                                    Team_Registration__r.Exam_Type__c = 'FRR' AND Team_Registration__r.Discounted_Price__c = NULL AND
                                    Team_Registration__r.Seats_Balance__c > 0
                                   ];
        if(!lstOpp.isEmpty()) {
            ChargentSFA__Transaction__c trans = new ChargentSFA__Transaction__c();        
            trans.ChargentSFA__Opportunity__c = lstOpp[0].Id;
            trans.ChargentSFA__Amount__c = 0.00;
            trans.ChargentSFA__Response_Message__c = 'Approved';
            trans.ChargentSFA__Response_Status__c = 'Approved';
            trans.ChargentSFA__Type__c = 'Charge';
            trans.ChargentSFA__Gateway_Date__c =system.now();
            
            System.debug('free trans:' + trans);       
            insert trans;     
            
            return 'Approved';
        } else {
            return Registration.Charge(oppId, cardMonth, cardYear, paymentType, cardType, cardSecurity, cardNumber);
        }
        
        
    }
    
    @RemoteAction
    public static List<contentData> getContentRegistrations(List<String> productCodes){
        List<Content__c> lstDocs;
        List<Attachment> lstAttachments;
        List<Related_Content__c> lstRelated;
        List<contentData> lstContentData = new List<contentData>();
        
        sfdcAppRemoter sr = new sfdcAppRemoter();
        
        lstDocs = [Select Id, Name, Content_Name__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c, Published_Date__c, Story__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Start_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_SCR__c, Visibility_Membership__c, Location__c from Content__c where Status__c = 'Active' and Is_advertisement__c != true and 
                   SKU__c in :productCodes];
        
        lstContentData = sr.filterContentDocs(lstDocs, null); 
        return lstContentData;
    }
    
    @RemoteAction
    public static EventsHelper.Event fetchEventDetails(String eventId){     
        return EventsHelper.fetchEventDetails(eventId);
    } 
    
    @RemoteAction
    public static wrapperChapterMeetingDetails getChapterMeetingDetail(String meetingId){
        
        List<Chapter_Meeting__c> lstChapterMeeting = [
            SELECT 
            Id, 
            Name, 
            Estimated_Cost__c, 
            Chapter_Meeting_Name__c, 
            Synopsis__c, 
            Last_Day_of_Registration__c, 
            NonMemberFee__c, 
            Cancellation_Policy__c, 
            Payment_Policy__c, 
            Start__c, 
            End__c, 
            Is_Sponsored__c, 
            Sponsor_Information__c, 
            Sponsor_Logo__c, 
            Sponsor_Name__c, 
            Sponsor_Website__c, 
            Time_Zone__r.Abbreviation__c, 
            Time_Zone__r.Name, 
            Time_Zone__r.Add_This_Event_Zone__c, 
            Status__c, 
            Chapter__c, 
            Chapter__r.Name, 
            Chapter_Meeting_Location__r.Building_Name__c, 
            Chapter_Meeting_Location__r.Address_Street_1__c, 
            Chapter_Meeting_Location__r.Address_Street_2__c, 
            Chapter_Meeting_Location__r.Venue_Location__c, 
            Chapter_Meeting_Location__r.Address_City__c, 
            Chapter_Meeting_Location__r.Address_State_Provence__c , 
            Chapter_Meeting_Location__r.Name, 
            Chapter_Meeting_Location__r.Address_Postal_Code__c, 
            Chapter_Meeting_Location__r.Address_Country__c, 
            Presentation__c, 
            Ceremony__c, 
            Group_Formation__c,
            Content__r.Id,
            Content__r.Name,
            Content__r.Description__c,
            Content__r.Location__c,
            Content__r.Event_Start_Date_Time__c,
            Content__r.Event_End_Date_Time__c,
            Content__r.Form__r.Form_Name__c,
            ON24_URL__c,
            ON24_Event_Id__c,          
            Virtual_Start_DateTime__c,
            Virtual_End_DateTime__c,
            Virtual_Meeting_URL__c,
            Virtual_Meeting_Instructions__c,
            In_Person_Title__c,
            Virtual_Title__c,
            Delivery_Method__c
            FROM Chapter_Meeting__c 
            WHERE Id = :meetingId
        ];    
        
        if(lstChapterMeeting != null && lstChapterMeeting.size() > 0) {
            
            Chapter_Meeting__c chapterMeeting = lstChapterMeeting[0];
            
            if(chapterMeeting.Status__c == 'Active') {
                List<aggregateResult> chaptReg = [select count(Id) total, Chapter_Meeting__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :meetingId group by Chapter_Meeting__c];
                
                List<Chapter_Member__c> lstChaptMem = [select Id, Name, Title__c, Chapter_Director_Bio__c, Contact__c, Contact__r.Name, Contact__r.Email, Director__c, Committee_Member__c from Chapter_Member__c where Chapter__c = :chapterMeeting.Chapter__c];
                system.debug('lstChaptMem:' + lstChaptMem);
                
                Map<Id,Chapter_Member__c> chaptMemMap = new Map<Id,Chapter_Member__c>();
                for(Chapter_Member__c cm : lstChaptMem) {
                    if(cm.Contact__c != null) {
                        chaptMemMap.put(cm.Contact__c, cm);
                        system.debug('chaptMemMap PUT:' + cm);                        
                    }                        
                }   
                system.debug('chaptMemMap:' + chaptMemMap);
                
                //System.assert(false, '* * * chaptMemMap: ' + chaptMemMap.keySet());
                
                List<User> lstUser = [Select ContactId, SmallPhotoUrl, FullPhotoUrl From User where ContactId in :chaptMemMap.keySet()];
                system.debug('lstUser:' + lstUser);
                
                List<wrapperChapterMemberDetails> lstChaptMemDetails = new List<wrapperChapterMemberDetails>();
                for(User u : lstUser) {
                    wrapperChapterMemberDetails wcmd = new wrapperChapterMemberDetails();
                    wcmd.chapterMember = chaptMemMap.get(u.ContactId);
                    wcmd.user = u;
                    system.debug('wcmd:' + wcmd);
                    lstChaptMemDetails.add(wcmd);
                }
                
                List<Chapter_Meeting_Speaker__c> lstChapterMeetingSpeakers = [select Id, Name, Chapter_Meeting__c, Chapter_Speaker__r.Name, Chapter_Speaker__r.First_Name__c, Chapter_Speaker__r.Last_Name__c, Chapter_Speaker__r.Qualifications__c, Chapter_Speaker__r.Biography__c, Chapter_Speaker__r.Contact__c from Chapter_Meeting_Speaker__c where Chapter_Meeting__c = :meetingId];
                
                wrapperChapterMeetingDetails wcm = new wrapperChapterMeetingDetails();
                wcm.isAutenticated = GARP_BC_Authentication.isAuthenticated();
                wcm.chapterMembers = lstChaptMemDetails;
                wcm.speakers = lstChapterMeetingSpeakers;
                if(chapterMeeting != null) {
                    wcm.chapterMeeting = chapterMeeting;
                    if(chaptReg != null && chaptReg.size() > 0) {
                        wcm.registrationCount = (Integer)chaptReg[0].get('total');
                    } else {
                        wcm.registrationCount = 0;            
                    }
                    return wcm;
                } else {
                    return null;
                }
            } else {
                return null;
            }
            
        } else {
            return null;
        }
        
    }
    
    @RemoteAction
    public static List<wrapperChapterMeetingDetails> getChapterMeetingDetails(Integer month, Integer year, Boolean upcoming){
        
        Date today = Date.Today();
        Integer queryMonth = 0;
        Integer queryYear = today.Month();
        List<Chapter_Meeting__c> lstChapterMeetings;
        
        if(upcoming) {
            lstChapterMeetings = [select Id, Name, Chapter_Meeting_Name__c, 
                                  Synopsis__c, 
                                  NonMemberFee__c, Cancellation_Policy__c, Payment_Policy__c, Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Address_Country__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c, Is_Sponsored__c, Sponsor_Name__c, Sponsor_Logo__c from Chapter_Meeting__c where Chapter__r.Status__c = 'Active' and Status__c = 'Active' and Start__c >= :today];    
        } else if((month > -1 && year > -1) || (month > -1 || year == -1)) {
            if(month > -1)
                queryMonth = month;
            if(year > -1)
                queryYear = year;
            lstChapterMeetings = [select Id, Name, Chapter_Meeting_Name__c, 
                                  Synopsis__c, 
                                  Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Address_Country__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c from Chapter_Meeting__c where 
                                  Status__c = 'Active' and CALENDAR_YEAR(Start__c) = :queryYear and CALENDAR_MONTH(Start__c) = :queryMonth];    
        } else if(year > -1 && month== -1) {
            lstChapterMeetings = [select Id, Name, Chapter_Meeting_Name__c, 
                                  Synopsis__c, 
                                  Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Address_Country__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c from Chapter_Meeting__c where 
                                  Status__c = 'Active' and CALENDAR_YEAR(Start__c) = :queryYear];    
        } else {
            lstChapterMeetings = [select Id, Name, Chapter_Meeting_Name__c, 
                                  Synopsis__c, 
                                  Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Address_Country__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c from Chapter_Meeting__c where 
                                  Status__c = 'Active' and CALENDAR_YEAR(Start__c) = :queryYear and CALENDAR_MONTH(Start__c) = :queryMonth];    
        }
        
        List<aggregateResult> lstChaptReg = [select count(Id) total, Chapter_Meeting__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c in :lstChapterMeetings group by Chapter_Meeting__c];
        Map<ID, Integer> chaptRegMap = new Map<ID, Integer>();
        for (AggregateResult ar : lstChaptReg) {
            ID id = (ID)ar.get('Chapter_Meeting__c');
            Integer val = (Integer)ar.get('total');
            chaptRegMap.put(id, val);
        }
        
        List<wrapperChapterMeetingDetails> lstChaptDetails = new List<wrapperChapterMeetingDetails>();
        for (Chapter_Meeting__c cm : lstChapterMeetings) {
            wrapperChapterMeetingDetails wcm = new wrapperChapterMeetingDetails();
            wcm.chapterMeeting = cm;
            wcm.registrationCount = chaptRegMap.get(cm.Id);
            lstChaptDetails.add(wcm);
        }
        
        return lstChaptDetails;
    }    
    
    @RemoteAction
    public static Contact getUserContactDetails(){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            List<Contact> lstContact = [SELECT Id, Name, FirstName, LastName, Email, HomePhone, OtherPhone, GARP_Member_ID__c, 
                                        MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet,KPI_CPE_Current_Cycle__c,KPI_CPE_Last_Completed_Cycle__c,
                                        AccountId, GARP_ID__c, Membership_Type__c, Name_As_it_Appears_On_ID__c, Job_Function__c, Risk_Specialty__c, Company__c, 
                                        ID_Number__c, ID_Type__c, GARP_Directory_Opt_In__c, KPI_Membership_Payment_Status__c, KPI_CPE_Requirement_Status__c,
                                        KPI_CPE_Participation__c, KPI_Chapter_Director__c,KPI_ERP_Candidate__c, KPI_ERP_Certified_Date__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified_Year__c,
                                        KPI_Current_Exam_Registration__c, KPI_FRM_Candidate__c, KPI_FRM_Certified_Date__c, KPI_Last_Exam_Registration__c,
                                        KPI_Membership_Since__c, KPI_FRM_Certified__c, KPI_ERP_Certified__c,Professional_Designation_CA__c,Professional_Designation_CFA__c,
                                        Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c,
                                        Professional_Designation_Other__c, Other_Qualifications__c, Area_of_Concentration__c, Corporate_Title__c, GARP_Directory_Invite_Opt_Out__c,
                                        GARP_Directory_Connect_Feature__c,GARP_Dir_Privacy_Additional_Detail__c,GARP_Dir_Privacy_Job_Information__c,GARP_Dir_Privacy_Prof_Background__c
                                        FROM Contact WHERE Id = :lstUser[0].ContactId];
            
            if( lstContact != null && lstContact.size() > 0 ) {            
                return lstContact[0];
            }
        }
        return null;
        
    }
    
    // 07/11/2019 Xiang - [US-22986] Adding new Contact & Lead email fields
    @RemoteAction
    public static Boolean unsubscribe(String contactId){
        
        
        List<Contact> lstContact = [select Id, Name, Email_GARP_Updates__c,Email_Daily_News__c,Email_Chapter_Meetings__c,Email_Information_Exchange__c ,
                                    Email_Member_Update__c,Email_CPE_News__c, Exam_Prep_Provider_Outreach__c, Email_The_Week_in_Risk__c,Email_Career_Center_Job_Board__c from Contact where Id = :contactId];
        if( lstContact != null && lstContact.size() > 0 ) {            
            lstContact[0].Email_GARP_Updates__c=false;
            lstContact[0].Email_FRM__c = false;
            lstContact[0].Email_ERP__c = false;
            lstContact[0].Email_Webcasts__c = false;
            lstContact[0].Email_Events__c = false;
            lstContact[0].Email_InsightAnalysis__c = false;
            lstContact[0].Email_CorporateTeamBuilding__c = false;
            lstContact[0].Exam_Prep_Provider_Outreach__c=false;
            lstContact[0].Email_Daily_News__c=false;
            lstContact[0].Email_Chapter_Meetings__c=false;
            lstContact[0].Email_Information_Exchange__c=false;
            lstContact[0].Email_Member_Update__c=false;
            lstContact[0].Email_The_Week_in_Risk__c=false;
            lstContact[0].Email_CPE_News__c =false;
            lstContact[0].Email_Career_Center_Job_Board__c=false;
            lstContact[0].Email_Subscription_Change_Source__c = 'User Email Preferences - Unsubscribe All';
            lstContact[0].SCR_Updates__c=false;
            update lstContact[0];
            return true;      
        } else if(lstContact == null || lstContact.size() == 0){
            List<Lead> lstLead = [select Id, Name, Email_GARP_Updates__c,Email_Daily_News__c,Email_Chapter_Meetings__c,Email_Information_Exchange__c ,
                                  Email_Member_Update__c,Email_CPE_News__c, Exam_Prep_Provider_Outreach__c, Email_The_Week_in_Risk__c,Email_Career_Center_Job_Board__c from Lead where Id = :contactId];
            if( lstLead != null && lstLead.size() > 0 ) { 
                lstLead[0].Email_GARP_Updates__c=false; 
                lstLead[0].Email_FRM__c = false;
                lstLead[0].Email_ERP__c = false;
                lstLead[0].Email_Webcasts__c = false;
                lstLead[0].Email_Events__c = false;
                lstLead[0].Email_InsightAnalysis__c = false;
                lstLead[0].Email_CorporateTeamBuilding__c = false;
                lstLead[0].Email_Daily_News__c=false;
                lstLead[0].Email_Chapter_Meetings__c=false;
                lstLead[0].Email_Information_Exchange__c=false;
                lstLead[0].Email_Member_Update__c=false;
                lstLead[0].Email_The_Week_in_Risk__c=false;
                lstLead[0].Email_CPE_News__c =false;
                lstLead[0].Email_Career_Center_Job_Board__c=false;
                lstLead[0].Exam_Prep_Provider_Outreach__c=false;
                lstLead[0].Email_Subscription_Change_Source__c = 'User Email Preferences - Unsubscribe All';
                lstLead[0].SCR_Updates__c=false;
                update lstLead[0];
                return true;
            }
        }
        return false;
        
    } 
    
    @RemoteAction
    public static Boolean eppOptIn(String contactId){
        List<Contact> lstContact = [select Id, Exam_Prep_Provider_Outreach__c from Contact where Id = :contactId];    
        
        Boolean eppOptIn;
        
        if( lstContact != null && lstContact.size() > 0 ) {
            if(lstContact[0].Exam_Prep_Provider_Outreach__c == false) {
                // Toggle EPP Outreach ON
                lstContact[0].Exam_Prep_Provider_Outreach__c = true;
                update lstContact[0];
                
            } else {
                // Toggle EPP Outreach OFF
                lstContact[0].Exam_Prep_Provider_Outreach__c = false;
                update lstContact[0];
            }
            
            eppOptIn = lstContact[0].Exam_Prep_Provider_Outreach__c;
        }
        return eppOptIn;
    }
    
    
    @RemoteAction
    public static Registration.wrapperCreateOrder deferExams(String examAttemptId, String productCode, String glCode, Boolean bWire){
        Registration.wrapperCreateOrder wco = PortalClass.checkExamAttempts(examAttemptId,productCode,glCode,bWire);
        if(wco != null && wco.opportunityId != null){
            wco = prepareWCO(wco, wco.opportunityId);
        }
        return wco;        
    }
    
    @RemoteAction
    public static List<productItems> getProductsById(List<String> productIds){
        
        utilities.verifyLoggedInUser();
        
        List<Product2> lstProducts = [
            SELECT Id, Name, Description, Content__r.Story__c, Content__r.Mobile_Story__c, Content__r.Description__c, Pre_Order_Date__c, Pre_Order_Shipping_Date__c, Content__r.Start_Date__c, Image__c, GL_Code__c, Weight__c,Taxable__c, (SELECT Id, Name, UnitPrice, Product2Id, ProductCode from PriceBookEntries where Pricebook2.IsActive = true)
            FROM Product2 
            WHERE Id IN :productIds
        ];
        
        List<ProductItems> productWrappers = new List<sfdcAppRemoter.ProductItems>();
        MAP<ID,Product2> mapProds = new MAP<ID,Product2>();
        for (Product2 product : lstProducts) {
            if(product.Name == 'ICBRR Handbooks') {
                product.Name = 'FRR Handbooks';
                product.Description = 'Financial Risk and Regulation Handbooks';
            }
            mapProds.put(product.Id, product);
        }
        
        
        for(String prod :productIds) {
            Product2 product = mapProds.get(Id.valueOf(prod));
            if(product != null) {
                sfdcAppRemoter.ProductItems productWrapper = new sfdcAppRemoter.ProductItems();
                productWrapper.Product = product;
                PriceBookEntry [] priceBookEntries = product.PriceBookEntries;
                productWrapper.Price = priceBookEntries[0];
                productWrappers.add(productWrapper);
            }
        }
        
        return productWrappers;
    }
    
    @RemoteAction
    public static productData getProduct(String productcode, String glCode){
        
        utilities.verifyLoggedInUser();
        productData pd = new productData();
        
        List<Product2> lstProducts = [select Id, Name, Description, Image__c from Product2 where ProductCode = :productcode and GL_Code__c = :glCode];
        if( lstProducts != null && lstProducts.size() > 0 ) {
            pd.product = lstProducts;
            List<PricebookEntry> lstPrice = [select Id, Name, UnitPrice, Product2Id, ProductCode from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in :lstProducts and IsActive=true];
            pd.price = lstPrice;
        }            
        return pd;
    }
    
    
    @RemoteAction
    public static String encodeString(String before) {            
        Blob beforeblob = Blob.valueOf(before);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);    
        return paramvalue;
    }
    
    @RemoteAction
    public static Boolean setLastLoginDate(){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select Id,ContactId from User where Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            List<Contact> lstContact = [select Id, Name from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {                
                lstContact[0].Last_Day_of_Login__c = datetime.now();
                
                //system.assert(false, 'BOOM!'+ lstContact[0]);
                
                update lstContact;
            }
        }
        return true;
    }
    
    
    @RemoteAction
    public static List<Contact> getBoardCandidates(){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            String contactId = lstUser[0].ContactId;
            List<Contact> lstContact = [select Id, Name from Contact where KPI_GARP_Board_Member__c = true];
            if( lstContact != null && lstContact.size() > 0 ) {
                return lstContact;
            }
        }
        return null;
    }
    
    
    @RemoteAction
    public static Boolean voteBoardCandidates(String contactId, String electionId){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            List<Contact> lstContact = [select Id, Name from Contact where Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                List<Board_Election__c> lstElection = [select Id, Name from Board_Election__c where Id = :electionId];
                if( lstElection != null && lstElection.size() > 0 ) {
                    Board_Vote__c bv = new Board_Vote__c();
                    
                    bv.Board_Election__c = electionId;
                    bv.Board_Member__c = contactId;
                    insert bv;
                }
            }
        }
        return true;
    }
    @RemoteAction
    public static boolean updateId(String idName, String idType, String idNumber){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            String contactId = lstUser[0].ContactId;
            List<Contact> lstContact = [select Id, Name,Name_As_it_Appears_On_ID__c, ID_Number__c, ID_Type__c from Contact where id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                lstContact[0].Name_As_it_Appears_On_ID__c = idName;
                
                if(idType.indexOf('Driver') > -1) {
                    lstContact[0].ID_Type__c = 'Driver\'s License';
                } else {
                    lstContact[0].ID_Type__c = idType;    
                }
                
                lstContact[0].ID_Number__c = idNumber;
                update lstContact[0];           
            }
        }
        return true;
    }
    
    @RemoteAction
    public static boolean sendDirectoryMessage(String templateName, String text, String recptContactId){
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            String contactId = lstUser[0].ContactId;
            
            List<Contact> srcContactlst = [SELECT Id, Name, FirstName, LastName, Email_URL__c, Email_WebSite_URL__c, Email, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_Member_ID__c, Membership_Type__c, GARP_Directory_Connect_Send_Count__c, KPI_FRM_Certified__c, KPI_ERP_Certified__c, KPI_Membership_Payment_Status__c  FROM Contact WHERE Id = :contactId];
            List<Contact> rcptContactlst = [SELECT Id, Name, FirstName, LastName, Email_URL__c, Email_WebSite_URL__c, Email, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_Member_ID__c, Membership_Type__c, GARP_Directory_Connect_Recieve_Count__c, KPI_FRM_Certified__c, KPI_ERP_Certified__c, GARP_Directory_Invite_Opt_Out__c, GARP_Directory_Connect_Feature__c, KPI_Membership_Payment_Status__c FROM Contact WHERE Id = :recptContactId];
            
            //System.assert(false, 'BOOM!'+ srcContactlst);
            
            if( srcContactlst != null && srcContactlst.size() > 0 && rcptContactlst != null && rcptContactlst.size() > 0 ) {
                
                Contact srcContact = srcContactlst[0];
                Contact rcptContact = rcptContactlst[0];
                
                // New Rules 2019
                if(templateName == 'Directory_Connect_Invite') {
                    
                    if(srcContact.Membership_Type__c != 'Individual' || srcContact.KPI_Membership_Payment_Status__c != 'In Good Standing' || 
                       rcptContact.GARP_Directory_Invite_Opt_Out__c == true) {
                            throw new applicationException('Unauthorized Access1');
                    }
                    
                } else if(srcContact.Membership_Type__c != 'Individual' || srcContact.KPI_Membership_Payment_Status__c != 'In Good Standing' ||
                          rcptContact.GARP_Directory_Connect_Feature__c == false) {
                              throw new applicationException('Unauthorized Access2');
                          }
                
                
                // grab the email template
                EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName = :templateName];
                
                // process the merge fields
                String subject = emailTemplate.Subject;
                subject = subject.replace('{!Account.Name}', rcptContact.Name);
                
                String htmlBody = emailTemplate.HtmlValue;
                
                system.debug('* * * HtmlValue Before ...'+ htmlBody);
                
                htmlBody = htmlBody.replace('{!Contact.GARP_ID__c}', rcptContact.GARP_Member_ID__c);
                htmlBody = htmlBody.replace('{!Contact.FirstName}', rcptContact.FirstName);
                htmlBody = htmlBody.replace('{!Contact.LastName}', rcptContact.LastName);
                
                htmlBody = htmlBody.replace('{!srcContact.FirstName}', srcContact.FirstName);
                htmlBody = htmlBody.replace('{!srcContact.LastName}', srcContact.LastName);
                htmlBody = htmlBody.replace('{!srcContact.Email}', srcContact.Email);
                
                htmlBody = htmlBody.replace('{!Contact.Email_URL__c}', rcptContact.Email_URL__c);
                htmlBody = htmlBody.replace('{!Contact.Email_WebSite_URL__c}', rcptContact.Email_WebSite_URL__c);
                
                htmlBody = htmlBody.replace('{!Contact.Id}', rcptContact.Id);
                htmlBody = htmlBody.replace('{!CustomText}', text);
                
                htmlBody = htmlBody.replace('<![CDATA[', '');
                htmlBody = htmlBody.replace(']]>', '');
                
                
                system.debug('* * * HtmlValue After ...'+ htmlBody);
                
                String plainBody = emailTemplate.Body;
                
                system.debug('* * * plainBody Before ...'+ plainBody);
                
                plainBody = plainBody.replace('{!Contact.GARP_ID__c}', rcptContact.GARP_Member_ID__c);
                plainBody = plainBody.replace('{!Contact.FirstName}', rcptContact.FirstName);
                plainBody = plainBody.replace('{!Contact.LastName}', rcptContact.LastName);
                
                plainBody = plainBody.replace('{!srcContact.FirstName}', srcContact.FirstName);
                plainBody = plainBody.replace('{!srcContact.LastName}', srcContact.LastName);
                plainBody = plainBody.replace('{!srcContact.Email}', srcContact.Email);
                
                plainBody = plainBody.replace('{!Contact.Email_URL__c}', rcptContact.Email_URL__c);
                plainBody = plainBody.replace('{!Contact.Email_WebSite_URL__c}', rcptContact.Email_WebSite_URL__c);
                
                plainBody = plainBody.replace('{!Contact.Id}', rcptContact.Id);
                plainBody = plainBody.replace('{!CustomText}', text);
                
                system.debug('* * * plainBody After ...'+ plainBody);
                
                //build the email message
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                
                email.setReplyTo(rcptContact.Email);
                email.setSenderDisplayName(rcptContact.Name);
                email.setTargetObjectId(rcptContact.Id);
                email.setSaveAsActivity(false);
                
                email.setSubject(subject);
                email.setHtmlBody(htmlBody);
                email.setPlainTextBody(plainBody);
                
                Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
                
                if(rcptContactlst[0].GARP_Directory_Connect_Recieve_Count__c == null)
                    rcptContactlst[0].GARP_Directory_Connect_Recieve_Count__c=1;
                else rcptContactlst[0].GARP_Directory_Connect_Recieve_Count__c++;
                
                update rcptContactlst;
                
                if(srcContactlst[0].GARP_Directory_Connect_Send_Count__c == null)
                    srcContactlst[0].GARP_Directory_Connect_Send_Count__c=1;
                else srcContactlst[0].GARP_Directory_Connect_Send_Count__c++;
                
                update srcContactlst;
            }
        }
        
        return true;
    }
    
    @RemoteAction
    public static searchResults searchDirectory(String searchText, String searchType, String industries, String jobFunctions, String corporateTitles, String company, String sortField, String sortOrder, Integer pageSize, Integer pageCurrent){
        
        String querystr = '';
        String likeClause = '%'+searchText+'%';
        if(company == '' && industries == '' && jobFunctions == '' && corporateTitles == '') {
            String query = 'SELECT Id, Name, MailingCity, MailingState, MailingPostalCode, MailingCountry, KPI_CPE_Current_Cycle__c, KPI_CPE_Last_Completed_Cycle__c, Job_Function__c, AccountId, GARP_ID__c, Membership_Type__c, Area_of_Concentration__c, GARP_Directory_Opt_In__c, GARP_Directory_Invite_Opt_Out__c, GARP_Dir_Privacy_Additional_Detail__c, GARP_Dir_Privacy_Job_Information__c, GARP_Dir_Privacy_Prof_Background__c, GARP_Directory_Connect_Feature__c, KPI_Membership_Payment_Status__c, KPI_FRM_Certified__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified__c, KPI_ERP_Certified_Year__c, KPI_Membership_Since__c, KPI_CPE_Requirement_Status__c, Professional_Designation_CA__c, Professional_Designation_CFA__c, Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Other_Qualifications__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c, Company_Type__c, Corporate_Title__c, Company__c FROM Contact';
            String whereClause = 'WHERE GARP_Directory_Opt_In__c = true and (KPI_FRM_Certified__c = true or KPI_ERP_Certified__c = true) and ' + searchType + ' like :likeClause'; 
            String sortClause = 'ORDER BY ' + sortField + ' ' + sortOrder + ' NULLS LAST';
            querystr = query + ' ' + whereClause + ' ' + sortClause;
            
            system.debug('* * * query ...'+ querystr);
            
        } else {
            
            String industriesInClause = '';
            if(industries != '') {
                String[] arrText = industries.split('; ');
                for(String s :arrText) {
                    if(industriesInClause == '') {
                        industriesInClause = '\'' + s + '\'';
                    } else {
                        industriesInClause = industriesInClause + ',' + '\'' + s + '\'';
                    }
                }
            }
            
            String jobFunctionsInClause = '';
            if(jobFunctions != '') {
                String[] arrText = jobFunctions.split('; ');
                for(String s :arrText) {
                    if(jobFunctionsInClause == '') {
                        jobFunctionsInClause = '\'' + s + '\'';
                    } else {
                        jobFunctionsInClause = jobFunctionsInClause + ',' + '\'' + s + '\'';
                    }
                }
            }
            
            String corporateTitlesInClause = '';
            if(corporateTitles != '') {
                String[] arrText = corporateTitles.split('; ');
                for(String s :arrText) {
                    if(corporateTitlesInClause == '') {
                        corporateTitlesInClause = '\'' + s + '\'';
                    } else {
                        corporateTitlesInClause = corporateTitlesInClause + ',' + '\'' + s + '\'';
                    }
                }
            }
            
            //String likeClause = searchText;
            String query = 'SELECT Id, Name, Email, MailingCity, MailingState, MailingPostalCode, MailingCountry, KPI_CPE_Current_Cycle__c, KPI_CPE_Last_Completed_Cycle__c, Job_Function__c, AccountId, GARP_ID__c, Membership_Type__c, Area_of_Concentration__c, GARP_Directory_Opt_In__c, GARP_Directory_Invite_Opt_Out__c, GARP_Dir_Privacy_Additional_Detail__c, GARP_Dir_Privacy_Job_Information__c, GARP_Dir_Privacy_Prof_Background__c, GARP_Directory_Connect_Feature__c, KPI_Membership_Payment_Status__c, KPI_FRM_Certified__c, KPI_FRM_Certified_Year__c, KPI_ERP_Certified__c, KPI_ERP_Certified_Year__c, KPI_Membership_Since__c, KPI_CPE_Requirement_Status__c, Professional_Designation_CA__c, Professional_Designation_CFA__c, Professional_Designation_CMA__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Other_Qualifications__c, Professional_Designation_PMP__c, Professional_Designation_ACCA__c, Company_Type__c, Corporate_Title__c, Company__c FROM Contact';
            String whereClause = 'WHERE GARP_Directory_Opt_In__c = true and (KPI_FRM_Certified__c = true or KPI_ERP_Certified__c = true)';
            if(industries != '') {
                whereClause +=  ' and Area_of_Concentration__c in (' + industriesInClause + ')'; 
            }
            if(jobFunctions != '') {
                whereClause +=  ' and Job_Function__c in (' + jobFunctionsInClause + ')'; 
            }
            if(corporateTitles != '') {
                whereClause +=  ' and Corporate_Title__c in (' + corporateTitlesInClause + ')'; 
            }
            if(company != '') {
                String companyLikeClause = '%'+company+'%';
                whereClause +=  ' and Company__c like :companyLikeClause'; 
            }
            whereClause +=  ' and ' + searchType + ' like :likeClause'; 
            String sortClause = 'ORDER BY ' + sortField + ' ' + sortOrder + ' NULLS LAST';
            querystr = query + ' ' + whereClause + ' ' + sortClause;
            
            system.debug('* * * query ...'+ querystr);
            
        }
        
        List<Contact> lstContact = database.query(querystr);            
        
        List<Contact> returnListContact = new List<Contact>();
        List<Id> ids = new List<Id>();
        if(lstContact.size() > pageSize) {
            Integer count = 1;
            Integer page = 1;
            for(Contact con :lstContact){
                if(page == pageCurrent) {
                    returnListContact.add(con);
                    ids.add(con.Id);
                }
                count++;
                if(count > pageSize) {
                    count=1;
                    page++;
                }
            }
        } else {
            returnListContact = lstContact;
        }
        
        searchResults results = new searchResults();
        
        if(lstContact.size() > pageSize) {
            results.lstUser = [select Id, Name, FullPhotoUrl, ContactId from User where ContactId in :ids];    
        } else {
            for(Contact c :lstContact)
                ids.add(c.Id);
            results.lstUser = [select Id, Name, FullPhotoUrl, ContactId from User where ContactId in :ids];
        }
        
        Decimal myDecimal = lstContact.size();
        Decimal divDec = myDecimal.divide(pageSize, 0, System.RoundingMode.UP);
        results.lstContact = returnListContact;
        results.pages = divDec.intValue();
        
        return results; 
    }
    
    
    @RemoteAction 
    public static List<wrapperUtils.wrapperProductInfo> getSwitchDetails(){
        return SwitchLayer.swithcLogic();  
    }
    
    @RemoteAction
    public static List<wrapperUtils.wrapperProductDetails> getOtherexamcodes(){
        List<wrapperUtils.wrapperProductDetails> lstDetails = FBRICBRUtils.getProductCodes();
        return lstDetails;
    }
    
    @RemoteAction
    public static Registration.wrapperCreateOrder getUnDefferedExams(id eaID, String prodCode, String glCode, Boolean bWire){
        Registration.wrapperCreateOrder wco = PortalClass.unDeferrExamAttempts(eaID,prodCode,glCode,bWire);
        if(wco != null && wco.opportunityId != null)
            wco = prepareWCO(wco, wco.opportunityId);
        return wco;
        //return '';
    }
    
    @RemoteAction
    public static wrapperProductInfo getDefferedExams(){
        PortalClass.getDefferedExams();
        wrapperProductInfo obj = new wrapperProductInfo();
        obj.bFRM1Deffered  = PortalClass.bFRM1Deffered;
        obj.bFRM2Deffered  = PortalClass.bFRM2Deffered;
        obj.bFRM1UnDeffered  = PortalClass.bFRM1UnDeffered;
        obj.bFRM2UnDeffered  = PortalClass.bFRM2UnDeffered;
        obj.bERPDeffered  = PortalClass.bERPDeffered;
        obj.bERP1Deffered  = PortalClass.bERP1Deffered;
        obj.bERP2Deffered  = PortalClass.bERP2Deffered;
        obj.bERP1UnDeffered  = PortalClass.bERP1UnDeffered;
        obj.bERP2UnDeffered  = PortalClass.bERP2UnDeffered;
        obj.bFRMSwitch= PortalClass.bFRMCanSwitch;
        obj.bERPSwitch= PortalClass.bERPCanSwitch;
        return obj;
    } 
    
    @RemoteAction
    public static Map<String,Registration.wrapperProductInfo> getProductCodes(){
        return Registration.getProductCodes(); 
    }    
    
    
    @RemoteAction
    public static id getParentId(){
        return PortalClass.getParentId();
    } 
    
    @RemoteAction
    public static boolean confirmProctorDownload(String proctorApplicationId){
        
        String userId = UserInfo.getUserId();   
        /*     
List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
if( lstUser != null && lstUser.size() > 0 ) { 
List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Roster_Downloaded_Date__c from Proctor_Registration__c where Id = :proctorApplicationId];

if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
Date now = date.today();
lstProctorRegistration[0].put('Roster_Downloaded_Date__c',now);                
update lstProctorRegistration[0];
}             
}
*/
        return true;
    }
    
    /*
    
    @RemoteAction
    public static Proctor_Registration__c setProctorRole(String siteId, String proctorId, String role){
        
        String userId = UserInfo.getUserId();        
        
        List<User> lstUser = [SELECT u.Id, u.ContactId FROM User u WHERE u.Id = :userId];
        
        if(!lstUser.isEmpty()) { 
            
            Proctor_Registration__c lstProctorRegistration = [SELECT Id, Name, Selected__c, Type__c, Type_of_Workday__c, Total_Payment__c FROM Proctor_Registration__c WHERE Test_Site__c = :siteId AND Id = :proctorId LIMIT 1];
            
            if(lstProctorRegistration != null) { 
                
                lstProctorRegistration.put('Type__c', role);   
                UPDATE lstProctorRegistration;
                
                lstProctorRegistration = [SELECT Id, Name, Selected__c, Type_of_Workday__c, Total_Payment__c FROM Proctor_Registration__c WHERE Id = :lstProctorRegistration.Id];
                
                return lstProctorRegistration;
                
            }  
            
        }
        
        return null;
        
    }
    
    
    @RemoteAction
    public static Proctor_Registration__c setProctorTypeOfWorkday(String siteId, String proctorId, String typeOfWorday){
        
        String userId = UserInfo.getUserId();        
        
        List<User> lstUser = [SELECT u.Id, u.ContactId FROM User u WHERE u.Id = :userId];
        
        if(!lstUser.isEmpty()) { 
            
            Proctor_Registration__c lstProctorRegistration = [SELECT Id, Name, Selected__c, Type_of_Workday__c, Total_Payment__c FROM Proctor_Registration__c WHERE Test_Site__c = :siteId AND Id = :proctorId LIMIT 1];
            
            if(lstProctorRegistration != null) { 
                
                lstProctorRegistration.put('Type_of_Workday__c', typeOfWorday);               
                UPDATE lstProctorRegistration;
                
                lstProctorRegistration = [SELECT Id, Name, Selected__c, Type_of_Workday__c, Total_Payment__c FROM Proctor_Registration__c WHERE Id = :lstProctorRegistration.Id];
                
                return lstProctorRegistration;
                
            }             
            
        }
        
        return null;
        
    }
    
    @RemoteAction
    public static List<Proctor_Registration__c> confirmProctorSelection(String siteId, String supervisor, String proctors){
        
        String userId = UserInfo.getUserId();        
        
        List<User> lstUser = [SELECT u.Id, u.ContactId FROM User u WHERE u.Id = :userId];
        
        if(!lstUser.isEmpty()) { 
            
            List<Proctor_Registration__c> lstProctors = (List<Proctor_Registration__c>)JSON.deserialize(proctors, List<Proctor_Registration__c>.class); 
            
            string accountId = Default_Record_References__c.getAll().get('UNMATCHED-BUSINESS-ACCOUNT').Record_Reference_ID__c;
            List<Account> lstAcct = [select Id, Name from Account where Id =: accountId];
            
            if(lstAcct != NULL && lstAcct.size() > 0) {
                //if(!lstProctors.isEmpty())ActivateProctorRegistrationService.activateProctorRegistrations(lstProctors, lstAcct[0].Id);             
            }            
            
            lstProctors.add((Proctor_Registration__c)JSON.deserialize(supervisor, Proctor_Registration__c.class));
            
            List<Proctor_Registration__c> toUpdate = new List<Proctor_Registration__c>();
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            
            for(Proctor_Registration__c proctor: lstProctors){
                
                if(proctor.Type__c != 'Supervisor' && proctor.Invitation_Sent_Datetime__c == null && proctor.Proctor_Email__c != null){
                    
                    if(proctor.Exam_Site_Date__c != null){
                        
                        proctor.Invitation_Sent_Datetime__c = Datetime.now();
                        
                        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        msg.setToAddresses(new List<String>{proctor.Proctor_Email__c});
                        
                        msg.setSubject('GARP: You Have Been Selected to Proctor the ' + Datetime.newInstance(proctor.Exam_Site_Date__c.year(), proctor.Exam_Site_Date__c.month(), proctor.Exam_Site_Date__c.day()).format('MMMM dd, yyyy') + ' Exam');
                        
                        String  htmlBody = '<p>You have been selected as a ' + proctor.Type__c + ' for the upcoming exam on ' + Datetime.newInstance(proctor.Exam_Site_Date__c.year(), proctor.Exam_Site_Date__c.month(), proctor.Exam_Site_Date__c.day()).format('MMMM dd, yyyy') + '.</p>';
                        htmlBody+= '<p>Please complete your proctor application by going to my.garp.org/login.</p>';
                        
                        msg.setHTMLBody(htmlBody);
                        
                        emails.add(msg);
                        
                    }
                    
                }
                
                proctor.Selected__c = true;
                proctor.Proctor_Selected_Date__c = Datetime.now();
                toUpdate.add(proctor);
                
            }
            
            if(!toUpdate.isEmpty()){
                UPDATE toUpdate;
            }
            
            if(!emails.isEmpty()){
                Messaging.sendEmail(emails);
            }
            
            return toUpdate;
            
        }
        
        return null;
        
    }
    
    */
    
    @RemoteAction
    public static boolean confirmExamAttestation(String examAttemptId){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            
            List<Exam_Attempt__c> lstExamAttempts = [select Id, Ticket_Download_Date__c from Exam_Attempt__c where Id = :examAttemptId];
            
            if( lstExamAttempts != null && lstExamAttempts.size() > 0 ) { 
                Datetime now = Datetime.now();
                Exam_Attempt__c examAttempt = lstExamAttempts[0];
                examAttempt.put('Ticket_Download_Date__c', now);
                update examAttempt;
            }
            return true;             
        }
        else { 
            return false;
        }
    }
    
    @RemoteAction
    public static boolean confirmExamResultsViewed(String examAttemptId){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            
            List<Exam_Attempt__c> lstExamAttempts = [select Id, Results_Viewed_Date__c from Exam_Attempt__c where Id = :examAttemptId];
            
            if( lstExamAttempts != null && lstExamAttempts.size() > 0 ) { 
                Datetime now = Datetime.now();
                Exam_Attempt__c examAttempt = lstExamAttempts[0];
                examAttempt.put('Results_Viewed_Date__c', now);
                update examAttempt;
            }
            return true;             
        }
        else { 
            return false;
        }
    }
    
    @RemoteAction
    public static boolean confirmProctor(String proctorApplicationId){
        
        String userId = UserInfo.getUserId(); 
        /*      
List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];

if( lstUser != null && lstUser.size() > 0 ) { 
List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Selected__c, Confirmed__c from Proctor_Registration__c where Id = :proctorApplicationId];

if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
lstProctorRegistration[0].put('Confirmed__c',true);                
update lstProctorRegistration[0];
}             
}
*/
        return true;
    }
    
    /*
    @RemoteAction
    public static Proctor_Registration__c selectProctor(String siteId, String proctorId, Boolean selected){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [SELECT u.Id, u.ContactId FROM User u WHERE u.Id = :userId];
        
        if(!lstUser.isEmpty()) { 
            
            Proctor_Registration__c lstProctorRegistration = [
                SELECT 
                Id, 
                Name, 
                Selected__c, 
                Status__c, 
                Confirmed__c, 
                Proctor_First_Name__c, 
                Proctor_Last_Name__c, 
                Proctor_Email__c, 
                Proctor_Selected_Date__c 
                FROM Proctor_Registration__c 
                WHERE Test_Site__c = :siteId AND Id = :proctorId LIMIT 1
            ];
            
            if(lstProctorRegistration != null) { 
                
                lstProctorRegistration.put('Selected__c', selected);       
                
                if(!selected){
                    lstProctorRegistration.put('Proctor_Selected_Date__c', null);
                }
                
                if(selected && lstProctorRegistration.Status__c == 'Vendor Approved'){
                    lstProctorRegistration.Status__c = 'Document Review';//Update status instead of letting the workflow rule handle it so the value is displayed in the view
                }      
                
                UPDATE lstProctorRegistration;
                
                return lstProctorRegistration;
                
            } 
            
        }
        
        return null;
        
    }
    */
    
    @RemoteAction
    public static boolean workedProctor(String siteId, String contactId, Boolean worked){
        
        String userId = UserInfo.getUserId();    
        /*      
List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];

if( lstUser != null && lstUser.size() > 0 ) { 
List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Worked__c, Selected__c, Confirmed__c from Proctor_Registration__c where Test_Site__c = :siteId and Contact__c = :contactId];

if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
lstProctorRegistration[0].put('Worked__c',worked);                       
update lstProctorRegistration[0];
}             
}
*/
        return true;
    }
    
    /*
    @RemoteAction
    public static List<Proctor_Registration__c> getProctorsBySite(String siteId){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        List<Proctor_Registration__c> lstProctorRegistration;
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            String contactId = lstUser[0].ContactId;
            
            lstProctorRegistration = [select Id, Name, Proctor_Email__c, Exam_Site_Date__c, Proctor_Last_Name__c, Proctor_First_Name__c, Worked__c, Invitation_Sent_Datetime__c, Selected__c, Confirmed__c, Type__c, Status__c, Type_of_Workday__c, Total_Payment__c from Proctor_Registration__c where Test_Site__c = :siteId and Type__c != 'Supervisor'];
        }
        return lstProctorRegistration;
    }
    */
    
    @RemoteAction
    public static boolean attestProctorApplication(String proctorApplicationId){
        
        String userId = UserInfo.getUserId(); 
        /*      
List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];

if( lstUser != null && lstUser.size() > 0 ) { 
String contactId = lstUser[0].ContactId;

List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Status__c from Proctor_Registration__c where Id = :proctorApplicationId];                        
if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
lstProctorRegistration[0].put('Status__c','Approved');

update lstProctorRegistration[0];
}             
}
*/
        return true;
    }
    
    @RemoteAction
    public static List<Exam_Attempt__c> getProctorSiteRoster(String proctorApplicationId){
        
        String userId = UserInfo.getUserId(); 
        /*
List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];

if( lstUser != null && lstUser.size() > 0 ) { 
String contactId = lstUser[0].ContactId;

List<Proctor_Registration__c> lstProctorRegistration = [select Id, Name, Test_Site__c from Proctor_Registration__c where Id = :proctorApplicationId];            
if( lstProctorRegistration != null && lstProctorRegistration.size() > 0 ) { 
List<Exam_Attempt__c> lstExamAttempt = [SELECT Id, Name, Cancelled__c, Candidate_Commitment__c, Candidate_Commitment__r.Opportunity__c, hasViolation__c, Checked_In__c, Result__c, Defered__c, Exam_Site__r.Exam__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Session__c, Member__r.GARP_ID__c, Member__r.name, Exam_Site__r.Site__r.Site_Code__c, Exam_Site__r.Site__r.Display_Address__c, Room__r.name, Seat_No__c, Ticket_Download_Date__c FROM Exam_Attempt__c where Exam_Site__c = :lstProctorRegistration[0].Test_Site__c];
if( lstExamAttempt != null && lstExamAttempt.size() > 0 ) { 
return lstExamAttempt;
}
}             
}
*/
        return null;
    }
    
    @RemoteAction
    public static boolean attestCPE(String contractReqId){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) { 
            String contactId = lstUser[0].ContactId;
            
            List<Candidate_Requirement__c> lstContractReq = [select Id, Name, Status__c from Candidate_Requirement__c where Id = :contractReqId];                        
            if( lstContractReq != null && lstContractReq.size() > 0 ) { 
                lstContractReq[0].put('Status__c','Completed');
                lstContractReq[0].put('Date_of_Completion__c',system.today());
                
                update lstContractReq[0];
            }             
        }
        return true;
    }
    
    
    @RemoteAction
    public static List<Chapter_Meeting_Registration__c> fetchChapterMeetingRegister(String chapterMeetingId){ 
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations;
        if(utilities.verifyChapterMeetingRights(chapterMeetingId, false, true, false)) {
            lstChapterMeetingRegistrations = [select Id, Name, Status__c, Attended__c, Contact__r.FirstName, Contact__r.LastName, 
                                              Contact__r.Corporate_Title__c, Contact__r.Company__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :chapterMeetingId];
        }
        return lstChapterMeetingRegistrations;
    }
    
    
    @RemoteAction
    public static List<Chapter_Meeting_Registration__c> toggelAttendance(String chapterMeetingId, String registrationId){        
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations;
        
        if(utilities.verifyChapterMeetingRights(chapterMeetingId, false, true, false)) {
            lstChapterMeetingRegistrations = [select Id, Name, Status__c, Attended__c, Contact__r.Name from Chapter_Meeting_Registration__c where Id=:registrationId];
            if(lstChapterMeetingRegistrations != null && lstChapterMeetingRegistrations.size() > 0) {
                if(lstChapterMeetingRegistrations[0].Attended__c == false) {
                    lstChapterMeetingRegistrations[0].Attended__c=true;
                }else{
                    lstChapterMeetingRegistrations[0].Attended__c=false;
                }
                update lstChapterMeetingRegistrations;
            }
            lstChapterMeetingRegistrations = [select Id, Name, Status__c, Attended__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Corporate_Title__c, Contact__r.Company__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :chapterMeetingId];
        }            
        return lstChapterMeetingRegistrations;
    }
    
    @RemoteAction
    public static Registration.wrapperCreateChapterMeetingRegistration chapterMeetingRegister(TempAccount objData){
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations;
        
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            return Registration.createChapterMeetingRegistration(objData, contactId);
        } else {
            return null;
        }
    }        
    
    
    @RemoteAction
    public static Registration.wrapperCreateChapterMeetingRegistration publicChapterMeetingRegister(TempAccount objData){
        return Registration.createChapterMeetingRegistration(objData, NULL);
    }
    
    @RemoteAction
    public static boolean setChapterMeetingConfirm(String registrationId){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations;
        
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            lstChapterMeetingRegistrations = [select Id, Name, Status__c from Chapter_Meeting_Registration__c where Id = :registrationId];
            if( lstChapterMeetingRegistrations != null && lstChapterMeetingRegistrations.size() > 0 ) {
                lstChapterMeetingRegistrations[0].put('Status__c','Confirmed');
                update lstChapterMeetingRegistrations;
            }        
        }
        return true;
    }     
    
    @RemoteAction
    public static List<Chapter_Meeting_Registration__c> getChapterMeetingRegistrations(){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations;
        
        if( lstUser != null && lstUser.size() > 0 ) {
            String contactId = lstUser[0].ContactId;
            lstChapterMeetingRegistrations = [select Id, Name, Role__c, Status__c, Ticket_QR__c, Chapter_Meeting__c, Chapter_Meeting__r.Name, Chapter_Meeting__r.Chapter_Meeting_Name__c, 
                                              Chapter_Meeting__r.Synopsis__c, 
                                              Chapter_Meeting__r.Start__c, Chapter_Meeting__r.End__c, Chapter_Meeting__r.Status__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting__r.Chapter_Meeting_Location__r.Name, Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_Postal_Code__c from Chapter_Meeting_Registration__c where Contact__c = :contactId];
        }
        return lstChapterMeetingRegistrations;
    }     
    
    @RemoteAction
    public static boolean signDirectorCode(String chapterId){
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            String contactId = lstUser[0].ContactId;
            
            List<Chapter_Member__c> lstChapterMember = [select Id, Name, Chapter_Director_Agreement_Signed_Date__c, Director__c from Chapter_Member__c where Contact__c = :contactId and Chapter__c = :chapterId];
            if( lstChapterMember != null && lstChapterMember.size() > 0 ) {
                datetime myDateTime = datetime.now();
                lstChapterMember[0].Chapter_Director_Agreement_Signed_Date__c=myDateTime;
                lstChapterMember[0].Director__c=true;
                update lstChapterMember[0];
            }
        }
        return true;
    } 
    
    @RemoteAction
    public static Registration.wrapperCreateOrder buyProductsByCode(LIST<purchaseCodeData> products, String opportunityName){
        
        String paymentId;        
        String userId = UserInfo.getUserId();        
        
        getUserReturnData rd = new getUserReturnData ();
        
        system.debug('* * * products: '+ products);
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            rd.userData = lstUser;        
            String contactId = lstUser[0].ContactId;
            
            List<Contact> lstContact = [SELECT Id, Name, FirstName, LastName, Email, HomePhone, Company__c, Mailing_Address_Company__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_Member_ID__c, Membership_Type__c FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                Registration.wrapperCreateOrder wco = new Registration.wrapperCreateOrder();
                wco.contactId = lstContact[0].Id;
                wco.garpId = lstContact[0].GARP_Member_ID__c;
                
                rd.contactData = lstContact;
                String accountId = lstContact[0].AccountId;        
                List<Account> lstAcct = [select Id, Name, Billing_Address_Company__c, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet from Account where Id = :lstContact[0].AccountId];
                
                Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');                
                List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
                
                Opportunity opp = new Opportunity();
                opp.Name=opportunityName;                    
                opp.StageName='New Lead';
                opp.CloseDate = system.today();
                opp.AccountId=accountId;
                //opp.Amount=totalCost;
                opp.RecordTypeId = recordTypeID;
                
                opp.ChargentSFA__Billing_Email__c = lstContact[0].Email;
                opp.ChargentSFA__Billing_First__c = lstContact[0].FirstName;
                opp.ChargentSFA__Billing_Last__c = lstContact[0].LastName;
                opp.ChargentSFA__Billing_Phone__c = lstContact[0].HomePhone;
                
                
                opp.ChargentSFA__Billing_Address__c = lstAcct[0].BillingStreet;
                opp.ChargentSFA__Billing_City__c = lstAcct[0].BillingCity;
                opp.ChargentSFA__Billing_State__c = lstAcct[0].BillingState;
                opp.ChargentSFA__Billing_Zip__c = lstAcct[0].BillingPostalCode;
                opp.ChargentSFA__Billing_Country__c = lstAcct[0].BillingCountry;
                opp.ChargentSFA__Billing_Company__c = lstAcct[0].Billing_Address_Company__c;
                
                opp.Shipping_First_Name__c = lstContact[0].FirstName;
                opp.Shipping_Last_Name__c = lstContact[0].LastName;
                opp.Shipping_E_mail__c = lstContact[0].Email;
                opp.Shipping_Company_Name__c = lstContact[0].Company__c;
                opp.Shipping_Phone_No__c = lstContact[0].HomePhone;
                opp.Shipping_Street__c = lstContact[0].MailingStreet;
                opp.Shipping_City__c = lstContact[0].MailingCity;
                opp.Shipping_State__c = lstContact[0].MailingState;
                opp.Shipping_Postal_Code__c = lstContact[0].MailingPostalCode;
                opp.Shipping_Country__c = lstContact[0].MailingCountry;
                opp.Shipping_Company_Name__c = lstContact[0].Mailing_Address_Company__c;
                
                
                // Chargent Data
                //opp.ChargentSFA__Charge_Amount__c = totalCost;
                insert opp;                
                wco.opportunityId = opp.Id;
                
                OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=lstContact[0].Id, Role='Decision Maker');
                insert contactRole;
                
                Decimal totalCost = 0;
                List<ID> idList = new List<ID>();
                List<String> prodCodes = new List<String>();
                List<PricebookEntry> lstPrice;
                
                for(purchaseCodeData pc :products) {
                    prodCodes.add(pc.prodCode);
                }
                
                List<PricebookEntry> lstPricebookEntry = [
                    SELECT Product2.Id, Product2.FRM_Exam__c, Product2.ERP_Exam__c, Product2.Name, Product2.ProductCode, Product2.GL_Code__c, Product2.Description, Product2.Image__c, Product2.IsActive, Product2.Weight__c, Product2.FRM_1_Book__c, Product2.FRM_2_Book__c, Product2.ERP_Study_Center__c, Product2.FBR_Study_Center__c, Product2.ICBRR_Study_Center__c, Product2.SCR_Study_Center__c, Pricebook2.IsActive, UnitPrice, UseStandardPrice 
                    FROM PriceBookEntry 
                    WHERE Pricebook2.IsActive = true and Product2.IsActive = true and pricebook2.IsActive = true
                ];
                MAP<String,PricebookEntry> mapPrice = new MAP<String,PricebookEntry>();
                for(PricebookEntry pe :lstPricebookEntry) {
                    mapPrice.put(pe.Product2.ProductCode+':'+pe.Product2.GL_Code__c,pe);
                }
                System.Debug('mapPrice:' + mapPrice);
                
                Integer months=0;
                String productDetails='';
                
                Integer numShipProds=0;
                Decimal amtShip=0;
                for(purchaseCodeData pur :products){
                
                    system.debug('* * * pur1: '+ pur);
                
                    PricebookEntry fndPrice = mapPrice.get(pur.prodCode+':'+pur.glCode);
                    if(fndPrice != NULL && fndPrice.Product2.Weight__c != NULL && fndPrice.Product2.Weight__c > 0) {
                        numShipProds++; 
                    }
                    if(fndPrice != NULL && fndPrice.Product2.ProductCode == 'SHIP') {
                        amtShip+=Decimal.ValueOf(pur.price);
                    }
                }
                system.debug('* * * numShipProds: '+ numShipProds);
                system.debug('* * * amtShip: '+ amtShip);
                
                for(purchaseCodeData pur :products){
                    
                    system.debug('* * * pur2: '+ pur);
                    
                    //PricebookEntry foundProd=null;    
                    //for(PricebookEntry prod :lstPricebookEntry){
                    //    if(prod.Product2.ProductCode == pur.prodCode && prod.Product2.GL_Code__c == pur.glCode) {
                    //        foundProd = prod;
                    //        break;
                    //    }
                    //}
                    PricebookEntry foundProd = mapPrice.get(pur.prodCode+':'+pur.glCode);
                    system.debug('* * * foundProd: '+ foundProd);
                    
                    //opp.Product_Names__c = '';
                    //opp.Total_Package_Weight__c = 0;
                    String shipProd;
                    if(foundProd != null) {
                        
                        if (foundProd.Product2.ProductCode != null && foundProd.Product2.ProductCode == 'SHIP'){
                            system.debug('Ship!: '+ foundProd);
                            continue;
                        }
                        
                        if(foundProd.Product2.FRM_Exam__c==true) {
                            opp.Books_FRM_Practice_Exams__c=true;
                        }
                        
                        if(foundProd.Product2.ERP_Exam__c==true) {
                            opp.Books_ERP_Practice_Exams__c=true;
                        }
                        
                        if(foundProd.Product2.FRM_1_Book__c==true) {
                            opp.Books_FRM_I__c=true;
                            if(foundProd.Product2.Weight__c > 0) {
                                opp.Has_Books__c =true;
                                shipProd='SHIPFRM1:4999';
                            }
                                
                        }
                        
                        if(foundProd.Product2.FRM_2_Book__c==true) {
                            opp.Books_FRM_II__c=true;
                            if(foundProd.Product2.Weight__c > 0) {
                                opp.Has_Books__c =true;
                                shipProd='SHIPFRM2:4999';
                            }
                                
                        }
                        
                        //if(foundProd.Product2.ERP_Study_Center__c==true) {
                        //    opp.Books_ERP__c=true;
                        //    if(foundProd.Product2.Weight__c > 0) {
                        //        opp.Has_Books__c =true;
                        //        shipProd='SHIPFRM1:4999';
                        //    }        
                        //}
                        
                        if(foundProd.Product2.ICBRR_Study_Center__c==true) {
                            opp.Books_ICBRR__c=true;
                            if(foundProd.Product2.Weight__c > 0) {
                                opp.Has_Books__c =true;
                                shipProd='SHIPFRR:4999';
                            }
                                
                            
                        }
                        
                        if(foundProd.Product2.FBR_Study_Center__c==true) {
                            opp.Books_FBR__c=true;
                            if(foundProd.Product2.Weight__c > 0) {
                                opp.Has_Books__c =true;
                                shipProd='SHIPFFR:4999';
                            }                           
                                
                        }
                        
                        if(foundProd.Product2.SCR_Study_Center__c == true) {
                            if(foundProd.Product2.Weight__c > 0) {
                                opp.Has_Books__c =true;
                                shipProd='SHIPSCR:4999';
                            }
                                
                        }
                        
                        system.debug('shipProd: '+ shipProd);
                        
                        if(shipProd!=NULL) {
                            PricebookEntry fndShipProd = mapPrice.get(shipProd);
                            system.debug('fndShipProd: '+ fndShipProd);
                            if(fndShipProd != NULL) {
                                OpportunityLineItem oli = new OpportunityLineItem( 
                                    OpportunityId = opp.Id,
                                    PricebookEntryId    = fndShipProd.Id,
                                    Product2Id          = fndShipProd.Product2Id,
                                    UnitPrice           = amtShip / numShipProds,
                                    Quantity            = 1
                                );
                                system.debug('ship oli: '+ oli);
                                lstOppLineItems.add(oli);
                            }
                            
                        }
                        
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opp.Id;
                        oppLineItem.PricebookEntryId = foundProd.Id;   
                        if(pur.price != null) {
                            oppLineItem.UnitPrice = Decimal.valueOf(pur.price);
                        } else {
                            oppLineItem.UnitPrice = foundProd.UnitPrice;    
                        }
                        if(pur.description != null) {
                            oppLineItem.Description = pur.description;
                        }
                        
                        Decimal cost = oppLineItem.UnitPrice;
                        if(pur.months != null) {
                            months = pur.months;
                        }
                        
                        if(pur.quantity != null) {
                            oppLineItem.Quantity = pur.quantity;
                            cost = cost * pur.quantity;
                        } else {
                            oppLineItem.Quantity = 1;
                        }          
                        
                        if(pur.paymentMethod != null){
                            opp.Alternate_Method_of_Payment__c = pur.paymentMethod;
                        }
                        
                        if (foundProd.Product2.ProductCode == 'PRFEE') {
                            opp.Alternate_Method_of_Payment__c = pur.description;
                        } else if (foundProd.Product2.ProductCode != null && foundProd.Product2.ProductCode == 'SLSTX'){
                            wco.tax = cost;
                        } else if (foundProd.Product2.ProductCode != null && foundProd.Product2.ProductCode == 'SHIP'){
                            wco.shipping = cost;
                        } else if (foundProd.Product2.ProductCode != null && foundProd.Product2.ProductCode == 'MEMR'){
                            
                            opp.Risk_Net__c = true;
                            
                            OpportunityLineItem riskNetOli = new OpportunityLineItem();
                            
                            riskNetOli.OpportunityId = opp.Id;
                            riskNetOli.PricebookEntryId = foundProd.Id;   
                            riskNetOli.Quantity = pur.quantity;
                            
                            if(pur.quantity == 12){
                                riskNetOli.Quantity=1;
                                riskNetOli.UnitPrice = 100.00;
                                //riskNetOli.TotalPrice = 100.00;
                                totalCost += 100;
                                system.debug('check this------'+riskNetOli.Quantity+'------'+riskNetOli.UnitPrice);
                            }else{
                                riskNetOli.UnitPrice = foundProd.UnitPrice;
                                totalCost += foundProd.UnitPrice * riskNetOli.Quantity;
                            }
                            
                            productDetails = foundProd.Product2.ProductCode + '~' + foundProd.Product2.GL_Code__c + '~' + foundProd.Product2.Name + '~' + riskNetOli.UnitPrice + '~' + riskNetOli.Quantity;
                            
                            lstOppLineItems.add(riskNetOli);
                            
                            continue;
                            
                        }
                        
                        totalCost += cost;
                        lstOppLineItems.add(oppLineItem);
                        
                        Decimal quantity = oppLineItem.Quantity;
                        Decimal unitPrice = oppLineItem.UnitPrice;
                        
                        if(productDetails == '') {
                            productDetails = foundProd.Product2.ProductCode + '~' + foundProd.Product2.GL_Code__c + '~' + foundProd.Product2.Name + '~' + unitPrice + '~' + quantity ;
                        } else {
                            productDetails = productDetails + '!' + foundProd.Product2.ProductCode + '~' + foundProd.Product2.GL_Code__c + '~' + foundProd.Product2.Name + '~' + unitPrice + '~' + quantity ;
                        }
                        
                    }                    
                }
                
                INSERT lstOppLineItems;
                
                opp.Amount=totalCost;
                opp.ChargentSFA__Charge_Amount__c = totalCost;
                if(months != 0) {
                    Date now = date.today();
                    Date myDate = Date.newInstance(now.year(), now.month(), 1);
                    myDate = myDate.addMonths(months + 1);
                    opp.Contract_End_Date__c = myDate;
                }
                UPDATE opp;
                
                opp = [select Id, Name, Display_Invoice_Number__c, Company__c from Opportunity where ID = :opp.Id];
                wco.invoiceNumber = opp.Display_Invoice_Number__c;
                wco.company = opp.Company__c;
                wco.totalCost = totalCost;
                wco.productDetails = productDetails;
                
                ChargentSFA__Payment_Request__c objPayment = new ChargentSFA__Payment_Request__c();
                objPayment.ChargentSFA__Billing_Contact__c = contactId;
                objPayment.ChargentSFA__Opportunity__c = opp.Id;
                insert objPayment;
                
                objPayment = [select id, name, ChargentSFA__Pay_Link__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Amount, ChargentSFA__Opportunity__r.Display_Invoice_Number__c from ChargentSFA__Payment_Request__c where id = :objPayment.Id];
                wco.payRequest = objPayment;
                
                return wco;
            }
        }
        
        return null;
    }
    
    @RemoteAction
    public static ChargentSFA__Payment_Request__c payPendingOpportunity(String oppId, String contactId){
        
        ID accountID = utilities.verifyUserAccount();
        
        if(oppId == null || contactId == null || contactId == ''){
            return null;
        }
        
        Opportunity opp = [
            SELECT Id, Name, Amount, ChargentSFA__Tokenization__c, ChargentSFA__Manual_Charge__c, ChargentSFA__Charge_Amount__c, ChargentSFA__Payment_Method__c,
            (
                SELECT Id, Description, PricebookEntryId, Quantity, UnitPrice, SortOrder, TotalPrice FROM OpportunityLineItems
            ) 
            FROM Opportunity 
            WHERE 
            Id = :oppId AND 
            StageName != 'Closed' AND 
            AccountId = :accountID
        ];
        
        if(opp != null) {
            
            if(opp.Amount == 0) {
                
                opp.StageName = 'Closed';
                
                UPDATE opp;
                
                return null;    
                
            } else {
                
                List<ChargentSFA__Transaction__c> lstTrans = [
                    Select id ,Name, ChargentSFA__Amount__c, ChargentSFA__Opportunity__r.CloseDate , ChargentSFA__Opportunity__c,ChargentSFA__Opportunity__r.GARP_Member_ID__c, ChargentSFA__Opportunity__r.StageName , ChargentSFA__Type__c, ChargentSFA__Payment_Method__c, ChargentSFA__Response_Status__c, ChargentSFA__Gateway_Date__c
                    FROM ChargentSFA__Transaction__c  
                    where 
                    ChargentSFA__Amount__c!= NULL and 
                    ChargentSFA__Opportunity__c = :oppId and 
                    ChargentSFA__Opportunity__r.StageName != 'Recurring Intent' AND 
                    ChargentSFA__Type__c = 'Credit' AND 
                    (
                        ChargentSFA__Response_Status__c = 'Approved' OR 
                        ChargentSFA__Response_Status__c = '' OR 
                        ChargentSFA__Response_Status__c = NULL
                    ) 
                    ORDER BY ChargentSFA__Gateway_Date__c ASC
                ];            
                
                if(lstTrans != null && lstTrans.size() > 0) {
                    
                    Decimal amt = opp.Amount;
                    
                    system.debug('amt:' + amt);
                    
                    for(ChargentSFA__Transaction__c ct :lstTrans) {
                        amt-= ct.ChargentSFA__Amount__c;
                        system.debug('amt:' + amt + ':' + ct.ChargentSFA__Amount__c);
                    }
                    
                    opp.ChargentSFA__Manual_Charge__c = true;
                    opp.ChargentSFA__Charge_Amount__c = amt;
                    
                } else {
                    
                    opp.ChargentSFA__Manual_Charge__c = false;
                    
                }
                
                opp.ChargentSFA__Payment_Method__c = 'Credit Card';
                opp.ChargentSFA__Tokenization__c = null;
                
                UPDATE opp;
                
                PriceBookEntry pricebookEntry = [
                    SELECT Id, unitprice, productcode, product2.Gl_Code__c 
                    FROM PriceBookEntry 
                    WHERE 
                    Pricebook2.IsActive = true AND 
                    Pricebook2.IsActive = true AND 
                    ProductCode = 'PRFEE' AND 
                    Product2.Gl_Code__c = '6110' AND 
                    isActive = TRUE
                ];
                
                if(pricebookEntry != null) {
                    
                    List<OpportunityLineItem> lis = new List<OpportunityLineItem>();
                    
                    for(OpportunityLineItem ol :opp.OpportunityLineItems){
                        if(ol.PricebookEntryId == pricebookEntry.Id) {
                            ol.TotalPrice = 0;
                            lis.add(ol);
                        }
                    }
                    
                    UPDATE lis;
                    
                    ChargentSFA__Payment_Request__c objPayment;
                    
                    List<ChargentSFA__Payment_Request__c> objPaymentList = [
                        SELECT id, name, ChargentSFA__Pay_Link__c 
                        FROM ChargentSFA__Payment_Request__c 
                        WHERE 
                        ChargentSFA__Opportunity__c = :oppId AND 
                        ChargentSFA__Status__c != 'Cancelled'
                    ];
                    
                    if(objPaymentList != null && objPaymentList.size() > 0) {
                        for(ChargentSFA__Payment_Request__c pr :objPaymentList) {
                            pr.ChargentSFA__Status__c = 'Cancelled';
                        }
                        UPDATE objPaymentList;
                    }
                    
                    ChargentSFA__Payment_Request__c objPaymentNew = new ChargentSFA__Payment_Request__c();
                    objPaymentNew.ChargentSFA__Billing_Contact__c = contactId;
                    objPaymentNew.ChargentSFA__Opportunity__c = opp.Id;    
                    
                    INSERT objPaymentNew;
                    
                    objPayment = [
                        SELECT id, name, ChargentSFA__Pay_Link__c 
                        FROM ChargentSFA__Payment_Request__c 
                        WHERE id = :objPaymentNew.Id
                    ];
                    
                    return objPayment;
                    
                }   
                
            }
            
        }
        
        return null;
        
    }
    
    
    @RemoteAction
    public static ChargentSFA__Payment_Request__c buyProducts(LIST<purchaseData> products){
        
        String paymentId;        
        String userId = UserInfo.getUserId();        
        
        getUserReturnData rd = new getUserReturnData ();
        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            rd.userData = lstUser;        
            String contactId = lstUser[0].ContactId;
            
            List<Contact> lstContact = Database.query('SELECT Id, Name, FirstName, LastName, Email, HomePhone, Company__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_ID__c, Membership_Type__c FROM Contact WHERE Id = :contactId');
            
            if( lstContact != null && lstContact.size() > 0 ) {
                
                rd.contactData = lstContact;
                String accountId = lstContact[0].AccountId;
                
                List<Account> lstAcct = [select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet from Account where Id = :lstContact[0].AccountId];
                
                if( lstAcct != null && lstAcct.size() > 0 ) {
                    
                    Integer totalCost = 0;
                    List<ID> idList = new List<ID>();
                    for(purchaseData pur :products){
                        totalCost+= integer.valueof(pur.price);
                        idList.add(pur.Id);
                    }
                    
                    Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
                    Opportunity opp = new Opportunity();
                    opp.Name='Purchase';
                    opp.StageName='New Lead';
                    opp.CloseDate = system.today();
                    opp.AccountId=accountId;
                    opp.Amount=totalCost;
                    opp.RecordTypeId = recordTypeID;
                    
                    opp.ChargentSFA__Billing_Email__c = lstContact[0].Email;
                    opp.ChargentSFA__Billing_First__c = lstContact[0].FirstName;
                    opp.ChargentSFA__Billing_Last__c = lstContact[0].LastName;
                    opp.ChargentSFA__Billing_Phone__c = lstContact[0].HomePhone;
                    opp.ChargentSFA__Billing_Company__c = lstContact[0].Company__c;
                    
                    opp.ChargentSFA__Billing_Address__c = lstAcct[0].BillingStreet;
                    opp.ChargentSFA__Billing_City__c = lstAcct[0].BillingCity;
                    opp.ChargentSFA__Billing_State__c = lstAcct[0].BillingState;
                    opp.ChargentSFA__Billing_Zip__c = lstAcct[0].BillingPostalCode;
                    opp.ChargentSFA__Billing_Country__c = lstAcct[0].BillingCountry;
                    
                    opp.Shipping_First_Name__c = lstContact[0].FirstName;
                    opp.Shipping_Last_Name__c = lstContact[0].LastName;
                    opp.Shipping_E_mail__c = lstContact[0].Email;
                    opp.Shipping_Company_Name__c = lstContact[0].Company__c;
                    opp.Shipping_Phone_No__c = lstContact[0].HomePhone;
                    opp.Shipping_Street__c = lstContact[0].MailingStreet;
                    opp.Shipping_City__c = lstContact[0].MailingCity;
                    opp.Shipping_State__c = lstContact[0].MailingState;
                    opp.Shipping_Postal_Code__c = lstContact[0].MailingPostalCode;
                    opp.Shipping_Country__c = lstContact[0].MailingCountry;
                    
                    // Chargent Data
                    opp.ChargentSFA__Charge_Amount__c = totalCost;
                    insert opp;
                    
                    OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=lstContact[0].Id, Role='Decision Maker');
                    insert contactRole;
                    
                    List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
                    for(PriceBookEntry PricebookEntryId : [select unitprice,productcode from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in: idList and isActive = true]) 
                    {
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opp.Id;
                        oppLineItem.PricebookEntryId = PricebookEntryId.Id;   
                        oppLineItem.UnitPrice = totalCost;
                        oppLineItem.Quantity=1;
                        lstOppLineItems.add(oppLineItem);
                    }
                    insert lstOppLineItems;             
                    
                    
                    
                    ChargentSFA__Payment_Request__c objPayment = new ChargentSFA__Payment_Request__c();
                    
                    objPayment.ChargentSFA__Billing_Contact__c = contactId;
                    objPayment.ChargentSFA__Opportunity__c = opp.Id;                    
                    insert objPayment;
                    
                    objPayment = [select id, name, ChargentSFA__Pay_Link__c from ChargentSFA__Payment_Request__c where id = :objPayment.Id];
                    
                    return objPayment;
                }
            }
        }
        
        return null; 
    }
    
    @RemoteAction
    public static productData getStudyProducts(String mode){
        
        productData prodData = new productData();
        List<Product2> lstProducts;
        if(mode == 'FRM'){
            lstProducts = [select Id, Name, Description, Image__c, Weight__c, Inventory__c, Pre_Order_Date__c, Coming_Soon__c, Pre_Order_Shipping_Date__c, Electronic_Delivery__c, Content__c, Product_ID__c from Product2 where FRM_Study_Center__c = true];
        } else if (mode == 'ERP'){
            lstProducts = [select Id, Name, Description, Image__c, Weight__c, Inventory__c, Pre_Order_Date__c, Coming_Soon__c, Pre_Order_Shipping_Date__c, Electronic_Delivery__c, Content__c, Product_ID__c from Product2 where ERP_Study_Center__c = true];
        } else if(mode == 'FBR'){
            lstProducts = [select Id, Name, Description, Image__c, Weight__c, Inventory__c, Pre_Order_Date__c, Coming_Soon__c, Pre_Order_Shipping_Date__c, Electronic_Delivery__c, Content__c, Product_ID__c from Product2 where FBR_Study_Center__c = true];
        } else if(mode == 'ICBRR'){
            lstProducts = [select Id, Name, Description, Image__c, Weight__c, Inventory__c, Pre_Order_Date__c, Coming_Soon__c, Pre_Order_Shipping_Date__c, Electronic_Delivery__c, Content__c, Product_ID__c from Product2 where ICBRR_Study_Center__c = true];
        } else if(mode == 'SCR'){
            lstProducts = [select Id, Name, Description, Image__c, Weight__c, Inventory__c, Pre_Order_Date__c, Coming_Soon__c, Pre_Order_Shipping_Date__c, Electronic_Delivery__c, Content__c, Product_ID__c from Product2 where SCR_Study_Center__c = true];
        }
        
        if( lstProducts != null && lstProducts.size() > 0 ) {
            List<ID> ids = new List<ID>();
            for(Product2 prod :lstProducts) {
                if(prod.Content__c != null)
                    ids.add(prod.Content__c);
                if(prod.Name == 'ICBRR Handbooks') {
                    prod.Name = 'FRR Handbooks';
                    prod.Description = 'Financial Risk and Regulation Handbooks';
                }
            }
            //System.assert(false, 'BOOM!' + ids);                  
            prodData.product = lstProducts;
            List<PricebookEntry> lstPrice = [select Id, Name, UnitPrice, Product2Id, ProductCode, Product2.Weight__c, Product2.Pre_Order_Shipping_Date__c, Product2.Display_Sort_Order__c, Product2.Content__c from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in :lstProducts and IsActive=true order by Product2.Display_Sort_Order__c];
            prodData.price = lstPrice;
            
            List<Content__c> lstContent = [
                select 
                Id, 
                Lead_Gen_URL__c,
                Name, 
                Content_Name__c, 
                RecordTypeId, 
                Description__c, 
                SKU__c, 
                External_ID__c,
                Google_Tracking_Name__c,  
                Category__c, 
                Subcategory__c, 
                Media_Type__c, 
                Next_Version__c,
                Next_Version__r.Content_Name__c,
                Next_Version__r.Lead_Gen_URL__c,             
                Is_advertisement__c, 
                Image__c, 
                Third_Party_Author__c, 
                Author__r.Name, 
                Author__c, 
                Book_Author__c, 
                Book_Publisher__c, 
                Book_Title__c, 
                Featured__c, 
                Featured_Order__c, 
                Display_Sort_Order__c, 
                Column__c, 
                Published_Date__c, 
                Story__c, 
                Mobile_Story__c,
                Third_Party_URL__c, 
                Duration_in_Minutes__c, 
                Event_Start_Date_Time__c, 
                Is_On_Demand__c, 
                Moderators__c, 
                Presenters__c, 
                Start_Date__c, 
                End_Date__c, 
                Visibility_ERP__c, 
                Visibility_FRM__c, 
                Visibility_SCR__c,
                Visibility_Membership__c, 
                Location__c, 
                Vanity_URL__c, 
                Hashtag__c, 
                Status__c, 
                Share_Count__c, 
                View_Count__c 
                FROM Content__c 
                WHERE Id IN :ids ORDER BY Published_Date__c DESC
            ];
            
            List<cdrive__Cloud_Files__c> lstCloudFiles = [select Id, cdrive__contextID__c, cdrive__File_Name__c from cdrive__Cloud_Files__c where cdrive__contextID__c in :ids];
            MAP<String,cdrive__Cloud_Files__c> mapCloudFiles = new MAP<String,cdrive__Cloud_Files__c>();
            for(cdrive__Cloud_Files__c cf :lstCloudFiles) {
                mapCloudFiles.put(cf.cdrive__contextID__c + '~' + cf.cdrive__File_Name__c, cf);
            }
            
            if(lstCloudFiles != null && lstCloudFiles.size() > 0) {
                for(Content__c cont :lstContent) {
                    cdrive__Cloud_Files__c fnd = mapCloudFiles.get(cont.id + '~' + cont.Image__c);
                    if(fnd != null) {
                        cont.Image__c = 'https://s3-us-west-2.amazonaws.com/garpsalesforcepublic/Content__c/' + cont.Id + '/' + fnd.Id + '_' + cont.Image__c;
                    }
                }
            }
            prodData.Content = lstContent;
        }            
        return prodData;
    } 
    
    
    @RemoteAction
    public static productData getFRMStudyProducts(){
        
        productData prodData = new productData();
        List<Product2> lstProducts = [select Id, Name, Description, Image__c from Product2 where FRM_Study_Center__c = true];
        if( lstProducts != null && lstProducts.size() > 0 ) {
            prodData.product = lstProducts;
            List<PricebookEntry> lstPrice = [select Id, Name, UnitPrice, Product2Id, ProductCode from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in :lstProducts and IsActive=true];
            prodData.price = lstPrice;
        }            
        return prodData;
    } 
    
    @RemoteAction
    public static productData getERPStudyProducts(){
        
        productData prodData = new productData();
        List<Product2> lstProducts = [select Id, Name, Description, Image__c from Product2 where ERP_Study_Center__c = true];
        if( lstProducts != null && lstProducts.size() > 0 ) {
            prodData.product = lstProducts;
            List<PricebookEntry> lstPrice = [select Id, Name, UnitPrice, Product2Id, ProductCode from PriceBookEntry where Pricebook2.IsActive = true and Product2Id in :lstProducts and IsActive=true];
            prodData.price = lstPrice;
        }            
        return prodData;
    } 
    
    @RemoteAction
    public static List<Document> getFolderDocs(String name){
        
        List<Document> lstDocs;
        List<Folder> lstfolder = [Select Id from folder where Name = :name];
        if( lstfolder != null && lstfolder.size() > 0 ) {
            lstDocs = [
                SELECT Id, Name, ContentType, Description, Url, LastModifiedDate, Keywords
                FROM Document 
                WHERE folderId = :lstfolder[0].Id
                ORDER BY Name ASC
            ];
        }
        return lstDocs;
    }  
    
    
    @RemoteAction
    global static Boolean requestNewChapter(String name, String type, String loction) { 
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            String contactId = lstUser[0].ContactId;
            
            system.debug('* * * contactId ...'+ contactId);
            //System.assert(false, 'BOOM!');
            
            List<Contact> lstContact = [SELECT Id, Name FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                Chapter__c ch = new Chapter__c();
                ch.put('Name',name);
                ch.put('Type__c',type);
                ch.put('Location__c',loction);
                ch.put('Status__c','Requested');
                insert ch;
                
                if(ch != null) {
                    Chapter_Member__c cm = new Chapter_Member__c();
                    cm.put('Chapter__c',ch.id);
                    cm.put('Contact__c',contactId);
                    cm.put('Director_Application_Status__c','Upload');
                    insert cm;
                }
            }
        }
        return true;
    }
    
    @RemoteAction
    public static CPEActivitiesWrapper getCPEActivities(){
        utilities.verifyLoggedInUser();
        CPEActivitiesWrapper saw = new CPEActivitiesWrapper();
        
        List<CPE_Activity__c> ca = [select Id, Name, Title__c, Description__c, Status__c, Location__c, Start_Date__c, End_Date__c, CPE_Activity_Type__r.Name, Area_of_Study__c, Credit__c, Activity_Date__c, Date_Description__c, Organization__c, Provider__c, Account__c, Publication__c, URL__c from CPE_Activity__c where Status__c = 'Active'];
        if(ca != null && ca.size() > 0) {
            
            List<Id> aids = new List<Id>();
            List<CPE_Activity__c> cpdActReturn = new List<CPE_Activity__c>();
            
            for(CPE_Activity__c c : ca) {
                
                datetime nowDateTime = datetime.now();
                Boolean addContent = true;
                if(c.End_Date__c == null && c.Start_Date__c != null && nowDateTime >= c.Start_Date__c) {
                    addContent = true;
                } else if(c.Start_Date__c == null && c.End_Date__c != null && nowDateTime < c.End_Date__c) {
                    addContent = true;
                } else if(c.Start_Date__c != null && c.End_Date__c != null && nowDateTime >= c.Start_Date__c && nowDateTime < c.End_Date__c) {
                    addContent = true;
                } else if(c.Start_Date__c == null && c.End_Date__c == null){
                    addContent = true;
                }       
                if(addContent == true) {
                    cpdActReturn.add(c);
                    aids.add(c.Account__c);
                }
                
            }
            List<Account> acct = [select Id, Name, CPE_Provider_Logo__c from Account where Id in :aids];
            saw.accounts = acct;
            saw.activities = cpdActReturn;
        }
        return saw;
    }
    
    @RemoteAction 
    public static Boolean submitCreditContent(String activityTypeId, String cpeCandidateRequirementId) {
        
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            List<Contact> lstContact = [select Id, Name, KPI_FRM_Certified__c, KPI_ERP_Certified__c from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                List<CPE_Activity__c> lstDocs = [select Id, Name, Title__c, Description__c, CPE_Activity_Type__c, Activity_Type_Description__c, Area_of_Study__c, Credit__c, Date_Description__c, Organization__c, Provider__c, Account__c, Publication__c, URL__c from CPE_Activity__c where Id = :activityTypeId];
                
                if( lstDocs != null && lstDocs.size() > 0 && lstDocs[0].CPE_Activity_Type__c != null && lstDocs[0].Credit__c != null && lstDocs[0].Title__c != null) {
                    
                    CPE_Activity__c doc = lstDocs[0];
                    Date now = date.today();
                    
                    CPE_Claim__c newClaim = new CPE_Claim__c();
                    newClaim.Candidate_Requirement__c = cpeCandidateRequirementId;
                    newClaim.CPE_Activity_Type__c = doc.CPE_Activity_Type__c;
                    newClaim.Date_of_Completion__c = now;
                    newClaim.Credits_Earned__c = doc.Credit__c;
                    newClaim.EventTitle__c = doc.Title__c;
                    newClaim.CPD_Activity__c = activityTypeId;
                    if(doc.Organization__c != null) {
                        newClaim.OrganizationName__c = doc.Organization__c;
                    }
                    if(doc.Account__c != null) {
                        newClaim.Provider__c = doc.Account__c;
                    }
                    if(doc.Area_of_Study__c != null) {
                        newClaim.Area_of_Study__c = doc.Area_of_Study__c;
                    }
                    if(doc.Publication__c != null) {
                        newClaim.Publication__c = doc.Publication__c;
                    }
                    if(doc.URL__c != null) {
                        newClaim.URL__c = doc.URL__c;
                    }
                    if(doc.Description__c != null) {
                        if(doc.Description__c.length() > 255) {
                            newClaim.Comment__c = doc.Description__c.substring(0, 255);        
                        } else {
                            newClaim.Comment__c = doc.Description__c;        
                        }
                        
                    }
                    
                    newClaim.Member__c = lstContact[0].Id;
                    newClaim.FRM__c = lstContact[0].KPI_FRM_Certified__c;
                    newClaim.ERP__c = lstContact[0].KPI_ERP_Certified__c;
                    insert newClaim;
                    return true;
                }
            }
        }
        return false;
    }
    
    @RemoteAction
    public static List<contentData> getContentDocs(String name){
        
        List<Content__c> lstDocs;
        List<contentData> lstContentData = new List<contentData>();
        
        List<Folder__c> lstfolder = [Select Id from Folder__c where Name = :name];
        if( lstfolder != null && lstfolder.size() > 0 ) {
            lstDocs = [SELECT Id,Name,Tagline__c,Content_Name__c,RecordTypeId,Description__c,SKU__c, Is_advertisement__c, Image__c,Third_Party_Author__c, Author__r.Name,Content_Type__c,Featured__c, Published_Date__c,Story__c,Start_Date__c,Lead_Gen_URL__c,
                       Topic__c, 
                       End_Date__c, 
                       Third_Party_URL__c, 
                       Third_Party_Portal_URL__c, 
                       Duration_in_Minutes__c, 
                       Event_Start_Date_Time__c, 
                       Is_On_Demand__c, 
                       Moderators__c, 
                       Presenters__c, 
                       Visibility_ERP__c, 
                       Visibility_FRM__c, 
                       Visibility_SCR__c, 
                       Visibility_Membership__c, 
                       Location__c, 
                       Display_Sort_Order__c,
                       Next_Version__c,
                       Next_Version__r.Content_Name__c,
                       Next_Version__r.Lead_Gen_URL__c
                       FROM Content__c 
                       WHERE Status__c = 'Active' AND Id in (SELECT Content__c FROM Content_Folders__c WHERE Folder__c = :lstfolder[0].Id) ORDER BY Display_Sort_Order__c
                      ];
            
            if( lstDocs != null && lstDocs.size() > 0 ) {
                
                sfdcAppRemoter sr = new sfdcAppRemoter();        
                lstContentData = sr.filterContentDocs(lstDocs, null); 
                List<ID> ids = new List<ID>();
                for(contentData cont :lstContentData) {
                    ids.add(cont.content.Id);
                }
                List<cdrive__Cloud_Files__c> lstCloudFiles = [select Id, cdrive__contextID__c, cdrive__File_Name__c from cdrive__Cloud_Files__c where cdrive__contextID__c in :ids];
                MAP<String,cdrive__Cloud_Files__c> mapCloudFiles = new MAP<String,cdrive__Cloud_Files__c>();
                if(lstCloudFiles != null && lstCloudFiles.size() > 0) {
                    for(cdrive__Cloud_Files__c cf :lstCloudFiles) {
                        mapCloudFiles.put(cf.cdrive__contextID__c + '~' + cf.cdrive__File_Name__c, cf);
                    }                    
                    for(contentData cont :lstContentData) {
                        cdrive__Cloud_Files__c fnd = mapCloudFiles.get(cont.content.id + '~' + cont.content.Image__c);
                        if(fnd != null) {
                            cont.content.Image__c = 'https://s3-us-west-2.amazonaws.com/garpsalesforcepublic/Content__c/' + cont.content.Id + '/' + fnd.Id + '_' + cont.content.Image__c;
                        }
                    }
                }
            }
        }        
        return lstContentData;
    }  
    
    @RemoteAction
    global static Boolean requestChapterDirector(String chapterId) {  
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            String contactId = lstUser[0].ContactId;
            
            system.debug('* * * contactId ...'+ contactId);
            
            List<Contact> lstContact = [SELECT Id, Name FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                
                List<Chapter_Member__c> lstchapterMember = [SELECT Id, Name, Chapter__c, Contact__c FROM Chapter_Member__c WHERE Chapter__c = :chapterId and Contact__c = :contactId];
                if( lstchapterMember != null && lstchapterMember.size() > 0 ) {             
                    lstchapterMember[0].put('Director_Application_Status__c','New');
                    update lstchapterMember[0];
                } else {
                    Chapter_Member__c cm = new Chapter_Member__c();
                    cm.Contact__c=contactId;
                    cm.chapter__c=chapterId;
                    cm.Director_Application_Status__c='New';
                    insert cm;
                }
            }
        }
        return true;
    }
    
    @RemoteAction
    global static Boolean setChapters(String chapId1, String chapId2) { 
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            String contactId = lstUser[0].ContactId;
            
            system.debug('* * * contactId ...'+ contactId);
            
            List<Contact> lstContact = [SELECT Id, Name FROM Contact WHERE Id = :contactId];
            if( lstContact != null && lstContact.size() > 0 ) {
                List<Chapter_Member__c> lstChapterMember = [select Id, Name, Director__c, Chapter__c, Can_Manage_Attendance__c, Can_Request_Meetings__c, Can_View_Resources__c, IsPrimary__c, IsSecondary__c from Chapter_Member__c where Contact__c = :contactId AND (IsPrimary__c = true OR IsSecondary__c = true)];
                boolean everFound1=false;
                boolean everFound2=false;
                
                boolean everFoundDirector=false;
                boolean everFoundView=false;
                boolean everFoundRequest=false;
                boolean everFoundAttendance=false;
                
                for(Chapter_Member__c cm: lstChapterMember) {
                    
                    String id = cm.Chapter__c;
                    boolean found1=false;
                    boolean found2=false;
                    
                    if(id.compareTo(chapId1) == 0){
                        everFound1=found1=true;                        
                    } else if(id.compareTo(chapId2) == 0) {
                        everFound2=found2=true;
                    } else {
                        if(cm.Director__c != null && cm.Director__c==true)
                            everFoundDirector=true;
                        if(cm.Can_View_Resources__c != null && cm.Can_View_Resources__c==true)
                            everFoundView=true;
                        if(cm.Can_View_Resources__c != null && cm.Can_Manage_Attendance__c==true)
                            everFoundAttendance=true;
                        if(cm.Can_View_Resources__c != null && cm.Can_Request_Meetings__c==true)
                            everFoundRequest=true;                        
                    }
                    
                    
                    system.debug('* * * Loop ...'+id + ':' + chapId1 + ':' + chapId2 + ':');
                    system.debug('* * * Loop ...'+found1 + ':' + everFound1 + ':' + found2 + ':' + everFound2);
                    
                    if(!found1 && !found2) {
                        if(everFoundView || everFoundAttendance || everFoundRequest || everFoundDirector) {
                            cm.IsPrimary__c=false;
                            cm.IsSecondary__c=false;
                            update cm;
                        } else {
                            delete cm;     
                        }
                    }
                }
                
                system.debug('* * * Loop Done ...'+ everFound1 + ':' + everFound2);
                
                if(!everFound1 && chapId1.length() > 0){
                    Chapter_Member__c cm = new Chapter_Member__c();
                    cm.Contact__c=contactId;
                    cm.chapter__c=chapId1;
                    cm.IsPrimary__c=true;
                    insert cm;
                }
                if(!everFound2 && chapId2.length() > 0){
                    Chapter_Member__c cm = new Chapter_Member__c();
                    cm.Contact__c=contactId;
                    cm.chapter__c=chapId2;
                    cm.IsSecondary__c=true;
                    insert cm;
                }
            }
        }
        
        return true;
    }
    
    @RemoteAction
    global static List<Exam_Attempt__c> changeCycle(String contractId) {
        
        ID vAccountID = utilities.verifyUserAccount();
        List<Exam_Attempt__c> EA = [SELECT Id, Name FROM Exam_Attempt__c where Id =  :contractId];
        List<Contract> lstContract = [SELECT Id, Name, RecordTypeId, StartDate, EndDate, Status FROM Contract WHERE Id = :contractId AND AccountID = :vAccountID];                      
        
        if( lstContract != null && lstContract.size() > 0 ) {
            Contract contract = lstContract[0];
            date startDate = contract.StartDate.addYears(1);
            contract.put('StartDate',startDate);
            update contract;
        }
        
        return EA;
    }
    
    @RemoteAction
    public static String createOppFreeERP(String contactId) {
         String returnID;
        
        Contact objContact = [select id,name,Email,account.BillingStreet,Account.BillingState,Account.BillingCountry,Company_Clean_Name__c,Account.BillingCity, FirstName, HomePhone, LastName, Mailing_Address_Company__c, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode,accountId from Contact where id =: contactId];
        
        Opportunity Newopp = new opportunity();
        if(objContact != null)
        {
            Map<Id,Opportunity> mapOppByAccount = new Map<Id,Opportunity>();
            Newopp.Name = 'Free Ebook Extension';
            Newopp.accountid = objContact.accountid;
            Newopp.StageName = 'New Lead';
            Newopp.CloseDate =system.today();
            Newopp.ChargentSFA__Billing_Address__c = objContact.account.BillingStreet;
            Newopp.ChargentSFA__Billing_City__c    = objContact.account.BillingCity;
            Newopp.ChargentSFA__Billing_Company__c = objContact.Company_Clean_Name__c;
            Newopp.ChargentSFA__Billing_Country__c = objContact.account.BillingCountry;
            Newopp.ChargentSFA__Billing_Email__c   = objContact.Email;
            Newopp.ChargentSFA__Billing_Last__c    = objContact.LastName;
            Newopp.ChargentSFA__Billing_First__c   = objContact.FirstName;
            Newopp.ChargentSFA__Billing_Phone__c   = objContact.HomePhone;
            Newopp.ChargentSFA__Billing_Postcode__c= objContact.MailingPostalCode;
            Newopp.ChargentSFA__Billing_State__c   = objContact.account.BillingState;
            
            
            Newopp.Shipping_Last_Name__c           = objContact.LastName;
            Newopp.Shipping_First_Name__c          = objContact.FirstName;
            Newopp.Shipping_Street__c              = objContact.account.BillingStreet;
            Newopp.Shipping_City__c                = objContact.account.BillingCity;
            Newopp.Shipping_Country__c             = objContact.account.BillingCountry;
            Newopp.Shipping_E_mail__c              = objContact.Email;
            Newopp.Shipping_Phone_No__c            = objContact.HomePhone;
            Newopp.Shipping_Postal_Code__c         = objContact.MailingPostalCode;
            Newopp.Shipping_State__c               = objContact.account.BillingState;
            
            Newopp.Give_Ebook_for_Free__c = true;
            Newopp.E_book_Type__c ='ERP Part I';
    
            insert Newopp;
            returnID = Newopp.Id;
    
            PriceBookEntry PricebookEntryId = [select unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode = 'ENC1X' and product2.Gl_Code__c = '4030' and isActive = true];
            List<OpportunityLineItem> lstOppLines = new List<OpportunityLineItem>();
    
            mapOppByAccount.put(Newopp.accountId,Newopp);
            OpportunityLineItem oppLine = new OpportunityLineItem(OpportunityId = Newopp.id,PricebookEntryId  = PricebookEntryId.Id,Quantity =1,UnitPrice =0);
            lstOppLines.add(oppLine);
    
            insert oppLine;
            
            paymentUtils.publishPaymentEvent(newOpp.Id, 0.00, 'Approved');
        }
        return returnID;
    }

    
    @RemoteAction
    global static List<Account>  fetchAcademicInstitutions() {        
        
        utilities.verifyLoggedInUser();
        Id AcademicRecordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Academic Institution');
        
        List<Account> lstAcct = [select Id, Name from Account where recordTypeId = :AcademicRecordTypeId];
        
        return lstAcct;
    }
    
    @RemoteAction
    global static List<Institution__c>  fetchCompanies() {
        Id recId = RecordTypeHelper.GetRecordTypeId('Institution__c','Organization');
        List<Institution__c> lstCompanies = [Select Id, Institution_Name__c from Institution__c where RecordTypeId = :recId];
        return lstCompanies;
    }
    
    @RemoteAction
    global static List<Institution__c>  fetchAcedmicInstitutions() {
        Id recId = RecordTypeHelper.GetRecordTypeId('Institution__c','Academic');
        List<Institution__c> lstSchools = [Select Id, Institution_Name__c from Institution__c where RecordTypeId = :recId];
        return lstSchools;
    }
    
    @RemoteAction
    public static getUserReturnData fetchUserDataById(String contactInputID) {
        system.debug('fetchUserData!');
        return fetchUserDataInternal(contactInputID);
    }
    
    
    @RemoteAction
    public static getUserReturnData fetchUserData() {
        system.debug('fetchUserData!');
        return fetchUserDataInternal(null);
    }
    
    public static getUserReturnData fetchUserDataInternal(String contactInputID) {
        
        getUserReturnData rd = new getUserReturnData ();
        String contactId = null;
        
        if(contactInputID != null) {
            rd.userData = null;
            contactId = contactInputID;
            List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.ContactId = :contactId];
            if( lstUser != null && lstUser.size() > 0 ) {
                rd.userData = lstUser;        
            }
            
        } else {
            
            String userId = UserInfo.getUserId();        
            List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
            if( lstUser != null && lstUser.size() > 0 ) {
                rd.userData = lstUser;        
                contactId = lstUser[0].ContactId;
            }
        }
        
        Map<String,Tax_Rate__c> csTaxRate = Tax_Rate__c.getall();
        Tax_Rate__c taxRate = csTaxRate.get('NJ');
        if(taxRate != NULL) {
            rd.NJtax = csTaxRate.get('NJ').Percent_Tax__c;    
        }        
        
        if(contactId != null) {
            
            List<Contact> lstContact = [
                SELECT 
                Id, 
                RecordTypeId, 
                RecordType.Name,
                Name, 
                FirstName, 
                FullName__c, 
                LastName, 
                Email, 
                HomePhone, 
                OtherPhone, 
                MobilePhone,
                Phone,
                Title, 
                Photo_URL__c,
                GARP_Member_ID__c, 
                Date_Joined__c,            
                MailingCity, 
                MailingCountry, 
                MailingPostalCode, 
                MailingState, 
                MailingStreet, 
                Mailing_Address_Company__c, 
                Account.BillingCountry,
                KPI_CPE_Current_Cycle__c,
                KPI_CPE_Last_Completed_Cycle__c, 
                RPT_Clean_Country__c,
                AccountId, GARP_ID__c, 
                Membership_Type__c,
                Name_As_it_Appears_On_ID__c, 
                ID_Number__c, ID_Type__c, OSTA_ID_Location__c,
                GARP_Directory_Opt_In__c, 
                First_Name_as_it_Appears_on_ID__c,
                Middle_Name_as_it_Appears_on_ID__c,
                Last_Name_as_it_Appears_on_ID__c,                
                KPI_Membership_Payment_Status__c, KPI_CPE_Requirement_Status__c,               
                KPI_CPE_Participation__c,
                KPI_Chapter_Director__c,
                KPI_ERP_Candidate__c, 
                KPI_ERP_Certified_Date__c, 
                KPI_Current_Exam_Registration__c, 
                KPI_FRM_Candidate__c,
                KPI_FRM_Certified_Date__c,
                KPI_FRM_Certified_Year__c,
                KPI_ERP_Certified_Year__c,
                KPI_Last_Exam_Registration__c,
                KPI_Membership_Since__c, 
                KPI_FRM_Certified__c, 
                KPI_ERP_Certified__c,                
                KPI_Member__c,
                KPI_Proctor_Supervisor__c,
                KPI_Chapter_Meeting_Speaker__c,
                KPI_Proctor__c,
                Venue_Contact__c,
                Research_Fellow_Award_Recipient__c,
                Author__c,
                KPI_GARP_Board_Member__c,
                KPI_Chapter_Committee_Member__c,
                KPI_Item_Writer__c,
                KPI_Event_Speaker__c,
                GARP_Business_Relationship__c, 
                
                Job_Function__c,
                Risk_Specialty__c,
                Area_of_Concentration__c, 
                Corporate_Title__c, 
                Company__c,                 
                Professional_Designation_CA__c,
                Professional_Designation_CFA__c,
                Professional_Designation_CMA__c, 
                Professional_Designation_CPA__c, 
                Professional_Designation_PMP__c, 
                Professional_Designation_ACCA__c,
                Professional_Designation_Other__c, 
                Other_Qualifications__c, 
                Years_of_Experience__c, 
                Currently_in_School__c, 
                Currently_Working__c,
                Currently_in_School_Status__c,
                Currently_Working_Status__c, 
                School_Name__c, 
                Degree_Program_Name__c, 
                How_Did_You_Hear_About_Us__c,
                How_Did_You_Hear_About_Us_Other__c,
                Industry_Working_Year__c,
                Risk_Management_Working_Year__c,
                Highest_Degree__c,
                Expected_Graduation_Date__c,
                Expected_Graduation_Month__c,
                GARP_Directory_Invite_Opt_Out__c,
                GARP_Directory_Connect_Feature__c,
                GARP_Dir_Privacy_Additional_Detail__c,
                GARP_Dir_Privacy_Job_Information__c,
                GARP_Dir_Privacy_Prof_Background__c, 
                Exam_Prep_Provider_Outreach__c,
                KPI_FRM_Resume_Certificate_Sent_Date__c, 
                KPI_ERP_Resume_Certificate_Sent_Date__c,
                KPI_GARP_Committee_Member__c, 
                Has_HL_Communities_Access__c,
                GBI_Participant__c,
                Event_Participant__c,
                Event_Contributor__c,
                Full_Name_in_Chinese__c,
                Gender__c,
                Birthdate,
                ID_Expiration_Date__c,
                EPP_Data_Manager__c,
                GT_Account__c,
                Block_Communities_Access__c,
                Experience__c,
                Ambassador__c,
                Student_Ambassador__c,
                Corporate_Ambassador__c,
                KPI_SCR_Attempts__c,
                KPI_SCR_Candidate__c,
                KPI_SCR_Completion_Date__c,
                KPI_SCR_Holder__c,
                KPI_SCR_Last_Integration_Data_Status__c,
                Last_Date_Subscription_Changed__c,
                SCR_Updates__c,
                Can_Vote_on_Board__c,
                OSTA_Street__c,
                OSTA_Recipient_Name__c,
                OSTA_ProvinceTerritory__c,
                OSTA_Phone_Number__c,
                OSTA_City__c,
                OSTA_Building_Village__c,
                OSTA_District_Country__c
                FROM Contact 
                WHERE Id = :contactId
            ];
            
            rd.examAlerts = MemberNotificationClass.getMemberNotificationsExamAlerts(contactId);
            System.debug('examAlerts:' + rd.examAlerts);
            
            if( lstContact != null && lstContact.size() > 0 ) {
                
                rd.contactData = lstContact;
                String accountId = lstContact[0].AccountId;
                
                rd.eppAccountData = [
                    SELECT
                    Id,
                    Name,
                    Account__c,
                    Alternate_EPP_Contact__c,
                    Alternate_EPP_Contact_Email__c,
                    Alternate_EPP_Contact_Name__c,
                    Alternate_EPP_Contact_Phone__c,
                    Alternate_Teaching_Format__c,
                    EPP_Contact_Email__c,
                    EPP_Contact_Phone__c,
                    EPP_Contract_Expiration_Date__c,
                    EPP_List_Last_Download_Date__c,
                    EPP_Location__c,
                    EPP_Location_Description__c,
                    EPP_Logo__c,
                    EPP_Overview__c,
                    EPP_Region_s__c,
                    EPP_Registration_Status__c,
                    EPP_Website__c,
                    EPP_ERP__c,
                    EPP_FBR__c,
                    EPP_FRM__c,
                    EPP_SCR__c,
                    EPP_ICBRR__c,
                    Primary_EPP_Contact__c,
                    Teaching_Format__c  
                    FROM 
                    EPP_Account__c
                    WHERE 
                    Primary_EPP_Contact__c = :contactId AND
                    EPP_Registration_Status__c = 'Approved'
                ];
                
                List<Account> lstAccount = [
                    SELECT Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c, Phone,
                    RecordType.Name , Block_Purchases_All_Types__c, Block_Purchases_Except_Wire__c
                    FROM Account 
                    WHERE Id = :accountId
                ];
                
                if( lstAccount != null && lstAccount.size() > 0 ) {
                    
                    rd.accountData = lstAccount;
                    
                    List<Experience__c> lstExperience = [SELECT Id,Start_Date__c, Name, Company__c,Title__c,Company__r.Name,CompanyOther__c, Type_of_Experience__c,Job_Description__c,End_Date__c,Manager_Name__c from Experience__c  where Contact__c = :contactId AND Status__c != 'To Be Deleted'];
                    
                    rd.experienceData = new List<Experience>();
                    for(Experience__c exp : lstExperience){
                        Experience experience = new Experience();
                        experience.Id = exp.Id;
                        experience.managerName = exp.Manager_Name__c;
                        experience.jobTitle = exp.Title__c;
                        experience.startDate = String.valueof(exp.Start_Date__c);
                        if(exp.Company__c != null){
                            experience.Company = exp.Company__r.Name;
                        }else{
                            experience.Company = exp.CompanyOther__c;
                        }
                        if(exp.End_Date__c != null)
                            experience.endDate = String.valueof(exp.End_Date__c);
                        experience.description = exp.Job_Description__c;
                        rd.experienceData.add(experience);
                    }
                    
                    List<Exam_Attempt__c> lstExamAttempt = [
                        SELECT 
                        Id, 
                        Name,
                        Re_score_Status__c, 
                        Deferral_Status__c, 
                        China_Location_Fee_Required__c, 
                        Icbrr_Exam_Date__c, 
                        Program_Name__c, 
                        Program_Abbrev__c, 
                        CreatedDate, 
                        Cancelled__c, 
                        Candidate_Requirement__c, 
                        Opportunity__c, 
                        Section__c, 
                        Opportunity__r.StageName, 
                        Opportunity__r.ChargentSFA__Billing_Country__c, 
                        Opportunity__r.CloseDate, 
                        Candidate_Commitment__c, 
                        Candidate_Commitment__r.EndDate, 
                        Candidate_Commitment__r.SCR_Computed_Expiration_Date__c,
                        Candidate_Commitment__r.Opportunity__c, 
                        Candidate_Commitment__r.Opportunity__r.CloseDate, 
                        Candidate_Commitment__r.Status, 
                        hasViolation__c, 
                        Checked_In__c, 
                        Result__c, 
                        Defered__c, 
                        Exam_Site__r.Exam__r.Name, 
                        Exam_Site__r.Exam__r.Exam__c, 
                        Exam_Site__r.Exam_Date__c, 
                        Exam_Site__r.Exam__r.Exam_Date__c, 
                        Exam_Site__r.Exam__r.Exam_Group__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.FRM_Total_Exam_Takers__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.ERP_Total_Exam_Takers__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.Active__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.Israel_Exam_Date__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_To_Apply_For_Deferral__c, 
                        Exam_Site__r.Exam__r.Exam_Group__r.Scheduling_Not_Available__c,
                        Exam_Site__r.Exam_Provider__r.Name,
                        Session__c, 
                        Member__r.GARP_ID__c, 
                        Member__r.name, 
                        Exam_Site__r.Site__r.Name, 
                        Exam_Site__r.Site__r.Site_Code__c, 
                        Exam_Site__r.Site__r.Display_Address__c, 
                        Exam_Site__r.Site__r.Is_OSTA_Information_Required__c, 
                        Exam_Site__r.Site__r.Is_Gender_Required__c,   
                        Room__r.name, Seat_No__c, 
                        Ticket_Download_Date__c,
                        Registered_On__c, 
                        ADA_Status__c, 
                        RAD_Status__c, 
                        Reporting_Time__c, 
                        Session_Time__c, 
                        Sunday_Exam__c, 
                        Room__r.Venue__r.Country__c, 
                        Room__r.Venue__r.State__c,
                        Reg_Status__c,
                        RecordType.Name,
                        Exam_Registration_Window__r.Exam_Registration_Window_Open__c, 
                        Exam_Registration_Window__r.Exam_Registration_Window_Close__c,
                        Exam_Registration_Window__r.Exam_Results_Release_Date__c,
                        Exam_Registration_Window__r.Exam_Results_Release_Timeframe__c,
                        Exam_Registration_Window__r.Loading_Exam_Results__c,
                        Active_Integration_Data__c,
                        Integration_Data_Status__c,
                        (
                            SELECT 
                            Id, 
                            Name, 
                            Location_Name__c, 
                            Scheduled_Date_Time__c,
                            Assesment_Type__c, 
                            Appointment_Duration__c,
                            Location_Address__c, 
                            Exam_Location_City__c, 
                            Exam_Location_State__c,
                            Exam_Location_Postal_Code__c,
                            Exam_Location_Country__c 
                            FROM Integration_Data__r 
                            WHERE Is_Active__c = True
                            ORDER BY CreatedDate Limit 1
                        ),
                        RPT_Exam_Part__c,
                        RTP_Exam_Location__c,
                        RPT_Exam_Mode__c,                        
                        Exam_Part__c,
                        Exam_Part__r.Name,
                        Exam_Part__r.Exam_Administration__c,
                        Exam_Part__r.Exam__r.Exam__c,
                        Exam_Part__r.Exam_Part_Number__c,
                        Exam_Part__r.Delivery_Method__c,
                        Exam_Part__r.Exam_Date__c,
                        Exam_Part__r.Exam_Start_Date__c,
                        Exam_Administration__r.Name,
                        Exam_Site__r.Name,
                        Integration_Data_Exam_Location__c,
                        Integration_Data_Exam_Scheduled_Date__c,
                        Program_Status__c,
                        Exam_Date__c,
                        OSTA_Consent__c
                        FROM Exam_Attempt__c 
                        WHERE Member__c = :contactId AND Cancelled__c != TRUE
                    ];       
                    
                    if(lstExamAttempt != null && !lstExamAttempt.isEmpty()){
                        
                        // If the associated Exam Group results are being loaded clear Result__c from the data being exposed to the client
                        for(Exam_Attempt__c ea: lstExamAttempt){
                            if(ea.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c){
                                // FRM/ERP Exam Results Loading
                                ea.Result__c = null;
                                //}else if(ea.Exam_Registration_Window__r.Loading_Exam_Results__c){
                                // SCR Exam Results Loading
                                //ea.Result__c = null;
                            }
                        }
                        rd.examAttemptData = lstExamAttempt;
                        
                        Map<Id, Id> mapSites = new Map<Id, Id>();
                        for(Exam_Attempt__c ea :lstExamAttempt) {
                            mapSites.put(ea.Exam_Site__r.Site__c, ea.Exam_Site__r.Site__c);
                        }
                        
                        List<Venue__c> lstVenue = [
                            SELECT Id, Site__c, Name, Location_Special_Instructions__c, Institution_Name__c, Building_Name__c, Address1__c, Address2__c, City__c, State__c, Zipcode__c, Country__c, (SELECT Id, Name FROM Attachments) 
                            FROM Venue__c 
                            WHERE Site__c in :mapSites.keyset() AND Active__c = TRUE
                        ];
                        rd.venueData = lstVenue;
                        
                        List<Room__c> lstRoom = [
                            SELECT Id, Name, Venue__r.Id, Venue__r.Location_Special_Instructions__c, Venue__r.Building_Name__c, Venue__r.Address1__c, Venue__r.Address2__c, Venue__r.City__c, Venue__r.State__c, Venue__r.Zipcode__c, Venue__r.Country__c 
                            FROM Room__c 
                            WHERE Id IN (SELECT room__c FROM Exam_Attempt__c WHERE Id in :lstExamAttempt) AND Active__c = TRUE
                        ];
                        rd.examRoomData = lstRoom;
                        
                    }
                    
                    List<SME_Registration__c> lstsmeRegistration = [
                        SELECT Id, Email__c 
                        FROM SME_Registration__c 
                        WHERE Contact__c = :contactId
                    ]; 
                    rd.smeRegistrationData = lstsmeRegistration;
                    
                    List<Event_Registration__c> lsteventRegistration = [
                        SELECT 
                        Id, 
                        Event__c, 
                        Status__c, 
                        Event_Paid_Date__c,
                        Event__r.Time_Zone__r.Name,
                        Event__r.Max_Capacity_Met__c,
                        Event__r.Online_Meeting_URL__c,
                        Event__r.Online_Meeting_Notes__c,
                        Event__r.Delivery_Method__c,
                        Event__r.Content__c, 
                        Event__r.Content__r.Content_Name__c, 
                        Event__r.Content__r.Vanity_URL__c, 
                        Event__r.Content__r.Description__c, 
                        Event__r.Content__r.Image__c, 
                        Event__r.Content__r.Location__c, 
                        Event__r.Content__r.Raw_HTML__c, 
                        Event__r.Content__r.Event_Start_Date_Time__c, 
                        Event__r.Content__r.Event_End_Date_Time__c, 
                        Event__r.Content__r.Duration_in_Minutes__c, 
                        Event__r.Content__r.Record_Type_Name__c,
                        Event__r.Content__r.Third_Party_URL__c
                        FROM Event_Registration__c 
                        WHERE Contact__c = :contactId
                    ];
                    rd.eventRegistrationData = lsteventRegistration;
                    
                    List<Webcast_Registration__c > lstWebcastRegistration = [
                        SELECT 
                        Id, 
                        Webcast__c, 
                        Status__c,
                        Webcast__r.Content__c, 
                        Webcast__r.On_Demand_URL__c,
                        Webcast__r.Content__r.Content_Name__c, 
                        Webcast__r.Content__r.Vanity_URL__c, 
                        Webcast__r.Content__r.Description__c, 
                        Webcast__r.Content__r.Image__c, 
                        Webcast__r.Content__r.Location__c, 
                        Webcast__r.Content__r.Raw_HTML__c, 
                        Webcast__r.Content__r.Event_Start_Date_Time__c, 
                        Webcast__r.Content__r.Event_End_Date_Time__c, 
                        Webcast__r.Content__r.Duration_in_Minutes__c, 
                        Webcast__r.Content__r.Record_Type_Name__c,
                        Webcast__r.Content__r.Third_Party_URL__c
                        FROM Webcast_Registration__c 
                        WHERE Contact__c = :contactId
                    ];
                    rd.webcastRegistrationData = lstWebcastRegistration;
                    /*
List<Proctor_Registration__c> lstproctorRegistration = [
SELECT 
Id, 
Name, Status__c, 
Selected__c, 
Confirmed__c, 
Exam_Group__r.Name, 
Exam_Group__c, 
Test_Site__c, 
Proctor_Email__c,
Box_Shipping_Address_1__c, 
Box_Shipping_Address_2__c, Box_Shipping_Address_3__c, 
Box_Shipping_City__c, 
Box_Shipping_Country__c, 
Box_Shipping_Postal_Code__c, 
Box_Shipping_State_Provence__c, 
Exam_Shipping_Address_1__c, 
Exam_Shipping_Address_2__c, 
Exam_Shipping_Address_3__c, 
Exam_Shipping_City__c, 
Exam_Shipping_Country__c, 
Exam_Shipping_Postal_Code__c, 
Exam_Shipping_State_Provence__c,
Payment_Shipping_Company__c,
Payment_Shipping_Address_1__c,
Payment_Shipping_Address_2__c,
Payment_Shipping_Address_3__c,
Payment_Shipping_City__c,
Payment_Shipping_State_Provence__c,
Payment_Shipping_Country__c,
Payment_Shipping_Postal_Code__c,
US_Citizen__c,
Payment_Method__c,
Wire_Info_Account_Number_or_IBAN__c,
Wire_Info_Bank_Address__c,
Wire_Info_Bank_Phone__c,
Wire_Info_Bank_Sort_Code__c,
Wire_Info_Bank_SWIFT__c,
Wire_Info_Name_of_Bank_Branch__c,
Wire_Info_Name_on_the_Account__c,
Wire_Info_Proctor_First_Name__c,
Wire_Info_Proctor_Surname__c,
Wire_Info_Special_Instructions__c,
Exam_Group__r.Active__c, 
Exam_Group__r.Exam_Date__c, 
Exam_Group__r.Proctor_Supervisors_Select__c, 
Exam_Group__r.Proctor_Supervisors_Roster_Download__c, 
Exam_Group__r.Last_Date_for_Proctor_Selection__c,
Exam_Group__r.Last_Date_for_Proctor_Info_Updates__c,
Exam_Group__r.Last_Date_for_Supervisor_Info_Updates__c,
Exam_Group__r.Proctor_Website_Open_Date__c,
Exam_Group__r.Proctor_Quiz_URL__c,                        
Test_Site__r.Name, 
Test_Site__r.Display_Address__c, 
Test_Site__r.Site_Code__c,
Test_Site__r.Is_OSTA_Information_Required__c, 
Test_Site__r.Is_Gender_Required__c,   
Type__c, 
Proctor_Type__c,
Vendor_ID__c
FROM Proctor_Registration__c 
WHERE Contact__c = :contactId
ORDER BY Exam_Group__r.Exam_Date__c

];

if(lstproctorRegistration != null && !lstproctorRegistration.isEmpty()){

rd.proctorRegistrationData = lstproctorRegistration;

List<Id> sites = new List<Id>();

for(Proctor_Registration__c pr : lstproctorRegistration) {
sites.add(pr.Test_Site__c);
}

List<Venue__c> lstVenue = [
SELECT Id, Site__c, Name, Location_Special_Instructions__c, Institution_Name__c, Building_Name__c, Address1__c, Address2__c, City__c, State__c, Zipcode__c, Country__c, (SELECT Id, Name FROM Attachments) 
FROM Venue__c 
WHERE Site__c in :sites
];
rd.venueData = lstVenue;

List<Room__c> lstRoom = [
SELECT Id, Name, Venue__r.Id, Venue__r.Location_Special_Instructions__c, Venue__r.Building_Name__c, Venue__r.Address1__c, Venue__r.Address2__c, Venue__r.City__c, Venue__r.State__c, Venue__r.Zipcode__c, Venue__r.Country__c 
FROM Room__c 
WHERE Venue__c in :lstVenue
];
rd.examRoomData = lstRoom;

}        
*/
                    List<Opportunity> lstOpportunity = [
                        SELECT Id, Name, StageName, Amount, Late_EA_Id__c, Institutional_Sale__c, Program_Name__c, 
                        Program_Abbrev__c, CreatedDate, Alternate_Method_of_Payment__c, Purchase_Date__c, LEGACY_Purchase_Date__c,
                        Company__c, Shipping_First_Name__c, Shipping_Last_Name__c, Shipping_Street__c, Shipping_City__c, 
                        Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c, Shipping_E_mail__c, Shipping_Phone_No__c,
                        Shipping_Company_Name__c,  Display_Invoice_Number__c, Renew_Membership__c, ChargentSFA__Payment_Method__c,
                        ChargentSFA__Payment_Received__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c, 
                        ChargentSFA__Billing_Phone__c, ChargentSFA__Billing_Email__c, ChargentSFA__Billing_Company__c, 
                        ChargentSFA__Billing_Address__c, ChargentSFA__Billing_City__c, ChargentSFA__Billing_State__c, 
                        ChargentSFA__Billing_Zip__c, ChargentSFA__Billing_Postcode__c, ChargentSFA__Billing_Country__c,
                        Switch_to_erp__c, Switch_to_frm__c, Event_Order__c, Purchase_Date_Time__c, Exam_Emails__c, 
                        OSTA_Check__c,  
                        (
                            SELECT Id, ProductCode, Product2.ProductCode, Description, PricebookEntryId, Quantity,
                            UnitPrice, SortOrder, TotalPrice, Product_ID__c, Cancel_Refunded__c 
                            FROM OpportunityLineItems
                        ) 
                        FROM Opportunity 
                        WHERE AccountId = :accountId AND StageName != 'Recurring Intent' AND StageName != 'Closed Lost'
                    ];
                    
                    if(lstOpportunity != null && !lstOpportunity.isEmpty()) {
                        
                        rd.opportunityData = lstOpportunity;
                        
                        set<id> opportunityIds = new set<id>();
                        set<id> productIds = new set<id>();
                        for(Opportunity o :lstOpportunity){
                            opportunityIds.add(o.id); 
                            
                            for(OpportunityLineItem ol :o.OpportunityLineItems){
                                productIds.add(ol.PricebookEntryId);
                            }
                        }
                        List<PricebookEntry> lstPriceBookEntry = [SELECT Id, Name, Product2Id, ProductCode from PriceBookEntry where Id in :productIds];
                        
                        rd.priceBookEntryData = lstPriceBookEntry;
                        List<Id> prods = new List<Id>();
                        for(PricebookEntry pe : lstPriceBookEntry) {
                            prods.add(pe.Product2Id);
                        }
                        
                        List<ChargentSFA__Payment_Request__c> lstPayRequest = [Select Id, Name, ChargentSFA__Opportunity__c, ChargentSFA__Pay_Link__c from ChargentSFA__Payment_Request__c where ChargentSFA__Opportunity__c in :opportunityIds];
                        rd.paymentRequestData = lstPayRequest;
                        
                        List<Product2> lstProducts = [select Id, Name, ProductCode, GL_Code__c, Description, Image__c from Product2 where Id in :prods];
                        rd.productData = lstProducts;
                        
                        List<ChargentSFA__Transaction__c> tres = [select Id, Name, ChargentSFA__Response_Message__c, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c in :opportunityIds];
                        rd.transactionData = tres;
                        
                        rd.emailNoteData = [SELECT Id, ChargentSFA__Opportunity__c from ChargentSFA__Email_Notification__c where ChargentSFA__Opportunity__c in :opportunityIds];
                        
                        rd.refundData = [
                            SELECT Id, Product_ID__c, Refund_amount__c, Opportunity__c, Opportunity__r.AccountId, Product__r.ProductCode, Product__r.Product_ID__c 
                            FROM Product_Refunds__c 
                            WHERE Status__c = 'Completed' AND Opportunity__c IN :opportunityIds
                        ];
                        
                    }
                    
                    List<eBook_Key__c> eBookList = [
                        SELECT Name, Cancelled__c, Product_ID__c, Member_EMail__c, Key__c, Is_API__c, Type__c, Status__c, Taken_Date__c, Access_Expiration_Date__c, Expiration_Date__c, Opportunity__c 
                        FROM eBook_Key__c 
                        WHERE Opportunity__c IN :lstOpportunity AND Cancelled__c = FALSE 
                        ORDER BY Taken_Date__c DESC
                    ];
                    if(eBookList != null && eBookList.size() > 0){
                        rd.eBookData = eBookList;
                    }
                    
                    List<CPE_Claim__c> lstCanReq = [Select id,Name,EventTitle__c, Approved__c, Description__c, Credits_Earned__c,Date_of_Completion__c,ApprovedCredits__c,ApprovalComments__c, Candidate_Requirement__r.Candidate_Commitment__c, Candidate_Requirement__r.Name, Candidate_Requirement__r.Candidate_Commitment__r.AccountId from CPE_Claim__c where Candidate_Requirement__r.Candidate_Commitment__r.AccountId=:accountId];
                    
                    if( lstCanReq != null && lstCanReq.size() > 0 ) {                                                                            
                        rd.claimsData = lstCanReq;
                    }
                    
                    List<Contract> lstContract = [
                        SELECT Id, Name, ContractNumber, RecordTypeId, StartDate, EndDate, SCR_Computed_Expiration_Date__c, ContractTerm, Membership_Type__c, Status, All_Requirements_Completed__c, All_Requirements_Completed_Date__c, Opportunity__c, Opportunity__r.StageName, Opportunity__r.Program_Name__c, Opportunity__r.Program_Abbrev__c, 
                        (
                            SELECT Id, Name, Status__c, Date_of_Completion__c, Date_of_Ready_for_Review__c, Approved_Credits__c, Candidate_Commitment__c, Exam__c, RecordTypeID 
                            FROM Candidate_Requirements__r 
                        ) 
                        FROM Contract 
                        WHERE AccountId = :accountId AND Status != 'Canceled'
                    ];                        
                    if(lstContract != null && lstContract.size() > 0) {
                        
                        // Create a map of all Candidate Requirements
                        Map<Id, Candidate_Requirement__c> candidateRequirementsMap = new Map<Id, Candidate_Requirement__c>();  
                        for(Contract contract: lstContract){
                            for(Candidate_Requirement__c candidateRequirement: contract.Candidate_Requirements__r){
                                candidateRequirementsMap.put(candidateRequirement.Id, candidateRequirement);
                            }
                        } 
                        
                        /* 
* If Exam Results are being loaded for the related Exam Registration set 
* Date of Completion to null so that the user can't see their result.
*/
                        for(Exam_Attempt__c examAttempt: lstExamAttempt){
                            if(examAttempt.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c){
                                if(candidateRequirementsMap.containsKey(examAttempt.Candidate_Requirement__c)){
                                    Candidate_Requirement__c cr = candidateRequirementsMap.get(examAttempt.Candidate_Requirement__c);
                                    cr.Status__c = 'Initial';
                                    cr.Date_of_Completion__c = null;
                                }
                            }
                        }   
                        
                        rd.contractData = lstContract;
                        
                    }
                    
                    List<Candidate_Requirement__c> lstContractReq = [
                        SELECT Id, Name, Approved_Credits__c, Candidate_Commitment__c, Date_No_Two_Years__c, 
                        (SELECT Id,Name FROM Attachments) 
                        FROM Candidate_Requirement__c 
                        WHERE Candidate_Commitment__c in :lstContract
                    ];
                    if( lstContractReq != null && lstContractReq.size() > 0 ) {                                                                             
                        rd.candidateRequirementData = lstContractReq; 
                    }
                    
                    List<RecordType> rtypes = [
                        Select Name, Id 
                        From RecordType 
                        where sObjectType = 'Candidate_Requirement__c' and isActive = true
                    ];
                    rd.candidateRequirementRecordTypes = rtypes;
                    
                    rtypes = [
                        Select Name, Id 
                        From RecordType 
                        where sObjectType='Contract' and isActive=true
                    ];
                    
                    rd.contractRecordTypes = rtypes;
                    
                    List<CPE_Activity_Type__c> lstCPEActivity = [Select Id, Name, Organization_Label_Text__c, Provider_Label_Text__c, Publication_Label_Text__c, Title_Label_Text__c, Contact_Email_Label_Text__c from CPE_Activity_Type__c where Active__c = true];                        
                    if( lstCPEActivity != null && lstCPEActivity.size() > 0 ) {                                                                            
                        rd.activityTypeData = lstCPEActivity;
                    }
                    
                    rtypes = [
                        Select Name, Id 
                        From RecordType 
                        where sObjectType='Account' and isActive=true
                    ];
                    
                    Map<String, String> accountRecordTypes = new Map<String, String>();
                    for(RecordType rt: rtypes){
                        accountRecordTypes.put(rt.Name, rt.Id);
                    }
                    
                    String AcademicRecordTypeId = accountRecordTypes.get('Academic Institution');
                    String BusinessRecordTypeId = accountRecordTypes.get('Business');
                    
                    List<Account> lstCPEProviders = [SELECT Id, Name, RecordTypeId, (SELECT CPE_Activity_Type__c, Start_Date__c, End_Date__c FROM CPE_Provider_Activities__r) FROM Account where CPD_Provider__c=true];
                    rd.providerData = lstCPEProviders;
                    
                    List<Account> lstCustomerCompanies = [SELECT Id, Name FROM Account where Customer_Company_List__c=true];          
                    rd.customerCompanyData = lstCustomerCompanies;
                    
                    List<CollaborationGroup> lstCollaborationGroups = [select Id, Name from CollaborationGroup];
                    rd.collaborationGroupsData = lstCollaborationGroups;
                    
                    List<Chapter__c> lstChapters = [select Id, Name, Type__c from Chapter__c where Status__c = 'Active'];
                    rd.chaptersData = lstChapters;
                    
                    system.debug('* * * lstChapters: ' + lstChapters);
                    
                    List<Chapter_Member__c> lstChapterDirectors = [select Id, Name, Chapter_Director_Agreement_Signed_Date__c, CreatedDate, Director__c, Contact__r.Name, Contact__r.Email, Chapter_Director_Bio__c, Chapter__c from Chapter_Member__c where Director__c = true and Chapter__c in :lstChapters];
                    rd.chapterDirectorData = lstChapterDirectors;
                    
                    system.debug('* * * lstChapterDirectors: ' + lstChapterDirectors);
                    
                    List<Chapter_Member__c> lstChapterMember = [select Id, Name, IsPrimary__c, IsSecondary__c, CreatedDate, Director__c, Committee_Member__c, Can_Request_Meetings__c, Can_Manage_Attendance__c, Can_View_Resources__c, Chapter_Director_Bio__c, Chapter__c, Chapter__r.Name, Chapter__r.Location__c, Chapter__r.Time_Zone__c, Chapter__r.Status__c, Director_Application_Status__c, Chapter_Director_Agreement_Signed_Date__c, (SELECT Id,Name FROM Attachments) from Chapter_Member__c where Contact__c = :contactId];
                    rd.chapterMemberData = lstChapterMember;
                    
                    list<Id> lstMyChapters = new list<Id>();
                    
                    for (Chapter_Member__c  cm : lstChapterMember) {
                        if(cm.Chapter__r.Status__c == 'Active') {
                            lstMyChapters.add(cm.Chapter__c);
                        }
                    }
                    
                    datetime myDateTime = datetime.now();
                    
                    List<Chapter_Meeting__c> lstChapterMeetings = [
                        SELECT Id, Name, Synopsis__c, Start__c, End__c, Time_Zone__r.Abbreviation__c, Time_Zone__r.Name, Status__c, Chapter__c, Chapter__r.Name, Chapter_Meeting_Location__r.Address_Street_1__c, Chapter_Meeting_Location__r.Address_Street_2__c, Chapter_Meeting_Location__r.Venue_Location__c, Chapter_Meeting_Location__r.Address_City__c, Chapter_Meeting_Location__r.Address_State_Provence__c , Chapter_Meeting_Location__r.Name, Chapter_Meeting_Location__r.Address_Postal_Code__c, Presentation__c, Ceremony__c, Group_Formation__c 
                        FROM Chapter_Meeting__c 
                        WHERE Status__c = 'Active' and Start__c >= :myDateTime
                    ];
                    rd.chapterMeetingData = lstChapterMeetings;
                    
                    List<Chapter_Meeting_Speaker__c> lstChapterMeetingSpeakers = [select Id, Name, Chapter_Meeting__c, Chapter_Speaker__r.Name, Chapter_Speaker__r.Qualifications__c, Chapter_Speaker__r.Biography__c, Chapter_Speaker__r.Contact__c from Chapter_Meeting_Speaker__c where Chapter_Meeting__c in :lstChapterMeetings];
                    rd.chapterMeetingSpeakerData = lstChapterMeetingSpeakers;
                    
                    List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations = [
                        SELECT 
                        Id, 
                        Name,
                        Chapter_Meeting__r.ON24_URL__c,
                        Chapter_Meeting__r.Delivery_Method__c,
                        Chapter_Meeting__r.Content__c, 
                        Chapter_Meeting__r.Content__r.Content_Name__c, 
                        Chapter_Meeting__r.Content__r.Vanity_URL__c, 
                        Chapter_Meeting__r.Content__r.Description__c, 
                        Chapter_Meeting__r.Content__r.Image__c, 
                        Chapter_Meeting__r.Content__r.Location__c, 
                        Chapter_Meeting__r.Content__r.Raw_HTML__c, 
                        Chapter_Meeting__r.Content__r.Event_Start_Date_Time__c, 
                        Chapter_Meeting__r.Content__r.Event_End_Date_Time__c, 
                        Chapter_Meeting__r.Content__r.Duration_in_Minutes__c, 
                        Chapter_Meeting__r.Content__r.Record_Type_Name__c,
                        Chapter_Meeting__r.Content__r.Third_Party_URL__c,
                        Role__c, 
                        Status__c, 
                        Ticket_QR__c, 
                        Chapter_Meeting__c, 
                        Chapter_Meeting__r.Name, 
                        Chapter_Meeting__r.Chapter_Meeting_Name__c, 
                        Chapter_Meeting__r.Synopsis__c, 
                        Chapter_Meeting__r.Start__c, 
                        Chapter_Meeting__r.End__c, 
                        Chapter_Meeting__r.Status__c, 
                        Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_Street_1__c, 
                        Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_Street_2__c, 
                        Chapter_Meeting__r.Chapter_Meeting_Location__r.Venue_Location__c, 
                        Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_City__c, 
                        Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_State_Provence__c, 
                        Chapter_Meeting__r.Chapter_Meeting_Location__r.Name, 
                        Chapter_Meeting__r.Chapter_Meeting_Location__r.Address_Postal_Code__c 
                        FROM Chapter_Meeting_Registration__c 
                        WHERE Contact__c = :contactId
                        AND Status__c != 'Cancelled'
                    ];
                    
                    rd.chapterMeetingRegistrationData = lstChapterMeetingRegistrations;     
                    
                    Date now = date.today();
                    
                    List<Board_Election__c> lstElection = [select Id, Name from Board_Election__c where Start_Date__c <= :now and End_Date__c >= :now];
                    
                    if( lstElection != null && lstElection.size() > 0 ) {       
                        rd.boardElectionData = lstElection[0];
                    }
                    
                    List<RecordType> lstRecordTypes = [select Id, sobjectType, Name, DeveloperName from RecordType where sobjectType = 'Content__c'];
                    if( lstRecordTypes != null && lstRecordTypes.size() > 0 ) {       
                        rd.contentRecordTypeData = lstRecordTypes;
                    }                        
                    
                    List<Exam_Group__c> lstexamGroup = [
                        SELECT 
                        Id, 
                        Name, 
                        Active__c, 
                        Exam_Date__c, 
                        Exam_Ticket_Available_Date__c, 
                        Proctor_Website_Open_Date__c, 
                        Registration_Start_Date__c, 
                        Last_Date_For_Late_Registration__c, 
                        Last_Date_For_ADA__c, 
                        Last_Date_For_Scholarship__c, 
                        Religious_Alternative_Last_Date__c, 
                        Last_Date_For_Location_Change__c,
                        Last_Date_for_Standard_Registration__c,
                        Last_Date_To_Apply_For_Deferral__c,
                        Scheduling_Not_Available__c,
                        Weekly_Study_Plan_Start_Date__c,
                        ERP_Study_Module_Lead_Gen_URL__c,
                        FRM_Study_Module_Lead_Gen_URL__c,
                        ERP_Free_Reading_Lead_Gen_URL__c,
                        FRM_Free_Reading_Lead_Gen_URL__c,
                        FRM_Study_Materials_Folder__c,
                        ERP_Study_Materials_Folder__c,
                        FRM_Study_Materials_Folder__r.Name,
                        ERP_Study_Materials_Folder__r.Name,
                        (SELECT Id, Name, Exam_Registration_Window_Open__c, Exam_Registration_Window_Close__c, Exam_Results_Release_Timeframe__c FROM Exam_Registration_Windows__r)
                        from Exam_Group__c 
                        where Active__c = true
                    ];
                    
                    if( lstexamGroup != null && lstexamGroup.size() > 0 ) {
                        rd.examGroupData = lstexamGroup;
                        
                        List<Exam__c> lstexams = [SELECT Id, Name FROM Exam__c WHERE Exam_Group__c IN :lstexamGroup];
                        if( lstexams != null && lstexams.size() > 0 ) {
                            
                            List<Exam_Sites__c> lstexamSites = [
                                SELECT Id, Name, 
                                Site__r.Is_OSTA_Information_Required__c, 
                                Site__r.Is_Gender_Required__c 
                                FROM Exam_Sites__c 
                                WHERE Exam__c IN :lstexams
                            ];
                            if( lstexamSites != null && lstexamSites.size() > 0 ) {
                                rd.examSitesData = lstexamSites;
                            }
                            
                        }
                        
                    }
                    
                    // SCR Exam Groups
                    List<Exam_Group__c> scrExamGroupData = [
                        SELECT Id, Name, Registration_Start_Date__c, Scheduling_Not_Available__c, SCR_Study_Materials_Folder__c, SCR_Study_Materials_Folder__r.Name,
                        (
                            SELECT Id, Name, Exam_Registration_Window_Open__c, Exam_Registration_Window_Close__c, Exam_Results_Release_Timeframe__c, Exam_Results_Release_Date__c
                            FROM Exam_Registration_Windows__r
                            ORDER BY Exam_Registration_Window_Open__c ASC
                        )
                        FROM Exam_Group__c 
                        WHERE SCR_Active__c = True
                        LIMIT 1
                    ];
                    
                    if(!scrExamGroupData.isEmpty()){
                        rd.scrExamGroupData = scrExamGroupData[0];
                    }
                    
                    List<Exam_Group__c> frrExamGroupData = [
                        SELECT Id, Name, FRR_Study_Materials_Folder__c, FRR_Study_Materials_Folder__r.Name
                        FROM Exam_Group__c 
                        WHERE Name = 'ICBRR'
                        LIMIT 1
                    ];
                    
                    if(!frrExamGroupData.isEmpty()){
                        rd.frrExamGroupData = frrExamGroupData[0];
                    }
                    
                    rd.membershipOffersData = [select Id, Authenticated_Affiliate_Can_Use_Offer__c, US_Description__c, Display_Name__c, Non_Member_Description__c, Non_US_Description__c, Member_Description__c, Name, US_Required__c, External_Link_Name__c, Info_Link__c, Membership_Required__c, Authenticated_Description__c, Memb_Offer_Description__c, Values_List__c, Memb_Offer_External_Link__c, Memb_Offer_Hashtag__c, Memb_Offer_Logo__c, Memb_Offer_Promo_Code__c, Memb_Offer_Status__c, Memb_Offer_Public_Button_Text__c, Memb_Offer_Portal_Route__c from Membership_Exclusive_Offers__c];                    
                    rd.mobiusProductConfig = Mobius_Products__c.getall();
                }        
            }
        } 
        
        // Removed data for Business Relationship users
        if(rd.contactData != null && !rd.contactData.isEmpty() && rd.contactData[0].RecordType.Name == 'Business Relationship'){
            rd.accountData = null;
            rd.contractData = null;
            rd.opportunityData = null;
        }
        
        // Removed data for non-Individual users
        if(rd.accountData != null && !rd.accountData.isEmpty() && rd.accountData[0].RecordType.Name != 'Individual'){
            rd.accountData = null;
            rd.contractData = null;
            rd.opportunityData = null;
        }
        
        return rd;        
        
    }
    
    @RemoteAction
    global static Boolean deleteFormData(String objectType, String recordId) {
        
        String objectName;
        Boolean publicAccess = False;
        String[] arrText;
        String[] retValues;
        String idCheck;
        String whereClause = ' WHERE Id = :recordId';
        sObject s;
        
        if(objectType != null) {
            arrText = objectType.split('~');                    
            if(arrText.size() > 1) { 
                objectName = arrText[0];
                publicAccess = true;
            } else {
                objectName = objectType;
            }
        }
        
        if(!publicAccess) {
            retValues = Utilities.getSecureWhereClause(objectName, recordId, whereClause);
            whereClause = retValues[0];
            idCheck = retValues[1];
        }
        
        system.debug('whereClause: ' + whereClause);
        
        s = Database.query('SELECT Id FROM ' + objectType + whereClause );
        if(s == NULL) {
            throw new applicationException('Unauthorized Access');
        } else {
            delete s;
        }
        
        return true;
    }
    
    @RemoteAction
    global static Boolean saveFormData(String objectType, String recordId, List<fieldInfo> fields) {
        
        String whereClause = ' WHERE Id = :recordId';
        Boolean publicAccess = true;
        String[] arrText;       
        String[] retValues;
        String idCheck;         
        String query;
        Integer cnt=0;
        sObject s;
        
        for (fieldInfo field : fields) {
            
            if(sfdcAppRemoter.verifyPublicField(objectType, field.name) == false)
                publicAccess = false;
            
            if(cnt == 0) {
                query = field.name;
            } else {
                query = query + ',' + field.name;
            }     
            cnt++;
        }
        
        
        if(String.isEmpty(recordId)) {
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectType);
            s =  targetType.newSObject();
            
        } else {
            if(!publicAccess) {
                retValues = Utilities.getSecureWhereClause(objectType, recordId, whereClause);
                whereClause = retValues[0];
                idCheck = retValues[1];
            }
            system.debug('whereClause: ' + whereClause);
            
            s = Database.query('SELECT ' + query + ' FROM ' + objectType + whereClause);
        }
        
        for (fieldInfo field : fields) {
            System.debug('field name is ' + field.name);  
            System.debug('field value is ' + field.value);
            
            if(field.value == null || field.readOnly == true) {
                continue;
            }
            
            System.debug('field type is ' + field.type);
            
            if(field.type.toLowerCase().compareTo('boolean')== 0) {
                
                if(field.value != null) {     
                    if(field.value.toLowerCase().compareTo('true')== 0) {
                        s.put(field.name, true);  
                    } else {
                        s.put(field.name, false);  
                    }
                } else {
                    s.put(field.name, false);  
                }
            } else if(field.type.toLowerCase().compareTo('double')== 0) {
                
                if(!String.isEmpty(field.value)) {
                    s.put(field.name, decimal.valueOf(field.value));
                }
                
            } else if(field.type.toLowerCase().compareTo('currency')== 0) {
                
                if(!String.isEmpty(field.value)) {
                    s.put(field.name, decimal.valueOf(field.value));
                }
                
            } else if(field.type.toLowerCase().compareTo('reference')== 0) {
                String refVal = field.refValue;
                
                System.debug('reference ' + refVal);
                
                String refOtherField = field.refOtherField;
                System.debug('reference other ' + refOtherField);
                
                //System.assert(false, 'BOOM!' + eventRecordTypeId);
                System.debug('refOtherField ' + refOtherField);
                
                if(!String.isEmpty(refVal)) {
                    s.put(field.name, refVal);
                    if(!String.isEmpty(refOtherField)) {
                        s.put(refOtherField, null);
                    }                    
                } else {    
                    if(!String.isEmpty(refOtherField)) {
                        s.put(refOtherField, field.value);
                    }
                    s.put(field.name, null);
                }
            } else if(field.type.toLowerCase().compareTo('date')== 0) {
                
                //datetime setDate = datetime.newInstance(field.epochValue);
                //Date myDate = date.newinstance(setDate.year(), setDate.month(), setDate.day());                
                Date myDate = Date.parse(field.Value); 
                s.put(field.name, myDate);
                
            } else if(field.type.toLowerCase().compareTo('datetime')== 0 ) {                
                
                datetime setDate = datetime.newInstance(field.epochValue);                
                s.put(field.name, setDate);
                
            } else {
                s.put(field.name, field.value);  
            }
        }
        
        if(String.isEmpty(recordId)) {
            insert s;
        } else {
            update s;
        }        
        
        return true;
    }
    
    @RemoteAction
    global static returnData fetchFormList(String objectType, String parentField, String parentId, List<String> fields) {
        
        String whereClause;
        Boolean publicAccess = true;
        String[] arrText;       
        String[] retValues;
        String idCheck;                 
        
        returnData rd = new returnData();
        Schema.DescribeSObjectResult DR_SObject;
        Map<String, Schema.sObjectField> mapToken_Fields;
        Map<String, Schema.sObjectType> mapToken_SObjects;
        
        Map<string,fieldInfo > resultObject = new Map<String,fieldInfo >();    
        mapToken_SObjects = Schema.getGlobalDescribe();
        
        DR_SObject = mapToken_SObjects.get(objectType).getDescribe();
        
        mapToken_Fields = DR_SObject.fields.getMap();
        
        System.debug('fields ' + DR_SObject.fields);
        
        String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            String contactId = lstUser[0].ContactId;
            String query;
            Integer cnt=0;
            for (String field : fields) {
                
                if(sfdcAppRemoter.verifyPublicField(objectType, field) == false)
                    publicAccess = false;
                
                if(cnt == 0) {
                    query = field;
                } else {
                    query = query + ',' + field;
                }     
                cnt++;
            }        
            
            String fname;
            for (String fieldName : mapToken_Fields.keySet()){
                System.debug('field name is ' + fieldName);   
                
                Integer found=0;
                for (String field : fields) {
                    
                    if(field.toLowerCase().compareTo(fieldName.toLowerCase()) == 0) {
                        found = 1;
                    }
                }
                
                if(found == 0) {
                    continue;
                }
                
                fname = fieldName;
                
                Schema.DescribeFieldResult dfr = mapToken_Fields.get(fieldName).getDescribe();
                System.debug(dfr.getName() + ' >> ' + dfr.getLabel());    
                
                fieldInfo fd = new fieldInfo();
                fd.name = dfr.getName();
                fd.label = dfr.getLabel(); 
                fd.type = String.valueOf(dfr.getType()); 
                
                fd.maxLength = dfr.getLength();
                fd.isCalculated = dfr.isCalculated();
                fd.isNillable = dfr.isNillable();
                fd.description = dfr.getInlineHelpText();
                
                List<String> lstPickvals=new List<String>();
                
                List<Schema.PicklistEntry>pick_list_values = dfr.getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                    lstPickvals.add(a.getValue());//add the value  to our final list
                }             
                
                fd.pickList = lstPickvals;
                
                resultObject.put(dfr.getName(), fd);     
                
            }   
            
            List<sObject> L;
            if(parentId == null || parentId.length() == 0) { 
                whereClause = ' WHERE ' + parentField + ' = :contactId';
                if(!publicAccess) {
                    retValues = Utilities.getSecureWhereClauseList(objectType, parentId, whereClause);
                    whereClause = retValues[0];
                    idCheck = retValues[1];
                }
                system.debug('whereClause: ' + whereClause);
                
                L = Database.query('SELECT ' + query + ' FROM ' + objectType + whereClause);    
            } else {
                whereClause = ' WHERE ' + parentField + ' = :parentId';
                if(!publicAccess) {
                    retValues = Utilities.getSecureWhereClauseList(objectType, parentId, whereClause);
                    whereClause = retValues[0];
                    idCheck = retValues[1];
                }
                
                system.debug('whereClause: ' + whereClause);
                system.debug('query: ' + query );                 
                
                L = Database.query('SELECT ' + query + ' FROM ' + objectType + whereClause);
            }
            
            system.debug('* * * Query fetchFormData Remoter ...'+query);            
            rd.recordData  = L;
            rd.fields= resultObject;
        }
        
        return rd;
    }
    
    @RemoteAction
    global static returnData fetchFormData(String objectType, String recordId, List<String> fields, String parentField, String parentId) {
        
        String whereClause;
        Boolean publicAccess = true;
        String[] arrText;       
        String[] retValues;
        String idCheck;         
        
        Schema.DescribeSObjectResult DR_SObject;
        Map<String, Schema.sObjectField> mapToken_Fields;
        Map<String, Schema.sObjectType> mapToken_SObjects;
        
        Map<string,fieldInfo > resultObject = new Map<String,fieldInfo >();    
        mapToken_SObjects = Schema.getGlobalDescribe();
        
        DR_SObject = mapToken_SObjects.get(objectType).getDescribe();
        
        mapToken_Fields = DR_SObject.fields.getMap();
        
        System.debug('fields ' + DR_SObject.fields);
        
        String query;
        Integer cnt=0;
        for (String field : fields) {
            
            if(sfdcAppRemoter.verifyPublicField(objectType, field) == false)
                publicAccess = false;
            if(cnt == 0) {
                query = field;
            } else {
                query = query + ',' + field;
            }     
            cnt++;
        }        
        
        System.debug('publicAccess:' + publicAccess);
        
        String fname;
        for (String fieldName : mapToken_Fields.keySet()){
            //System.debug('field name is ' + fieldName);   
            
            Integer found=0;
            for (String field : fields) {
                
                if(field.toLowerCase().compareTo(fieldName.toLowerCase()) == 0) {
                    found = 1;
                }
            }
            
            if(found == 0) {
                continue;
            }
            
            fname = fieldName;
            
            Schema.DescribeFieldResult dfr = mapToken_Fields.get(fieldName).getDescribe();
            //System.debug(dfr.getName() + ' >> ' + dfr.getLabel());    
            
            fieldInfo fd = new fieldInfo();
            fd.name = dfr.getName();
            fd.label = dfr.getLabel(); 
            fd.type = String.valueOf(dfr.getType()); 
            
            fd.maxLength = dfr.getLength();
            fd.isCalculated = dfr.isCalculated();
            fd.isNillable = dfr.isNillable();
            fd.description = dfr.getInlineHelpText();
            
            List<String> lstPickvals=new List<String>();
            
            List<Schema.PicklistEntry>pick_list_values = dfr.getPickListValues();
            for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                lstPickvals.add(a.getValue());//add the value  to our final list
            }             
            
            fd.pickList = lstPickvals;
            
            resultObject.put(dfr.getName(), fd);     
            
        }    
        
        List<sObject> L;
        if(parentField != null && parentId != null && parentField != '' && parentId != '') {
            
            whereClause = ' WHERE ' + parentField + ' = :parentId';
            if(!publicAccess) {
                retValues = Utilities.getSecureWhereClauseList(objectType, parentId, whereClause);
                whereClause = retValues[0];
                idCheck = retValues[1];
            }
            system.debug('whereClause: ' + whereClause);   
            
            L = Database.query('SELECT Id, ' + query + ' FROM ' + objectType + whereClause);
            
        } else {
            
            whereClause = ' WHERE Id = :recordId';
            if(!publicAccess) {
                retValues = Utilities.getSecureWhereClause(objectType, recordId, whereClause );
                whereClause = retValues[0];
                idCheck = retValues[1];
            }
            system.debug('whereClause: ' + whereClause);
            
            L = Database.query('SELECT Id, ' + query + ' FROM ' + objectType + whereClause);
        }
        
        system.debug('* * * Query fetchFormData Remoter ...'+query);
        
        returnData rd = new returnData();
        
        rd.recordData  = L;
        rd.fields= resultObject;
        
        return rd;
    }
    
    
    @RemoteAction
    public static void requestNewExamSite(String examSiteCountry, String examSite, String garpId) {
        
        String emailBody = 'User with GARP Id ' + garpId + ' has requested new Exam Site in ' + examSiteCountry + ',' + examSite; 
        Messaging.SingleEmailmessage mail = new Messaging.SingleEmailmessage();
        mail.setPlainTextBody(emailBody);
        String[] toAddresses = new String[] {'memberservices@garp.com'};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Request for new Exam Site');
        
        Messaging.sendEmail(new Messaging.SingleEmailmessage[] { mail});
        return; 
        
    }
    
    
    global class FAQWrapper {
        List<FAQ_Category__c> FAQ_Category;
        List<FAQ_Section__c> FAQ_Sections;
        List<FAQ_Subsection__c> FAQ_Subsections;
        List<Frequently_Asked_Questions__c> FAQs;
        
        public FAQWrapper(List<FAQ_Category__c> category, List<FAQ_Section__c> sections, List<FAQ_Subsection__c> subsections, List<Frequently_Asked_Questions__c> inFAQs) {
            FAQ_Category = category;
            FAQ_Sections = sections;
            FAQ_Subsections = subsections;
            FAQs = inFAQs;
        }
        
        
    }
    
    @RemoteAction    
    public static FAQWrapper getFaqsByCategory(String category) {
        List<FAQ_Category__c> FAQ_Category = [SELECT Id, Name, FAQ_Category__c from FAQ_Category__c where Name = :category];
        List<FAQ_Section__c> FAQ_Sections = [select Id, Name, FAQ_Category__c, Section_Order_Number__c, FAQ_Category__r.name from FAQ_section__c where FAQ_Category__r.name = :category order by Section_Order_Number__c];
        List<FAQ_Subsection__c> FAQ_Subsections = [select Id, Name, FAQ_Category__c, FAQ_section__c, Subsection_Order_Number__c, FAQ_Category__r.name, Related_Section_Order_Number__c from FAQ_subsection__c where FAQ_Category__r.name = :category order by Subsection_Order_Number__c];
        List<Frequently_Asked_Questions__c> FAQs = [select Id, Name, GA_Label__c, FAQ_Category__r.name, FAQ_Rank__c, FAQ_Question__c, FAQ_Answer__c, FAQ_section__r.name, FAQ_subsection__r.name, Related_Subsection__c, LastModifiedDate from Frequently_Asked_Questions__c where FAQ_Category__r.name = :category order by Related_Subsection__c];
        
        FAQWrapper response = new FAQWrapper(FAQ_Category, FAQ_Sections, FAQ_Subsections, FAQs);
        return response;
    }
    
    @RemoteAction
    public static dailyOrdersWrapper fetchDailyOrders(){
        
        Id userId = UserInfo.getUserId();
        
        List<User> users = [
            SELECT Id, AccountId, ContactId, Contact.GT_Account__c 
            FROM User 
            WHERE Id = :userId 
            LIMIT 1
        ];
        
        dailyOrdersWrapper dow = new dailyOrdersWrapper();
        
        if(users.isEmpty() || !users[0].Contact.GT_Account__c){
            return dow;
        }
        
        List<Daily_Orders__c> lstDO = [
            SELECT Id, Name, Daily_Orders_List__c, Order_Date__c, Record_Type_Name__c, GARP_Approved__c,
            (SELECT Id, Name, CreatedDate FROM Attachments)
            FROM Daily_Orders__c 
            WHERE 
            GARP_Approved__c = TRUE AND
            Record_Type_Name__c = 'Exam Materials' AND 
            Order_Date__c = LAST_N_DAYS:7 ORDER BY Order_Date__c DESC
        ];
        
        List<Daily_Orders__c> lstFRR = [
            SELECT Id, Name, Daily_Orders_List__c, Order_Date__c, Record_Type_Name__c, Start_Date__c, End_Date__c, GARP_Approved__c,
            (SELECT Id, Name, CreatedDate FROM Attachments)
            FROM Daily_Orders__c 
            WHERE 
            GARP_Approved__c = TRUE AND
            Record_Type_Name__c = 'Certificates' AND 
            Start_Date__c = LAST_N_DAYS:124 ORDER BY Start_Date__c DESC
        ];
        
        dow.lstDO = lstDO;
        dow.lstFRR = lstFRR;
        
        return dow;
        
    } 
    
    @RemoteAction
    public static Response.Envelope payOpportunity(Id opportunityId, String cardMonth, String cardYear, String cardSecurity, String cardNumber){
        
        try{
            
            Id userId = UserInfo.getUserId();
            
            List<User> users = [SELECT Id, Email, AccountId FROM User WHERE Id = :userId];
            
            if(users == null || users.isEmpty()){
                return new Response.Detail('Could not locate user.', 404, new List<Object>{'Could not locate user.'});
            }
            
            User user = users[0];
            Utilities.updateFormSession('', user.Email);
            
            
            List<Opportunity> opportunities = null;
            if(user.AccountId == null){
                opportunities = [
                    SELECT Id, Name, Amount, StageName, AccountId,
                    (SELECT Id, Name, UnitPrice FROM OpportunityLineItems) 
                    FROM Opportunity
                    WHERE Id = :opportunityId
                ];
            }else{
                opportunities = [
                    SELECT Id, Name, Amount, StageName, AccountId,
                    (SELECT Id, Name, UnitPrice FROM OpportunityLineItems) 
                    FROM Opportunity
                    WHERE Id = :opportunityId AND AccountId = :user.AccountId
                ];
            }
            
            if(opportunities == null || opportunities.isEmpty()){
                return new Response.Detail('Could not locate opportunity.', 404, new List<Object>{'Could not locate opportunity.'});
            }
            
            Opportunity opportunity = opportunities[0];
            
            if(opportunity.Amount == 0) {
                
                opportunity.StageName = 'Closed';
                UPDATE opportunity;
                
                Response.Detail res = new Response.Detail();
                
                res.data = opportunity;
                res.status = 200;
                res.message = 'The Opportunity with Id ' + opportunity.Id + ' with an Amount of USD' + opportunity.Amount + ' was \'Closed\' successfully.';
                
                return res;
                
            } else {              
                
                Payment payment = new Payment(cardNumber, cardSecurity, cardMonth, cardYear);
                
                ChargentSFA.TChargentOperations.TChargentResult chargentResponse = payment.charge(opportunity.Id);                
                
                system.debug('Chargent Response: '+ chargentResponse);
                system.debug('Chargent Result: '+ chargentResponse.Message); 
                
                if(!Test.isRunningTest() && !chargentResponse.Message.contains('Approved')){
                    throw new Response.ResponseException(chargentResponse.Message, 400, new List<Object>{chargentResponse.Message});
                }
                
                Response.Detail res = new Response.Detail();
                
                res.data = opportunity;
                res.status = 200;
                res.message = 'The Opportunity with Id ' + opportunity.Id + ' with an Amount of USD' + opportunity.Amount + ' was \'Closed\' successfully.';
                
                return res;
                
            }
            
        }catch(Response.ResponseException e){
            
            return new Response.Detail(e.getMessage(), e.status, e.errors);
            
        }catch(Exception e){
            
            return new Response.Detail(null, 400, new List<Object>{e.getMessage(), e.getLineNumber(), e.getStackTraceString()});
            
        }
        
    }
    
    @RemoteAction
    public static Response.Envelope getOpportunity(Id opportunityId){
        
        Response.Detail res = new Response.Detail();
        
        Id userId = UserInfo.getUserId();
        
        List<User> users = [SELECT Id, AccountId FROM User WHERE Id = :userId];
        
        if(users == null || users.isEmpty()){
            return new Response.Detail('Could not locate user.', 404, new List<Object>{'Could not locate user.'});
        }
        
        User user = users[0];
        
        List<Opportunity> opportunities = [
            SELECT Id, Name, Amount, StageName, AccountId, ChargentSFA__Transaction_Total__c, OSTA_Check__c,
            (SELECT Id, Name, UnitPrice FROM OpportunityLineItems) 
            FROM Opportunity
            WHERE Id = :opportunityId AND AccountId = :user.AccountId
        ];
        
        if(opportunities == null || opportunities.isEmpty()){
            return new Response.Detail('Could not locate opportunity.', 404, new List<Object>{'Could not locate opportunity.'});
        }
        
        Opportunity opportunity = opportunities[0];
        
        // Amount due
        opportunity.Amount = opportunity.Amount - opportunity.ChargentSFA__Transaction_Total__c;
        
        res.data = opportunity;
        res.status = 200;
        res.message = 'Opportunity with Id ' + opportunity.Id + ' retrieved successfully.';
        
        return res;
        
    }
    
    @RemoteAction
    public static Id saveBOTComplianceDataSet(Id ContactId, String Vote) {
            List<BOT_Compliance_Data_Set__c> lstComplianceData = [select Id, Name, Contact__c , Date_Signed__c, Vote__c from BOT_Compliance_Data_Set__c where Contact__c = :ContactId];
            BOT_Compliance_Data_Set__c dataSet = new BOT_Compliance_Data_Set__c(Contact__c=ContactId, Vote__c=Vote);
    
            if(lstComplianceData.isEmpty()) {
               insert dataSet;
            }
        
        return dataSet.Id;
    }
    
    @RemoteAction
    public static List<BOT_Compliance_Data_Set__c> getBOTComplianceDataSet(Id ContactId) {
        List<BOT_Compliance_Data_Set__c> lstComplianceData = [select Id, Name, Contact__c , Date_Signed__c, Vote__c from BOT_Compliance_Data_Set__c where Contact__c = :ContactId];
        return lstComplianceData;
    }
    
    @RemoteAction
    public static Response.Detail submitProfileData(List<Experience> experiences, TempAccount tempAcc,string contactId,string progReqId) {
    
        try{
          if( contactId != null) {   
  
              Contact con = [SELECT Id, Name, AccountId FROM Contact WHERE Id = :contactId];
              if( con != null ) {
                  
                  List<Experience__c> experiencesInsert = new List<Experience__c>();
                  Set<String> accountNames = new Set<String>();
                  for(Experience exp :experiences){
                      if(string.isNotBlank(exp.Company))
                          accountNames.add(exp.Company);
                  }
                  
                  List<Account> accounts = [Select Id,name from Account where Name IN: accountNames];
                  Map<String,String> accNameToIdMap = new Map<String,String>();
                  for(Account acc: accounts){
                      accNameToIdMap.put(acc.Name,acc.Id);
                  }
                  
                  for(Experience exp :experiences) {
                                        
                      Experience__c newExperience = new Experience__c();
                      if(String.isNotBlank(exp.Id)){
                          newExperience.Id = exp.Id;
                      }
                      newExperience.Contact__c      = con.id;
                      newExperience.Manager_Name__c = exp.managerName;
                      newExperience.Title__c        = exp.jobTitle;
                      newExperience.Start_Date__c   = Date.valueOf(exp.startDate);
                      if(accNameToIdMap.containsKey(exp.Company)){
                          newExperience.Company__c = accNameToIdMap.get(exp.Company);
                      }else{
                          newExperience.CompanyOther__c = exp.Company;
                      }
                      if(String.isNotBlank(exp.endDate)){
                          newExperience.End_Date__c     = Date.valueOf(exp.endDate);
                      }
                      newExperience.Job_Description__c = exp.description;
                      newExperience.Program_Requirement__c = progReqId;
                      
                      experiencesInsert.add(newExperience);
                  }
                  
                  con.OSTA_Street__c            = tempAcc.streetTownDetails;
                  con.OSTA_Recipient_Name__c    = tempAcc.nameOfRecipient;
                  con.OSTA_ProvinceTerritory__c = tempAcc.provincesLevel;
                  con.OSTA_Phone_Number__c      = tempAcc.phoneNumber;
                  con.OSTA_City__c              = tempAcc.city;
                  con.OSTA_Building_Village__c  = tempAcc.buildingVillageDetails;
                  con.OSTA_District_Country__c  = tempAcc.districtCountry;
                  
                  con.MailingStreet     = tempAcc.mailingStreet;
                  con.MailingCity       = tempAcc.mailingCity;
                  con.MailingState      = tempAcc.mailingStateProvince;
                  con.MailingPostalCode = tempAcc.mailingZipPostalCode;
                  con.MailingCountry    = tempAcc.mailingCountry;
                  con.Phone            = tempAcc.homePhoneNumber;
                  
                  update con;
                  upsert experiencesInsert;
                  
                  System.Debug('experiencesInsert:' + experiencesInsert);
                  
                  SET<String> expIDs = new SET<String>();
                  if(!experiencesInsert.isEmpty()) {
                      for(Experience__c exp :experiencesInsert) {                      
                          expIDs.add(exp.Id);
                      }
                  }                
                  System.Debug('expIDs:' + expIDs);
                  
                  // Locate Deletes
                  List<Experience__c> experiencesDelete = new List<Experience__c>();                                    
                  List<Experience__c> lstExp = [select Id from Experience__c where Status__c != 'To Be Deleted' AND Contact__c = :contactId];
                  System.Debug('lstExp:' + lstExp );
                
                  if(!lstExp.isEmpty()) {
                      for(Experience__c exp :lstExp) {
                          System.Debug('exp :' + exp );
                      
                          if(!expIDs.contains(exp.id)) {
                              exp.Status__c = 'To Be Deleted';
                              experiencesDelete.add(exp);
                          }
                      }
                  }
                  System.Debug('experiencesDelete:' + experiencesDelete);
                  
                  if(!experiencesDelete.IsEmpty()) {
                      UPDATE experiencesDelete;
                  }
                  setCVSubmission(progReqId);
              }
              return new Response.Detail('Success', 200, null);
          }else{
            throw new Response.ResponseException('User not found.', 404, null);
          }
    
        } catch(Response.ResponseException e) {
    
            return new Response.Detail(e.getMessage(), e.status, e.errors);
    
        } catch(Exception e) {
    
            return new Response.Detail(null, 400, new List<Object>{
                e.getMessage(),
                e.getLineNumber(),
                e.getStackTraceString()
            });
    
        }
  
    }   
    
    global class Experience {
        global string managerName;
        global string jobTitle;
        global string startDate;
        global string endDate;
        global string description;
        global string company;
        global string id;
    }
   
}