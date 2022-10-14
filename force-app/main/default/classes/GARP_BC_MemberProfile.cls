public class GARP_BC_MemberProfile {

    public static Contact getMemberProfile(String contactId){
        
        System.debug('GARP_BC_MemberProfile.getMemberProfile:'+ contactId);
        
        List<Contact> lstCont = [select Id, FirstName, LastName, Email,
                                 How_Did_You_Hear_About_Us__c, How_Did_You_Hear_About_Us_Other__c,
                                 HomePhone, OtherPhone, Fax, LinkedIn_URL__c,
                                 Mailing_Address_Company__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry,
                                 AccountId, Account.Billing_Address_Company__c, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry,
                                 Currently_Working_Status__c, Area_of_Concentration__c, Industry_Working_Year__c, Company__c, Corporate_Title__c, Job_Function__c, Risk_Specialty__c, Risk_Management_Working_Year__c,
                                 Professional_Designation_ACCA__c, Professional_Designation_CA__c, Professional_Designation_CAIA__c, Professional_Designation_CFA__c, Professional_Designation_CFP__c,
                                 Professional_Designation_CIA__c, Professional_Designation_CMA__c, Professional_Designation_CMT__c, Professional_Designation_CPA__c, 
                                 Professional_Designation_CQF__c, Professional_Designation_PMP__c, Professional_Designation_Other__c, Other_Qualifications__c,
                                 School_Name__c, Degree_Program_Name__c, Highest_Degree__c, Expected_Graduation_Date__c, Expected_Graduation_Month__c, Title                                 
                                 from Contact where Id = :contactId];
        
        System.debug('GARP_BC_MemberProfile.lstCont:'+ lstCont);
        
        if(!lstCont.isEmpty()) {
            return lstCont[0];
        } else {
            return null;
        }
    }

    public static List<Country_Code__c> getCountries(){
        return [select id, Country__c, LetterCode__c, (select id, name, code__c from Provinces__r Order by Name) from Country_Code__c Order By Country__c];
    }
    
    public static List<Institution__c> getInstitutions(){
        return [select id, Institution_Name__c, RecordType.Name from Institution__c Order By Institution_Name__c];
    }
    
    @AuraEnabled
    public static List<GARP_MS_MemberProfile.InstitutionSearchResult> searchInstitutions(String searchTerm, String institutionType) {
        
        String recId = recordtypehelper.getrecordtypeidfromschema('Institution__c',institutionType);
        
        List<GARP_MS_MemberProfile.InstitutionSearchResult> searchResultList = new List<GARP_MS_MemberProfile.InstitutionSearchResult>();
        for(sObject so : Database.Query('Select Id, Institution_Name__c FROM Institution__c WHERE Institution_Name__c LIKE \'%' + searchTerm + '%\' AND RecordTypeId = :recId order by Institution_Name__c limit 15')) {
            String fieldvalue = (String)so.get('Institution_Name__c');
            searchResultList.add(new GARP_MS_MemberProfile.InstitutionSearchResult(fieldvalue, so.Id));
        }
        
        return searchResultList;
    }
 
    public static List<String> getPickListValues(String strObjectName, String strPicklistField) {

        List<String> retValues = new List<String>();
            
        Map<String, String> mapPickListValues = new Map<String, String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
        List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            retValues.add(objPickList.getLabel());
        }
        
        return retValues;
    }
            
    public static Boolean setMemberProfile(GARP_MS_MemberProfile.memberProfileUpdate profileUpdate){
        Boolean ret = false;
        
        if(profileUpdate == NULL) {
            return false;
        }
        
        System.debug('setMemberProfile profileUpdate:' + profileUpdate);
        
        if(profileUpdate.ContactId != NULL) {
            List<Contact> lstCont = [select Id, FirstName, LastName, Email,
                                     HomePhone, OtherPhone, Fax, LinkedIn_URL__c,
                                     Mailing_Address_Company__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry,
                                     How_Did_You_Hear_About_Us__c, How_Did_You_Hear_About_Us_Other__c,
                                     AccountId, Account.Billing_Address_Company__c, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry,
                                     Currently_Working_Status__c, Area_of_Concentration__c, Industry_Working_Year__c, Company__c, Corporate_Title__c, Job_Function__c, Risk_Specialty__c, Risk_Management_Working_Year__c,
                                     Professional_Designation_ACCA__c, Professional_Designation_CA__c, Professional_Designation_CAIA__c, Professional_Designation_CFA__c, Professional_Designation_CFP__c,
                                     Professional_Designation_CIA__c, Professional_Designation_CMA__c, Professional_Designation_CMT__c, Professional_Designation_CPA__c, 
                                     Professional_Designation_CQF__c, Professional_Designation_PMP__c, Professional_Designation_Other__c, Other_Qualifications__c,
                                     School_Name__c, Degree_Program_Name__c, Highest_Degree__c, Expected_Graduation_Date__c, Expected_Graduation_Month__c, Title       
                                     from Contact where Id = :profileUpdate.ContactId];
            
            System.debug('lstCont:' + lstCont);
            
            if(!lstCont.isEmpty()) {
                Contact updateContact = lstCont[0];
                if(profileUpdate.profileParts.NameEmail) {
                    updateContact.FirstName = profileUpdate.FirstName;
                    updateContact.LastName = profileUpdate.LastName;
                    updateContact.Email = profileUpdate.Email;
                    update updateContact;
                    
                    System.debug('updateContact:' + updateContact);
                    return true;
                } else if(profileUpdate.profileParts.MailingAddress) {                
                    updateContact.Mailing_Address_Company__c = profileUpdate.Mailing_Address_Company;
                    updateContact.MailingStreet = profileUpdate.MailingStreet;
                    updateContact.MailingCity = profileUpdate.MailingCity;
                    updateContact.MailingState = profileUpdate.MailingState;
                    updateContact.MailingPostalCode = profileUpdate.MailingPostalCode;
                    updateContact.MailingCountry = profileUpdate.MailingCountry;
                    update updateContact;
                    
                    System.debug('updateContact:' + updateContact);
                    return true;
                    
                } else if(profileUpdate.profileParts.PhoneNumbers) {                
                    updateContact.HomePhone = profileUpdate.HomePhone;
                    updateContact.OtherPhone = profileUpdate.OtherPhone;
                    updateContact.Fax = profileUpdate.Fax;
                    updateContact.LinkedIn_URL__c = profileUpdate.LinkedIn_URL;
                    update updateContact;
                    
                    System.debug('updateContact:' + updateContact);
                    return true;
                } else if(profileUpdate.profileParts.EmploymentInformation) {     

                    updateContact.Currently_Working_Status__c = profileUpdate.Currently_Working_Status;
                    updateContact.Area_of_Concentration__c = profileUpdate.Area_of_Concentration;
                    updateContact.Industry_Working_Year__c = profileUpdate.Industry_Working_Year;
                    updateContact.Company__c = profileUpdate.Company;
                    updateContact.Corporate_Title__c = profileUpdate.Corporate_Title;
                    updateContact.Job_Function__c = profileUpdate.Job_Function;
                    updateContact.Risk_Specialty__c = profileUpdate.Risk_Specialty;
                    updateContact.Risk_Management_Working_Year__c = profileUpdate.Risk_Management_Working_Year;
                    updateContact.Professional_Designation_ACCA__c = profileUpdate.Professional_Designation_ACCA;
                    updateContact.Professional_Designation_CA__c = profileUpdate.Professional_Designation_CA;
                    updateContact.Professional_Designation_CAIA__c = profileUpdate.Professional_Designation_CAIA;
                    updateContact.Professional_Designation_CFA__c = profileUpdate.Professional_Designation_CFA;
                    updateContact.Professional_Designation_CFP__c = profileUpdate.Professional_Designation_CFP;
                    updateContact.Professional_Designation_CIA__c = profileUpdate.Professional_Designation_CIA;
                    updateContact.Professional_Designation_CMA__c = profileUpdate.Professional_Designation_CMA;
                    updateContact.Professional_Designation_CMT__c = profileUpdate.Professional_Designation_CMT;
                    updateContact.Professional_Designation_CPA__c = profileUpdate.Professional_Designation_CPA;
                    updateContact.Professional_Designation_CQF__c = profileUpdate.Professional_Designation_CQF;
                    updateContact.Professional_Designation_PMP__c = profileUpdate.Professional_Designation_PMP;
                    updateContact.Other_Qualifications__c = profileUpdate.Other_Qualifications;
                    
                    update updateContact;
                    
                    System.debug('updateContact:' + updateContact);
                    return true;
                    
                } else if(profileUpdate.profileParts.AcademicInformation) {
                    updateContact.School_Name__c = profileUpdate.School_Name;
                    updateContact.Degree_Program_Name__c = profileUpdate.Degree_Program_Name;
                    updateContact.Highest_Degree__c = profileUpdate.Highest_Degree;
                    updateContact.Expected_Graduation_Date__c = profileUpdate.Expected_Graduation_Date;
                    updateContact.Expected_Graduation_Month__c = profileUpdate.Expected_Graduation_Month;
                    update updateContact;
                    
                    System.debug('updateContact:' + updateContact);
                    return true;
                    
                } else if(profileUpdate.profileParts.CompanyTitle) {
                    
                    updateContact.Company__c = profileUpdate.Company;
                    updateContact.Title = profileUpdate.Title;
                    
                    System.debug('updateContact:' + updateContact);
                        
                    update updateContact;
                } else if(profileUpdate.profileParts.Survey) {
                    
                    updateContact.How_Did_You_Hear_About_Us__c = profileUpdate.How_Did_You_Hear_About_Us;
                    
                    updateContact.Currently_Working_Status__c = profileUpdate.Currently_Working_Status;
                    updateContact.Area_of_Concentration__c = profileUpdate.Area_of_Concentration;
                    updateContact.Industry_Working_Year__c = profileUpdate.Industry_Working_Year;
                    updateContact.Company__c = profileUpdate.Company;
                    updateContact.Corporate_Title__c = profileUpdate.Corporate_Title;
                    updateContact.Job_Function__c = profileUpdate.Job_Function;
                    updateContact.Risk_Specialty__c = profileUpdate.Risk_Specialty;
                    updateContact.Risk_Management_Working_Year__c = profileUpdate.Risk_Management_Working_Year;
                    updateContact.Professional_Designation_ACCA__c = profileUpdate.Professional_Designation_ACCA;
                    updateContact.Professional_Designation_CA__c = profileUpdate.Professional_Designation_CA;
                    updateContact.Professional_Designation_CAIA__c = profileUpdate.Professional_Designation_CAIA;
                    updateContact.Professional_Designation_CFA__c = profileUpdate.Professional_Designation_CFA;
                    updateContact.Professional_Designation_CFP__c = profileUpdate.Professional_Designation_CFP;
                    updateContact.Professional_Designation_CIA__c = profileUpdate.Professional_Designation_CIA;
                    updateContact.Professional_Designation_CMA__c = profileUpdate.Professional_Designation_CMA;
                    updateContact.Professional_Designation_CMT__c = profileUpdate.Professional_Designation_CMT;
                    updateContact.Professional_Designation_CPA__c = profileUpdate.Professional_Designation_CPA;
                    updateContact.Professional_Designation_CQF__c = profileUpdate.Professional_Designation_CQF;
                    updateContact.Professional_Designation_PMP__c = profileUpdate.Professional_Designation_PMP;
                    updateContact.Professional_Designation_Other__c = profileUpdate.Professional_Designation_Other;
                    
                    updateContact.Other_Qualifications__c = profileUpdate.Other_Qualifications;
                                        
                    updateContact.School_Name__c = profileUpdate.School_Name;
                    updateContact.Degree_Program_Name__c = profileUpdate.Degree_Program_Name;
                    updateContact.Highest_Degree__c = profileUpdate.Highest_Degree;
                    updateContact.Expected_Graduation_Date__c = profileUpdate.Expected_Graduation_Date;
                    updateContact.Expected_Graduation_Month__c = profileUpdate.Expected_Graduation_Month;
                    update updateContact;
                    
                    System.debug('updateContact:' + updateContact);
                    return true;
                    
                }
            }
        } else if(profileUpdate.AccountId != NULL && profileUpdate.profileParts.BillingAddress) {       
            List<Account> lstAcct = [select Id, Billing_Address_Company__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry from Account where Id = :profileUpdate.AccountId];
            if(!lstAcct.isEmpty()) {
                Account updateAcct = lstAcct[0];
                updateAcct.Billing_Address_Company__c = profileUpdate.Billing_Address_Company;
                updateAcct.BillingStreet = profileUpdate.BillingStreet;
                updateAcct.BillingCity = profileUpdate.BillingCity;
                updateAcct.BillingState = profileUpdate.BillingState;
                updateAcct.BillingPostalCode = profileUpdate.BillingPostalCode;
                updateAcct.BillingCountry = profileUpdate.BillingCountry;
                
                System.debug('updateAcct:' + updateAcct);
                update updateAcct;
                ret = true;
            }
        }
        
        return ret;
    }

    
}