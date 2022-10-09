public class GARP_MS_MemberProfile {
    
	public class profileParts {
        @AuraEnabled Public Boolean NameEmail {get;set;}
        @AuraEnabled Public Boolean MailingAddress {get;set;}
        @AuraEnabled Public Boolean BillingAddress {get;set;}
        @AuraEnabled Public Boolean PhoneNumbers {get;set;}
        @AuraEnabled Public Boolean EmploymentInformation {get;set;}
        @AuraEnabled Public Boolean AcademicInformation {get;set;}
        @AuraEnabled Public Boolean Survey {get;set;}
        @AuraEnabled Public Boolean CompanyTitle {get;set;}
    }
    
    public class memberProfileUpdate {
        @AuraEnabled Public profileParts profileParts {get;set;}        
        @AuraEnabled Public String ContactId {get;set;}
        @AuraEnabled Public String AccountId {get;set;}
        
        @AuraEnabled Public String FirstName {get;set;}
        @AuraEnabled Public String LastName {get;set;}
        @AuraEnabled Public String Email {get;set;}
        @AuraEnabled Public String Mailing_Address_Company {get;set;}
        @AuraEnabled Public String MailingStreet {get;set;}
        @AuraEnabled Public String MailingCity {get;set;}
        @AuraEnabled Public String MailingState  {get;set;}
        @AuraEnabled Public String MailingPostalCode  {get;set;}
        @AuraEnabled Public String MailingCountry  {get;set;}      
        
        @AuraEnabled Public String HomePhone  {get;set;}      
        @AuraEnabled Public String OtherPhone  {get;set;}      
        @AuraEnabled Public String Fax  {get;set;}      
		@AuraEnabled Public String LinkedIn_URL  {get;set;}              
        
        @AuraEnabled Public String Billing_Address_Company {get;set;}
        @AuraEnabled Public String BillingStreet {get;set;}
        @AuraEnabled Public String BillingCity {get;set;}
        @AuraEnabled Public String BillingState  {get;set;}
        @AuraEnabled Public String BillingPostalCode  {get;set;}
        @AuraEnabled Public String BillingCountry  {get;set;}        
        
        
        @AuraEnabled Public String How_Did_You_Hear_About_Us {get;set;}
        
        @AuraEnabled Public String Currently_Working_Status {get;set;}
        @AuraEnabled Public String Area_of_Concentration {get;set;}
        @AuraEnabled Public String Industry_Working_Year {get;set;}
        @AuraEnabled Public String Company {get;set;}
        @AuraEnabled Public String Risk_Management_Working_Year {get;set;}
        @AuraEnabled Public String Corporate_Title {get;set;}
        @AuraEnabled Public String Job_Function {get;set;}
        @AuraEnabled Public String Risk_Specialty {get;set;}
		@AuraEnabled Public Boolean Professional_Designation_ACCA {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_CA {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_CAIA {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_CFA {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_CFP {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_CIA {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_CMA {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_CMT {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_CPA {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_CQF {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_PMP {get;set;}
        @AuraEnabled Public Boolean Professional_Designation_Other {get;set;}
        @AuraEnabled Public String Other_Qualifications {get;set;}
        
        @AuraEnabled Public String School_Name {get;set;}
        @AuraEnabled Public String Degree_Program_Name {get;set;}
        @AuraEnabled Public String Highest_Degree {get;set;}
        @AuraEnabled Public String Expected_Graduation_Date {get;set;}
        @AuraEnabled Public String Expected_Graduation_Month {get;set;}
        
        @AuraEnabled Public String Title {get;set;}
        
        public memberProfileUpdate() {
            this.profileParts = new profileParts();
            this.profileParts.NameEmail = False;
            this.profileParts.MailingAddress = False;
            this.profileParts.BillingAddress = False;
            this.profileParts.PhoneNumbers = False;
            this.profileParts.EmploymentInformation = False;
            this.profileParts.AcademicInformation = False;
            this.profileParts.Survey = False;
            this.profileParts.CompanyTitle = False;
        }
    }    
    
	public class memberProfileEdit {
        @AuraEnabled Public Contact contact;
        @AuraEnabled Public List<Country_Code__c> countries;
        @AuraEnabled Public List<Institution__c> institutions;
        @AuraEnabled Public List<String> industries;
        @AuraEnabled Public List<String> professionalLevels;
        @AuraEnabled Public List<String> jobFunctions;
        @AuraEnabled Public List<String> riskSpecialties;
        @AuraEnabled Public List<String> graduationMonths;
        @AuraEnabled Public List<String> howDidYouHearOptions;
        @AuraEnabled Public List<String> degrees;
        @AuraEnabled Public List<String> designations;
    }
    
    public class InstitutionSearchResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public InstitutionSearchResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }
    
    public static memberProfileEdit getMemberProfileForEdit(String contactId){
        
        System.debug('GARP_MS_MemberProfile.getMemberProfile:'+ contactId);
        
        memberProfileEdit mpe = new memberProfileEdit();
        
        if(contactId == NULL) {
            String userId = UserInfo.getUserId();
            System.debug('userId:' + userId);
            
            List<User> users = [SELECT Id, ContactId, Email FROM User WHERE Id = :userId];
            System.debug('userId:' + userId);
            
            if(!users.isEmpty()) {      
                contactId = users[0].ContactId;
            }
        }
        if(contactId != NULL) {
            mpe.contact = GARP_BC_MemberProfile.getMemberProfile(contactId);
        }
        mpe.countries = GARP_BC_MemberProfile.getCountries();
        //mpe.institutions = GARP_BC_MemberProfile.getInstitutions();
        mpe.industries = GARP_BC_MemberProfile.getPickListValues('Contact','Area_of_Concentration__c');
        mpe.professionalLevels = GARP_BC_MemberProfile.getPickListValues('Contact','Corporate_Title__c');
        mpe.jobFunctions = GARP_BC_MemberProfile.getPickListValues('Contact','Job_Function__c');
        mpe.riskSpecialties = GARP_BC_MemberProfile.getPickListValues('Contact','Risk_Specialty__c');
        mpe.graduationMonths = GARP_BC_MemberProfile.getPickListValues('Contact','Expected_Graduation_Month__c');
        mpe.howDidYouHearOptions = GARP_BC_MemberProfile.getPickListValues('Contact','How_Did_You_Hear_About_Us__c');
        mpe.degrees = GARP_BC_MemberProfile.getPickListValues('Contact','Highest_Degree__c');

        String[] designations=new String[]{'Professional_Designation_ACCA__c',
            							   'Professional_Designation_CA__c',
            							   'Professional_Designation_CAIA__c',
            							   'Professional_Designation_CFA__c',
            							   'Professional_Designation_CFP__c',
            							   'Professional_Designation_CIA__c',
            							   'Professional_Designation_CMA__c',
            							   'Professional_Designation_CMT__c',
            							   'Professional_Designation_CPA__c',
            							   'Professional_Designation_CQF__c',
            							   'Professional_Designation_PMP__c',
            							   'Professional_Designation_Other__c'
            								};
        
		System.debug('designations:'+ designations);
        mpe.designations = designations;
        
        return mpe;
    }
    
    public static Boolean setMemberProfile(memberProfileUpdate profileUpdate){        
		return GARP_BC_MemberProfile.setMemberProfile(profileUpdate);
    }

    public static Boolean setMemberEmail(memberProfileUpdate profileUpdate){        
		return GARP_BC_MemberProfile.setMemberEmail(profileUpdate);
    }
    
    public static List<InstitutionSearchResult> searchInstitutions(String searchTerm, String institutionType) {
        return GARP_BC_MemberProfile.searchInstitutions(searchTerm, InstitutionType);
    }
    
    
}