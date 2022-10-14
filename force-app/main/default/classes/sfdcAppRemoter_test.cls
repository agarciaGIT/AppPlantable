@isTest
public class sfdcAppRemoter_test {
    
    static Account acc ;
    static Opportunity opp; 
    static ChargentSFA__Transaction__c chargentTrans;
    static TempAccount tempaccount;
    static Contact contact;
    static Exam_Attempt__c attempt;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contract contract;
    static Lead lead;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Candidate_Requirement__c reqt;
    static Chapter_Meeting__c chapMeeting ;
    static Chapter_Meeting_Registration__c meetingReg;
    static Chapter_Meeting_Speaker__c meetingSpeaker;
    static sfdcAppRemoter.fieldInfo fieldInfo;
    static User user;
    static User user1;
    static Profile profile;
    static Contact contact1;
    static Folder__c folder;
    static Content_Folders__c content_folder;
    static content__c content;
    static content__c content1;
    static Board_Election__c election;
    static EmailTemplate template;
    //static Proctor_Registration__c proctor;
    //static Proctor_Registration__c proctor2;
    static CPE_Activity_Type__c  type;
    static CPE_Activity__c activity;
    static Chapter_Member__c member;
    static Chapter__c chapter;
    static Product2 prod;
    static Product2 prod1;
    static Product2 prod2;
    static Product2 prod3;
    static Registration.wrapperCreateOrder wco;
    
    static void testDataNew() {
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        //insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        insert new UpdateIds__c(Name= 'ICBRR', Record_Id__c = 'a1e40000006sqih');   
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        //chargentTrans = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id, ChargentSFA__Amount__c=100.00);
        //insert chargentTrans;
        
        
        contact = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        contact1 = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,lastname = 'Testdhaskd',AccountId = acc.id,email='daghtest@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),Name_As_it_Appears_On_ID__c = 'testtest' ,ID_Number__c = 'dasf123l',ID_Type__c = 'Passport');
        insert contact1;
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true;
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp;
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
        
        profile = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
        
        user = [select Id, Email from User where contactId = :contact.Id];
        //user = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        //insert user;
        
        //System.assert(false, 'BOOM!' + user);
        
        //user1 = [select Id, Email from User where contactId = :contact1.Id];
        user1 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact1.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        insert user1;
        
        //template = new EmailTemplate (developerName = 'test', TemplateType= 'Text', Name = 'test');
        //insert template;
        /*
        proctor = new Proctor_Registration__c(
            Name = 'pr', 
            Proctor_First_Name__c = 'pfn', 
            Proctor_Last_Name__c = 'pln', 
            Proctor_Email__c = 'pem@gmail.com', 
            Proctor_Type__c = 'GARP', 
            contact__c = contact.id,
            test_site__c = site.id,
            Exam_Group__c  = objExamGrp.id,
            Selected__c = false,
            Proctor_Selected_Date__c = null            
        );
        insert proctor;
        
        proctor2 = new Proctor_Registration__c(
            Name = 'pr3', 
            Proctor_First_Name__c = 'pf3n', 
            Proctor_Last_Name__c = 'pln3', 
            Proctor_Email__c = 'pe3m@gmail.com', 
            Proctor_Type__c = 'GARP', 
            test_site__c = site.id,
            Exam_Group__c  = objExamGrp.id,
            Selected__c = false,
            Proctor_Selected_Date__c = null            
        );
        insert proctor2;
        */
        prod = new Product2(FRM_Study_Center__c = true,Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        prod1 = new Product2(ERP_Study_Center__c = true,Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod2; 
        
        prod3 = new Product2(Name = 'For Testing RestoreAMPFree',productCode = 'PRFEE',GL_Code__c = '6110',Family = 'Hardware',isActive = true);
        insert prod3;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry restoreAmpFreeEntry1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert restoreAmpFreeEntry1;
        
        PricebookEntry restoreAmpFreeEntry2 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert restoreAmpFreeEntry2;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice; 
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = restoreAmpFreeEntry1.id);
        
        content1 = new Content__c();
        content1.Content_Type__c = 'Doc' ;
        content1.Status__c = 'Active' ;
        insert content1;
        
        content = new Content__c();
        content.Content_Type__c = 'News Feed' ;
        content.Status__c = 'Active' ;
        content.Is_On_Demand__c = true;
        content.Raw_HTML__c = 'test';
        content.Is_advertisement__c = true;
        content.Content_Other_Viewed__c = content1.id + '!1';
        content.Featured_Order__c = '1';
        content.Category__c = 'Technology';
        content.Subcategory__c = 'Cyber Security';
        content.Topic__c = 'topic';
        content.Is_advertisement__c = false;
        content.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Content__c','Article');
        insert content;
        
        folder = new Folder__c();
        folder.Name = 'Test';
        insert folder;
        
        content_folder = new Content_Folders__c();
        content_folder.Content__c = content.Id;
        content_folder.Folder__c = folder.Id;
        
        tempAccount = new tempAccount();
        tempAccount.id = contact.id; 
        tempAccount.eppHelp = true;
        tempAccount.infoExchange = true;
        tempAccount.contactId = contact.id;
        tempAccount.FirstName = 'test';
        tempAccount.LastName = 'test';
        tempAccount.Email = 'test@test.com';
        tempAccount.Membership_Type = 'AFREE';
        tempAccount.garpMembership_Type = 'AFREE';
        tempAccount.ACCA = false;
        tempAccount.CA = false;
        tempAccount.CFA = false;
        tempAccount.CMA = false;
        tempAccount.CPA = false;
        tempAccount.InSchool = false;
        tempAccount.OtherDesignation = false;
        tempAccount.PMP = false;
        tempAccount.autoRenew = false;
        tempAccount.erpSwitch = false;
        tempAccount.frmSwitch = false;
        tempAccount.graduationDate = 'Invalid Date';
        tempAccount.hasBooks = false;
        tempAccount.isErpChecked = false;
        tempAccount.isFbrChecked = false;
        tempAccount.isFrmChecked = false;
        tempAccount.isIcbrChecked = false;
        tempAccount.isStudentChecked = false;
        tempAccount.isFbraChecked = false;
        tempAccount.productcode = new List<String>(); 
        TempAccount.productDefinition productDefition = new TempAccount.productDefinition();
        productDefition.GLCode = '4999';
        productDefition.ProductCode = 'AFREE';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ productDefition };   
            tempAccount.siteName = 'undefined';
        tempAccount.isWorking = false;
        tempAccount.jobTarget = false;       
        tempAccount.referral = 'Bloomberg Terminal'; 
        tempAccount.sameShip = 'true';
        tempAccount.switchFeeEnabled = false;
        tempAccount.ShippingOptionsString = 'test:12,test:12,test:12';
        tempAccount.BillingStreetTwo = 'test';
        tempAccount.BillingStreetThree = 'test';
        tempAccount.MailingStreetTwo = 'test';
        tempAccount.MailingStreetThree = 'test';
        tempAccount.isFrmChecked = true;
        tempAccount.OtherDesignation = true;
        tempAccount.isStudentChecked = true;
        tempAccount.taxPrice = 123;
        tempAccount.isIcbrChecked = true;
        tempAccount.isFbraChecked = true;
        tempAccount.siteName = 'test';
        
    }
    
    static void testDataForAll() {
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        
        contact = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        contact1 = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,lastname = 'Testdhaskd',AccountId = acc.id,email='daghtest@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),Name_As_it_Appears_On_ID__c = 'testtest' ,ID_Number__c = 'dasf123l',ID_Type__c = 'Passport');
        insert contact1;
        
        profile = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
        
        user = [select Id, Email from User where contactId = :contact.Id];
        
        user1 = new User(
            Alias = 'newUser', 
            Email='newuser@testorg.com', 
            contactId = contact1.id,
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser@testorg.com'
        );
        
        insert user1;
        
    } 
    
    static void testData(){ 
        fieldInfo = new sfdcAppRemoter.fieldInfo();
        fieldInfo.name = 'firstname';
        fieldInfo.label = 'first name'; 
        fieldInfo.type = 'text'; 
        fieldInfo.maxLength = 20;
        fieldInfo.description = 'test';
        prod = new Product2(FRM_Exam__c=True, ERP_Exam__c=True, FRM_1_Book__c=True, FRM_2_Book__c=True, ERP_Study_Center__c=True, ICBRR_Study_Center__c=True, FBR_Study_Center__c = True, FRM_Study_Center__c = true,Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        prod1 = new Product2(FRM_Exam__c=True, ERP_Exam__c=True, FRM_1_Book__c=True, FRM_2_Book__c=True, ICBRR_Study_Center__c=True, FBR_Study_Center__c = True, ERP_Study_Center__c = true,Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod2; 
        
        prod3 = new Product2(Name = 'For Testing RestoreAMPFree',productCode = 'PRFEE',GL_Code__c = '6110',Family = 'Hardware',isActive = true);
        insert prod3;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry restoreAmpFreeEntry1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert restoreAmpFreeEntry1;
        
        PricebookEntry restoreAmpFreeEntry2 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert restoreAmpFreeEntry2;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice; 
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        insert new UpdateIds__c(Name= 'ICBRR', Record_Id__c = 'a1e40000006sqih');   
        //a1e40000006sqih  a0Cf0000004O778
        acc = new Account(
            Name = 'TestAccount',
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account','Individual'),
            CurrencyIsoCode  = 'USD'
        );
        
        insert acc;
        
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        
        wco = new Registration.wrapperCreateOrder();
        wco.opportunityId = opp.Id;
        
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('FRM Program').getRecordTypeId();
        contract = new Contract(Opportunity__c = opp.id,AccountId = acc.id,recordTypeId = rtId);
        insert contract;
        
        Contract  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12     ,StartDate = opp.CloseDate        );
        insert contract;
        
        contract.Status = 'Activated';
        update contract;
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true;
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp;
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        contact = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        user = [select Id, Email from User where contactId = :contact.Id];
        
        //user = [select Id, Email from User where contactId = :contact.Id];
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
        
        lead = new Lead(lastname = 'test',firstName = 'test' ,status = 'Open',email= 'test@test.com',company = acc.id);
        insert lead;
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        contact.CPE_Current_Program_Requirement__c = reqt.Id;
        update contact;
        
        chapMeeting = new Chapter_Meeting__c(Status__c='Active');
        insert chapMeeting;
        
        meetingReg = new Chapter_Meeting_Registration__c();
        meetingReg.Chapter_Meeting__c = chapMeeting.id;
        meetingReg.contact__c = contact.id;
        insert meetingReg;
        
        meetingSpeaker = new Chapter_Meeting_Speaker__c(Name='Bob',Chapter_Meeting__c=chapMeeting.Id);
        insert meetingSpeaker;
        
        tempAccount = new tempAccount();
        tempAccount.id = contact.id; 
        tempAccount.eppHelp = true;
        tempAccount.infoExchange = true;
        tempAccount.contactId = contact.id;
        tempAccount.FirstName = 'test';
        tempAccount.LastName = 'test';
        tempAccount.Email = 'test@test.com';
        tempAccount.Membership_Type = 'AFREE';
        tempAccount.garpMembership_Type = 'AFREE';
        tempAccount.ACCA = false;
        tempAccount.CA = false;
        tempAccount.CFA = false;
        tempAccount.CMA = false;
        tempAccount.CPA = false;
        tempAccount.InSchool = false;
        tempAccount.OtherDesignation = false;
        tempAccount.PMP = false;
        tempAccount.autoRenew = false;
        tempAccount.erpSwitch = false;
        tempAccount.frmSwitch = false;
        tempAccount.graduationDate = 'Invalid Date';
        tempAccount.hasBooks = false;
        tempAccount.isErpChecked = false;
        tempAccount.isFbrChecked = false;
        tempAccount.isFbraChecked = false;
        tempAccount.isFrmChecked = false;
        tempAccount.isIcbrChecked = false;
        tempAccount.isStudentChecked = false;
        tempAccount.productcode = new List<String>(); 
        TempAccount.productDefinition productDefition = new TempAccount.productDefinition();
        productDefition.GLCode = '4999';
        productDefition.ProductCode = 'AFREE';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ productDefition };   
            tempAccount.siteName = 'undefined';
        tempAccount.isWorking = false;
        tempAccount.jobTarget = false;       
        tempAccount.referral = 'Bloomberg Terminal'; 
        tempAccount.sameShip = 'true';
        tempAccount.switchFeeEnabled = false;
        tempAccount.ShippingOptionsString = 'test:12,test:12,test:12';
        tempAccount.BillingStreetTwo = 'test';
        tempAccount.BillingStreetThree = 'test';
        tempAccount.MailingStreetTwo = 'test';
        tempAccount.MailingStreetThree = 'test';
        tempAccount.isFrmChecked = true;
        tempAccount.OtherDesignation = true;
        tempAccount.isStudentChecked = true;
        tempAccount.taxPrice = 123;
        tempAccount.isIcbrChecked = true;
        tempAccount.siteName = 'test';
        
        tempAccount.chapterMeetingId = chapMeeting.Id;
        
        contact1 = new Contact(
            KPI_ERP_Certified__c = true,
            KPI_FRM_Certified__c = true,
            GARP_Directory_Opt_In__c = true,
            recordtypeId = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship'),
            firstname = 'FirstNameTest',
            lastname = 'Testdhaskd',
            AccountId = acc.id,
            email='daghtest@test.com',
            KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),
            Name_As_it_Appears_On_ID__c = 'testtest',
            ID_Number__c = 'dasf123l',
            ID_Type__c = 'Passport'
        );
        
        INSERT contact1;
        
        profile = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
        
        user1 = new User(
            Alias = 'newUser', 
            Email='newuser@testorg.com', 
            contactId = contact1.id,
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser@testorg.com'
        );
        
        INSERT user1;
        
        content = new Content__c();
        content.Content_Type__c = 'News Feed' ;
        content.Status__c = 'Draft' ;
        content.Is_On_Demand__c = true;
        content.Raw_HTML__c = 'test';
        insert content;
        
        folder = new Folder__c();
        folder.Name = 'Test';
        insert folder;
        
        content_folder = new Content_Folders__c();
        content_folder.Content__c = content.Id;
        content_folder.Folder__c = folder.Id;
        
        
        election = new Board_Election__c(End_Date__c = system.today() + 12,Start_Date__c = system.today() + 5 );
        insert election;
        
        
        //template = new EmailTemplate (developerName = 'test', TemplateType= 'Text', Name = 'test');
        //insert template;
        
        //proctor = new Proctor_Registration__c(Name = 'pr', Proctor_First_Name__c = 'pfn', Proctor_Last_Name__c = 'pln', Proctor_Email__c = 'pem@gmail.com', Proctor_Type__c = 'GARP', contact__c = contact.id,test_site__c = site.id,Exam_Group__c  = objExamGrp.id);
        //insert proctor;
        
        type = new CPE_Activity_Type__c (name = 'test');
        insert type;
        
        activity = new CPE_Activity__c(Description__c='desc',Organization__c='Org',Account__c=acc.Id,Area_of_Study__c='Area',Publication__c='Pub',URL__c='url',Title__c = 'test',Activity_Type_Description__c = 'test',Provider__c = 'test',CPE_Activity_Type__c  = type.id,Status__c = 'Active',Credit__c=1.0);
        insert activity;
        
        chapter = new Chapter__c(LEGACY_Name__c = 'tre',LEGACY_PK_Chapter__c='terw',Location__c = 'e4wrew',Region__c='Americas',status__c='Active',type__c = 'Professional');
        insert chapter;
        
        member = new Chapter_Member__c(Director__c = true,IsPrimary__c = true,Contact__c = contact.id, Chapter__c=chapter.Id);
        insert member;
        
    }
    
    static testMethod void unitTest_14(){
        
        testDataNew();
        test.startTest();
        system.runAs(user){
            
            
            List<sfdcAppRemoter.contentData> lstContData = sfdcAppRemoter.getContentDocs(content.Id);
            
            
        }
        test.stopTest();
    }
    
    
    static testMethod void unitTest_13(){
        
        testDataNew();
        test.startTest();
        system.runAs(user){
            List<String> contentTypes = new List<String>();
            contentTypes.add('Doc');
            List<String> topics = new List<String>();
            topics.add('topic');
            List<String> recordTypes = new List<String>();
            recordTypes.add(String.valueOf(RecordTypeHelper.GetRecordTypeId('Content__c','Article')));
            
            
            
        }
        test.stopTest();
    }
    
    static testMethod void unitTest_12(){
        
        testDataNew();
        test.startTest();
        system.runAs(user){
            
            ID attId = sfdcAppRemoter.uploadAttachment(NULL, EncodingUtil.base64Encode(Blob.valueOf('---text---')), 'file.txt');
            Id addCId = sfdcAppRemoter.addContactAttachment(Contact.Id, attId, EncodingUtil.base64Encode(Blob.valueOf('---text---')), 'file.txt');
            Contact communititesContact = sfdcAppRemoter.getCommunitiesConsent();
            Contact communititesContactPresist = sfdcAppRemoter.persistCommunitiesConsent();
            
            List<Content__c> lst = sfdcAppRemoter.getJobs();
            
            Boolean changeExamSiteResult = sfdcAppRemoter.changeExamSite(attempt.Id, exmSite.Id);
            
            Boolean bolRet = sfdcAppRemoter.deleteOrder(opp.Id);
            
            wco = sfdcAppRemoter.createOrderForPortalUsers(tempAccount);
            
            List<User> lstUser = sfdcAppRemoter.verifyAuth();
            
            bolRet = sfdcAppRemoter.unsubscribe(Contact.Id);
            
            bolRet = sfdcAppRemoter.setLastLoginDate();
            
            //bolRet = sfdcAppRemoter.sendDirectoryMessage(template.Name, 'Hi!', Contact.Id);
            
            //bolRet = sfdcAppRemoter.confirmProctorDownload(proctor.Id);
            
            // bolRet = sfdcAppRemoter.selectProctorRole(exmSite.Id, Contact.Id, 'Room Proctor');
            
            bolRet = sfdcAppRemoter.confirmExamAttestation(attempt.Id);
            
            bolRet = sfdcAppRemoter.confirmExamResultsViewed(attempt.Id);
            
            ChargentSFA__Payment_Request__c payReq = sfdcAppRemoter.payPendingOpportunity(opp.Id, Contact.Id);
            
            sfdcAppRemoter.productData pd = sfdcAppRemoter.getStudyProducts('FRM');
            pd = sfdcAppRemoter.getStudyProducts('ERP');
            pd = sfdcAppRemoter.getStudyProducts('FBR');
            pd = sfdcAppRemoter.getStudyProducts('ICBRR');
            
            sfdcAppRemoter.requestNewExamSite('USA','New York', '123');
            
        }
        test.stopTest();
    }    
    
    @IsTest(SeeAllData=true)
    static void unitTest_10(){
        
        testDataForAll();
        test.startTest();
        system.runAs(user){
            ID attId = sfdcAppRemoter.uploadAttachment(NULL, EncodingUtil.base64Encode(Blob.valueOf('---text---')), 'file.txt');
            attId = sfdcAppRemoter.uploadAttachment(attId, EncodingUtil.base64Encode(Blob.valueOf('---text---')), 'file.txt');
            
            //ConnectApi.Photo photo = sfdcAppRemoter.setUserPhoto(attId);
            
            
            
        }        
        test.stopTest();
        
    }
    
    static testMethod void unitTest_11(){
        
        testDataForAll();
        test.startTest();
        system.runAs(user){
            Study_App_Lesson_Plan__c LP = new Study_App_Lesson_Plan__c(Name='Lesson',Description__c='Desc', Exam__c='ERP Exam Part II', Year__c='2016');
            List<Study_App_Lesson_Plan__c> lstLP = sfdcAppRemoter.getStudyTopics('ERP Exam Part II', '2016');
            
            Contract c = new Contract(Accountid = acc.id,Status = 'Draft',CurrencyIsoCode = 'USD',All_Requirements_Completed__c = False);
            insert c;
            c.Status = 'Activated';
            update c;
            Candidate_Requirement__c cr = new Candidate_Requirement__c(Name='CV Submission',Candidate_Commitment__c = c.id);
            insert cr;
            
            Boolean retBol = sfdcAppRemoter.setCVSubmission(cr.Id);
            retBol =  sfdcAppRemoter.setNoTwoyears(cr.Id);
        }
        test.stopTest();
    }    
    
    static testMethod void unitTest_7(){
        testData();
        test.startTest();
        system.runAs(user1){
            
            sfdcAppRemoter.purchaseCodeData purchaseCodeData = new sfdcAppRemoter.purchaseCodeData();
            purchaseCodeData.prodCode = 'AFREE';
            purchaseCodeData.glCode = '4999';
            purchaseCodeData.price = '123';
            purchaseCodeData.description = 'rew';
            purchaseCodeData.months = 3;
            
            sfdcAppRemoter.purchaseData purchaseData = new sfdcAppRemoter.purchaseData();
            purchaseData.id = prod.id;
            purchaseData.price = '12';
            
            sfdcAppRemoter.addressData addressData = new sfdcAppRemoter.addressData();
            addressData.Address_1 = 'test';
            addressData.Address_2 = 'test';
            addressData.Address_3 = 'test';
            addressData.City = 'test';
            addressData.State_Provence = 'test' ;
            addressData.Postal_Code =  'test';
            addressData.Country = 'test';
            
            sfdcAppRemoter.getUserContactDetails();
            //sfdcAppRemoter.unsubscribe();
            sfdcAppRemoter.updateId('test', 'test', '6578');
            sfdcAppremoter.voteBoardCandidates(contact1.id,  election.Id);
            //sfdcAppRemoter.confirmProctor(proctor.id);
            //sfdcAppRemoter.attestProctorApplication(proctor.id);
            //sfdcAppRemoter.getProctorSiteRoster(proctor.id);
            //sfdcAppRemoter.chapterMeetingRegister(tempAccount);
            sfdcAppRemoter.setChapterMeetingConfirm(string.valueOf(meetingReg.Id));
            sfdcAppRemoter.getChapterMeetingRegistrations();
            sfdcAppRemoter.signDirectorCode(chapter.Id);
            
            //   sfdcAppRemoter.getEventContentDocs(12, 2014, false);
            sfdcAppRemoter.getChapterMeetingDetail (string.valueOf(chapMeeting.id));
            sfdcAppRemoter.getChapterMeetingDetails(12, 2014, false);
            sfdcAppRemoter.searchDirectory('test', 'lastname','','','','','lastname', 'DESC', 1, 0);
            //  sfdcAppRemoter.searchDirectory('test', 'lastname','Other','','','Bank of America','lastname', 'DESC', 1, 0);
            //sfdcAppRemoter.fetchChapterMeetingRegister(string.valueOf(meetingReg.id));
            //sfdcAppRemoter.submitClaimFromMeeting( string.valueOf(chapMeeting.id),  string.valueOf(contact.Id),  string.valueOf(type.id), string.valueOf(acc.id), true);
            sfdcAppRemoter.toggelAttendance(String.valueOf( chapMeeting.id),  string.valueOf(meetingReg.Id));
            
            sfdcAppRemoter.prepareWCO(wco, opp.Id);
            
        }        
        test.stopTest();
    }
    
    
    static testMethod void unitTest_6(){
        testData();
        test.startTest();
        system.runAs(user1){
            sfdcAppRemoter.purchaseCodeData purchaseCodeData = new sfdcAppRemoter.purchaseCodeData();
            purchaseCodeData.prodCode = 'AFREE';
            purchaseCodeData.glCode = '4999';
            purchaseCodeData.price = '123';
            purchaseCodeData.description = 'rew';
            purchaseCodeData.months = 3;
            
            sfdcAppRemoter.purchaseData purchaseData = new sfdcAppRemoter.purchaseData();
            purchaseData.id = prod.id;
            purchaseData.price = '12';
            
            sfdcAppRemoter.addressData addressData = new sfdcAppRemoter.addressData();
            addressData.Address_1 = 'test';
            addressData.Address_2 = 'test';
            addressData.Address_3 = 'test';
            addressData.City = 'test';
            addressData.State_Provence = 'test' ;
            addressData.Postal_Code =  'test';
            addressData.Country = 'test';
            
            sfdcAppRemoter.buyProductsByCode(new sfdcAppRemoter.purchaseCodeData[] {purchaseCodeData}, 'test');
            sfdcAppRemoter.buyProducts(new sfdcAppRemoter.purchaseData[] {purchaseData});
            sfdcAppRemoter.requestNewChapter('test', 'test', 'test');
            sfdcAppRemoter.submitCreditContent( activity.Id, reqt.id);
            sfdcAppRemoter.setChapters(string.valueOf(chapter.id), string.valueOf(chapter.id));
            sfdcAppRemoter.requestChapterDirector(chapter.id);
            sfdcAppRemoter.fetchUserDataInternal(contact1.id);
        }
        
        
        test.stopTest();     
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        system.runAs(user){
            sfdcAppRemoter remoter = new sfdcAppRemoter();
            sfdcAppRemoter.searchResults results = new sfdcAppRemoter.searchResults();
            sfdcAppRemoter.wrapperChapterMeetingDetails wrapperChapterMeetingDetails = new sfdcAppRemoter.wrapperChapterMeetingDetails();
            sfdcAppRemoter.wrapperChapterMemberDetails wrapperChapterMemberDetails = new sfdcAppRemoter.wrapperChapterMemberDetails();
            sfdcAppRemoter.productList productList = new sfdcAppRemoter.productList();
            productList.GLCode =  '4999';
            productList.price= '123';
            productList.ProductCode = 'AFREE';
            productList.Description = 'tuyio';
            sfdcAppRemoter.addressData addressData = new sfdcAppRemoter.addressData();
            sfdcAppRemoter.purchaseCodeData purchaseCodeData = new sfdcAppRemoter.purchaseCodeData();
            sfdcAppRemoter.purchaseData purchaseData = new sfdcAppRemoter.purchaseData();   
            sfdcAppRemoter.contentData contentData = new sfdcAppRemoter.contentData();      
            sfdcAppRemoter.productData productData = new sfdcAppRemoter.productData() ;       
            sfdcAppRemoter.wrapperProductInfo wrapperProductInfo = new sfdcAppRemoter.wrapperProductInfo();
            sfdcAppRemoter.getExperienceData getExperienceData = new sfdcAppRemoter.getExperienceData();
            sfdcAppRemoter.getUserReturnData getUserReturnData = new sfdcAppRemoter.getUserReturnData();        
            sfdcAppRemoter.returnData returnData = new sfdcAppRemoter.returnData();
            fieldInfo = new sfdcAppRemoter.fieldInfo();
            fieldInfo.name = 'firstname';
            fieldInfo.label = 'first name'; 
            fieldInfo.type = 'text'; 
            fieldInfo.maxLength = 20;
            fieldInfo.description = 'test';
            
            sfdcAppRemoter.appData appData = new sfdcAppRemoter.appData();
            sfdcAppRemoter.getChangeExamSites( string.valueOf(attempt.id));
            sfdcAppRemoter.changeExamSite(string.valueOf(attempt.id), exmSite.id);
            sfdcAppRemoter.createOtherexams(new sfdcAppRemoter.productList[]{productList}, tempAccount);
            sfdcAppRemoter.removeOrder(string.valueOf( opp.Id));
            sfdcAppremoter.setContactInfo(tempAccount);
            sfdcAppRemoter.getContactInfo(string.valueOf(contact.id)); 
        }
        test.stopTest();
        
    }
    
    static testMethod void unitTest_8(){
        testData();
        test.starttest();
        sfdcAppRemoter.getFolderDocs('test');
        test.stopTest();    
        
    }
    
    static testMethod void unitTest_2(){
        testData();
        test.startTest();
        system.runAs(user){
            sfdcAppRemoter remoter = new sfdcAppRemoter();
            fieldInfo = new sfdcAppRemoter.fieldInfo();
            fieldInfo.name = 'firstname';
            fieldInfo.label = 'first name'; 
            fieldInfo.type = 'text'; 
            fieldInfo.maxLength = 20;
            fieldInfo.description = 'test';
            sfdcAppRemoter.getExamProducts('test',contact.email);
            sfdcAppRemoter.autoRenewOff(false);
            sfdcAppRemoter.fetchCompanies();
            sfdcAppRemoter.saveFormData('Contact',string.valueof(contact.id),new sfdcAppremoter.fieldInfo[]{fieldInfo});
            //sfdcAppremoter.deleteFormData('Content__c',string.valueof(content.id));
            sfdcAppRemoter.fetchUserData();
            sfdcAppRemoter.fetchAcademicInstitutions();
        }
        test.stopTest();
        
    }    
    static testMethod void unitTest_3(){
        testData();
        test.startTest();
        try{            
            sfdcAppRemoter.renewContractcheck();
        }catch(Exception ex){}
        try{            
            sfdcAppRemoter.RecurringFuture(opp.id,'12','2014','Credit Card','VISA','543','543456765');            
        }catch(Exception ex){}
        try{            
            sfdcAppremoter.createoppRecurring('AFREE');
        }catch(Exception ex){}
        try{            
            sfdcAppremoter.VoidRecurring(opp.id);           
        }catch(Exception ex){}
        try{
            sfdcAppRemoter.autoRenew(false, 'AFREE','',False);           
        }catch(Exception ex){}
        try{
            sfdcAppRemoter.getUPSPrice('string strAddress1','string strAddress2','string strCity','string strCountry','string strStateCode','string strZip',new String[] {'MEMI'});
        }catch(Exception ex){}
        try{
            system.runAs(user1){
                sfdcAppRemoter.logError('String errorObject', 'String msg', 'String file', 'String method', 'String page', 'String Agent');
            }
        }catch(Exception ex){}
        try{
            //sfdcAppRemoter.updateSite(attempt.id,exmsite.id);
        }catch(Exception ex){}
        try{
            sfdcAppRemoter.Charge(opp.Id,'12','2014','Credit Card','VISA','543','543456765');
        }catch(Exception ex){}
        try{
            sfdcAppRemoter.getUnDefferedExams(attempt.id, 'FRM1S','4999',false);
        }catch(Exception ex){}
        try{
            sfdcAppRemoter.fetchFormData('Contact', contact.id, new string[]{'lastname','firtstname'},'','');
            //sfdcAppRemoter.fetchUserDataInside(contact.id);
            sfdcAppRemoter.fetchUserData();
            sfdcAppRemoter.fetchUserDataInternal(contact.id);
            //sfdcAppRemoter.fetchContactData();
            sfdcAppRemoter.fetchCompanies();
        }catch(Exception ex){}   
        try{
            sfdcAppRemoter.fetchFormList('Contact', 'Account','AccountID', new string[]{'lastname','firtstname'});
            sfdcAppRemoter.fetchFormData('Contact', contact.id, new string[]{'lastname','firtstname'},'','');
            sfdcAppRemoter.saveFormData('Contact', string.valueOf(contact.id), new sfdcappRemoter.fieldInfo[] {fieldInfo});
            sfdcAppRemoter.deleteFormData('Contact', contact.id);
        }catch(Exception ex){}
        test.stopTest();
        
    }
    
    
    
    static testMethod void unitTest_4(){
        testData();
        test.startTest();
        system.runAs(user){
            //sfdcAppRemoter.getInvoicePayments(opp.id);
            sfdcAppRemoter.getContentRegistrations(new string[]{'AFREE'});
            sfdcAppRemoter.deferExams(attempt.id,  'AFREE', '4999',false);
            sfdcAppRemoter.getProduct('AFREE', '4999');
            sfdcAppRemoter.encodeString('trewyrte');
            sfdcAppRemoter.getBoardCandidates();
            sfdcAppRemoter.getSwitchDetails();
            sfdcAppRemoter.getOtherexamcodes();
            sfdcAppRemoter.getDefferedExams();
            sfdcAppRemoter.getParentId(); 
            //sfdcAppRemoter.selectProctor(site.Id,  proctor.Id, true);
            //sfdcAppRemoter.setProctorRole(site.Id, proctor.Id, 'Assistant Supervisor');
            //sfdcAppRemoter.setProctorTypeOfWorkday(site.Id, proctor.Id, 'Full');
            // sfdcAppRemoter.confirmProctorSelection(site.Id, JSON.serialize(proctor), JSON.serialize(proctor2));
            sfdcAppRemoter.workedProctor(site.id, contact.id, true);
            //sfdcAppRemoter.getProctorsBySite( site.Id);
            sfdcAppRemoter.attestCPE( Reqt.Id);
            sfdcAppRemoter.getCPEActivities();
            sfdcAppRemoter.getERPStudyProducts();
            sfdcAppRemoter.getFRMStudyProducts();
            sfdcAppRemoter.getContentDocs('Test');
            sfdcAppremoter.changeCycle(contract.id);
            //sfdcAppRemoter.uploadAttachment('filename', 'fileData', contact.id);
            sfdcAppRemoter.getUserContactDetails();
        }
        test.stopTest();
    }
    
    static testMethod void unitTest_5(){
        
        testData();
        test.startTest();
        sfdcAppremoter remoter = new sfdcAppremoter();
        sfdcAppremoter.createorder(tempAccount);
        sfdcAppRemoter.setLead('test@test.com', 'test', 'test', 'Full Time',null);
        sfdcAppRemoter.CheckExistingMember('test@test.com');
        sfdcAppRemoter.getTestDate();
        sfdcAppRemoter.getRegistrationDate();
        sfdcAppRemoter.getActiveSites();
        system.runAs(user1){
            sfdcAppRemoter.restoreAMPFee(opp.Id);
            remoter.filterContentDocs(new Content__c[] {content}, 1) ;
        }
        test.stopTest();
        
    }
    
    static testMethod void test_getProductsById(){
        
        testData();
        test.startTest();
        
        sfdcAppremoter remoter = new sfdcAppremoter();
        List<String> productIds = new List<String>();
        String prodId = String.valueOf(prod1.Id);
        productIds.add(prodId);
        sfdcAppRemoter.getProductsById(productIds);
        
        test.stopTest();
        
    }
    
    
    @isTest
    static private void eventsWebcastsHelperTest(){
        
        Event_Speaker__c eventSpeaker = new Event_Speaker__c();
        INSERT eventSpeaker;
        
        Event__c event = new Event__c();
        // Kyan - Hey the test class is not working because it is missing custom validation the next two rows are my custom validation delete this note if everything works
        event.Grace_Period__c = 5;
        event.Event_Cancellation_Days__c = 2;
        event.Status__c = 'Active';
        INSERT event;
        
        Event_Sessions__c eventSession = new Event_Sessions__c();
        eventSession.Event__c = event.Id;
        INSERT eventSession;
        
        Event_Speaker_Session_Track__c eventSpeakerSessionTrack = new Event_Speaker_Session_Track__c();
        eventSpeakerSessionTrack.Event_Speaker__c = eventSpeaker.Id;
        eventSpeakerSessionTrack.Event_Session__c = eventSession.Id;
        INSERT eventSpeakerSessionTrack;   
        
        EventsHelper.Event events = sfdcAppRemoter.fetchEventDetails(event.Id);
        
        Webcast__c webcast =  new Webcast__c();
        webcast.Status__c = 'Active';
        INSERT webcast;
        
        Presenter__c presenter = new Presenter__c();
        presenter.Webcast__c = webcast.Id;
        INSERT presenter;
        
    }
    
    @isTest
    static private void getOneWireLocations(){
        
        Test.setMock(HttpCalloutMock.class, new OneWireLocationsMockHttpCallout());
        
        Test.startTest();
        String json = sfdcAppRemoter.getOneWireLocations('{ query : "new york"}');
        Test.stopTest();
        
        System.assertNotEquals(null, json);
        
    }
    
    @isTest
    static private void getOneWireHighlightedJobs(){
        
        Job__c job1 = new Job__c(Display_Sort_Order__c = '1');
        Job__c job2 = new Job__c(Display_Sort_Order__c = '2');
        Job__c job3 = new Job__c(Display_Sort_Order__c = '3');
        
        INSERT job1;
        INSERT job2;
        INSERT job3;
        
        List<Job__c> jobs = sfdcAppRemoter.getHighlightedJobs();
        System.assertEquals(3, jobs.size());
        System.assertEquals('1', jobs[0].Display_Sort_Order__c);
        System.assertEquals('2', jobs[1].Display_Sort_Order__c);
        System.assertEquals('3', jobs[2].Display_Sort_Order__c);
        
    }
    
    @isTest
    static private void getFaqsByCategoryTest() {
        String testCategoryName = 'testCategory';
        
        FAQ_Category__c FAQ_Category = new FAQ_Category__c();
        FAQ_Category.Name = testCategoryName;
        INSERT FAQ_Category;
        System.assertNotEquals(null, sfdcAppRemoter.getFaqsByCategory(testCategoryName));
    }
    
    @isTest
    static private void proctorPortalUnitTests(){
        
        /*
        Proctor_Registration__c pr =  new Proctor_Registration__c(
            Wire_Info_Bank_Phone__c = '111-111-1111',
            Proctor_Email__c = 'test@email.com',
            Proctor_First_Name__c = 'firstname',
            Proctor_Last_Name__c = 'surname',
            Payment_Method__c = 'I want a check mailed to me',
            Attest_Payment_Info__c = false,
            Payment_Shipping_Address_1__c = 'address1',
            Status__c = null
        );
        
        INSERT pr;
        
        
        List<Map<String, sfdcAppRemoter.sObjectFieldProperties>> fields = sfdcAppRemoter.getSObjectFieldsWithMetadata('Proctor_Registration__c', 'Payment_Method__c, Wire_Info_Bank_Phone__c, Attest_Payment_Info__c, Payment_Shipping_Address_1__c', 'Id', '=', pr.Id);
        
        System.assertEquals('I want a check mailed to me', fields[0].get('Payment_Method__c').value);
        System.assertEquals('111-111-1111', fields[0].get('Wire_Info_Bank_Phone__c').value);
        System.assertEquals(false, fields[0].get('Attest_Payment_Info__c').value);
        System.assertEquals('address1', fields[0].get('Payment_Shipping_Address_1__c').value);
        
        fields[0].get('Payment_Method__c').value = 'I am requesting a wire transfer';
        fields[0].get('Wire_Info_Bank_Phone__c').value = '123-123-1234';
        fields[0].get('Attest_Payment_Info__c').value = true;
        fields[0].get('Payment_Shipping_Address_1__c').value = 'modifiedAddress1';
        
        String jsonData = JSON.serialize(fields[0]);
        
        Proctor_Registration__c result = sfdcAppRemoter.saveProctorRegistration(pr.Id, jsonData);
        
        System.assertEquals('I am requesting a wire transfer', result.Payment_Method__c);
        System.assertEquals('123-123-1234', result.Wire_Info_Bank_Phone__c);
        System.assertEquals(true, result.Attest_Payment_Info__c);
        System.assertEquals('modifiedAddress1', result.Payment_Shipping_Address_1__c);
        
        Proctor_Registration__c status = sfdcAppRemoter.setProctorRegistrationStatus(pr.Id, 'Document Review');
        
        System.assertEquals('Document Review', status.Status__c);
        */
    }
    
    @isTest
    private static void getOpportunity(){
        
        testDataForAll();
        
        test.startTest();
        
        System.runAs(user1){
            sfdcAppRemoter.getOpportunity(opp.Id);
        }
        
        test.stopTest();
        
    }
    
    @isTest
    private static void payOpportunity(){
        
        testDataForAll();
        
        test.startTest();
        
        System.runAs(user1){
            sfdcAppRemoter.payOpportunity(opp.Id, '01', '2025', '124', '4111111111111111');
        }
        
        test.stopTest();
        
    }    
    
    @isTest
    private static void payZeroDollarOpportunity(){
        
        testDataForAll();
        
        opp.Amount = 0;
        
        UPDATE opp;
        
        test.startTest();
        
        System.runAs(user1){
            sfdcAppRemoter.payOpportunity(opp.Id, '01', '2025', '124', '4111111111111111');
        }
        
        test.stopTest();
        
    }   
    
    @isTest
    private static void getPortalAds(){
        
        test.startTest();
        
        Content__c content = new Content__c(
            Name = 'TEST',
            Is_advertisement__c = TRUE, 
            Ad_Format__c = 'User Portal'
        );
        
        INSERT content;
        
        sfdcAppRemoter.getPortalAds();
        
        test.stopTest();
        
    }
    
    @isTest
    private static void updateUserEmail(){
        
        testDataForAll();
        
        test.startTest();
        
        System.runAs(user1){
            sfdcAppRemoter.updateUserEmail('changed@testorg.com');
        }
        
        test.stopTest();
        
    }
    
    @isTest
    private static void submitRequiredOstaInformationForZeroDollarOrder(){
        
        testDataForAll();
        
        opp.OSTA_Check__c = true;
        opp.Amount = 0;
        
        UPDATE opp;
        
        test.startTest();
        
        System.runAs(user1){
            Response.Detail res = sfdcAppRemoter.submitRequiredOstaInformation(JSON.serializePretty(contact), opp.Id);
        }
        
        test.stopTest();
        
    }
    
}