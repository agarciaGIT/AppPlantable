@isTest
private class EventRegistrationTest {
    
    @testSetup
    private static void testSetup(){
       
        Form__c form = new Form__c();
        
        form.Name = 'TESTFORM';
        form.Form_Name__c = 'form-test';
        form.Status__c = 'Active';
        
        INSERT form;
        
        Account account = new Account();    
        account.Name = 'TEST';
        INSERT account;
        
        Default_Record_References__c drf = new Default_Record_References__c();
        drf.Name = 'UNMATCHED-BUSINESS-ACCOUNT';
        drf.Record_Reference_ID__c = account.Id;
        INSERT drf;
        
        Id eventRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Non-Convention' AND sObjectType = 'Event__c' LIMIT 1].Id;
        Id conventionRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Convention' AND sObjectType = 'Event__c' LIMIT 1].Id;
        
        // Insert Convention
        Event__c convention = new Event__c();
        
        convention.Name = 'TEST CONVENTION';
        convention.RecordTypeId = conventionRecordTypeId;
        convention.Last_Date_For_Registration__c = Date.today().addDays(30);
        
        INSERT convention;
        
        Event_Rate__c conventionRate = new Event_Rate__c();
        
        conventionRate.Type__c = 'Early';
        conventionRate.Event__c = convention.Id;
        conventionRate.Start_Date__c = Date.today();
        conventionRate.End_Date__c = Date.today().addDays(30);
        
        INSERT conventionRate;
        
        // Insert Event
        Event__c event = new Event__c();
        
        event.Name = 'TEST EVENT';
        event.RecordTypeId = eventRecordTypeId;
        event.Last_Date_For_Registration__c = Date.today().addDays(30);
        event.Parent_Event__c = convention.Id;
        
        INSERT event;
        
        Event_Rate__c eventRate = new Event_Rate__c();
        
        eventRate.Type__c = 'Early';
        eventRate.Event__c = event.Id;
        eventRate.Start_Date__c = Date.today();
        eventRate.End_Date__c = Date.today().addDays(30);
        
        INSERT eventRate;
        
        // Insert Invite Only
        Event__c inviteOnly = new Event__c();
        
        inviteOnly.Name = 'TEST EVENT';
        inviteOnly.RecordTypeId = eventRecordTypeId;
        inviteOnly.Last_Date_For_Registration__c = Date.today().addDays(30);
        inviteOnly.Invite_Only__c = TRUE;
        
        INSERT inviteOnly;
        
        Event_Rate__c inviteOnlyRate = new Event_Rate__c();
        
        inviteOnlyRate.Type__c = 'Early';
        inviteOnlyRate.Event__c = inviteOnly.Id;
        inviteOnlyRate.Start_Date__c = Date.today();
        inviteOnlyRate.End_Date__c = Date.today().addDays(30);
        
        INSERT inviteOnlyRate;
        
        // Product
        Product2 product = new Product2(Company__c = 'GARP', Name = 'PRODUCTCODE', ProductCode = 'PRODUCTCODE', GL_Code__c = '4999', Family = 'Events', IsActive = TRUE);
        
        INSERT product;
        
        // Insert Event Discount
        Event_Discount__c ed = new Event_Discount__c();
        
        ed.Event__c = event.Id;
        ed.Discount_Code__c = 'DISCOUNTCODE';
        ed.Discount_To_Fixed_Price__c = 0;
        ed.Start_Date__c = Date.today();
        ed.Registration_Type__c = 'Attendee';
        
        INSERT ed;
        
        // Insert Product Discount
        Product_Discount__c pd = new Product_Discount__c();
        
        pd.Event_Discount__c = ed.Id;
        pd.Product__c = product.Id;
        
        INSERT pd;
        
    }
    
    @isTest
    private static void getCurrentConventionInformation(){
        
        EventRegistration.getCurrentConventionInformation();
        
    }
    
    @isTest
    private static void getAllEventInformation(){
        
        Id eventId = [SELECT Id FROM Event__c WHERE Invite_Only__c = FALSE AND RecordType.Name = 'Non-Convention' LIMIT 1].Id;
        
        EventRegistration.getAllEventInformation(eventId);
        
    }
    
    @isTest
    private static void eventInformation(){
        
        Id eventId = [SELECT Id FROM Event__c WHERE RecordType.Name = 'Convention' LIMIT 1].Id;
        
        EventRegistration.eventInformation(eventId);
        
    }
    
    @isTest
    private static void createInviteOnlyEventRegistrationPublic(){

        Lead lead = new Lead();
        
        lead.FirstName = 'TEST';
        lead.LastName = 'LASTNAME';
        lead.Email = 'test@test.com';
        lead.Company = 'TEST';
        
        INSERT lead;
        
        Id formId = [SELECT Id FROM Form__c WHERE Form_Name__c = 'form-test' LIMIT 1].Id;
        
        Form_Data__c formData = new Form_Data__c();
        
        formData.Form__c = formId;
        formData.Lead__c = lead.Id;
        
        INSERT formData;
        
        Id eventId = [SELECT Id FROM Event__c WHERE Invite_Only__c = TRUE LIMIT 1].Id;
        
		TempAccount tempAccount = new TempAccount();
        
        tempAccount.id = lead.Id;
        tempAccount.eventId = eventId;
        tempAccount.Company = 'TEST';
        tempAccount.FirstName = 'FNAME';
        tempAccount.LastName = 'LNAME';
        tempAccount.Email = 'test.test@test.com';
        tempAccount.Company = 'testco';
        tempAccount.formName = 'form-test';
        
        Test.startTest();
        EventRegistration.createInviteOnlyEventRegistration(tempAccount);
        Test.stopTest();
        
        List<Form_Data__c> formDataRecords = [SELECT Id, Status__c FROM Form_Data__c];
        
        System.assertEquals('Completed', formDataRecords[0].Status__c);

        EventRegistration.rsvpInviteOnlyDecline(eventId, 'test.test@test.com');
        
    }
    
    @isTest
    private static void createInviteOnlyEventRegistrationPrivate(){
        
        Contact contact = new Contact();
        
        contact.FirstName = 'TEST';
        contact.LastName = 'LASTNAME';
        contact.Email = 'test@test.com';
        
        INSERT contact;
        
        Id formId = [SELECT Id FROM Form__c WHERE Form_Name__c = 'form-test' LIMIT 1].Id;
        
        Form_Data__c formData = new Form_Data__c();
        
        formData.Form__c = formId;
        formData.Contact__c = contact.Id;
        
        INSERT formData;
        
        Id eventId = [SELECT Id FROM Event__c WHERE Invite_Only__c = TRUE LIMIT 1].Id;
        
		TempAccount tempAccount = new TempAccount();
        
        tempAccount.id = contact.Id;
        tempAccount.eventId = eventId;
        tempAccount.Company = 'TEST';
        tempAccount.FirstName = 'FNAME';
        tempAccount.LastName = 'LNAME';
        tempAccount.Email = 'test.test@test.com';
        tempAccount.Company = 'testco';
        tempAccount.formName = 'form-test';
                
        Test.startTest();
        EventRegistration.createInviteOnlyEventRegistration(tempAccount);
        Test.stopTest();
        
        List<Form_Data__c> formDataRecords = [SELECT Id, Status__c FROM Form_Data__c WHERE Contact__c = :contact.Id];
        
        System.assertEquals('Completed', formDataRecords[0].Status__c);
        
    }
    
    @isTest
    private static void createContributorEventRegistrationPublic(){
        
        Lead lead = new Lead();
        
        lead.FirstName = 'TEST';
        lead.LastName = 'LASTNAME';
        lead.Email = 'test@test.com';
        lead.Company = 'TEST';
        
        INSERT lead;
        
        Id formId = [SELECT Id FROM Form__c WHERE Form_Name__c = 'form-test' LIMIT 1].Id;
        
        Form_Data__c formData = new Form_Data__c();
        
        formData.Form__c = formId;
        formData.Lead__c = lead.Id;
        
        INSERT formData;
        
        Id eventId = [SELECT Id FROM Event__c WHERE Invite_Only__c = TRUE LIMIT 1].Id;
        
		TempAccount tempAccount = new TempAccount();
        
        tempAccount.id = lead.Id;
        tempAccount.eventId = eventId;
        tempAccount.Company = 'TEST';
        tempAccount.FirstName = 'FNAME';
        tempAccount.LastName = 'LNAME';
        tempAccount.Email = 'test.test@test.com';
        tempAccount.Company = 'testco';
        tempAccount.formName = 'form-test';
        
        Test.startTest();
        EventRegistration.createContributorEventRegistration(tempAccount);
        Test.stopTest();
        
        List<Form_Data__c> formDataRecords = [SELECT Id, Status__c FROM Form_Data__c];
        
        System.assertEquals('Completed', formDataRecords[0].Status__c);
        
    }
    
    @isTest
    private static void createContributorEventRegistrationPrivate(){
        
        Contact contact = new Contact();
        
        contact.FirstName = 'TEST';
        contact.LastName = 'LASTNAME';
        contact.Email = 'test@test.com';
        
        INSERT contact;
        
        Id formId = [SELECT Id FROM Form__c WHERE Form_Name__c = 'form-test' LIMIT 1].Id;
        
        Form_Data__c formData = new Form_Data__c();
        
        formData.Form__c = formId;
        formData.Contact__c = contact.Id;
        
        INSERT formData;
        
        Id eventId = [SELECT Id FROM Event__c WHERE Invite_Only__c = TRUE LIMIT 1].Id;
        
		TempAccount tempAccount = new TempAccount();
        
        tempAccount.id = contact.Id;
        tempAccount.eventId = eventId;
        tempAccount.Company = 'TEST';
        tempAccount.FirstName = 'FNAME';
        tempAccount.LastName = 'LNAME';
        tempAccount.Email = 'test.test@test.com';
        tempAccount.Company = 'testco';
        tempAccount.formName = 'form-test';
        
        Test.startTest();
        EventRegistration.createContributorEventRegistration(tempAccount);
        Test.stopTest();
        
        List<Form_Data__c> formDataRecords = [SELECT Id, Status__c FROM Form_Data__c WHERE Contact__c = :contact.Id];
        
        System.assertEquals('Completed', formDataRecords[0].Status__c);
        
    }
    
    @isTest
    private static void confirmDiscountCode(){
        
        Id eventId = [SELECT Id FROM Event__c WHERE Invite_Only__c = FALSE AND RecordType.Name = 'Non-Convention' LIMIT 1].Id;
        
        EventRegistration.confirmDiscountCode('DISCOUNTCODE~PRODUCTCODE', eventId);
        
    }
    
}