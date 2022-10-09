@RestResource(urlMapping='/webcast/registration')
global without sharing class createWebcastRegistrationFromMicrosites {
    
    global class Wrapper{
        public Id candidateContactId { get; set; }
        public String webcastId { get; set; }  
        public Boolean isApplicantUserSessionOnline { get; set; }  
        public List < Webcast_Registration__c > webcastRegistration { get; set; }   
    }
    
    global class desilWrapper{
        public String userId        { get; set; }
        public String webcastId     { get; set; }
    }
    
    @HttpPost
    global static void doPost(){
        String requestBody = RestContext.request.requestBody.toString();
        createWebcastRegistrationFromMicrosites.desilWrapper desilWrapper = (createWebcastRegistrationFromMicrosites.desilWrapper)JSON.deserialize(requestBody, createWebcastRegistrationFromMicrosites.desilWrapper.class);
        
        String candidateUserId = desilWrapper.userId;
        String webcastId = desilWrapper.webcastId;
        Boolean isApplicantUserSessionOnline = false;
        
        List<AuthSession> IsApplicantOnline = [SELECT LastModifiedDate, LoginType, NumSecondsValid, SessionType, UsersId FROM AuthSession where LoginType = 'Chatter Communities External User' and SessionType = 'ChatterNetworks' and UsersId = :candidateUserId];
        
        Integer IsApplicantOnlineSize = IsApplicantOnline.size();
        if(IsApplicantOnlineSize > 0){ isApplicantUserSessionOnline = true; } else {isApplicantUserSessionOnline = false;}
        
        Id applicantContactId = null;
        Id newWebcastRegistrationId = null;
        Boolean hasUserRegisteredForThisWebcast = true;
        
        List < Webcast_Registration__c > webcastRegistration = new List < Webcast_Registration__c >(); 
        Wrapper rd = new Wrapper();        
        
        List<User> lstUser = [Select u.Id,u.ContactId,Email from User u where u.Id = :candidateUserId];
        Id UserContactId =  lstUser[0].ContactId;
        
        webcastRegistration = doesApplicantHaveWebcastRegistration(UserContactId, webcastId); 
        Integer webcastRegistrationSize = webcastRegistration.size();
        
        if(webcastRegistrationSize > 0){ hasUserRegisteredForThisWebcast = true; } else { hasUserRegisteredForThisWebcast = false; }
        
        if(!hasUserRegisteredForThisWebcast){            
            List < Contact > contactInformation = [SELECT Id, FirstName, Company__c , Title, LastName, Email, Account_Clean_Company_Name__c FROM Contact where Contact.Id = :UserContactId];
            
            applicantContactId = UserContactId;
            String applicantWebcastId = webcastId;
            String applicantEmail = contactInformation[0].Email;
            String applicantJobTitle = contactInformation[0].Title;
            String applicantCompany = contactInformation[0].Company__c;
            String applicantFirstName = contactInformation[0].FirstName;
            String applicantLastName = contactInformation[0].LastName;
            
            TempAccount objData = provisionTempAccountData(applicantContactId, applicantWebcastId, applicantEmail, applicantJobTitle, applicantCompany, applicantFirstName, applicantLastName);
            Registration.wrapperCreateWebcastRegistration createNewWebcastRegistration = Registration.createWebcastRegistration(objData,applicantContactId);
            
            newWebcastRegistrationId = createNewWebcastRegistration.webcastRegistrationId;
            webcastRegistration = [SELECT Id, Name, Contact__r.Id, Webcast__r.Id, Webcast__r.On_Demand_URL__c FROM Webcast_Registration__c where Id = :newWebcastRegistrationId];            
        }
        
        if(isApplicantUserSessionOnline){
            rd.isApplicantUserSessionOnline = isApplicantUserSessionOnline;
            rd.candidateContactId = UserContactId;
            rd.webcastRegistration = webcastRegistration; 
            rd.webcastId = webcastId;
        }
        
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(rd));
    }
    
    public static Wrapper createWebcastRegistrationFromCalendar(String contactId, String webcastId) {
        Wrapper rd = new Wrapper();
        Id applicantContactId = null;
        Id newWebcastRegistrationId = null;
        Boolean hasUserRegisteredForThisWebcast = true;
        
        //      1. Check to see if the event registration exists
        List < Webcast_Registration__c > webcastRegistration = new List < Webcast_Registration__c >();         
        
        webcastRegistration = doesApplicantHaveWebcastRegistration(contactId, webcastId); 
        Integer webcastRegistrationSize = webcastRegistration.size();
        
        if(webcastRegistrationSize > 0){ hasUserRegisteredForThisWebcast = true; } else { hasUserRegisteredForThisWebcast = false; }
        
        //   2. If it doesnt, provisionTempAccountData and create Webcast Registration
        
        if(!hasUserRegisteredForThisWebcast){            
            List < Contact > contactInformation = [SELECT Id, FirstName, Company__c , Title, LastName, Email, Account_Clean_Company_Name__c FROM Contact where Contact.Id = :contactId];
            
            applicantContactId = contactId;
            String applicantWebcastId = webcastId;
            String applicantEmail = contactInformation[0].Email;
            String applicantJobTitle = contactInformation[0].Title;
            String applicantCompany = contactInformation[0].Company__c;
            String applicantFirstName = contactInformation[0].FirstName;
            String applicantLastName = contactInformation[0].LastName;
            
            TempAccount objData = provisionTempAccountData(applicantContactId, applicantWebcastId, applicantEmail, applicantJobTitle, applicantCompany, applicantFirstName, applicantLastName);
            Registration.wrapperCreateWebcastRegistration createNewWebcastRegistration = Registration.createWebcastRegistration(objData,applicantContactId);
            
            newWebcastRegistrationId = createNewWebcastRegistration.webcastRegistrationId;
            webcastRegistration = [SELECT Id, Name, Contact__r.Id, Webcast__r.Id, Webcast__r.On_Demand_URL__c FROM Webcast_Registration__c where Id = :newWebcastRegistrationId];            
        }
        
        //  3. If it does, send the Wrapper with the information accordingly
        rd.webcastRegistration = webcastRegistration; 
        rd.webcastId = webcastId;
    
        return rd;
    }
    
    public static List < Webcast_Registration__c > doesApplicantHaveWebcastRegistration(Id UserContactId, string webcastId){
        List < Webcast_Registration__c > webcastRegistration = [SELECT Id, Name, Webcast__r.On_Demand_URL__c FROM Webcast_Registration__c where (Contact__r.Id = :UserContactId and Webcast__r.Id = :webcastId)];
        return webcastRegistration;  
    }
    
    public static TempAccount provisionTempAccountData(id userContactId, string webcastId, string email, string jobTitle, string company, string FirstName, string LastName){
        TempAccount tempObjData = new TempAccount(); 
        tempObjData.isFrmChecked = false;
        tempObjData.isErpChecked = false;
        tempObjData.isIcbrChecked = false;
        tempObjData.isFbrChecked = false;
        tempObjData.isFbraChecked = false;
        tempObjData.frmSwitch = false;
        tempObjData.erpSwitch = false;
        tempObjData.isEventChecked = true;
        tempObjData.Email = email;
        tempObjData.FirstName = FirstName;
        tempObjData.LastName = LastName;
        tempObjData.contactId = userContactId;
        tempObjData.jobtitle = jobTitle;
        tempObjData.company = company;
        tempObjData.eppHelp = false;
        tempObjData.chapterMeetingRegistrationId = NULL;
        tempObjData.webcastId = webcastId;
        return tempObjData;
    }   
}