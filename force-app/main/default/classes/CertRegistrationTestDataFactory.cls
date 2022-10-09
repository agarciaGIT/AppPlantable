@isTest
public with sharing class CertRegistrationTestDataFactory {
        
    @TestVisible private static Id pricebookId = null;
    
    @TestVisible private static void setupCaptcha(){
        
        CAPTCHA_Configuration__c captchaConfigurations = new CAPTCHA_Configuration__c(
            Name = 'Exam Registration',
            Enabled__c = true,
            Submission_Speed_Threshold__c = 0
        );
        
        INSERT captchaConfigurations;
        
    }
    
    @TestVisible private static void setupChargent(){
        
        //CHARGENT
        ChargentBase__Gateway__c chargentGateway = new ChargentBase__Gateway__c(
            Name = 'Test',
            ChargentBase__Active__c = true,
            ChargentBase__Available_Payment_Methods__c = 'Credit Card'
        );
        
        INSERT chargentGateway;
        INSERT new UpdateIds__c(Name = 'GARP', Record_Id__c = chargentGateway.Id);
        
    }
    
    @TestVisible private static void setupAccountOwner(){
        
        //ACCOUNT OWNER
        INSERT new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX'); 
        
    }
    
    @TestVisible private static void setupActivePricebook(){
        
        Pricebook2 activePricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = TRUE
        );
        
        UPDATE activePricebook;
        
        pricebookId = activePricebook.Id;
        
    }
    
    @TestVisible private static void setupFeeProducts(){
        
        //FEES
        Product2 AFREE = new Product2(Company__c = 'GARP', Name = 'AFREE', ProductCode = 'AFREE', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);       
        Product2 MEMI = new Product2(Company__c = 'GARP', Name = 'MEMI', ProductCode = 'MEMI', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 PRFEE = new Product2(Company__c = 'GARP', Name = 'PRFEE', ProductCode = 'PRFEE', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 SLSTX = new Product2(Company__c = 'GARP', Name = 'SLSTX', ProductCode = 'SLSTX', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 CDNTAX = new Product2(Company__c = 'GARP', Name = 'CDNTAX', ProductCode = 'CDNTAX', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 SHIP = new Product2(Company__c = 'GARP', Name = 'SHIP', ProductCode = 'SHIP', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);                 

        INSERT new List<Product2>{
            AFREE, 
            MEMI, 
            PRFEE, 
            SLSTX, 
            CDNTAX, 
            SHIP
        };
        
        PricebookEntry AFREEPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = AFREE.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry MEMIPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = MEMI.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry PRFEEPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = PRFEE.Id, UnitPrice = 50, IsActive = true);
        PricebookEntry SLSTXPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SLSTX.Id, UnitPrice = 15.23, IsActive = true);
        PricebookEntry CDNTAXPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = CDNTAX.Id, UnitPrice = 22, IsActive = true);
        PricebookEntry SHIPPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SHIP.Id, UnitPrice = 21.34, IsActive = true);          

        INSERT new List<PricebookEntry>{
            AFREEPBE,
            MEMIPBE,
            PRFEEPBE,
            SLSTXPBE,
            CDNTAXPBE,
            SHIPPBE
        };
        
    }
    
    @TestVisible private static void setupBookProducts(){
        
        //EBOOKS  
        Product2 SCRX = new Product2(Company__c = 'GARP', Taxable__c = true, Name = 'SCR eBook', ProductCode = 'SCRX', GL_Code__c = '4999', Family = 'Books', IsActive = true);  
        
        //BOOKS
        Product2 SCRH = new Product2(Company__c = 'GARP', Taxable__c = true, Weight__c = 1.0, Name = 'SCR Book', ProductCode = 'SCRH', GL_Code__c = '4999', Family = 'Books', IsActive = true);

        INSERT new List<Product2>{ SCRX, SCRH };
        
        //EBOOKS
        PricebookEntry SCRXPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SCRX.Id, UnitPrice = 10000, IsActive = true);
        
        //BOOKS
        PricebookEntry SCRHPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SCRH.Id, UnitPrice = 10000, IsActive = true);   

        INSERT new List<PricebookEntry>{ SCRXPBE, SCRHPBE };
        
    }
    
    @TestVisible private static void setupExamRegistrationDependencyObjects(){
        
        Product2 SCRM = new Product2(Company__c = 'GARP', Name = 'SCR Member', ProductCode = 'SCRM', GL_Code__c = '4999', Family = 'Exams', IsActive = true);  
        Product2 SCRNM = new Product2(Company__c = 'GARP', Name = 'SCR Non-member', ProductCode = 'SCRNM', GL_Code__c = '4999', Family = 'Exams', IsActive = true);  
        Product2 SCRCM = new Product2(Company__c = 'GARP', Name = 'SCR Certified Member', ProductCode = 'SCRCM', GL_Code__c = '4999', Family = 'Exams', IsActive = true);  
        Product2 SCR2A = new Product2(Company__c = 'GARP', Name = 'SCR 2nd Attempt', ProductCode = 'SCR2A', GL_Code__c = '4999', Family = 'Exams', IsActive = true);    

        INSERT new List<Product2>{ SCRM, SCRNM, SCRCM, SCR2A };

        PricebookEntry SCRMPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SCRM.Id, UnitPrice = 10000, IsActive = true); 
        PricebookEntry SCRNMPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SCRNM.Id, UnitPrice = 10000, IsActive = true); 
        PricebookEntry SCRCMPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SCRCM.Id, UnitPrice = 10000, IsActive = true);  
        PricebookEntry SCR2APBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SCR2A.Id, UnitPrice = 10000, IsActive = true); 

        INSERT new List<PricebookEntry>{ SCRMPBE, SCRNMPBE, SCRCMPBE, SCR2APBE };

        //SITES AND EXAMS
        Site__c site = new Site__c(
            name = 'SCR',
            Display_Address__c = 'SCR',
            Active__c = true,
            Non_selectable__c = false        
        );    
        
        INSERT new List<Site__c>{site}; 
        
        Exam_Group__c examGroup = new Exam_Group__c(
            Name = 'SCR',
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Exam_Group__c', 'SCR')
        );
        INSERT examGroup;
        
        Exam__c exam = new Exam__c(
            Exam_Group__c = examGroup.Id,
            Exam_Date__c = System.today().addDays(60),
            Exam__c = 'SCR Exam',
            Name = 'SCR Exam'
        );
        INSERT exam;
        
        Exam_Sites__c examSite = new Exam_Sites__c(
            Name = 'SCR',
            Site__c = site.Id, 
            Exam__c = exam.Id
        );         
        INSERT examSite;
                        
    }

    @TestVisible private static User createAffiliateContact(){

        Account account = new Account();
        account.Name = 'TEST';
        account.OwnerId = [SELECT Id, Record_id__c FROM updateids__c WHERE name = 'User' LIMIT 1].Record_id__c;
        account.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account', 'Individual');
        INSERT account;

        Opportunity opportunity = new Opportunity(
            Name = 'Affiliate Membership',
            AccountId = account.Id,
            Eligible_for_Membership_Extension__c = TRUE,
            CloseDate = Date.today(),
            StageName = 'New Lead',
            RecordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated')
        );

        INSERT opportunity;

        PricebookEntry pbe = [SELECT Id, Product2Id FROM PricebookEntry WHERE ProductCode = 'AFREE' LIMIT 1];

        OpportunityLineItem affiliateMembershipOpportunityOli = new OpportunityLineItem( 
            OpportunityId       = opportunity.Id,                          
            PricebookEntryId    = pbe.Id,
            Product2Id          = pbe.Product2Id,
            UnitPrice           = 0,
            Quantity            = 1,
            Description         = 'Affiliate Membership'
        );

        INSERT affiliateMembershipOpportunityOli;

        Contact contact = new Contact();
        contact.AccountId = account.Id;
        contact.Email = 'test.user.1234@garpqa.com';
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
        INSERT contact;

        Contract membershipContract = new Contract(
            Name = 'Affiliate Membership',
            AccountId = account.Id,
            Opportunity__c = opportunity.Id,
            CustomerSignedId = contact.Id,
            StartDate = System.Today(),
            ContractTerm = 12,
            Membership_Type__c = 'Affiliate',
            RecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership')
        );
        
        INSERT membershipContract;

        opportunity.StageName = 'Closed';

        UPDATE opportunity;
        
        List<User> users =  [
            SELECT Id, ContactId, AccountId
            FROM User 
            WHERE ContactId = :contact.Id LIMIT 1
        ];
        
        System.debug(users);
        
        if(users.isEmpty()){
            return null;
        }else{
            return users[0];
        }

    }

    @TestVisible private static User createCertRegistration(String registrationType, String paymentMethod, String username){
        
        Response.Detail res = CertRegistrationFormRemoter.fetchCertRegistrationFormData(registrationType);
        
        System.debug(res);

        CertRegistrationForm.ViewModel vm = (CertRegistrationForm.ViewModel)res.data;
        
        System.debug(vm);

        Lead lead = new Lead();
        
        lead.FirstName = username;
        lead.LastName = username;
        lead.Email = username + '@test.com';
        
        Response.Detail upsertLeadRes = RegistrationFormLeadRemoter.upsertLead(JSON.serialize(lead), 'test-form-key');
        
        Lead createdLead = (Lead)upsertLeadRes.data;
        
        createdLead.Phone = '1234567890';
        createdLead.ID_Type__c = 'Passport';
        createdLead.ID_Number__c = '1234567890';
        createdLead.Name_as_it_Appears_on_ID__c = username;
        createdLead.Billing_Address_1__c = '123 SAMPLE STREET';
        createdLead.Billing_City__c = 'SAMPLE CITY';
        createdLead.Billing_State__c = 'NJ';
        createdLead.Billing_Company__c = 'TEST CO';
        createdLead.Billing_Phone_Number__c = '1234567890';
        createdLead.Billing_Country__c = 'United StatesS';
        createdLead.Billing_Postal_Code__c = '07310';
        createdLead.Shipping_Address_1__c = '123 SAMPLE STREET';
        createdLead.Shipping_City__c = 'SAMPLE CITY';
        createdLead.Shipping_State__c = 'NJ';
        createdLead.Shipping_Company__c = 'TEST CO';
        createdLead.Shipping_Phone_Number__c = '1234567890';
        createdLead.Shipping_Country__c = 'United States';
        createdLead.Shipping_Postal_Code__c = '07310';
        createdLead.Payment_Type__c = paymentMethod;
        createdLead.Shipping_Address_Same_as_Billing_Address__c = FALSE;
        
        CertRegistrationForm.RegistrationRequest registrationRequest = new CertRegistrationForm.RegistrationRequest();
        
        registrationRequest.token = vm.token;
        registrationRequest.lead = createdLead;
        registrationRequest.registrationType = registrationType;
        registrationRequest.products = new Map<String, CertRegistrationForm.Item>();
        
        String registrationRequestJSON = JSON.serialize(registrationRequest);
        
        Response.Detail responseDetailObject = CertRegistrationFormRemoter.createCertRegistrationOrder(registrationType, registrationRequestJSON);
        
        System.debug(responseDetailObject); 
        
        CertRegistrationForm.RegistrationResponse registrationResponse = (CertRegistrationForm.RegistrationResponse)responseDetailObject.data;
        
        System.debug(registrationResponse);
        
        Lead convertedLead = (Lead)registrationResponse.lead;
        convertedLead.Payment_Type__c = paymentMethod;
        
        System.debug(convertedLead);
        
        CertRegistrationForm.ChargeRequest chargeRequest = new CertRegistrationForm.ChargeRequest();
        
        CertRegistrationForm.Card card = new CertRegistrationForm.Card();
        
        card.expirationMonth = '01';
        card.expirationYear = '2025';
        card.fullName = username;
        card.cardNumber = '4111111111111111';
        card.securityCode = '123';
        
        chargeRequest.token = vm.token;
        chargeRequest.card = card;
        chargeRequest.lead = convertedLead;
        chargeRequest.registrationType = registrationType;
        
        String chargeRequestJSON = JSON.serialize(chargeRequest);
        
        ContactTriggerHandler.stopRecurssion = false;
        Response.Detail chargeResponse = CertRegistrationFormRemoter.payCertRegistrationOrder(registrationType, chargeRequestJSON); 
        
        System.debug(chargeResponse);
        
        List<User> users =  [
            SELECT Id, ContactId, AccountId
            FROM User 
            WHERE ContactId = :convertedLead.ConvertedContactId LIMIT 1
        ];
        
        System.debug(users);
        
        if(users.isEmpty()){
            return null;
        }else{
            return users[0];
        }
        
    }
    
}