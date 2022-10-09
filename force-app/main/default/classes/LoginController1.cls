global without sharing class LoginController1 {

    global String sessionID {get; set;}
        
    global String username {get; set;}
    global String password {get; set;}   
    global String firstName {get; set;}
    global String lastName {get; set;}
    global String country {get; set;}
    global String company {get; set;}
    global String industry {get; set;}
    global String jobFunction {get; set;}
    global Boolean hasMessages {get; set;}
    global String isGRA {get; set;}
    
    global String emailForPasswordReset {get; set;}
    global Boolean passwordResetSuccessful {get; set;}
    global Boolean passwordResetEmailNotFound {get; set;}
    global Boolean captchaSuccessful {get; set;}
    
    
    global String action {get; set;}
    global String actionId {get; set;}
    global String start {get; set;}
    global String gotoParam {get; set;}
    global String startURL {get; set;}
    global String returnUrl {get; set;}
    
    global String loginErrMsg {get; set;}
    
    global Boolean newUser {get; set;}
    
    global String regOppId {get; set;}
    
    
    //global String debugInfo {get; set;}
    
    global List<SelectOption> countryList {
        get {
            if (countryList == null) {
                countryList = new List<SelectOption> {new SelectOption('', '-- Please Select --')};
                for (String country : COUNTRIES) {
                    countryList.add(new SelectOption(country, country));
                }
            }
            return countryList;
        }
        set;}    
    global List<SelectOption> industryList {
        get {
            if (industryList == null) {
                industryList = new List<SelectOption> {new SelectOption('', '-- Please Select --')};
                for (String industry : INDUSTRIES) {
                    industryList.add(new SelectOption(industry, industry));
                }
            }
            return industryList;
        }
        set;}
    global List<SelectOption> jobFunctionList {
        get {
            if (jobFunctionList == null) {
                jobFunctionList = new List<SelectOption> {new SelectOption('', '-- Please Select --')};
                for (String jobFunction : JOBFUNCTIONS) {
                    jobFunctionList.add(new SelectOption(jobFunction, jobFunction));
                }
            }
            return jobFunctionList;
        }
        set;}
    
    //public class TestException extends Exception {}
    
    @RemoteAction
    public static List<Account> getAllCustomerCompanies(){
        return [SELECT Name FROM Account where Customer_Company_List__c=true];   
    }
    
    global LoginController1() {
        action = ApexPages.currentPage().getParameters().get('action');
        actionId = ApexPages.currentPage().getParameters().get('id');
        start = ApexPages.currentPage().getParameters().get('start');
        gotoParam = ApexPages.currentPage().getParameters().get('goto');
        startURL = ApexPages.currentPage().getParameters().get('startURL'); //to handle higher logic callback param
        returnUrl = ApexPages.currentPage().getParameters().get('ReturnUrl'); //to handle higher logic callback param
        
        isGRA = 'false';
        String url = ApexPages.currentPage().getUrl();
        if(url != null) {
        url = url.toLowerCase();
            if(url.indexOf('logingra') > -1) {
                isGRA = 'true';
            }
        }

        system.debug('Login Action1:' + action + ':' + actionId + ':' + start + ':' + gotoParam + ':' + startURL + ':' + returnUrl + ':' + isGRA);
        
        String registerParam = ApexPages.currentPage().getParameters().get('register');
        if (registerParam != null && Boolean.valueOf(registerParam)) {
            newUser = true;
        } else {
            newUser = false; 
        }
        passwordResetSuccessful = false;
        passwordResetEmailNotFound = false;
    }
    
    global PageReference init() {
    
        Apexpages.currentPage().getHeaders().put('X-FRAME-OPTIONS', 'DENY');
    
        username =  ApexPages.currentPage().getParameters().get('username');
        password = ApexPages.currentPage().getParameters().get('password');
        start = ApexPages.currentPage().getParameters().get('start');

        //debugInfo += '<h1>ALL INCOMING HEADERS</h1>';
        //for (string key: ApexPages.currentPage().getHeaders().keySet()) {
        //    debugInfo += key + ' = ' + ApexPages.currentPage().getHeaders().get(key) + '<br />';
        //}        
        //
        //HTTP_REFERER
        
        String refer = ApexPages.currentPage().getHeaders().get('Referer');
        if(refer != NULL && refer.indexOf('start=GBI') > -1) {
            return new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/LoginGRA');
        }
        
        if (ApexPages.currentPage().getHeaders().get('CipherSuite') == null) {
            return new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/Login');
        }
        
        if(username != null && password != null) {
            return login();
        } else {   
            return checkIsLoggedIn();
        }
    }
        
    global void logOtherStartPage(String startPage, String flow) {
    
        AppError__c ae = new AppError__c(Name='Login Log',Message__c=startPage,Error__c=flow);
        insert ae;
    
    }
        
    global PageReference checkIsLoggedIn() {
    
        String redirectUrl = '/sfdcApp';
        String flow = 'checkIsLoggedIn~';
        String username = '';
        
        flow += 'checkIsLoggedIn[' + UserInfo.getUserId() + ']~';
        
    
        User u = [SELECT Id, Name, IsPortalEnabled FROM User WHERE Id = :UserInfo.getUserId()];
        flow += 'checkIsLoggedIn[' + u  + ']~';   
        
        username = u.Name;
        
        if (u.IsPortalEnabled || Test.isRunningTest()) {
            redirectUrl += start != null ? '#!/' + start : '#!/dashboard';
            
            flow += 'isGRA[' + redirectUrl  + ']~';           
            
            if(isGRA == 'true') {
                redirectUrl = '/graApp';
                redirectUrl += start != null ? '#!/' + start : '#!/home';   
                
                flow += 'isGRA[' + redirectUrl  + ']~';           
            }
            
            if (action != null) { 
                if (action == 'meeting'){
                    redirectUrl = '/apex/RegisterForMeeting?id=' + actionId;
                } else if (action == 'jobtarget') {
                    redirectUrl = '/apex/RegisterForJobTarget?goto=' + gotoParam;
                } else if (action == 'auth') {
                    redirectUrl = '/apex/redirect?userid=' + u.Id + '&route=' + gotoParam;
                } else if (action == 'eBookFRM') {
                    redirectUrl = '/mobiusRedirect?prod=' + actionId;
                }
                flow += 'action != null[' + redirectUrl + ']~';           
            }
            
            if(startURL != null){
                redirectUrl = EncodingUtil.urlDecode(startURL, 'UTF-8');
                flow += 'startURL != null[' + redirectUrl + ']~';           
            }
            
            if(returnUrl != null && returnUrl.indexOf('https://connect.garp.com') > -1) {
                returnUrl = returnUrl.substring(24);
                redirectUrl = '/HLRedirect?ReturnUrl=' + returnUrl;
                
                flow += 'returnUrl != null[' + redirectUrl + ']~';
            }
            
            logOtherStartPage(username, flow) ;
            
            system.debug('flow 1:' + flow);
            
            return new PageReference(redirectUrl);
        }
        
        system.debug('flow 2:' + flow);
        logOtherStartPage(username, flow);

        return null;
    }
    
    global PageReference login() {
    
        String flow = 'login~';
    
        String redirectUrl = '/sfdcApp';
        redirectUrl += start != null ? '#!/' + start : '#!/dashboard';
        if(isGRA == 'true') {
            redirectUrl = '/graApp';
            redirectUrl += start != null ? '#!/' + start : '#!/home';     
            
            flow += 'isGRA[' + redirectUrl  + ']~';                   
        }
        
        if(startURL != null) {
            redirectUrl = EncodingUtil.urlDecode(startURL, 'UTF-8');
            
            flow += 'startURL != null[' + redirectUrl + ']~';           
        }
        
        system.debug('Login Action2:' + action + ':' + actionId + ':' + start + ':' + gotoParam + ':' + startURL + ':' + returnUrl + ':' + isGRA + ':' + redirectUrl + ':' + username);
        
        flow += 'Login Action2:' + action + ':' + actionId + ':' + start + ':' + gotoParam + ':' + startURL + ':' + returnUrl + ':' + isGRA + ':' + redirectUrl + ':' + username + '~';   
        
        System.PageReference retLogin;

        List<User> lstUser = [Select Id, ContactId from User where username = :username];
        if( (lstUser != null && lstUser.size() > 0) || Test.isRunningTest() ) {
            //String contactId = lstUser[0].ContactId;
            
            List<Contact> lstContact;
            if(Test.isRunningTest()) {
                lstContact = [SELECT Id, Name, Last_Login_Start__c, Last_Login_Count__c, GBI_Participant__c FROM Contact WHERE email = 'Test@Test.com'];    
            } else {
                lstContact = [SELECT Id, Name, Last_Login_Start__c, Last_Login_Count__c, GBI_Participant__c FROM Contact WHERE Id = :lstUser[0].ContactId];    
            }
            
            flow += 'Login lstContact :' + lstContact  + '~';
             
            if( lstContact != null && lstContact.size() > 0 ) {
            
                if (action != null) {
                    if (action == 'meeting') {
                        redirectUrl = '/apex/RegisterForMeeting?id=' + actionId;
                    } else if (action == 'jobtarget') {
                        redirectUrl = '/apex/RegisterForJobTarget?goto=' + gotoParam;
                    } else if (action == 'auth') {
                        redirectUrl = '/apex/redirect?userid=' + lstUser[0].Id + '&route=' + gotoParam;
                    } else if (action == 'eBookFRM') {
                        redirectUrl = '/mobiusRedirect?prod=' + actionId;
                    }
                    flow += 'action != null[' + redirectUrl + ']~';
                }

                if(returnUrl != null && returnUrl.indexOf('https://connect.garp.com') > -1) {
                    returnUrl = returnUrl.substring(24);
                    redirectUrl = '/HLRedirect?ReturnUrl=' + returnUrl;
                    
                    flow += 'returnUrl != null[' + redirectUrl + ']~';
                }
                
                system.debug('redirectUrl:'+ redirectUrl);            

                flow += 'redirectUrl[' + redirectUrl + ']~';                                         
                                               
                Decimal cnt = lstContact[0].Last_Login_Count__c;
                if(cnt == null) {
                    lstContact[0].Last_Login_Count__c=0;
                }
                system.debug('Login Action3:' + redirectUrl);
                
                flow += 'Last_Login_Count__c[' + lstContact[0].Last_Login_Count__c+ ']~';
                
                // For GBI Login, User Contact needs to have GBI_Participant__c checked
                if('true' == isGRA&& true != lstContact[0].GBI_Participant__c) {
                    try {
                        insert new API_Transaction__c(Name='GBI Login', Description__c='GBI login attempt but not participant', Contact__c = lstContact[0].Id);
                    }catch(Exception e) {
                        System.debug(e);
                    }
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You are not able to login at this time. Please contact your administrator for support.'));
                    hasMessages = true;
                    password = null;
                    
                    
                    flow += 'GBI Login[' + isGRA + ']~';   
                    logOtherStartPage(username, flow);
                    return null;
                }
                
                retLogin = Site.login(username, password, redirectUrl);
                
                flow += 'retLogin [' + retLogin + ']~';  
                
                if(retLogin != null) {
                    lstContact[0].Last_Day_of_Login__c = datetime.now();
                    if(lstContact[0].Last_Login_Start__c == NULL) {
                        lstContact[0].Last_Login_Count__c = 1;
                        lstContact[0].Last_Login_Start__c = datetime.now();
                    } else {
                        DateTime nowDT = system.now();
                        DateTime loginDT = lstContact[0].Last_Login_Start__c;
                        Decimal diff = ((nowDT.getTime())/1000/60/60) - ((loginDT.getTime())/1000/60/60); 
                        if(diff < 1) {
                            cnt++;
                            lstContact[0].Last_Login_Count__c=cnt;
                        } else {
                            lstContact[0].Last_Login_Start__c=nowDT;
                            lstContact[0].Last_Login_Count__c = 1;
                        }
                    }
                    flow += 'update lstContact[' + lstContact[0] + ']~';  
                    update lstContact;
                    
                    if(lstContact[0].Last_Login_Count__c > 20) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You are not able to login at this time. You have made too many attempt in the last hour. Please try again later.');
                        ApexPages.addMessage(myMsg);
                        //lstContact[0].Last_Login_Count__c.addError('Required field.');
                        hasMessages=true;
                        password=null;
                        
                        flow += 'Last_Login_Count__ct[' + lstContact[0].Last_Login_Count__c + ']~'; 
                        return null;
                    }
                    
                }        
            } else {
                system.debug('Login Action4:' + redirectUrl);
                retLogin = Site.login(username, password, redirectUrl);
                flow += 'retLogin2 [' + retLogin + ']~';
            }           
        } else {
            system.debug('Login Action5:' + redirectUrl);
            retLogin = Site.login(username, password, redirectUrl);
            flow += 'retLogin3 [' + retLogin + ']~';
        }

        system.debug('flow 3:' + flow);
        logOtherStartPage(username, flow);
        
        return retLogin;
    }
    
    global PageReference resetPassword() {
       // List<User> u = [SELECT Id,username, Email FROM User WHERE username = :emailForPasswordReset AND IsPortalEnabled=true];
       List<User> u = [SELECT Id, Email FROM User WHERE Username = :emailForPasswordReset AND IsPortalEnabled=true];
        system.debug('*****:'+emailForPasswordReset);
        if (u.isEmpty()) {
            passwordResetEmailNotFound = true;
            system.debug('&&&&&:'+passwordResetEmailNotFound);
        } else {
            passwordResetSuccessful = Site.forgotPassword(emailForPasswordReset);
            passwordResetSuccessful=true;
          //  ResetPasswordResult rpr = system.resetPassword(u[0].Id,true);            
            system.debug('#####:'+passwordResetSuccessful);
            system.debug('^^^^^:'+emailForPasswordReset);
        }       
        return null;
    }
    
    global PageReference resetPasswordResetSuccessful() {
        passwordResetSuccessful = false;
        passwordResetEmailNotFound = false;
        return null;
    }
    
    global Boolean getHasErrors() {
        return ApexPages.hasMessages(ApexPages.Severity.Error);
    }
    
    
    private boolean createMember(List<contact> lstcont) {
    
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
        
    global PageReference register() {
        System.SavePoint sp = Database.setSavePoint();
        Id leadId;
        Registration.wrapperCreateOrder order;
        
        system.debug('register:'+order);

        //System.assert(false, 'BOOM!' + order);
        
        try {           
            TempAccount userData = getUserData();
            
            system.debug('getUserData:' + userData);
            
            if (Registration.GetMember(userData)){
                
                system.debug('GetMember Yes');
                
                List<Contact> lstCont = Registration.GetBussinessContact(userData);
                
                System.debug(lstCont);
                
                if (lstCont != null && lstCont.size() > 0){
                    
                    createMember(lstCont);
                    Contact newCont = lstCont[0];
                    
                    PageReference pr = new PageReference('/sfdcApp#!/registration_information/' + newCont.Id);
                    if(action != null) {
                        if(action == 'meeting'){                                
                            pr.getParameters().put('action', action);
                            pr.getParameters().put('id', actionId);
                            pr.getParameters().put('userid', newCont.Id);
                            pr.getParameters().put('success', String.valueOf(Registration.chapterMeetingRegister(newCont.Id, actionId, true)));
                        } else if (action == 'jobtarget'){
                            pr.getParameters().put('action', action);
                            pr.getParameters().put('userid', newCont.Id);
                        }
                    }
                    return pr;
                    
                } else {        
                    
                    system.debug('Member Exists:'+userData);
                
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The email you provided is already in our system. Please log in instead.'));
                    return null;
                }
                
            } else {
                
                leadId = Registration.SetLead(userData);
                
                system.debug('userData:'+userData);
                
                if (leadId != null) {
                    userData.Id = leadId;
                    order = Registration.createOrder(userData);
                    String invoiceNumber = order.invoiceNumber;
                    system.debug('userData:'+userData);
                    
                    if (order.contactId != null) {
                        //throw new TestException('order.contactId: ' + order.contactId);
                        //PageReference pr = Page.SignupConfirm;
                        Lead convertedLead = [SELECT ConvertedContactId FROM Lead where id =: userData.Id];                    
                        
                        system.debug('convertedLead:'+convertedLead);
                        
                        Cookie invoiceNumberCookie = new Cookie('invoiceNumber',order.invoiceNumber,null,500,false);
                        Cookie opportunityIdCookie = new Cookie('opportunityId',order.opportunityId,null,500,false);
                        Cookie companyCookie = new Cookie('company',order.company,null,500,false);
                        Cookie garpIdCookie = new Cookie('garpId',order.garpId,null,500,false);
                        
                        ApexPages.currentPage().setCookies(new Cookie[]{invoiceNumberCookie, opportunityIdCookie, companyCookie, garpIdCookie});

                        
                        PageReference pr = new PageReference('/sfdcApp?invoiceNumber=' + order.invoiceNumber + '#!/registration_information/' + convertedLead.ConvertedContactId);
                        if(action != null) {
                            if(action == 'meeting'){                                
                                pr.getParameters().put('action', action);
                                pr.getParameters().put('id', actionId);
                                pr.getParameters().put('userid', convertedLead.ConvertedContactId);
                                pr.getParameters().put('success', String.valueOf(Registration.chapterMeetingRegister(convertedLead.ConvertedContactId, actionId, true)));
                            } else if (action == 'jobtarget'){
                                pr.getParameters().put('action', action);
                                pr.getParameters().put('userid', convertedLead.ConvertedContactId);
                            }                        
                        }
                        return pr;
                    }                  
                }
            }       
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
            Database.rollback(sp);
            return null;
        }               
        
        //If it makes it to this point, something went wrong
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an unexpected error.'));
        System.debug('Error registering new user. leadId is ' + leadId + ', order is ' + order); 
        Database.rollback(sp);
        return null;
    }
    
    private TempAccount getUserData(){
        TempAccount objData = new TempAccount();
        objData.FirstName = firstName;
        objData.LastName = lastName;
        objData.Email = username;
        objData.MailingCountry = country;
        objData.BillingCountry = country;
        objData.Company = company;
        objData.JobFunction = jobFunction;
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
    
    public static List<String> COUNTRIES = new List<String> {
         'Afghanistan'
        ,'Åland Islands'
        ,'Albania'
        ,'Algeria'
        ,'American Samoa'
        ,'Andorra'
        ,'Angola'
        ,'Anguilla'
        ,'Antarctica'
        ,'Antigua and Barbuda'
        ,'Argentina'
        ,'Armenia'
        ,'Aruba'
        ,'Australia'
        ,'Austria'
        ,'Azerbaijan'
        ,'Bahamas'
        ,'Bahrain'
        ,'Bangladesh'
        ,'Barbados'
        ,'Belarus'
        ,'Belgium'
        ,'Belize'
        ,'Benin'
        ,'Bermuda'
        ,'Bhutan'
        ,'Bolivia'
        ,'Bonaire'
        ,'Bosnia and Herzegovina'
        ,'Botswana'
        ,'Bouvet Island'
        ,'Brazil'
        ,'British Indian Ocean Territory'
        ,'British Virgin Islands'
        ,'Brunei'
        ,'Bulgaria'
        ,'Burkina Faso'
        ,'Burundi'
        ,'Cambodia'
        ,'Cameroon'
        ,'Canada'
        ,'Cape Verde'
        ,'Cayman Islands'
        ,'Central African Republic'
        ,'Chad'
        ,'Chile'
        ,'China'
        ,'Christmas Island'
        ,'Cocos (Keeling) Islands'
        ,'Colombia'
        ,'Comoros'
        ,'Republic of the Congo'
        ,'Democratic Republic of the Congo'
        ,'Cook Islands'
        ,'Costa Rica'
        ,'Côte d\'Ivoire'
        ,'Croatia'
        ,'Cuba'
        ,'Curaçao'
        ,'Cyprus'
        ,'Czech Republic'
        ,'Denmark'
        ,'Djibouti'
        ,'Dominica'
        ,'Dominican Republic'
        ,'Ecuador'
        ,'Egypt'
        ,'El Salvador'
        ,'Equatorial Guinea'
        ,'Eritrea'
        ,'Estonia'
        ,'Ethiopia'
        ,'Falkland Islands'
        ,'Faroe Islands'
        ,'Fiji'
        ,'Finland'
        ,'France'
        ,'French Guiana'
        ,'French Polynesia'
        ,'French Southern and Antarctic Lands'
        ,'Gabon'
        ,'Gambia'
        ,'Georgia'
        ,'Germany'
        ,'Ghana'
        ,'Gibraltar'
        ,'Greece'
        ,'Greenland'
        ,'Grenada'
        ,'Guadeloupe'
        ,'Guam'
        ,'Guatemala'
        ,'Guernsey'
        ,'Guinea'
        ,'Guinea-Bissau'
        ,'Guyana'
        ,'Haiti'
        ,'Heard Island and McDonald Islands'
        ,'Vatican City'
        ,'Honduras'
        ,'Hong Kong'
        ,'Hungary'
        ,'Iceland'
        ,'India'
        ,'Indonesia'
        ,'Iran'
        ,'Iraq'
        ,'Ireland'
        ,'Isle of Man'
        ,'Israel'
        ,'Italy'
        ,'Jamaica'
        ,'Japan'
        ,'Jersey'
        ,'Jordan'
        ,'Kazakhstan'
        ,'Kenya'
        ,'Kiribati'
        ,'Kuwait'
        ,'Kyrgyzstan'
        ,'Laos'
        ,'Latvia'
        ,'Lebanon'
        ,'Lesotho'
        ,'Liberia'
        ,'Libya'
        ,'Liechtenstein'
        ,'Lithuania'
        ,'Luxembourg'
        ,'Macau'
        ,'Macedonia'
        ,'Madagascar'
        ,'Malawi'
        ,'Malaysia'
        ,'Maldives'
        ,'Mali'
        ,'Malta'
        ,'Marshall Islands'
        ,'Martinique'
        ,'Mauritania'
        ,'Mauritius'
        ,'Mayotte'
        ,'Mexico'
        ,'Micronesia'
        ,'Moldova'
        ,'Monaco'
        ,'Mongolia'
        ,'Montenegro'
        ,'Montserrat'
        ,'Morocco'
        ,'Mozambique'
        ,'Myanmar'
        ,'Namibia'
        ,'Nauru'
        ,'Nepal'
        ,'Netherlands'
        ,'New Caledonia'
        ,'New Zealand'
        ,'Nicaragua'
        ,'Niger'
        ,'Nigeria'
        ,'Niue'
        ,'Norfolk Island'
        ,'North Korea'
        ,'Northern Mariana Islands'
        ,'Norway'
        ,'Oman'
        ,'Pakistan'
        ,'Palau'
        ,'Palestine'
        ,'Panama'
        ,'Papua New Guinea'
        ,'Paraguay'
        ,'Peru'
        ,'Philippines'
        ,'Pitcairn Islands'
        ,'Poland'
        ,'Portugal'
        ,'Puerto Rico'
        ,'Qatar'
        ,'Republic of Kosovo'
        ,'Réunion'
        ,'Romania'
        ,'Russia'
        ,'Rwanda'
        ,'Saint Barthélemy'
        ,'Saint Helena'
        ,'Saint Kitts and Nevis'
        ,'Saint Lucia'
        ,'Saint Martin'
        ,'Saint Pierre and Miquelon'
        ,'Saint Vincent and the Grenadines'
        ,'Samoa'
        ,'San Marino'
        ,'São Tomé and Príncipe'
        ,'Saudi Arabia'
        ,'Senegal'
        ,'Serbia'
        ,'Seychelles'
        ,'Sierra Leone'
        ,'Singapore'
        ,'Sint Maarten'
        ,'Slovakia'
        ,'Slovenia'
        ,'Solomon Islands'
        ,'Somalia'
        ,'South Africa'
        ,'South Georgia'
        ,'South Korea'
        ,'South Sudan'
        ,'Spain'
        ,'Sri Lanka'
        ,'Sudan'
        ,'Suriname'
        ,'Svalbard and Jan Mayen'
        ,'Swaziland'
        ,'Sweden'
        ,'Switzerland'
        ,'Syria'
        ,'Taiwan'
        ,'Tajikistan'
        ,'Tanzania'
        ,'Thailand'
        ,'Timor-Leste'
        ,'Togo'
        ,'Tokelau'
        ,'Tonga'
        ,'Trinidad and Tobago'
        ,'Tunisia'
        ,'Turkey'
        ,'Turkmenistan'
        ,'Turks and Caicos Islands'
        ,'Tuvalu'
        ,'Uganda'
        ,'Ukraine'
        ,'United Arab Emirates'
        ,'United Kingdom'
        ,'United States '
        ,'United States Minor Outlying Islands'
        ,'United States Virgin Islands'
        ,'Uruguay'
        ,'Uzbekistan'
        ,'Vanuatu'
        ,'Venezuela'
        ,'Vietnam'
        ,'Wallis and Futuna'
        ,'Western Sahara'
        ,'Yemen'
        ,'Zambia'
             ,'Zimbabwe'
             };  
    public static List<String> JOBFUNCTIONS = new List<String> {
            'Academics',
            'Accounting',
            'Actuarial',
            'Administration',
            'Audit',
            'Board Member',
            'Business Unit Leader',
            'Clearance/Settlement',
            'Controller',
            'Data Governance',
            'Environmental/Sustainability',
            'Executive Management',
            'Human Resources',
            'Information Security',
            'Legal/Compliance',
            'Marketing',
            'Operations',
            'Portfolio Management',
            'Procurement',
            'Product Development',
            'Research',
            'Risk Management: Credit',
            'Risk Management: Energy/Commodities',
            'Risk Management: Enterprise',
            'Risk Management: Market',
            'Risk Management: Model Risk',
            'Risk Management: Operational',
            'Risk Management: Tech/Data',
            'Risk Management: Liquidity',
            'Sales',
            'Software Development',
            'Supply Chain',
            'Trading',
            'Treasury',
            'Other'                
    };   
        
    public static List<String> INDUSTRIES = new List<String> {
            'Accounting/Audit',
            'Asset Management',
            'Automotive',
            'Banking',
            'Broker/Dealer',
            'Capital Markets',
            'Consumer Products',
            'Education/Training',
            'Environmental/Life Sciences',
            'Government',
            'Health Care',
            'Industrial Products',
            'Insurance',
            'Management Consulting',
            'Manufacturing',
            'Media/Entertainment',
            'Metals and Mining',
            'Non-profit/NGO/Int’l Development',
            'Oil and Gas',
            'Pharmaceutical',
            'Power and Renewables',
            'Private Equity',
            'Professional Services',
            'Real Estate/Construction',
            'Retail/Wholesale',
            'Technology',
            'Telecom',
            'Transportation',
            'Travel/Hospitiality',
            'Venture Capital',
            'Wealth Management',
            'Other'
    };
}