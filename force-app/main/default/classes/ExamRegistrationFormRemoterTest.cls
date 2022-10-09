@isTest
private class ExamRegistrationFormRemoterTest {
    
    @testSetup
    public static void testSetup(){ 
        
       	INSERT new Exam_Date__c(Name = 'Exam Date', Date_String__c = String.valueOf(System.today().addDays(60)));
        
        ExamRegistrationTestDataFactory.setupCaptcha();
        ExamRegistrationTestDataFactory.setupChargent();
		ExamRegistrationTestDataFactory.setupAccountOwner();     
		ExamRegistrationTestDataFactory.setupActivePricebook();
        ExamRegistrationTestDataFactory.setupFeeProducts();
		ExamRegistrationTestDataFactory.setupBookProducts();
		ExamRegistrationTestDataFactory.setupExamRegistrationDependencyObjects();
        
    }
               
    @isTest
    public static void fetchExamRegistrationCompletedData(){
        
        //ExamRegistrationFormHelper.validateRequest = false;

        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationCompletedData('FRM');
        
        System.assertEquals(200, res.status, res.message);
        
    }
    
    @isTest
    public static void fetchExamRegistrationCompletedDataERP(){
        
        //ExamRegistrationFormHelper.validateRequest = false;

        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationCompletedData('ERP');
        
        System.assertEquals(200, res.status, res.message);
        
    }
    
    @isTest
    public static void fetchExamRegistrationCompletedDataSCR(){
        
        //ExamRegistrationFormHelper.validateRequest = false;

        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationCompletedData('SCR');
        
        System.assertEquals(200, res.status, res.message);
        
    }
    
    @isTest
    public static void fetchFrmFormData(){
  
        //ExamRegistrationFormHelper.validateRequest = false;

        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationFormData('FRM',null);
        
        System.assertEquals(200, res.status, res.message);
        
    }
    
    @isTest
    public static void fetchErpFormData(){

        //ExamRegistrationFormHelper.validateRequest = false;
  
        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationFormData('ERP',null);
        
        System.assertEquals(200, res.status, res.message);
        
    }

    @isTest
    public static void fetchScrFormData(){

        //ExamRegistrationFormHelper.validateRequest = false;
  
        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationFormData('SCR',null);
        
        System.assertEquals(200, res.status, res.message);
        
    }
    
    @isTest
    public static void registerForFRMPart1NonAuthenticatedBusinessContact(){

        //ExamRegistrationFormHelper.validateRequest = false;

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
        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Credit Card', 'TESTUSERONE', FALSE, FALSE);
        Test.stopTest();
        
    }
    
    @isTest
    public static void registerForFRMPart1And2NonAuthenticated(){

        Test.startTest();
        //ExamRegistrationFormHelper.validateRequest = false;
		User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Credit Card', 'TESTUSERONE', TRUE, FALSE);
        Test.stopTest();
        
    }
    
    @isTest
    public static void registerForERPPart1And2NonAuthenticated(){

        Test.startTest();
        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('ERP', 'Credit Card', 'TESTUSERONE', TRUE, FALSE);
        Test.stopTest();
        
    }

    @isTest
    public static void registerForFRMPart1NonAuthenticated(){

        Test.startTest();
        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Credit Card', 'TESTUSERONE', FALSE, FALSE);
        Test.stopTest();
        
    }
    
    @isTest
    public static void registerForSCRNonAuthenticated(){

        Test.startTest();
        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('SCR', 'Credit Card', 'TESTUSERONE', FALSE, FALSE);
        Test.stopTest();
        
    }
    
    /*@isTest
    public static void registerForFRMPart1AuthenticatedWithCorrectScholarship(){ 

        User user = ExamRegistrationTestDataFactory.createAffiliateContact();
        
        Scholarship_Application__c scholarshipApplication = new Scholarship_Application__c();
        
        scholarshipApplication.Applicant__c = user.ContactId;
        scholarshipApplication.Exam_Group__c = [SELECT Id FROM Exam_Group__c LIMIT 1].Id;
        scholarshipApplication.Status__c = 'Approved';
        scholarshipApplication.Exam_Type__c = 'FRM';
        
        INSERT scholarshipApplication;

        Test.startTest();
        
        System.runAs(user){
            //ExamRegistrationFormHelper.validateRequest = false;
        	user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Check', 'TESTUSERONE', FALSE, FALSE);
        }
        
        Test.stopTest();
       
        List<Opportunity> opportunities = [
            SELECT Id, RecordType.Name, AccountId, StageName,
            (SELECT Id, Name, ProductCode FROM OpportunityLineItems),
            (SELECT Id, Status FROM Contracts__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId AND StageName = 'New Lead'
        ];

        List<Contract> contracts = new List<Contract>();
        for(Opportunity opportunity: opportunities){
            opportunity.StageName = 'Closed';
            for(Contract contract: opportunity.Contracts__r){
                contract.Status = 'Activated';
                contracts.add(contract);
            }
        }

        //Needed to simulate the closing of the Opportunity in a separate transaction context.
        opportunityTriggerHelper.isFirstRun = TRUE;

        UPDATE opportunities;
        UPDATE contracts;

        System.assertEquals(1, [SELECT Id, ProductCode FROM OpportunityLineItem WHERE ProductCode = 'SAFRM1'].size(), 'It should apply the discount');
        System.assertEquals('Used', [SELECT Id, Status__c FROM Scholarship_Application__c WHERE Id = :scholarshipApplication.Id].Status__c, 'It should NOT set the Scholarship Application Status to "Used"');
        
    }
    
    @isTest
    public static void registerForFRMPart1AuthenticatedWithIncorrectScholarship(){

        User user = ExamRegistrationTestDataFactory.createAffiliateContact();
        
        Scholarship_Application__c scholarshipApplication = new Scholarship_Application__c();
        
        scholarshipApplication.Applicant__c = user.ContactId;
        scholarshipApplication.Exam_Group__c = [SELECT Id FROM Exam_Group__c LIMIT 1].Id;
        scholarshipApplication.Status__c = 'Approved';
        scholarshipApplication.Exam_Type__c = 'ERP';
        
        INSERT scholarshipApplication;

        Test.startTest();
        
        System.runAs(user){
            //ExamRegistrationFormHelper.validateRequest = false;
        	user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Check', 'TESTUSERONE', FALSE, FALSE);
        }

        Test.stopTest();

        List<Opportunity> opportunities = [
            SELECT Id, RecordType.Name, AccountId, StageName,
            (SELECT Id, Name, ProductCode FROM OpportunityLineItems),
            (SELECT Id, Status FROM Contracts__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId AND StageName = 'New Lead'
        ];

        List<Contract> contracts = new List<Contract>();
        for(Opportunity opportunity: opportunities){
            opportunity.StageName = 'Closed';
            for(Contract contract: opportunity.Contracts__r){
                contract.Status = 'Activated';
                contracts.add(contract);
            }
        }

        //Needed to simulate the closing of the Opportunity in a separate transaction context.
        opportunityTriggerHelper.isFirstRun = TRUE;

        UPDATE opportunities;
        UPDATE contracts;

        System.assertEquals(0, [SELECT Id, ProductCode FROM OpportunityLineItem WHERE ProductCode = 'SAFRM1'].size(), 'It should NOT apply the discount');
        System.assertEquals('Approved', [SELECT Id, Status__c FROM Scholarship_Application__c WHERE Id = :scholarshipApplication.Id].Status__c, 'It should NOT set the Scholarship Application Status to "Used"');
        
    }*/
    
    /*@isTest
    public static void registerForERPPart1AuthenticatedWithCorrectScholarship(){

        User user = ExamRegistrationTestDataFactory.createAffiliateContact();
        
        Scholarship_Application__c scholarshipApplication = new Scholarship_Application__c();
        
        scholarshipApplication.Applicant__c = user.ContactId;
        scholarshipApplication.Exam_Group__c = [SELECT Id FROM Exam_Group__c LIMIT 1].Id;
        scholarshipApplication.Status__c = 'Approved';
        scholarshipApplication.Exam_Type__c = 'ERP';
        
        INSERT scholarshipApplication;
        
        Test.startTest();
        
        System.runAs(user){
            //ExamRegistrationFormHelper.validateRequest = false;
        	user = ExamRegistrationTestDataFactory.createExamRegistration('ERP', 'Check', 'TESTUSERONE', FALSE, FALSE);
        }        

        Test.stopTest();
        
        List<Opportunity> opportunities = [
            SELECT Id, RecordType.Name, AccountId, StageName,
            (SELECT Id, Name, ProductCode FROM OpportunityLineItems),
            (SELECT Id, Status FROM Contracts__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId AND StageName = 'New Lead'
        ];

        List<Contract> contracts = new List<Contract>();
        for(Opportunity opportunity: opportunities){
            opportunity.StageName = 'Closed';
            for(Contract contract: opportunity.Contracts__r){
                contract.Status = 'Activated';
                contracts.add(contract);
            }
        }

        //Needed to simulate the closing of the Opportunity in a separate transaction context.
        opportunityTriggerHelper.isFirstRun = TRUE;

        UPDATE opportunities;
        UPDATE contracts;
        
        System.assertEquals(1, [SELECT Id, ProductCode FROM OpportunityLineItem WHERE ProductCode = 'SAERP1'].size(), 'It should apply the discount');
        System.assertEquals('Used', [SELECT Id, Status__c FROM Scholarship_Application__c WHERE Id = :scholarshipApplication.Id].Status__c, 'It should set the Scholarship Application Status to "Used"');
                
    }*/

    /*@isTest
    public static void registerForERPPart1AuthenticatedWithIncorrectScholarship(){

        User user = ExamRegistrationTestDataFactory.createAffiliateContact();
        
        Scholarship_Application__c scholarshipApplication = new Scholarship_Application__c();
        
        scholarshipApplication.Applicant__c = user.ContactId;
        scholarshipApplication.Exam_Group__c = [SELECT Id FROM Exam_Group__c LIMIT 1].Id;
        scholarshipApplication.Status__c = 'Approved';
        
        //Simulate Scholarship for FRM when the user is trying to register for ERP.
        scholarshipApplication.Exam_Type__c = 'FRM';
        
        INSERT scholarshipApplication;

        Test.startTest();
        
        System.runAs(user){
            //ExamRegistrationFormHelper.validateRequest = false;
       		user = ExamRegistrationTestDataFactory.createExamRegistration('ERP', 'Check', 'TESTUSERONE', FALSE, FALSE);
        }

        Test.stopTest();
        
        List<Opportunity> opportunities = [
            SELECT Id, RecordType.Name, AccountId, StageName,
            (SELECT Id, Name, ProductCode FROM OpportunityLineItems),
            (SELECT Id, Status FROM Contracts__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId AND StageName = 'New Lead'
        ];

        List<Contract> contracts = new List<Contract>();
        for(Opportunity opportunity: opportunities){
            opportunity.StageName = 'Closed';
            for(Contract contract: opportunity.Contracts__r){
                contract.Status = 'Activated';
                contracts.add(contract);
            }
        }

        //Needed to simulate the closing of the Opportunity in a separate transaction context.
        opportunityTriggerHelper.isFirstRun = TRUE;

        UPDATE opportunities;
        UPDATE contracts;
        
        System.assertEquals(0, [SELECT Id, ProductCode FROM OpportunityLineItem WHERE ProductCode = 'SAERP1'].size(), 'It should NOT apply the discount');
        System.assertEquals('Approved', [SELECT Id, Status__c FROM Scholarship_Application__c WHERE Id = :scholarshipApplication.Id].Status__c, 'It should NOT set the Scholarship Application Status to "Used"');
        
    }*/
    
    @isTest
    public static void registerForFRMPart2Authenticated(){

        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Check', 'TESTUSERONE', FALSE, FALSE);
        
        Opportunity opportunity = [
            SELECT Id, RecordType.Name, AccountId, StageName,
            (SELECT Id, Status FROM Contracts__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId AND StageName = 'New Lead'
			LIMIT 1
		];

        opportunity.StageName = 'Closed';

        UPDATE opportunity;
		Test.startTest();
        List<Contract> contracts = new List<Contract>();
        for(Contract contract: opportunity.Contracts__r){
            contract.Status = 'Activated';
            contracts.add(contract);
        }

        UPDATE contracts;
        
        Exam_Rate__c er = [Select Id,Exam__c from Exam_Rate__c where Exam__r.Exam__c = 'FRM Part 1' Limit 1];
        
        Exam_Rate_Offering__c ero = new Exam_Rate_Offering__c();
        ero.Exam_Rate__c = er.id;
        ero.Start_Date__c = system.today().adddays(-10);
        ero.End_Date__c = system.today().adddays(10);
        ero.Contact__c = user.contactId;
        
        insert ero;

        //Test.startTest();
        
        System.runAs(user){
            //ExamRegistrationFormHelper.validateRequest = false;
        	user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Credit Card', 'TESTUSERONE', FALSE, FALSE);
        }
        
        Test.stopTest();
        
    }
    
   /* @isTest
    public static void registerForSCRAuthenticated(){

        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('SCR', 'Credit Card', 'TESTUSERONE', FALSE, FALSE);
        Test.startTest();
        Opportunity opportunity = [
            SELECT Id, RecordType.Name, AccountId, StageName,
            (SELECT Id, Status FROM Contracts__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId AND StageName = 'New Lead'
			LIMIT 1
		];

        opportunity.StageName = 'Closed';

        UPDATE opportunity;
		//Test.startTest();
        List<Contract> contracts = new List<Contract>();
        for(Contract contract: opportunity.Contracts__r){
            contract.Status = 'Activated';
            contracts.add(contract);
        }
        UPDATE contracts;

        
        
        System.runAs(user){
            //ExamRegistrationFormHelper.validateRequest = false;
        	user = ExamRegistrationTestDataFactory.createExamRegistration('SCR', 'Check', 'TESTUSERONE', FALSE, FALSE);
        }
        
        Test.stopTest();
        
    }*/
    
    @isTest
    public static void registerForERPPart1NonAuthenticated(){

        Test.startTest();
        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('ERP', 'Check', 'TESTUSERONE', FALSE, TRUE);
        Test.stopTest();
        
    }
    
    @isTest
    public static void registerForERPPart2Authenticated(){

        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('ERP', 'Check', 'TESTUSERONE', FALSE, FALSE);
        Test.startTest();
        Opportunity opportunity = [
            SELECT Id, RecordType.Name, AccountId, StageName,
            (SELECT Id, Status FROM Contracts__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId AND StageName = 'New Lead'
            LIMIT 1
        ];

        opportunity.StageName = 'Closed';

        UPDATE opportunity;

        List<Contract> contracts = new List<Contract>();
        for(Contract contract: opportunity.Contracts__r){
            contract.Status = 'Activated';
            contracts.add(contract);
        }

        UPDATE contracts;
        
        //Test.startTest();
        
        System.runAs(user){
            //ExamRegistrationFormHelper.validateRequest = false;
        	user = ExamRegistrationTestDataFactory.createExamRegistration('ERP', 'Check', 'TESTUSERONE', FALSE, FALSE);
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void fetchExamRegistrationInfoData(){

        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Check', 'TESTUSERONE', FALSE, FALSE);
        Test.startTest();
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName,
            (SELECT Id, Exam_Site__r.Site__c FROM Exam_Registrations__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
			LIMIT 1
		];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        
        
        System.runAs(user){
            String contactId = user.ContactId;
            //ExamRegistrationFormHelper.validateRequest = false;
            ExamRegistrationFormRemoter.fetchExamRegistrationInfoData('FRM', contactId);
        }
        
        Test.stopTest();      
        
    }
    
    @isTest
    public static void fetchExamRegistrationInfoDataSCR(){

        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('SCR', 'Credit Card', 'TESTUSERONE', FALSE, FALSE);
        Test.startTest();
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName,
            (SELECT Id, Exam_Site__r.Site__c FROM Exam_Registrations__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
			LIMIT 1
		];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        
        
        System.runAs(user){
            String contactId = user.ContactId;
            //ExamRegistrationFormHelper.validateRequest = false;
            ExamRegistrationFormRemoter.fetchExamRegistrationInfoData('SCR', contactId);
        }
        
        Test.stopTest();      
        
    }
    
    @isTest
    public static void fetchExamRegistrationInfoDataERP(){

        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('ERP', 'Check', 'TESTUSERONE', FALSE, FALSE);
        Test.startTest();
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName,
            (SELECT Id, Exam_Site__r.Site__c FROM Exam_Registrations__r)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
			LIMIT 1
		];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        
        
        System.runAs(user){
            String contactId = user.ContactId;
            //ExamRegistrationFormHelper.validateRequest = false;
            ExamRegistrationFormRemoter.fetchExamRegistrationInfoData('ERP', contactId);
        }
        
        Test.stopTest();      
        
    }
    
    @isTest
    public static void updateExamRegistrationInfoData(){

        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Credit Card', 'TESTUSERONE', FALSE, FALSE);
        Test.startTest();
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
			LIMIT 1
		];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        //Test.startTest();
        
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
            
            Response.Detail response = ExamRegistrationFormRemoter.updateExamRegistrationInfoData('FRM', jsonString);
		
        }
        
        Test.stopTest();         
        
    }
    @isTest
    public static void updateExamRegistrationInfoDataSCR(){

        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('SCR', 'Credit Card', 'TESTUSERONE', FALSE, FALSE);
        Test.startTest();
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
			LIMIT 1
		];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        //Test.startTest();
        
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
            
            Response.Detail response = ExamRegistrationFormRemoter.updateExamRegistrationInfoData('SCR', jsonString);
		
        }
        
        Test.stopTest();         
        
    }
    
    @isTest
    public static void updateExamRegistrationInfoDataERP(){

        //ExamRegistrationFormHelper.validateRequest = false;
        User user = ExamRegistrationTestDataFactory.createExamRegistration('ERP', 'Credit Card', 'TESTUSERONE', FALSE, FALSE);
        Test.startTest();
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
			LIMIT 1
		];
        
        opportunity.StageName = 'Closed';
        
        UPDATE opportunity;
        
        //Test.startTest();
        
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
            
            Response.Detail response = ExamRegistrationFormRemoter.updateExamRegistrationInfoData('ERP', jsonString);
		
        }
        
        Test.stopTest();         
        
    }
    
    @isTest
    public static void testexamRegistrationForm(){
        String examType = 'FRM';
        String paymentMethod = 'Check';
        String username = 'TESTUSERONE';
        Boolean isCombinedPartIAndPartII = false; 
        Boolean isChinaExamSite = false;
        
        Exam__c exam = [Select Id,(Select Id,Name,Exam_Part__c,Site__c,Site__r.Name,Exam__c,Exam__r.Administration_Time_of_Day__c,Site__r.AM_Exam_Capacity_Available__c,Site__r.PM_Exam_Capacity_Available__c,Site__r.Is_OSTA_Information_Required__c from Exam_Events__r where Exam_Part__c != null AND Site__r.Is_OSTA_Information_Required__c = true),(Select Id,Exam__c,Exam_Administration__c from Exam_Parts__r) from Exam__c where Exam__c Like :('%'+examType+'%') Limit 1];
        List<PricebookEntry> pbeList = [Select Id,Pricebook2Id,Product2Id,Product2.Name,UnitPrice,Product_ID__c,ProductCode,IsActive from PricebookEntry where Product2.Family = 'Exams'];
        
        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationFormData(examType,null);
        ExamRegistrationForm.ViewModel vm = (ExamRegistrationForm.ViewModel)res.data;
        
        Lead lead = new Lead();
        
        lead.FirstName = username;
        lead.LastName = username;
        lead.Email = username + '@test.com';
        
        Response.Detail upsertLeadRes = RegistrationFormLeadRemoter.upsertLead(JSON.serialize(lead), 'test-form-key');

        System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('Lead'+upsertLeadRes.data);
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
        createdLead.Shipping_Address_Same_as_Billing_Address__c = true;
        
        ExamRegistrationForm.RegistrationRequest registrationRequest = new ExamRegistrationForm.RegistrationRequest();
        
        registrationRequest.token = vm.token;
        registrationRequest.lead = createdLead;
        registrationRequest.registrationType = examType;
        ExamRegistrationForm.Item  item = new ExamRegistrationForm.Item(pbeList[0]);
        registrationRequest.products = new Map<String, ExamRegistrationForm.Item>{'FRMS1' => item};
        
        ExamSelectionOptions.Site esoSite = new ExamSelectionOptions.Site();
        esoSite.id = exam.Exam_Events__r[0].Id;
        esoSite.label = 'Exam Site';
        esoSite.examSite = exam.Exam_Events__r[0];
        esoSite.site = exam.Exam_Events__r[0].Site__r;
        
        ExamSelectionOptions.ExamPart part = new ExamSelectionOptions.ExamPart();
        part.id = exam.Exam_Parts__r[0].Id;
        part.label = 'Exam Part';
        part.examPart = exam.Exam_Parts__r[0];
        
        ExamSelectionOptions.ExamPricebookEntry pbe = new ExamSelectionOptions.ExamPricebookEntry();
        pbe.id = pbeList[0].Id;
        pbe.exam = exam;
        pbe.examAdminID = exam.Exam_Parts__r[0].Exam_Administration__c;
        pbe.pricebookEntry = pbeList[0];
        pbe.rateType = 'Member';
        
        ExamSelectionOptions.Exam esoExam = new ExamSelectionOptions.Exam();
        esoExam.id = exam.Id;
        esoExam.label = 'FRM';
        esoExam.exam = exam;
        esoExam.examParts = new List<ExamSelectionOptions.ExamPart>{part};
        esoExam.examPricebookEntry = pbe;
        
        ExamRegistrationForm.Selection selection = new ExamRegistrationForm.Selection();
        selection.site = esoSite;
        selection.examPart = part;
        selection.exam = esoExam;
        
        registrationRequest.selections = new List<ExamRegistrationForm.Selection>{selection};
        
        String registrationRequestJSON = JSON.serialize(registrationRequest);
        
        test.startTest();
        FrmRegistrationForm erf = new FrmRegistrationForm();
        erf.addExamRegistrations(new List<ExamSelectionOptions.Exam>{esoExam});
        Response.Detail responseDetailObject = ExamRegistrationFormRemoter.createExamRegistrationOrder(examType, registrationRequestJSON);
        test.stopTest();
        
     }
    @isTest
    public static void testSCRexamRegistrationForm(){
        String examType = 'SCR';
        String paymentMethod = 'Check';
        String username = 'TESTUSERONE';
        Boolean isCombinedPartIAndPartII = false; 
        Boolean isChinaExamSite = false;
        
        Exam__c exam = [Select Id,(Select Id,Name,Exam_Part__c,Site__c,Site__r.Name,Exam__c,Exam__r.Administration_Time_of_Day__c,Site__r.AM_Exam_Capacity_Available__c,Site__r.PM_Exam_Capacity_Available__c,Site__r.Is_OSTA_Information_Required__c from Exam_Events__r where Exam_Part__c != null AND Site__r.Is_OSTA_Information_Required__c = true),(Select Id,Exam__c,Exam_Administration__c from Exam_Parts__r) from Exam__c where Exam__c Like :('%'+examType+'%') Limit 1];
        List<PricebookEntry> pbeList = [Select Id,Pricebook2Id,Product2Id,Product2.Name,UnitPrice,Product_ID__c,ProductCode,IsActive from PricebookEntry where Product2.Family = 'Exams'];
        
        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationFormData(examType,null);
        ExamRegistrationForm.ViewModel vm = (ExamRegistrationForm.ViewModel)res.data;
        
        Lead lead = new Lead();
        
        lead.FirstName = username;
        lead.LastName = username;
        lead.Email = username + '@test.com';
        
        Response.Detail upsertLeadRes = RegistrationFormLeadRemoter.upsertLead(JSON.serialize(lead), 'test-form-key');

        System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('Lead'+upsertLeadRes.data);
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
        createdLead.Shipping_Address_Same_as_Billing_Address__c = true;
        
        ExamRegistrationForm.RegistrationRequest registrationRequest = new ExamRegistrationForm.RegistrationRequest();
        
        registrationRequest.token = vm.token;
        registrationRequest.lead = createdLead;
        registrationRequest.registrationType = examType;
        ExamRegistrationForm.Item  item = new ExamRegistrationForm.Item(pbeList[0]);
        registrationRequest.products = new Map<String, ExamRegistrationForm.Item>{'SCR' => item};
        
        ExamSelectionOptions.ExamPart part = new ExamSelectionOptions.ExamPart();
        part.id = exam.Exam_Parts__r[0].Id;
        part.label = 'Exam Part';
        part.examPart = exam.Exam_Parts__r[0];
        
        ExamSelectionOptions.ExamPricebookEntry pbe = new ExamSelectionOptions.ExamPricebookEntry();
        pbe.id = pbeList[0].Id;
        pbe.exam = exam;
        pbe.examAdminID = exam.Exam_Parts__r[0].Exam_Administration__c;
        pbe.pricebookEntry = pbeList[0];
        pbe.rateType = 'Member';
        
        ExamSelectionOptions.Exam esoExam = new ExamSelectionOptions.Exam();
        esoExam.id = exam.Id;
        esoExam.label = 'SCR';
        esoExam.exam = exam;
        esoExam.examParts = new List<ExamSelectionOptions.ExamPart>{part};
        esoExam.examPricebookEntry = pbe;
        
        test.startTest();
        ScrExamRegistrationForm erf = new ScrExamRegistrationForm();
        erf.getExamSelectionOptions(new Set<String>{'SCR'});
        erf.getFeesMapAuthenticated(new List<ExamSelectionOptions.Exam>{esoExam});
        test.stopTest();
        
     }
    
    @isTest
    public static void testRemoterExceptions(){

        Test.startTest();
        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationCompletedData('Test');
        Response.Detail res1 = ExamRegistrationFormRemoter.fetchExamRegistrationFormData('Test',null);
        ExamRegistrationFormRemoter.fetchExamRegistrationInfoData('Test', null);
        Response.Detail response = ExamRegistrationFormRemoter.updateExamRegistrationInfoData('test', 'test');
        Response.Detail response2 = ExamRegistrationFormRemoter.payExamRegistrationOrder('FRM','test');
        Response.Detail response3 = ExamRegistrationFormRemoter.createExamRegistrationOrder('FRM','test');
        Test.stopTest();
        
    }
    @isTest
    public static void testERPRegistrationFormMethods(){
		String examType = 'ERP';
        String paymentMethod = 'Check';
        String username = 'TESTUSERONE';
        Boolean isCombinedPartIAndPartII = false; 
        Boolean isChinaExamSite = false;
        User user = ExamRegistrationTestDataFactory.createAffiliateContact();
        
        Scholarship_Application__c scholarshipApplication = new Scholarship_Application__c();
        scholarshipApplication.Applicant__c = user.ContactId;
        scholarshipApplication.Exam_Group__c = [SELECT Id FROM Exam_Group__c LIMIT 1].Id;
        scholarshipApplication.Status__c = 'Approved';
        scholarshipApplication.Exam_Type__c = 'ERP';
        
        INSERT scholarshipApplication;
        
        Exam__c exam = [Select Id,Exam__c,(Select Id,Name,Exam_Part__c,Site__c,Site__r.Name,Exam__c,Exam__r.Administration_Time_of_Day__c,Site__r.AM_Exam_Capacity_Available__c,Site__r.PM_Exam_Capacity_Available__c from Exam_Events__r where Exam_Part__c != null),(Select Id,Exam__c,Exam_Administration__c from Exam_Parts__r) from Exam__c where Exam__c Like :('%'+examType+'%') Limit 1];
        List<PricebookEntry> pbeList = [Select Id,Pricebook2Id,Product2Id,Product2.Name,UnitPrice,Product_ID__c,ProductCode,IsActive from PricebookEntry where Product2.Family = 'Exams'];
        
        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationFormData(examType,null);
        ExamRegistrationForm.ViewModel vm = (ExamRegistrationForm.ViewModel)res.data;
        
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
        
        ExamRegistrationForm.RegistrationRequest registrationRequest = new ExamRegistrationForm.RegistrationRequest();
        
        registrationRequest.token = vm.token;
        registrationRequest.lead = createdLead;
        registrationRequest.registrationType = examType;
        registrationRequest.products = new Map<String, ExamRegistrationForm.Item>();
        
        ExamSelectionOptions.Site esoSite = new ExamSelectionOptions.Site();
        esoSite.id = exam.Exam_Events__r[0].Id;
        esoSite.label = 'Exam Site';
        esoSite.examSite = exam.Exam_Events__r[0];
        
        ExamSelectionOptions.ExamPart part = new ExamSelectionOptions.ExamPart();
        part.id = exam.Exam_Parts__r[0].Id;
        part.label = 'Exam Part';
        part.examPart = exam.Exam_Parts__r[0];
        
        ExamSelectionOptions.ExamPricebookEntry pbe = new ExamSelectionOptions.ExamPricebookEntry();
        pbe.id = pbeList[0].Id;
        pbe.exam = exam;
        pbe.examAdminID = exam.Exam_Parts__r[0].Exam_Administration__c;
        pbe.pricebookEntry = pbeList[0];
        pbe.rateType = 'Member';
        
        ExamSelectionOptions.Exam esoExam = new ExamSelectionOptions.Exam();
        esoExam.id = exam.Id;
        esoExam.label = 'ERP';
        esoExam.exam = exam;
        esoExam.examParts = new List<ExamSelectionOptions.ExamPart>{part};
        esoExam.examPricebookEntry = pbe;
        
        ExamRegistrationForm.Selection selection = new ExamRegistrationForm.Selection();
        selection.site = esoSite;
        selection.examPart = part;
        selection.exam = esoExam;
        
        registrationRequest.selections = new List<ExamRegistrationForm.Selection>{selection};
        Test.startTest();
        system.runAs(user){
            ErpRegistrationForm erf = new ErpRegistrationForm();
            erf.getFeesMapAuthenticated(new List<ExamSelectionOptions.Exam>{esoExam});
            erf.getExamSelectionOptions(new Set<String>{'ERP'});
            erf.getFeesMap();
            erf.getExamPartNumbers(new List<ExamSelectionOptions.Exam>{esoExam});
            erf.getExamSelectionOptions();
            erf.getStudyMaterials(new Set<integer>{1,2});
        }
        Test.stopTest();
        
    }
        
}