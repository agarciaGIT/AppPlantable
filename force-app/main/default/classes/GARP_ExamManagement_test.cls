@isTest
public class GARP_ExamManagement_test {
    
    public static Account account;
    public static Contact contact;
    
    public static Exam_Sites__c examSiteChinaExamPart1;
    public static Exam_Sites__c examSiteChinaExamPart2;
    
    public static Exam_Sites__c examSiteNonChinaExamPart1;
    public static Exam_Sites__c examSiteNonChinaExamPart2;
    
    public static Site__c testSiteChina;    
    public static Site__c testSiteNonChina;    
    
    public static Exam_Group__c examGroup;
    public static Exam_Group__c examGroup1;
    public static Exam_Group__c nextExamGroup;
    
    public static Exam_Part__c exampart;
    public static Exam_Part__c exampart1;
    public static Exam_Part__c exampart2;
    
    public static Exam_Administration__c examAdmin;
    public static Exam_Administration__c examAdmin1;
    
    public static Exam__c frmPart1;
    public static Exam__c frmPart2;
    
    public static Product2 CHLF;
    public static Product2 OSTA;
    public static Product2 FRMRET1;
    public static Product2 FRMRET2;
    public static Product2 ERPRET1;
    public static Product2 ERPRET2;
    
    public static PricebookEntry CHLFPBE;
    public static PricebookEntry OSTAPBE;
    public static PricebookEntry FRMRET1PBE;
    public static PricebookEntry FRMRET2PBE;
    public static PricebookEntry ERPRET1PBE;
    public static PricebookEntry ERPRET2PBE;
    
    public static void setup(){
        
        Pricebook2 activePricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = TRUE
        );
        
        UPDATE activePricebook;  
        
        Id pricebookId = activePricebook.Id;
        
        //FEES      
        CHLF = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'CHLF', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        OSTA = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'CHNDF', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        FRMRET1 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'FRMRET1', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        FRMRET2 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'FRMRET2', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        ERPRET1 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'ERPRET1', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        ERPRET2 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'ERPRET2', GL_Code__c = '2009', Family = 'Hardware', IsActive = true);
        
        INSERT CHLF;
        INSERT OSTA;
        INSERT FRMRET1;
        INSERT FRMRET2;
        INSERT ERPRET1;
        INSERT ERPRET2;
        
        CHLFPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = CHLF.Id, UnitPrice = 10000, IsActive = true);
        OSTAPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = OSTA.Id, UnitPrice = 10000, IsActive = true);
        FRMRET1PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = FRMRET1.Id, UnitPrice = 10000, IsActive = true);
        FRMRET2PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = FRMRET2.Id, UnitPrice = 10000, IsActive = true);
        ERPRET1PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = ERPRET1.Id, UnitPrice = 10000, IsActive = true);
        ERPRET2PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = ERPRET2.Id, UnitPrice = 10000, IsActive = true);
        
        INSERT CHLFPBE;
        INSERT OSTAPBE;
        INSERT FRMRET1PBE;
        INSERT FRMRET2PBE;
        INSERT ERPRET1PBE;
        INSERT ERPRET2PBE;
        
        List<Exam_Group__c> examGroupList = new List<Exam_Group__c>();
        nextExamGroup = new Exam_Group__c();
        nextExamGroup.Name = '21-Nov';
        nextExamGroup.Active__c = false;
        nextExamGroup.Registration_Start_Date__c = Date.today().addDays(20);
        nextExamGroup.Exam_Date__c = Date.today().addDays(-5);
        nextExamGroup.Exam_Change_Start_Date_Time__c= DateTime.now().addDays(30);
		insert nextExamGroup;
        //examGroupList.add(nextExamGroup);
        
        examGroup = new Exam_Group__c();
        examGroup.Name = '21-May';
        examGroup.Active__c = true;
        examGroup.Exam_Date__c = Date.today().addDays(-5);
        examGroup.Next_Exam_Group__c = nextExamGroup.id;
        examGroup.Exam_Ticket_Available_Date__c = Date.today().addDays(10);
        examGroup.Exam_Results_Available_Date__c = Date.today().addDays(10);
        examGroup.Exam_Change_Start_Date_Time__c= DateTime.now().addDays(15);
        examGroupList.add(examGroup);
        
        examGroup = new Exam_Group__c();
        examGroup.Name = '21-SCR';
        examGroup.SCR_Active__c = true;
        examGroup.Next_Exam_Group__c = nextExamGroup.id;
        examGroup.Exam_Date__c = Date.today().addDays(-5);
        examGroup.Exam_Ticket_Available_Date__c = Date.today().addDays(10);
        examGroup.Exam_Results_Available_Date__c = Date.today().addDays(10);
        examGroup.Exam_Change_Start_Date_Time__c= DateTime.now().addDays(15);
        examGroupList.add(examGroup);
        
        insert examGroupList;
        
        frmPart1 = new Exam__c();
        frmPart1.Name = 'May 2018 FRM Exam Part I';
        frmPart1.Exam_Group__c = examGroup.Id;
        frmPart1.Exam__c = 'FRM Part 1';
        frmPart1.Exam_Date__c = Date.today().addDays(10); 
        INSERT frmPart1; 
        
        frmPart2 = new Exam__c();
        frmPart2.Name = 'May 2018 FRM Exam Part II';
        frmPart2.Exam_Group__c = examGroup.Id;
        frmPart2.Exam__c = 'FRM Part 2';
        frmPart2.Exam_Date__c = Date.today().addDays(10);
        INSERT frmPart2;
        
        account = new Account();
        account.Name = 'TEST CO';
        INSERT account;
        
        contact = new Contact();
        contact.Email = 'TEST@TEST.com';
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.AccountId = account.Id;
        contact.First_Name_as_it_Appears_on_ID__c = 'Test';
        contact.Middle_Name_as_it_Appears_on_ID__c = 'T';
        contact.Last_Name_as_it_Appears_on_ID__c = 'Test';
        INSERT contact;
        
        testSiteChina = new Site__c();
        testSiteChina.Name = 'China, Guangzhou';
        testSiteChina.Active__c = true;
        testSiteChina.Display_Address__c = 'China, Guangzhou';
        testSiteChina.Is_OSTA_Information_Required__c = true;
        INSERT testSiteChina;
        
        testSiteNonChina = new Site__c();
        testSiteNonChina.Name = 'Canada, Surrey';
        testSiteNonChina.Active__c = true;
        testSiteNonChina.Display_Address__c = 'Canada, Surrey';
        testSiteNonChina.Is_OSTA_Information_Required__c = false;
        INSERT testSiteNonChina;
        
        examAdmin = new Exam_Administration__c();
        examAdmin.Exam_Group__c = examGroup.id;
        examAdmin.Exam_Date__c = system.today();
        examAdmin.Exam_Type__c = 'FRM' ;
        examAdmin.Exam_Results_Release_Date__c = DateTime.now().addDays(90);
        insert examAdmin;
        
        
        
        exampart = new Exam_Part__c();
        exampart.Exam__c = frmPart1.Id;
        exampart.Exam_Administration__c = examAdmin.Id ;
        exampart.Delivery_Method__c = 'CBT';
        exampart.Exam_Start_Date__c = Date.today();
        exampart.Exam_Date__c = Date.today();
        exampart.Exam_End_Date__c = Date.today().addDays(10);
        
        insert exampart;
        
        exampart2 = new Exam_Part__c();
        exampart2.Exam__c = frmPart2.Id;
        exampart2.Exam_Administration__c = examAdmin.Id ;
        exampart2.Delivery_Method__c = 'CBT';
        exampart2.Exam_Start_Date__c = Date.today();
        exampart2.Exam_Date__c = Date.today();
        exampart2.Exam_End_Date__c = Date.today().addDays(10);
        
        insert exampart2;
        
        examSiteChinaExamPart1 = new Exam_Sites__c();
        examSiteChinaExamPart1.Name = 'May 2018 FRM Exam Part I, China, Guangzhou';
        examSiteChinaExamPart1.Site__c = testSiteChina.Id;
        examSiteChinaExamPart1.Exam__c = frmPart1.Id;
        examSiteChinaExamPart1.Exam_Part__c = exampart.Id;
        INSERT examSiteChinaExamPart1;
        
        examSiteChinaExamPart2 = new Exam_Sites__c();
        examSiteChinaExamPart2.Name = 'May 2018 FRM Exam Part II, China, Guangzhou';
        examSiteChinaExamPart2.Site__c = testSiteChina.Id;
        examSiteChinaExamPart2.Exam__c = frmPart2.Id;
        examSiteChinaExamPart2.Exam_Part__c = exampart2.Id;
        INSERT examSiteChinaExamPart2;
        
        examSiteNonChinaExamPart1 = new Exam_Sites__c();
        examSiteNonChinaExamPart1.Name = 'May 2018 FRM Exam Part I, Canada, Surrey';
        examSiteNonChinaExamPart1.Site__c = testSiteNonChina.Id;
        examSiteNonChinaExamPart1.Exam__c = frmPart1.Id;
        examSiteNonChinaExamPart1.Exam_Part__c = exampart.Id;
        INSERT examSiteNonChinaExamPart1;
        
        examSiteNonChinaExamPart2 = new Exam_Sites__c();
        examSiteNonChinaExamPart2.Name = 'May 2018 FRM Exam Part II, Canada, Surrey';
        examSiteNonChinaExamPart2.Site__c = testSiteNonChina.Id;
        examSiteNonChinaExamPart2.Exam__c = frmPart2.Id;
        examSiteNonChinaExamPart2.Exam_Part__c = exampart2.Id;
        INSERT examSiteNonChinaExamPart2;
        
    }
    
    @isTest
    public static void startOutsideOfChinaAndSwitchIntoChina(){
        
        setup();
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Attempt__c examRegistration2 = new Exam_Attempt__c();
        examRegistration2.Member__c = contact.Id;
        examRegistration2.Opportunity__c = opportunity.Id;
        examRegistration2.Exam_Site__c = examSiteNonChinaExamPart2.Id;
        INSERT examRegistration2;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteNonChinaExamPart2.Id;
        examRegistration.Cloned_From__c = examRegistration2.Id;
        INSERT examRegistration;
        
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Quantity=1;
        oppli1.OpportunityId=opportunity.Id; 
        oppli1.TotalPrice=10;
        oppli1.PriceBookEntryId = CHLFPBE.Id;
        insert oppli1;
        
        Test.startTest();
        
        //GARP_ExamManagement.changeExamSiteOnExamRegistrations(examRegistration.Id, examSiteChinaExamPart1.Id);
        
        Date tdy = Date.today();
        GARP_ExamManagement.updateOSTAIDInfo(contact.Id, 'Passport', '12345657', tdy);
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void startInsideOfChinaAndSwitchOutOfChina(){
        
        setup();
        
        Contract frmProgram = new Contract(
            AccountId = account.Id,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program'),
            Status = 'Draft',
            Name = 'FRM Program',
            StartDate = Date.today(),
            ContractTerm = 9999
        );
        
        INSERT frmProgram;
        
        frmProgram.Status = 'Activated ( Auto-Renew )';
        
        UPDATE frmProgram; 
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'New Lead';
        opportunity.CloseDate = Date.today();
        INSERT opportunity;
        
        Opportunity opportunity1 = new Opportunity();
        opportunity1.AccountId = account.Id;
        opportunity1.Amount = 700.00;
        opportunity1.Name = 'TEST';
        opportunity1.StageName = 'Closed';
        opportunity1.CloseDate = Date.today();
        INSERT opportunity1;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteChinaExamPart1.Id;
        INSERT examRegistration;
        
        Exam_Attempt__c examRegistrationClosed = new Exam_Attempt__c();
        examRegistrationClosed.Member__c = contact.Id;
        examRegistrationClosed.Opportunity__c = opportunity1.Id;
        examRegistrationClosed.Exam_Site__c = examSiteChinaExamPart1.Id;
        INSERT examRegistrationClosed;
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opportunity1.Id;
        oli.Product2Id = CHLF.Id;
        oli.UnitPrice = 40.00;
        oli.Quantity = 1;
        oli.PricebookEntryId = CHLFPBE.Id;
        oli.Exam_Registration__c = examRegistration.Id;
        INSERT oli;
        
        OpportunityLineItem osta = new OpportunityLineItem();
        osta.OpportunityId = opportunity.Id;
        osta.Product2Id = OSTA.Id;
        osta.UnitPrice = 10.00;
        osta.Quantity = 1;
        osta.PricebookEntryId = OSTAPBE.Id;
        osta.Exam_Registration__c = examRegistration.Id;
        INSERT osta;
        
        opportunity.StageName = 'Closed';
        UPDATE opportunity;
        
        Test.startTest();
        Contract ostaProgram = GARP_ExamManagement.createOstaProgram(opportunity, osta);
        ostaProgram = GARP_ExamManagement.fetchOstaProgram(account.Id);
        GARP_ExamManagement.createOrUpdateOstaExamRegistrationData(ostaProgram);
        //GARP_ExamManagement.changeExamSiteOnExamRegistrations(examRegistration.Id, examSiteNonChinaExamPart1.Id);
		
        Contract ostaProgram1 = GARP_ExamManagement.createOstaProgram(opportunity1, oli);
        ostaProgram1 = GARP_ExamManagement.fetchOstaProgram(account.Id);
        GARP_ExamManagement.createOrUpdateOstaExamRegistrationData(ostaProgram1);
        //GARP_ExamManagement.changeExamSiteOnExamRegistrations(examRegistrationClosed.Id, examSiteNonChinaExamPart1.Id);
        Test.stopTest();
    } 
    
    @isTest
    public static void deferAndUndeferChinaExamRegistrations(){
        
        setup();
        Contract frmProgram = new Contract(
            AccountId = account.Id,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program'),
            Status = 'Draft',
            Name = 'FRM Program',
            StartDate = Date.today(),
            ContractTerm = 9999
        );
        INSERT frmProgram;
        frmProgram.Status = 'Activated ( Auto-Renew )';
        UPDATE frmProgram; 
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        INSERT opportunity;
        
        Exam_Attempt__c examRegistrationPart1 = new Exam_Attempt__c();
        examRegistrationPart1.Member__c = contact.Id;
        examRegistrationPart1.Opportunity__c = opportunity.Id;
        examRegistrationPart1.Exam_Site__c = examSiteChinaExamPart1.Id;
        INSERT examRegistrationPart1;
        
        Exam_Attempt__c examRegistrationPart2 = new Exam_Attempt__c();
        examRegistrationPart2.Member__c = contact.Id;
        examRegistrationPart2.Opportunity__c = opportunity.Id;
        examRegistrationPart2.Exam_Site__c = examSiteChinaExamPart2.Id;
        INSERT examRegistrationPart2;
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opportunity.Id;
        oli.Product2Id = CHLF.Id;
        oli.UnitPrice = 40.00;
        oli.Quantity = 1;
        oli.PricebookEntryId = CHLFPBE.Id;
        oli.Exam_Registration__c = examRegistrationPart2.Id;
        INSERT oli;
        
        Test.startTest();
        
        GARP_ExamManagement.computeDeferralLocationFeesOrProductRefunds(opportunity.Id, examRegistrationPart2.Id, GARP_ExamManagement.DeferralAction.DEFER);
        GARP_ExamManagement.createDeferralProductRefunds(examRegistrationPart2.Id, GARP_ExamManagement.DeferralAction.DEFER);
        
        examRegistrationPart2.Defered__c = 'Pending';
        examRegistrationPart2.Deferral_Status__c = 'Deferred Out';
        
        UPDATE examRegistrationPart2;
        
        GARP_ExamManagement.computeDeferralLocationFeesOrProductRefunds(opportunity.Id, examRegistrationPart1.Id, GARP_ExamManagement.DeferralAction.DEFER);
        GARP_ExamManagement.createDeferralProductRefunds(examRegistrationPart1.Id, GARP_ExamManagement.DeferralAction.DEFER);
        
        
        examRegistrationPart1.Defered__c = 'Pending';
        examRegistrationPart1.Deferral_Status__c = 'Deferred Out';
        
        UPDATE examRegistrationPart1;  
        
        GARP_ExamManagement.computeDeferralLocationFeesOrProductRefunds(opportunity.Id, examRegistrationPart1.Id, GARP_ExamManagement.DeferralAction.UNDEFER);
        GARP_ExamManagement.createDeferralProductRefunds(examRegistrationPart1.Id, GARP_ExamManagement.DeferralAction.UNDEFER);
        
        examRegistrationPart1.Defered__c = null;
        examRegistrationPart1.Deferral_Status__c = null;
        
        UPDATE examRegistrationPart1;  
        
        GARP_ExamManagement.computeDeferralLocationFeesOrProductRefunds(opportunity.Id, examRegistrationPart2.Id, GARP_ExamManagement.DeferralAction.UNDEFER);
        GARP_ExamManagement.createDeferralProductRefunds(examRegistrationPart2.Id, GARP_ExamManagement.DeferralAction.UNDEFER);
        
        Test.stopTest();
        
    } 
    
    @isTest
    public static void requestRetabulation(){
        
        setup();
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        INSERT opportunity;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Result__c = 'Fail';
        examRegistration.Exam_Site__c = examSiteNonChinaExamPart1.Id;
        INSERT examRegistration;
        
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        opportunityLineItem.Exam_Registration__c = examRegistration.Id;
        opportunityLineItem.OpportunityId = opportunity.Id;
        opportunityLineItem.Product2Id = FRMRET1.Id;
        opportunityLineItem.UnitPrice = 100.00;
        opportunityLineItem.Quantity = 1;
        opportunityLineItem.PricebookEntryId = FRMRET1PBE.Id;
        INSERT opportunityLineItem;
        
        Test.startTest();
        
        Set<Id> retabulationRequestExamRegistrationIds = new Set<Id>();
        retabulationRequestExamRegistrationIds.add(examRegistration.Id);
        
        Map<Id, OpportunityLineItem> retabulationRequestFeesMapByOpportunityId = new Map<Id, OpportunityLineItem>();
        retabulationRequestFeesMapByOpportunityId.put(opportunity.Id, opportunityLineItem);
        
        GARP_ExamManagement.setExamRegistionReScoreStatusForReview(retabulationRequestExamRegistrationIds, retabulationRequestFeesMapByOpportunityId);
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void setScholarshipApplicationStatusAsUsed(){
        
        setup();
        Scholarship_Application__c scholarshipApplication = new Scholarship_Application__c();
        scholarshipApplication.Exam_Group__c = examGroup.Id;
        scholarshipApplication.Applicant__c = contact.Id;
        scholarshipApplication.Status__c = 'Approved';
        INSERT scholarshipApplication;
        Set<Id> scholarshipApplicationIds = new Set<Id>{scholarshipApplication.Id};
            
            Test.startTest();
        GARP_ExamManagement.setScholarshipApplicationStatusAsUsed(scholarshipApplicationIds);
        Test.stopTest();
        
        System.assertEquals('Used', [SELECT Status__c FROM Scholarship_Application__c WHERE Id = :scholarshipApplication.Id LIMIT 1].Status__c);
    }
    
    @isTest
    public static void getAllProgramInfo(){
        setup();
        GARP_ExamManagementRemoter.getAllProgramInfo();
    }
    
    @isTest
    public static void getProgramData(){
        setup();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' limit 1]; 
        User user = new User(Alias = 'nUser', Email='newuser@testorg.com', 
                             contactId = contact.id,EmailEncodingKey='UTF-8', 
                             LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', 
                             UserName='nuser123@testorg.com');
        system.debug('user.id=============>'+user.id);
        system.debug('user.contactId=============>'+user.contactId);
        Contract Program = new Contract(
            AccountId = account.Id,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program'),
            Name = 'Test Contract'
        );
        INSERT Program ;
        
        Program.Status = 'Activated';
        update Program;
        
        Candidate_Requirement__c canReq = new Candidate_Requirement__c();
        canReq.Candidate_Commitment__c = Program.id;
        canReq.name = 'FRM1 test';
        canReq.Exam__c = frmPart1.Id;
        canReq.Status__c = 'Completed';
        insert canReq;
        
        Exam_Administration__c examAdmin1 = new Exam_Administration__c();
        examAdmin1.Exam_Group__c = examGroup.id;
        examAdmin1.Exam_Date__c = system.today();
        examAdmin1.Exam_Start_Date__c = system.today().addDays(5);
        examAdmin1.Exam_Type__c = 'FRM' ;
        examAdmin1.Exam_Admin_Modifications_Start_Date__c = system.today();	
        examAdmin1.Exam_Admin_Modifications_End_Date__c = system.today().adddays(30);	
        examAdmin1.Exam_Scheduling_Start_Date__c = system.today();	
        examAdmin1.Exam_Scheduling_End_Date__c = system.today().adddays(30);
        examAdmin1.Exam_Results_Release_Date__c = DateTime.now().addDays(90);
        insert examAdmin1;
        
        Exam_Part__c expart1 = new Exam_Part__c();
        expart1.Exam__c = frmPart2.Id;
        expart1.Exam_Administration__c = examAdmin1.Id ;
        expart1.Delivery_Method__c = 'CBT';
        expart1.Exam_Date__c = Date.today();
        expart1.Exam_Start_Date__c = Date.today();
        expart1.Exam_End_Date__c = Date.today().addDays(10);
        
        insert expart1;
		
		Exam_Provider__c ep = new Exam_Provider__c(Name = 'GARP');
		insert ep;
        
        Exam_Sites__c exsite = new Exam_Sites__c();
        exsite.Name = 'FRM Part 1';
        exsite.Site__c = testSiteNonChina.Id;
        exsite.Exam__c = frmPart1.Id;
        exsite.Exam_Part__c = expart1.id;
        exsite.Exam_Provider__c = ep.id;
        INSERT exsite;
        
        Exam_Sites__c exsite2 = new Exam_Sites__c();
        exsite2.Name = 'FRM Part 2';
        exsite2.Site__c = testSiteChina.Id;
        exsite2.Exam__c = frmPart2.Id;
        exsite2.Exam_Part__c = expart1.id;
        exsite2.Exam_Provider__c = ep.id;
        INSERT exsite2;
		
		Venue__c vn1 = new Venue__c(Name='test', Institution_Name__c='test', Building_Name__c='test', Address1__c='test', Address2__c='test',City__c='test', State__c='test',Zipcode__c='12345',Country__c='test', Site__c = testSiteChina.Id, Active__c = True);
		insert vn1;
		Venue__c vn2 = new Venue__c(Name='test', Institution_Name__c='test', Building_Name__c='test', Address1__c='test', Address2__c='test',City__c='test', State__c='test',Zipcode__c='12345',Country__c='test', Site__c = testSiteNonChina.Id, Active__c = True);
		insert vn2;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Administration__c = examAdmin1.Id;
        examRegistration.Exam_Part__c = expart1.Id;
        examRegistration.Exam_Site__c = exsite.Id;
        //examRegistration.Defered__c = 'Pending';
        INSERT examRegistration;
        
        Exam_Attempt__c examRegistration2 = new Exam_Attempt__c();
        examRegistration2.Member__c = contact.Id;
        examRegistration2.Opportunity__c = opportunity.Id;
        //examRegistration2.Exam_Administration__c = examAdmin1.Id;
        //examRegistration2.Defered__c = 'Pending';
        examRegistration2.Exam_Site__c = exsite2.Id;
        INSERT examRegistration2;
        
        GARP_ExamManagement.getProgramData('frm');
        Program.Status = 'Completed';
        update Program;
        GARP_ExamManagement.getProgramData('erp');
        GARP_ExamManagement.getProgramData('SCR');
    }
    
    @isTest
    public static void getProgramInfo(){
        setup();
        
        GARP_ExamManagementRemoter.getProgramInfo('frm');
        GARP_ExamManagementRemoter.getProgramInfo('erp');
        
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteChinaExamPart1.Id;
        INSERT examRegistration;
        
        GARP_ExamManagement.createCBTIntegrationAuthorization(examRegistration.Id);
        GARP_ExamManagementRemoter.logFailedAuthorization(examRegistration.Id);
    }
    
    @isTest
    public static void processExamRegMods() {
        setup();
        Exam_Administration__c examAdmin1 = new Exam_Administration__c();
        examAdmin1.Exam_Group__c = examGroup.id;
        examAdmin1.Exam_Date__c = system.today().addDays(-5);
        examAdmin1.Exam_Results_Release_Date__c = DateTime.now().addDays(90);
        insert examAdmin1;
        
        Exam_Administration__c examAdmin2 = new Exam_Administration__c();
        examAdmin2.Exam_Group__c = nextExamGroup.id;
        examAdmin2.Exam_Date__c = system.today().addDays(10);
        examAdmin2.Exam_Start_Date__c = system.today().addDays(5);
        examAdmin2.Exam_Type__c = 'FRM' ;
        examAdmin2.Exam_Results_Release_Date__c = DateTime.now().addDays(90);
        insert examAdmin2;
        
        List<Exam_Attempt__c> attemptList = new List<Exam_Attempt__c>();
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Exam_Part__c = exampart.Id;
        examRegistration.Exam_Administration__c = examAdmin1.Id;
        examRegistration.Exam_Site__c = examSiteChinaExamPart1.Id;
        attemptList.add(examRegistration);
        
        Exam_Attempt__c examRegistration2 = new Exam_Attempt__c();
        examRegistration2.Member__c = contact.Id;
        examRegistration2.Exam_Part__c = exampart2.Id;
        examRegistration2.Exam_Administration__c = examAdmin1.Id;
        examRegistration2.Exam_Site__c = examSiteNonChinaExamPart2.Id;
        attemptList.add(examRegistration2);
        INSERT attemptList;
        
        Exam_Registration_Modification__c examRegMod = new Exam_Registration_Modification__c();
        // examRegMod.Contact_Name__c = contact.Id;
        examRegMod.Part_I_Exam_Admin_From__c = examAdmin1.id ;
        examRegMod.Part_II_Exam_Admin_From__c  = examAdmin1.id ;
        examRegMod.Part_I_Exam_Registration__c = examRegistration.id;
        examRegMod.Part_II_Exam_Registration__c = examRegistration2.id;
        examRegMod.Part_I_Exam_Admin_To__c  = examAdmin2.id;
        examRegMod.Part_II_Exam_Admin_To__c  = examAdmin2.id ;
        examRegMod.Status__c = 'Pending';
        insert examRegMod ;
        
        Contract frmProgram = new Contract(
            AccountId = account.Id,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'OSTA Program'),
            Status = 'Draft',
            Name = 'FRM Program',
            StartDate = Date.today(),
            ContractTerm = 9999
        );
        
        INSERT frmProgram;
        frmProgram.Status = 'Activated';
        UPDATE frmProgram; 
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'New Lead';
        opportunity.CloseDate = Date.today();
        INSERT opportunity;
        
        Set<Id> setId = new Set<Id>();
        setId.add(examRegMod.Id);
        GARP_ExamManagement.processExamRegMods(setId,false,false);
    }
    
    @isTest
    public static void processExamRegModsFromClient(){
        setup();
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteNonChinaExamPart1.Id;
        INSERT examRegistration;
        
        GARP_ExamManagementRemoter.processExamRegModsFromClient(examRegistration.Id);
    }
    
    @isTest
    public static void findRefundOpp(){
        setup();
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteNonChinaExamPart1.Id;
        INSERT examRegistration;
        
        Exam_Attempt__c examRegistration1 = new Exam_Attempt__c();
        examRegistration1.Member__c = contact.Id;
        examRegistration1.Opportunity__c = opportunity.Id;
        examRegistration1.Exam_Site__c = examSiteNonChinaExamPart1.Id;
        examRegistration1.Cloned_From__c = examRegistration.Id;
        INSERT examRegistration1;
        
        GARP_ExamManagement.findRefundOpp(examRegistration1);
    }
    
    @isTest
    public static void issueProductRefund(){
        setup();
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteNonChinaExamPart1.Id;
        INSERT examRegistration;
        
        
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        opportunityLineItem.Exam_Registration__c = examRegistration.Id;
        opportunityLineItem.OpportunityId = opportunity.Id;
        opportunityLineItem.Product2Id = CHLF.Id;
        opportunityLineItem.UnitPrice = 100.00;
        opportunityLineItem.Quantity = 1;
        opportunityLineItem.PricebookEntryId = CHLFPBE.Id;
        INSERT opportunityLineItem;
        
        GARP_ExamManagement.issueProductRefund(opportunity.Id , 'CHLF', 1);
    }
    
    @isTest
    public static void createOppLineItem(){
        setup();
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteNonChinaExamPart1.Id;
        INSERT examRegistration;
        
        
        
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        opportunityLineItem.Exam_Registration__c = examRegistration.Id;
        opportunityLineItem.OpportunityId = opportunity.Id;
        opportunityLineItem.Product2Id = CHLF.Id;
        opportunityLineItem.UnitPrice = 100.00;
        opportunityLineItem.Quantity = 1;
        opportunityLineItem.PricebookEntryId = CHLFPBE.Id;
        INSERT opportunityLineItem;
        
        //List<prodLine> lstProds = new List<prodLine>();
        GARP_ExamManagement.prodLine pc = new GARP_ExamManagement.prodLine();
        pc.prodCode = 'CHLF';
        pc.glCode = '2008';
        pc.description = 'OSTA Location Fee';
        pc.amount = 200;
        pc.examRegId = examRegistration.Id;
        
        
        MAP<String, Product2> mapProduct = new MAP<String, Product2>();
        mapProduct.put('CHLF',CHLF);
        
        MAP<String, PricebookEntry> mapPrice = new MAP<String, PricebookEntry>();
        String mapPriceId = CHLFPBE.Id;
        String oppId = opportunity.Id;
        String strmMapPrice = CHLF.ID;
        mapPrice.put(mapPriceId,CHLFPBE);
        mapPrice.put(strmMapPrice,CHLFPBE);
        GARP_ExamManagement.createOppLineItem(oppId , pc, mapProduct,mapPrice);
    }
    
    @isTest
    public static void cancelOstaProgram(){
        setup();
        Contract program = new Contract(
            AccountId = account.Id,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'OSTA Program'),
            Name = 'Activated'
        );
        INSERT program ;
        program.Status = 'Activated';
        update program;
        
        GARP_ExamManagement.cancelOstaProgram(account.Id);
    }
    
    @isTest
    public static void issueRefundNew(){
        setup();
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteNonChinaExamPart1.Id;
        INSERT examRegistration;
        
        
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        opportunityLineItem.Exam_Registration__c = examRegistration.Id;
        opportunityLineItem.OpportunityId = opportunity.Id;
        opportunityLineItem.Product2Id = CHLF.Id;
        opportunityLineItem.UnitPrice = 100.00;
        opportunityLineItem.Quantity = 1;
        opportunityLineItem.PricebookEntryId = CHLFPBE.Id;
        INSERT opportunityLineItem;
        
        MAP<Id,Opportunity> mapOpp = new MAP<Id,Opportunity>([select Id, AccountId,Name,
                                    (SELECT Id, ProductCode, Product2Id, Product2.ProductCode, Description, PricebookEntryId, Quantity, UnitPrice, SortOrder, TotalPrice FROM OpportunityLineItems),
                                    (SELECT Id, ChargentSFA__Opportunity__c, ChargentSFA__Response_Status__c, ChargentSFA__Amount__c FROM ChargentSFA__Transactions__r 
                                     WHERE ChargentSFA__Response_Status__c = 'Approved' ORDER BY ChargentSFA__Amount__c ASC),
                                    (select Id, Name, Opportunity__c from Product_Refunds__r where Product_Code__c = 'CHLF' AND Status__c != 'Denied')
                                    from Opportunity where ID =: opportunity.Id]);
        
        GARP_ExamManagement.issueProductRefund(mapOpp.get(opportunity.id), 'CHLF', 1);
    }
    
    @isTest
    public static void computeOSTAProgramMoves(){
        setup();
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Attempt__c examRegistration1 = new Exam_Attempt__c();
        examRegistration1.Member__c = contact.Id;
        examRegistration1.Opportunity__c = opportunity.Id;
        examRegistration1.Exam_Site__c = examSiteNonChinaExamPart1.Id;
        INSERT examRegistration1;
        
        Exam_Attempt__c examRegistration2 = new Exam_Attempt__c();
        examRegistration2.Member__c = contact.Id;
        examRegistration2.Opportunity__c = opportunity.Id;
        examRegistration2.Exam_Site__c = examSiteNonChinaExamPart2.Id;
        INSERT examRegistration2;
        
        Exam_Administration__c examAdmin1 = new Exam_Administration__c();
        examAdmin1.Exam_Group__c = examGroup.id;
        examAdmin1.Exam_Date__c = system.today();
        examAdmin1.Exam_Results_Release_Date__c = DateTime.now().addDays(90);
        insert examAdmin1;
        
        system.debug('examSiteChinaExamPart1=======>'+examSiteChinaExamPart1);
        system.debug('testSiteChina==========>'+testSiteChina);
        GARP_ExamManagement.computeOSTAProgramMoves(examRegistration1, examRegistration2, examSiteChinaExamPart1,
                                                                 examSiteChinaExamPart2, examAdmin1, examAdmin1,examSiteChinaExamPart1, 
                                                                 examSiteChinaExamPart2, examAdmin1, examAdmin1);
    }
	
    @isTest
    public static void getExamPartNumber(){
        setup();
        GARP_ExamManagement.getExamPartNumber('ERP Exam Part I');
        GARP_ExamManagement.getExamPartNumber('ERP Exam Part II');
        GARP_ExamManagement.getExamPartNumber('abc');
    }
    
    @isTest
    public static void getExamRescheduleData(){
        setup();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' limit 1]; 
        User user = new User(Alias = 'nUser', Email='newuser@testorg.com', 
                             contactId = contact.id,EmailEncodingKey='UTF-8', 
                             LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', 
                             UserName='nuser123@testorg.com');
        system.debug('user.id=============>'+user.id);
        system.debug('user.contactId=============>'+user.contactId);
        Contract Program = new Contract(
            AccountId = account.Id,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program'),
            Name = 'Test Contract'
        );
        INSERT Program ;
        
        Program.Status = 'Activated';
        update Program;
        
        Exam_Administration__c examAdmin1 = new Exam_Administration__c();
        examAdmin1.Exam_Group__c = examGroup.id;
        examAdmin1.Exam_Date__c = system.today();
        examAdmin1.Exam_Type__c = 'FRM' ;
        examAdmin1.Exam_Results_Release_Date__c = DateTime.now().addDays(90);
        insert examAdmin1;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
        
        Exam_Part__c expart1 = new Exam_Part__c();
        expart1.Exam__c = frmPart2.Id;
        expart1.Exam_Administration__c = examAdmin1.Id ;
        expart1.Delivery_Method__c = 'CBT';
        expart1.Exam_Start_Date__c = Date.today();
        expart1.Exam_Date__c = Date.today();
        expart1.Exam_End_Date__c = Date.today().addDays(10);
        
        insert expart1;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Opportunity__c = opportunity.Id;
        examRegistration.Exam_Site__c = examSiteChinaExamPart1.Id;
        INSERT examRegistration;
        
        Exam_Attempt__c examRegistration1 = new Exam_Attempt__c();
        examRegistration1.Member__c = contact.Id;
        examRegistration1.Opportunity__c = opportunity.Id;
        examRegistration1.Exam_Site__c = examSiteChinaExamPart2.Id;
        INSERT examRegistration1;
        
        String userId = UserInfo.getUserId();
        GARP_ExamManagement.getExamRescheduleData(examGroup.id, 'FRM', examAdmin1.Id, examAdmin1.Id, examSiteChinaExamPart1.Id, examSiteChinaExamPart1.Id,userId);
        GARP_ExamManagement.getExamRescheduleData(examGroup.id, 'ERP', examAdmin1.Id, examAdmin1.Id, examSiteChinaExamPart1.Id, examSiteChinaExamPart1.Id,userId);
        GARP_ExamManagement.getExamRescheduleData(examGroup.id, 'ABC', examAdmin1.Id, examAdmin1.Id, examSiteChinaExamPart1.Id, examSiteChinaExamPart1.Id,userId);
        
        GARP_ExamManagementRemoter.createExamRescheduleFeesOrder(examGroup.id, 'FRM', examAdmin1.Id, examAdmin1.Id, examSiteChinaExamPart1.Id, examSiteChinaExamPart1.Id);
        
    }
    
    @isTest
    public static void getExamRescheduleInformation(){
        setup();
        GARP_ExamManagementRemoter.getExamRescheduleInformation(examGroup.id, 'FRM');
        GARP_ExamManagementRemoter.getExamRescheduleInformation(examGroup.id, 'ERP');
        GARP_ExamManagementRemoter.getExamRescheduleInformation(examGroup.id, 'ABC');
    }
    @isTest
    public static void testTransaction() {
        setup();
        Account acc = [Select Id from Account Limit 1];
        Opportunity opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        GARP_ExamManagement.createTransaction(opp.Id);
    }
    
    @isTest
    public static void createExamRescheduleFeesOrder() {
        setup();
        
        
        List<Product2> Product2List = new List<Product2>();
        Product2 p1 = new Product2(Name = ' Test Product1',Description='Test Product Entry1 For Product',productCode = 'FRM1X',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '5',Weight__c=5,GL_Code__c='4011');
        Product2List.add(p1);
        Product2 p2 = new Product2(Name = ' Test Product2',Description='Test Product Entry2 For Product',productCode = 'CHLF',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '6',Weight__c=6,GL_Code__c='4011');
        Product2List.add(p2);
        insert Product2List;
        
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        Update standardPricebook;
        
        List<PricebookEntry> PricebookEntryList = new List<PricebookEntry>();
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = Product2List[0].Id,UnitPrice = 250,IsActive = true,UseStandardPrice = false);
        PricebookEntryList.add(standardPrice1);
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = Product2List[1].Id,UnitPrice = 250,IsActive = true,UseStandardPrice = false);
        PricebookEntryList.add(standardPrice2);
        insert PricebookEntryList ;
        
        Account acc = [Select Id from Account Limit 1];
        List<Opportunity> OppResults= new List<Opportunity>();
        Opportunity opp1 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        Opportunity opp2 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'Closed',Program__c = 'Print' ,closedate = system.today()+ 15);        
        OppResults.add(opp1);
        OppResults.add(opp2);
        insert OppResults;
        
        
        List<Exam_Attempt__c> examRegistrations = new List<Exam_Attempt__c>();
        
        Exam_Attempt__c examRegistration1 = new Exam_Attempt__c();
        examRegistration1.Member__c = contact.Id;
        examRegistration1.Opportunity__c = OppResults[0].Id;
        examRegistration1.Exam_Site__c = examSiteChinaExamPart2.Id;
        examRegistrations.add(examRegistration1);
        INSERT examRegistrations;
        
        Contract frmProgram = new Contract(AccountId = account.Id,CustomerSignedId = contact.Id,RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program'),Status = 'Draft',Name = 'FRM Program', StartDate = Date.today(), ContractTerm = 9999);
        INSERT frmProgram;        
        frmProgram.Status = 'Activated ( Auto-Renew )';
        UPDATE frmProgram;
        
        Scholarship_Application__c sa = new Scholarship_Application__c(Applicant__c = frmProgram.CustomerSignedId,
                                                                       Exam_Type__c='FRM',Status__c='Submitted', Exam_Group__c= examGroup.Id);
        insert sa;
        
        List<OpportunityLineItem> OpportunityLineItemList = new List<OpportunityLineItem>();
        OpportunityLineItem oppLineItem1 = new OpportunityLineItem(OpportunityId = OppResults[0].Id,PricebookEntryId = PricebookEntryList[0].Id,UnitPrice = 7000,Description='test',
                                                                   Quantity = 5,Product_company__c='GRA Test',Exam_Registration__c = examRegistrations[0].Id,Scholarship_Application__c = sa.Id);
        OpportunityLineItemList.add(oppLineItem1);
        OpportunityLineItem oppLineItem2 = new OpportunityLineItem(OpportunityId = OppResults[1].Id,PricebookEntryId = PricebookEntryList[1].Id,UnitPrice = 7000,Description='test',
                                                                   Quantity = 5,Product_company__c='GRA Test',Exam_Registration__c = examRegistrations[0].Id,Scholarship_Application__c = sa.Id);
        OpportunityLineItemList.add(oppLineItem2);
        insert OpportunityLineItemList;
        
        
        ChargentSFA__Transaction__c payment = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = OppResults[0].id,ChargentSFA__Type__c = 'Charge',
                                                                              ChargentSFA__Response_Status__c= 'Approved');
        insert payment;
        
        ChargentSFA__Transaction__c payment1 = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = OppResults[1].id,ChargentSFA__Type__c = 'Charge',
                                                                               ChargentSFA__Response_Status__c= 'Approved');
        insert payment1;
        
        
        List<Product_Refunds__c> ProductRefundsList = new List<Product_Refunds__c>();
        Product_Refunds__c refund1 = new Product_Refunds__c (Status__c='Completed',Cancel_E_book__c = True,Take_Membership__c = true,Refund_amount__c =123,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[0].id,Payment_Transaction__c = payment.id);
        ProductRefundsList.add(refund1);
        Product_Refunds__c refund2 = new Product_Refunds__c (Status__c='Completed',Cancel_ERP_Enrollment__c = True,Take_Membership__c = true,Refund_amount__c =123,
                                                             opportunity__c = OppResults[1].id,product__c = Product2List[1].id,Payment_Transaction__c = payment1.id);
        ProductRefundsList.add(refund2);
        insert ProductRefundsList;
        
        Map<Id, Exam_Attempt__c> examRegistrationsMap = new Map<Id, Exam_Attempt__c>([SELECT Id,Opportunity__c,(SELECT id,OpportunityId,Exam_Registration__c,Product_company__c,Product2Id,Description,Quantity,UnitPrice,PricebookEntryId,Scholarship_Application__c from Opportunity_Line_Items__r) FROM Exam_Attempt__c LIMIT 50]);
            Set<Id> oppId = new Set<Id>();
        oppId.add(OppResults[0].Id);
        oppId.add(OppResults[1].Id);
        
        
        GARP_ExamManagement.getAllOpportunityIdsByExamRegistration(examRegistration1);
        GARP_ExamManagement.getAllOpportunityIdsByExamRegistrations(examRegistrations);
        GARP_ExamManagement.createChinaLocationFeeProductRefunds(examRegistrationsMap,oppId);
        GARP_ExamManagement.createExamRescheduleOpp(null,null);
        
    }
	
	
    
    @isTest
    public static void remainingTests() {
		setup();
        List<Exam_Attempt__c> attemptList = new List<Exam_Attempt__c>();
		
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' limit 1]; 
        User user = new User(Alias = 'nUser', Email='newuser@testorg.com', 
                             contactId = contact.id,EmailEncodingKey='UTF-8', 
                             LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', 
                             UserName='nuser123@testorg.com');
        system.debug('user.id=============>'+user.id);
        system.debug('user.contactId=============>'+user.contactId);
        Contract Program = new Contract(
            AccountId = account.Id,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program'),
            Name = 'Test Contract'
        );
        INSERT Program ;
        
        Program.Status = 'Activated';
        update Program;
        
        Exam_Administration__c examAdmin1 = new Exam_Administration__c();
        examAdmin1.Exam_Group__c = examGroup.id;
        examAdmin1.Exam_Date__c = system.today();
        examAdmin1.Exam_Type__c = 'FRM' ;
        examAdmin1.Exam_Results_Release_Date__c = DateTime.now().addDays(90);
        insert examAdmin1;
        
		/*
        Opportunity opportunity = new Opportunity();
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        Insert opportunity;
		*/
		
        
        Opportunity opportunity = new Opportunity();
        opportunity.AccountId = account.Id;
        opportunity.Amount = 700.00;
        opportunity.Name = 'TEST';
        opportunity.StageName = 'Closed';
        opportunity.CloseDate = Date.today();
        INSERT opportunity;
        
        Exam_Part__c expart1 = new Exam_Part__c();
        expart1.Exam__c = frmPart2.Id;
        expart1.Exam_Administration__c = examAdmin1.Id ;
        expart1.Delivery_Method__c = 'CBT';
        expart1.Exam_Start_Date__c = Date.today();
        expart1.Exam_Date__c = Date.today();
        expart1.Exam_End_Date__c = Date.today().addDays(10);
        
        insert expart1;
        
        Exam_Attempt__c examRegistration11 = new Exam_Attempt__c();
        examRegistration11.Member__c = contact.Id;
        examRegistration11.Opportunity__c = opportunity.Id;
        examRegistration11.Exam_Site__c = examSiteChinaExamPart1.Id;
        attemptList.add(examRegistration11);
        
        Exam_Attempt__c examRegistration1 = new Exam_Attempt__c();
        examRegistration1.Member__c = contact.Id;
        examRegistration1.Opportunity__c = opportunity.Id;
        examRegistration1.Exam_Site__c = examSiteChinaExamPart2.Id;
        INSERT examRegistration1;
        
        String userId = UserInfo.getUserId();
        GARP_ExamManagement.getExamRescheduleData(examGroup.id, 'FRM', examAdmin1.Id, examAdmin1.Id, examSiteChinaExamPart1.Id, examSiteChinaExamPart1.Id,userId);
        GARP_ExamManagement.getExamRescheduleData(examGroup.id, 'ERP', examAdmin1.Id, examAdmin1.Id, examSiteChinaExamPart1.Id, examSiteChinaExamPart1.Id,userId);
        GARP_ExamManagement.getExamRescheduleData(examGroup.id, 'ABC', examAdmin1.Id, examAdmin1.Id, examSiteChinaExamPart1.Id, examSiteChinaExamPart1.Id,userId);
        
		
		
		
		/*
		Exam_Administration__c examAdmin1 = new Exam_Administration__c();
        examAdmin1.Exam_Group__c = examGroup.id;
        examAdmin1.Exam_Date__c = system.today().addDays(-5);
        examAdmin1.Exam_Results_Release_Date__c = DateTime.now().addDays(90);
        insert examAdmin1;*/
        
        Exam_Administration__c examAdmin2 = new Exam_Administration__c();
        examAdmin2.Exam_Group__c = nextExamGroup.id;
        examAdmin2.Exam_Date__c = system.today().addDays(10);
        examAdmin2.Exam_Start_Date__c = system.today().addDays(5);
        examAdmin2.Exam_Type__c = 'FRM' ;
        examAdmin2.Exam_Results_Release_Date__c = DateTime.now().addDays(90);
        insert examAdmin2;
        
        Exam_Attempt__c examRegistration = new Exam_Attempt__c();
        examRegistration.Member__c = contact.Id;
        examRegistration.Exam_Part__c = exampart.Id;
        examRegistration.Exam_Administration__c = examAdmin1.Id;
        examRegistration.Exam_Site__c = examSiteChinaExamPart1.Id;
        attemptList.add(examRegistration);
        
        Exam_Attempt__c examRegistration111 = new Exam_Attempt__c();
        examRegistration111.Member__c = contact.Id;
        examRegistration111.Exam_Part__c = exampart.Id;
        examRegistration111.Exam_Administration__c = examAdmin1.Id;
        examRegistration111.Exam_Site__c = examSiteChinaExamPart1.Id;
        attemptList.add(examRegistration111);
        
        Exam_Attempt__c examRegistration2 = new Exam_Attempt__c();
        examRegistration2.Member__c = contact.Id;
        examRegistration2.Exam_Part__c = exampart2.Id;
        examRegistration2.Exam_Administration__c = examAdmin1.Id;
        examRegistration2.Exam_Site__c = examSiteNonChinaExamPart2.Id;
        attemptList.add(examRegistration2);
        INSERT attemptList;
        
        Exam_Registration_Modification__c examRegMod = new Exam_Registration_Modification__c();
        // examRegMod.Contact_Name__c = contact.Id;
        examRegMod.Part_I_Exam_Admin_From__c = examAdmin1.id ;
        examRegMod.Part_II_Exam_Admin_From__c  = examAdmin1.id ;
        examRegMod.Part_I_Exam_Registration__c = examRegistration.id;
        examRegMod.Part_II_Exam_Registration__c = examRegistration2.id;
        examRegMod.Part_I_Exam_Admin_To__c  = examAdmin2.id;
        examRegMod.Part_II_Exam_Admin_To__c  = examAdmin2.id ;
        examRegMod.Status__c = 'Pending';
        insert examRegMod ;
        
        Exam_Registration_Modification__c examRegMod1 = new Exam_Registration_Modification__c();
        examRegMod1.Part_I_Exam_Admin_From__c = examAdmin1.id ;
        examRegMod1.Part_I_Exam_Registration__c = examRegistration111.id;
        examRegMod1.Part_I_Exam_Admin_To__c  = examAdmin2.id;
        examRegMod1.Part_I_Exam_Site_From__c  = examSiteChinaExamPart1.id ;
        examRegMod1.Part_I_Exam_Site_To__c  = examSiteNonChinaExamPart1.id ;
        examRegMod1.Status__c = 'Pending';
        insert examRegMod1 ;
        
        Contract frmProgram = new Contract(
            AccountId = account.Id,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'OSTA Program'),
            Status = 'Draft',
            Name = 'FRM Program',
            StartDate = Date.today(),
            ContractTerm = 9999
        );
        
        INSERT frmProgram;
        frmProgram.Status = 'Activated';
        UPDATE frmProgram; 
        
        Set<Id> setId = new Set<Id>();
        setId.add(examRegMod.Id);
        setId.add(examRegMod1.Id);
        GARP_ExamManagement.processExamRegMods(setId,false,false);
        
        GARP_ExamManagementRemoter.createExamRescheduleFeesOrder(examGroup.id, 'FRM', examAdmin1.Id, examAdmin1.Id, examSiteChinaExamPart1.Id, examSiteChinaExamPart1.Id);
        GARP_ExamManagement.createExamRescheduleFeesOrderInternal(examGroup.id, 'FRM', examAdmin1.Id, examAdmin1.Id, examSiteChinaExamPart1.Id, examSiteChinaExamPart1.Id,userinfo.getUserId(),true);
	}
}