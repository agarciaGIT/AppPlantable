global without sharing class LwcLoginPageController {
    global Static String sessionID {get; set;}    
    global Static String username {get; set;}
    global Static String password {get; set;}   
    global Static String firstName {get; set;}
    global Static String lastName {get; set;}
    global Static String country {get; set;}
    global Static String company {get; set;}
    global Static String industry {get; set;}
    global Static String jobFunction {get; set;}
    global Static Boolean hasMessages {get; set;}
    global Static String isGRA {get; set;}  
    global Static String emailForPasswordReset {get; set;}
    global Static Boolean passwordResetSuccessful {get; set;}
    global Static Boolean passwordResetEmailNotFound {get; set;}
    global Static Boolean captchaSuccessful {get; set;}   
    global Static String action {get; set;}
    global Static String actionId {get; set;}
    global Static String start {get; set;}
    global Static String gotoParam {get; set;}
    global Static String startURL {get; set;}
    global Static String returnUrl {get; set;}   
    global Static String loginErrMsg {get; set;}
    global Static Boolean newUser {get; set;}   
    global Static String regOppId {get; set;}

    @auraEnabled 
    global static List<String> getCountries(){
        List<Country_Code__c> ccs = GARP_BC_MemberProfile.getCountries();
        List<String> countryList = new List<String>();
        for(Country_Code__c c :ccs) {
            countryList.add(c.Country__c);
        }
        system.debug('countryList:'+countryList);
        return countryList;
    }

    @auraEnabled 
    global static List<String> getIndustries(){
        List<String> industryList = GARP_BC_MemberProfile.getPickListValues('Contact','Area_of_Concentration__c');
        return industryList;
    }

    @auraEnabled 
    global static List<String> getjobFunction(){
        List<String> jobFunctionList = GARP_BC_MemberProfile.getPickListValues('Contact','Job_Function__c');
        return jobFunctionList;
    }

    @auraEnabled
    global static String register(String email,String firstName,String lastName,String country,String industry,String company,String job) {
        System.SavePoint sp = Database.setSavePoint();
        Id leadId;
        Registration.wrapperCreateOrder order;        
        system.debug('register:'+order);
        system.debug(firstName+'email:'+email);
        //System.assert(false, 'BOOM!' + order);       
        try {           
            TempAccount userData = getUserData(email,firstName,lastName,country,industry,company,job);           
            system.debug(userData.Email+'getUserData:'+userData);            
            if (Registration.GetMember(userData)){               
                system.debug('GetMember Yes');               
                List<Contact> lstCont = Registration.GetBussinessContact(userData);               
                System.debug(lstCont);                
                if (lstCont != null && lstCont.size() > 0){                   
                    createMember(lstCont);
                    Contact newCont = lstCont[0];                   
                    // Assign Email Subscriptions
                    newCont.Email_Daily_News__c = True;
                    newCont.Email_The_Week_in_Risk__c = True;
                    update newCont;
                    return newCont.Id;                   
                } else {                            
                    system.debug('Member Exists:'+userData);                
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The email you provided is already in our system. Please log in instead.'));
                    throw new LoginException('The email you provided is already in our system. Please log in instead.');
                }               
            }else{               
                leadId = Registration.SetLead(userData);                
                system.debug('userData:'+userData);
                
                if (leadId != null) {
                    userData.Id = leadId;
                    CAPTCHA_Configuration__c capConfig = Utilities.getCaptchaConfiguration();
                    if(capConfig != NULL && capConfig.Override_Key__c != NULL) {
                        userData.cap = capConfig.Override_Key__c;
                    }
                    order = Registration.createOrder(userData);
                    String invoiceNumber = order.invoiceNumber;
                    system.debug('userData:'+userData);
                    
                    if (order.contactId != null) {
                        Lead convertedLead = [SELECT ConvertedContactId FROM Lead where id =: userData.Id];                                           
                        system.debug('convertedLead:'+convertedLead);        
                        Contact cont = [select Id, Email_Daily_News__c, Email_The_Week_in_Risk__c from Contact where id = :convertedLead.ConvertedContactId];
                        // Assign Email Subscriptions
                        cont.Email_Daily_News__c = True;
                        cont.Email_The_Week_in_Risk__c = True;
                        update cont;                       
                        return cont.Id;
                    }                  
                }
            }       
        } catch(LoginException e) {
            System.debug(e.getlineNumber()+'Exception***' + e.getMessage()); 
            Database.rollback(sp);
            throw new LoginException(e.getMessage());
        }                
        //If it makes it to this point, something went wrong
        Database.rollback(sp);
        System.debug('Error registering new user. leadId is ' + leadId + ', order is ' + order); 
        throw new LoginException('There was an unexpected error.');
    }

    private static TempAccount getUserData(String email,String firstName,String lastName,String country,String industry,String company,String job){
        TempAccount objData = new TempAccount();
        objData.FirstName = firstName;
        objData.LastName = lastName;
        objData.Email = email;
        objData.MailingCountry = country;
        objData.BillingCountry = country;
        objData.Company = company;
        objData.JobFunction = job;
        objData.Organization = industry;
        objData.Industry = industry;
        objData.Membership_Type = 'AFREE';
        objData.garpMembership_Type = 'AFREE';
        objData.ACCA = false;
        objData.CA = false;
        objData.CFA = false;
        objData.CMA = false;
        objData.CPA = false;
        objData.InSchool = false;
        objData.OtherDesignation = false;
        objData.PMP = false;
        objData.autoRenew = false;
        objData.erpSwitch = false;
        objData.frmSwitch = false;
        objData.graduationDate = 'Invalid Date';
        objData.hasBooks = false;
        objData.isErpChecked = false;
        objData.isFbrChecked = false;
        objData.isFrmChecked = false;
        objData.isIcbrChecked = false;
        objData.isStudentChecked = false;
        objData.productcode = new List<String>(); 
        TempAccount.productDefinition productDefition = new TempAccount.productDefinition();
        productDefition.GLCode = '4999';
        productDefition.ProductCode = 'AFREE';
        objData.productcode1 = new TempAccount.productDefinition[]{ productDefition };   
        objData.siteName = 'undefined';
        objData.isWorking = false;
        objData.jobTarget = false;       
        objData.referral = '';
        objData.sameShip = 'true';
        objData.switchFeeEnabled = false;
        objData.eppHelp = false;
        return objData;
    }

    private static boolean createMember(List<contact> lstcont) {
    
        String accountId;
        Contact c = lstcont[0];
        id userid = [select id, name, Record_id__c from updateids__c where name = 'User'].Record_id__c;
        
        Id individualRecId = RecordTypeHelper.GetRecordTypeId('Account','Individual');
        List < Account > lstAcct = [select Id, Name, RecordTypeID from Account where Id = : c.AccountId];
        
        //System.assert(false, 'BOOM!' + lstAcct);
        
        if (lstAcct != null && lstAcct.size() > 0) {
            
            // Create Account and Add Contact Role
            if(lstAcct[0].RecordTypeID != individualRecId) {
                Account acctNew = new Account();
                acctNew.RecordTypeID = individualRecId ;
                acctNew.Name = c.Name.replace(' ','');
                acctNew.GARP_ID__c = c.GARP_ID_New__c;
                acctNew.ownerid = userid;
                insert acctNew;
                
                c.AccountId = acctNew.Id;
                update c;
                
                accountId = acctNew.Id;
                
               // List< AccountContactRelation > lstAcctContRole = [select Id, AccountId, ContactId from AccountContactRelation where AccountId = :lstAcct[0].Id and ContactId = :c.Id];
               // if(lstAcctContRole == null || lstAcctContRole.size() == 0) {
                //    AccountContactRelation role = new AccountContactRelation();
                  //  role.AccountId = lstAcct[0].Id;
                 //  role.ContactId = c.Id;
                  //  insert role;
              //  }
                
            } else {
                accountId = lstAcct[0].Id;
            }        
        }
        
        //Create an opportunity
        Contact con = [
            SELECT Id, Name, FirstName, LastName, Email, AccountID, HomePhone, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode
            FROM Contact 
            WHERE Id = :c.Id
        ];

        contactExtn conextn = new contactExtn();
        Opportunity oppty   = new Opportunity();
        
        oppty = conextn.createOpportunity(con, con.name, False);
        oppty.Eligible_for_Membership_Extension__c= false;
        
        //Adding Affiliate product to the opportunity
        conextn.createOppLineItems(oppty.ID, 'AFREE', '4999', con, '0.00');
        
        //Creating an Affiliate Contract
        Id contractID = conextn.createContract(con.AccountID, oppty.ID, con.ID, 'Affiliate', TRUE);

        //Close the opportunity
        oppty.Amount    = 0.00;
        oppty.StageName = 'Closed';
        
        UPDATE oppty;
        
        con.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
        con.do_not_fire__c = FALSE;
        
        UPDATE con;
        
        return true;
        
    }

    public class LoginException extends Exception {
 
    }
}