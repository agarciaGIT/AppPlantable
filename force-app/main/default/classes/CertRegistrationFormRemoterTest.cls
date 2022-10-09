@isTest
private class CertRegistrationFormRemoterTest {
    
    @testSetup
    public static void testSetup(){ 
        
        INSERT new Exam_Date__c(Name = 'Exam Date', Date_String__c = String.valueOf(System.today().addDays(60)));
        
        CertRegistrationTestDataFactory.setupCaptcha();
        CertRegistrationTestDataFactory.setupChargent();
        CertRegistrationTestDataFactory.setupAccountOwner();     
        CertRegistrationTestDataFactory.setupActivePricebook();
        CertRegistrationTestDataFactory.setupFeeProducts();
        CertRegistrationTestDataFactory.setupBookProducts();
        CertRegistrationTestDataFactory.setupExamRegistrationDependencyObjects();
        
    }
      
    @isTest
    public static void fetchScrFormData(){
    
        Response.Detail res = CertRegistrationFormRemoter.fetchCertRegistrationFormData('SCR');
        
        System.assertEquals(200, res.status, res.message);
        
    }

    @isTest
    public static void fetchExamRegistrationCompletedData(){
        
        Response.Detail res = CertRegistrationFormRemoter.fetchCertRegistrationCompletedFormData('SCR');
        
        System.assertEquals(200, res.status, res.message);
        
    }
    
    @isTest
    public static void registerForScrNonAuthenticatedBusinessContact(){

        Account account = new Account();
        account.Name = 'TEST';
        INSERT account;

        Contact contact = new Contact();
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.Email = 'test@test.com';
        contact.AccountId = account.Id;
        contact.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Business Relationship');
        INSERT contact;

        Test.startTest();
        
        User user = CertRegistrationTestDataFactory.createCertRegistration('SCR', 'Credit Card', 'TESTUSERONE');
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void registerForScrNonAuthenticated(){
        
        Test.startTest();
        
        User user = CertRegistrationTestDataFactory.createCertRegistration('SCR', 'Credit Card', 'TESTUSERONE');
        
        Test.stopTest();
        
    }

    @isTest
    public static void registerForScrAuthenticated(){
        
        User user = CertRegistrationTestDataFactory.createAffiliateContact();

        Test.startTest();
        
        System.runAs(user){
            user = CertRegistrationTestDataFactory.createCertRegistration('SCR', 'Credit Card', 'TESTUSERONE');
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void fetchCertRegistrationInfoData(){
        
        User user = CertRegistrationTestDataFactory.createCertRegistration('SCR', 'Check', 'TESTUSERONE');
        
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName,
            (SELECT Id, Exam_Site__r.Site__c FROM Exam_Registrations__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
            LIMIT 1
        ];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        Test.startTest();
        
        System.runAs(user){

            String contactId = user.ContactId;
            
            CertRegistrationFormRemoter.fetchCertRegistrationInfoFormData('SCR', contactId);
        
        }
        
        Test.stopTest();      
        
    }     
    
    @isTest
    public static void updateCertRegistrationInfoData(){
        
        User user = CertRegistrationTestDataFactory.createCertRegistration('SCR', 'Check', 'TESTUSERONE');
        
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
            LIMIT 1
        ];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        Test.startTest();
        
        System.runAs(user){

            String contactId = user.ContactId;
            
            Contact contact = [
                SELECT
                Id, 
                Name, 
                FirstName, 
                LastName, 
                MailingAddress, 
                MailingStreet, 
                MailingCity, 
                MailingState, 
                MailingCountry, 
                MailingPostalCode,
                Email, 
                ID_Type__c, 
                ID_Number__c, 
                Name_As_it_Appears_On_ID__c, 
                ID_Expiration_Date__c, 
                Full_Name_in_Chinese__c, 
                Birthdate, 
                Gender__c,
                Phone, 
                OtherPhone, 
                Currently_Working_Status__c, 
                Company__c,
                Currently_in_School_Status__c, 
                KPI_Membership_Auto_Renew_Status__c, 
                School_Name__c, 
                Degree_Program_Name__c
                FROM Contact 
                WHERE Id = :contactId             
            ];
            
            String jsonString = JSON.serialize(contact);
            
            Response.Detail response = CertRegistrationFormRemoter.updateCertRegistrationInfo('SCR', jsonString);
        
        }
        
        Test.stopTest();         
        
    }

    @isTest
    public static void fetchCertRegistrationFormDataInvalidType(){
        
        Response.Detail res = CertRegistrationFormRemoter.fetchCertRegistrationFormData('INV');
        
        System.assertEquals(400, res.status, res.message);
        
    }

    @isTest
    public static void updateCertRegistrationInfoDataInvalidType(){
        
        User user = CertRegistrationTestDataFactory.createCertRegistration('SCR', 'Check', 'TESTUSERONE');
        
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
            LIMIT 1
        ];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        Test.startTest();
        
        System.runAs(user){

            String contactId = user.ContactId;
            
            Contact contact = [
                SELECT
                Id, 
                Name, 
                FirstName, 
                LastName, 
                MailingAddress, 
                MailingStreet, 
                MailingCity, 
                MailingState, 
                MailingCountry, 
                MailingPostalCode,
                Email, 
                ID_Type__c, 
                ID_Number__c, 
                Name_As_it_Appears_On_ID__c, 
                ID_Expiration_Date__c, 
                Full_Name_in_Chinese__c, 
                Birthdate, 
                Gender__c,
                Phone, 
                OtherPhone, 
                Currently_Working_Status__c, 
                Company__c,
                Currently_in_School_Status__c, 
                KPI_Membership_Auto_Renew_Status__c, 
                School_Name__c, 
                Degree_Program_Name__c
                FROM Contact 
                WHERE Id = :contactId             
            ];
            
            String jsonString = JSON.serialize(contact);
            
            Response.Detail response = CertRegistrationFormRemoter.updateCertRegistrationInfo('INV', jsonString);
        
        }
        
        Test.stopTest();         
        
    }

    @isTest
    public static void fetchCertRegistrationInfoDataInvalidType(){
        
        User user = CertRegistrationTestDataFactory.createCertRegistration('SCR', 'Check', 'TESTUSERONE');
        
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName,
            (SELECT Id, Exam_Site__r.Site__c FROM Exam_Registrations__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
            LIMIT 1
        ];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        Test.startTest();
        
        System.runAs(user){

            String contactId = user.ContactId;
            
            CertRegistrationFormRemoter.fetchCertRegistrationInfoFormData('INV', contactId);
        
        }
        
        Test.stopTest();      
        
    }   

    @isTest
    public static void fetchExamRegistrationCompletedDataInvalidType(){
        
        Response.Detail res = CertRegistrationFormRemoter.fetchCertRegistrationCompletedFormData('INV');
        
        System.assertEquals(400, res.status, res.message);
        
    }

    @isTest
    public static void payCertRegistrationOrderInvalidType(){

        Response.Detail res = CertRegistrationFormRemoter.payCertRegistrationOrder('INV', '{ "registrationType" : "SCR" }');

        System.assertEquals(400, res.status, res.message);

    }

    @isTest
    public static void createCertRegistrationOrderInvalidType(){

        Response.Detail res = CertRegistrationFormRemoter.createCertRegistrationOrder('INV', '{ "registrationType" : "SCR" }');

        System.assertEquals(400, res.status, res.message);

    }

    @isTest
    public static void createCertRegistrationOrderException(){

        Response.Detail res = CertRegistrationFormRemoter.createCertRegistrationOrder(null, '{ "registrationType" : "SCR" }');

        System.assertEquals(400, res.status);

    }

    @isTest
    private static void addTaxAndDutyToOrderTestWithNjBilling(){

        Product2 book = [SELECT Id FROM Product2 WHERE ProductCode = 'SCRH'];

        Lead lead = new Lead();
        lead.Billing_State__c = 'NJ';
        lead.Shipping_State__c = 'NY';
        lead.Shipping_Address_Same_as_Billing_Address__c = true;

        List<OpportunityLineItem> olis = new List<OpportunityLineItem>{
            new OpportunityLineItem(Product2Id = book.Id, UnitPrice = 100)
        };

        List<OpportunityLineItem> taxOrDutyOlis = new ScrRegistrationForm().addTaxAndDutyToOrder(olis, lead);

        System.assertEquals((100 * 0.06625), taxOrDutyOlis[0].UnitPrice, 'It should equal the unit price * 0.06625 (NJ Sales Tax Rate)');

    }

    @isTest
    private static void addTaxAndDutyToOrderTestWithNjShipping(){

        Product2 book = [SELECT Id FROM Product2 WHERE ProductCode = 'SCRH'];

        Lead lead = new Lead();
        lead.Billing_State__c = 'NY';
        lead.Shipping_State__c = 'NJ';
        lead.Shipping_Address_Same_as_Billing_Address__c = false;

        List<OpportunityLineItem> olis = new List<OpportunityLineItem>{
            new OpportunityLineItem(Product2Id = book.Id, UnitPrice = 100)
        };

        List<OpportunityLineItem> taxOrDutyOlis = new ScrRegistrationForm().addTaxAndDutyToOrder(olis, lead);

        System.assertEquals((100 * 0.06625), taxOrDutyOlis[0].UnitPrice, 'It should equal the unit price * 0.06625 (NJ Sales Tax Rate)');

    }
       
    @isTest
    private static void addTaxAndDutyToOrderTestWithCanadaBilling(){

        Product2 book = [SELECT Id FROM Product2 WHERE ProductCode = 'SCRH'];

        Lead lead = new Lead();
        lead.Billing_Country__c = 'Canada';
        lead.Shipping_Country__c = 'United States';
        lead.Shipping_Address_Same_as_Billing_Address__c = true;

        List<OpportunityLineItem> olis = new List<OpportunityLineItem>{
            new OpportunityLineItem(Product2Id = book.Id, UnitPrice = 100)
        };

        List<OpportunityLineItem> taxOrDutyOlis = new ScrRegistrationForm().addTaxAndDutyToOrder(olis, lead);

        System.assertEquals(22, taxOrDutyOlis[0].UnitPrice, 'It should equal the unit price $22.00 (Canadian Duty)');

    }

    @isTest
    private static void addTaxAndDutyToOrderTestWithCanadaShipping(){

        Product2 book = [SELECT Id FROM Product2 WHERE ProductCode = 'SCRH'];

        Lead lead = new Lead();
        lead.Billing_Country__c = 'United States';
        lead.Shipping_Country__c = 'Canada';
        lead.Shipping_Address_Same_as_Billing_Address__c = false;

        List<OpportunityLineItem> olis = new List<OpportunityLineItem>{
            new OpportunityLineItem(Product2Id = book.Id, UnitPrice = 100)
        };

        List<OpportunityLineItem> taxOrDutyOlis = new ScrRegistrationForm().addTaxAndDutyToOrder(olis, lead);

        System.assertEquals(22, taxOrDutyOlis[0].UnitPrice, 'It should equal the unit price $22.00 (Canadian Duty)');

    }

}