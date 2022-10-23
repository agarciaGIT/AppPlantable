public class GARP_Common {

    public class captchaInfo {
        public String cap;
        public String capip;
        public String sessionToken;
    }
    
    public class checkExistingContact {
        public Contact contact;
        public Boolean isMember;
    }
    
    public class checkAuthentication {
        public User user;
        public String contactId;
        public Boolean isAuthenticated;
    }
    
    // Common Wappers
    
    public class productInfo {
        public String ProductName;
        public String ProductCode;
        public String GLCode;
        public Decimal Amount;
    }
    
    public class screenInfo {
        public List<Country_Code__c> Locations;
        public FAQWrapper FAQInfo;
        public Boolean IsAuthenticated;
    }
    
    public class existingContactInfo {
        public Contact ContactRecord;
        public Account AccountRecord;
        public String GARPId;
        public Boolean isMember;
        public String currentMemberType;
        public Boolean isInGoodStanding;
        public Boolean isCertified;
    }
    
    public class verifyExistingCustomerInfo {
        public Boolean IsCustomer;
        public String LeadId;
    } 
    
    // Methods
    public static verifyExistingCustomerInfo VerifyExistingCustomer(String email, String firstName, String lastName, String formName, String cta) {
        verifyExistingCustomerInfo retInfo = new verifyExistingCustomerInfo();
        
        checkExistingContact checkRet = CheckExistingContact(email);
        retInfo.IsCustomer = checkRet.isMember;
        retInfo.LeadId = SetLead(email, firstName, lastName, formName, cta);
        
        return retInfo;
    }
    
    public static existingContactInfo getExistingContactInfo(String ContactId) {
        existingContactInfo extContInfo = new existingContactInfo();
        extContInfo.isInGoodStanding = False;
        extContInfo.isCertified = False;
        extContInfo.isMember = False;
        
        List<Contact> lstCont = [select Id, GARP_ID_New__c, AccountId, Account.RecordTypeId,
                                 Email, Phone, Company__c,
                                 Mailing_Address_Company__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                                 from Contact where Id = :ContactId];
        if(!lstCont.isEmpty()) {
            Contact cont = lstCont[0];
            
            List<Account> lstAcct = [select Id, Billing_Address_Company__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry 
                                     from Account where Id = :cont.AccountId];
            if(!lstAcct.isEmpty()) {
                Account acct = lstAcct[0];
                
                extContInfo.ContactRecord = cont;
                extContInfo.AccountRecord = acct;
                extContInfo.GARPId = cont.GARP_ID_New__c;
                
                Id memRecId = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
                Id frmRecId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
                Id erpRecId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
                List<Contract> lstContract = [select Id, RecordTypeId, Membership_Type__c from 
                                              Contract where (RecordTypeId = :memRecId AND Status like 'Activated%') OR 
                                              ((RecordTypeId = :frmRecId OR RecordTypeId = :erpRecId) AND Status = 'Completed')
                                              Order By StartDate];
                if(!lstContract.isEmpty()) {
                    for(Contract c :lstContract) {
                        if(c.RecordTypeId == memRecId && !extContInfo.isMember) {
                            extContInfo.currentMemberType = c.Membership_Type__c;
                            extContInfo.isMember = True;
                        } else if(c.RecordTypeId == frmRecId || c.RecordTypeId == frmRecId) {
                            extContInfo.isCertified = True;
                        }
                    }
                }            
            }
        }
        return extContInfo;
    }
    
    
    public static checkAuthentication CheckAuthentication() {
        checkAuthentication checkAuth = new checkAuthentication();
        checkAuth.isAuthenticated = False;
        
        String userId = UserInfo.getUserId();
        List<User> lstUser = [SELECT Id, ContactId, Name FROM User WHERE Id = :userId];
        if(!lstUser.isEmpty() && lstUser[0].Name != 'GARP Membership') {
            checkAuth.user = lstUser[0];
            checkAuth.isAuthenticated = True;
        }
        return checkAuth;
    }
    
    public static checkExistingContact CheckExistingContact(String Email) {
        checkExistingContact checkRet = new checkExistingContact();
        checkRet.isMember = False;
        
        Id individualRecId = RecordTypeHelper.GetRecordTypeId('Account','Individual');
        
        List<Contact> lstCont = [select Id, GARP_ID_New__c, AccountId, Account.RecordTypeId from Contact where Email = :Email];
        if(!lstCont.isEmpty()) {
            checkRet.contact = lstCont[0];
            checkRet.isMember =(lstCont[0].Account.RecordTypeId == individualRecId);
            return checkRet;
        }
        return checkRet;
    }
    
    public static Id SetLead(String email, String firstName, String lastName, String formName, String cta) {
        
        if (email == null) return null; 
        
        Form_Data__c formData = new Form_Data__c();
        
        formData.First_Name__c = firstName;
        formData.Last_Name__c = lastName;
        formData.Email__c = email;
        formData.Status__c = 'Abandoned';
        if(cta!=NULL && cta.length() == 0) {
            cta=null;
        }
        formData.Call_To_Action__c = cta;
               
        Utilities.FormDataResponse rd = Utilities.manageFormSubmission(formData, formName);            
        
        if(rd.leadId != NULL) {
            return rd.leadId;
        } else {
            return rd.contactId;
        }
    }
    
    public static void removeOrder(String orderId) {
        List<Opportunity> lstOpp = [select Id, Name, StageName from Opportunity where id = :orderId and StageName = 'New Lead'];
        if(!lstOpp.isEmpty()) {
            lstOpp[0].StageName = 'Closed Lost';
            update lstOpp;
        }
    }

	public class FAQWrapper {
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
    
    public static FAQWrapper getFaqsByCategory(String category) {
        List<FAQ_Category__c> FAQ_Category = [SELECT Id, Name, FAQ_Category__c from FAQ_Category__c where Name = :category];
        List<FAQ_Section__c> FAQ_Sections = [select Id, Name, FAQ_Category__c, Section_Order_Number__c, FAQ_Category__r.name from FAQ_section__c where FAQ_Category__r.name = :category order by Section_Order_Number__c];
        List<FAQ_Subsection__c> FAQ_Subsections = [select Id, Name, FAQ_Category__c, FAQ_section__c, Subsection_Order_Number__c, FAQ_Category__r.name, Related_Section_Order_Number__c from FAQ_subsection__c where FAQ_Category__r.name = :category order by Subsection_Order_Number__c];
        List<Frequently_Asked_Questions__c> FAQs = [select Id, Name, GA_Label__c, FAQ_Category__r.name, FAQ_Rank__c, FAQ_Question__c, FAQ_Answer__c, FAQ_section__r.name, FAQ_subsection__r.name, Related_Subsection__c, LastModifiedDate from Frequently_Asked_Questions__c where FAQ_Category__r.name = :category order by Related_Subsection__c];
        
        FAQWrapper response = new FAQWrapper(FAQ_Category, FAQ_Sections, FAQ_Subsections, FAQs);
        return response;
    }
    
    public static String formatAddressTextArea(String street1, String street2, String street3) {
        String retAddress = '';
        if(street1 != NULL) {
            retAddress = street1;
        }
        if(street2 != NULL) {
            retAddress = retAddress + '\n' + street2;
        }
        if(street2 != NULL) {
            retAddress = retAddress + '\n' + street2;
        }
        return retAddress;
    }
    
}