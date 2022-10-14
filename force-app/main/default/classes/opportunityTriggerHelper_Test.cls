@isTest
public class opportunityTriggerHelper_Test {
    
    static Account acc ;
    static Opportunity opp; 
    static ChargentSFA__Transaction__c chargentTrans;
    static Contact contact; 
    static list<Exam_Attempt__c> attempt3;
    static Exam_Attempt__c attempt;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contract Contract;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Candidate_Requirement__c reqt;
    static list<ChargentSFA__Transaction__c> tran;
    static list<Product_Refunds__c> pr;
    
    static void testData(){ 
        // Inst Sale Supported Product Codes: 
        // FRM1,FRM2,FRM1E,FRM2E,FRM1S,FRM2S,FRM1L,FRM2L,ENC1E,ENC2E,ENC1S,ENC2S,ENC1L,ENC2L,ENC,FFR,FCBR,FBRNM,CBR,CBRHB,CBRNM,FRM1H,FRM2H,FRM1X,FRM2X,ENC1B,ENC2B,ENC1X,ENC2X,MEMI

        TestClassUtil.isForOldTrigger();
        Product2 prod3 = new Product2(Name = 'enrollment',productCode = 'FRM1X',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod3;
        
        Product2 prod4 = new Product2(Name = 'enrollment',productCode = 'ENC',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod4;
        
        Product2 prod5 = new Product2(Name = 'enrollment',productCode = 'ENC1X',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod5;
        
        // Changed from FRMRET1 to FRM1
        Product2 prod8 = new Product2(Name = 'enrollment',productCode = 'FRM1',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod8;
        
        // Changed from CHLF to FRM1E
        Product2 prod10 = new Product2(Name = 'enrollment',productCode = 'FRM1E',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod10;
        
        // Changed from ERPRET1 to ENC1B
        Product2 prod11 = new Product2(Name = 'enrollment',productCode = 'ENC1B',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod11;
        
        Product2 prod12 = new Product2(Name = 'enrollment',productCode = 'CBRNM',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod12;
        
        Product2 prod13 = new Product2(Name = 'enrollment',productCode = 'FCBR',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod13;
        
        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> lstPriceBook = new List<PricebookEntry>();
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        lstPriceBook.add(standardPrice3);
        
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id,UnitPrice = 10000, IsActive = true);
        lstPriceBook.add(standardPrice4);
        
        PricebookEntry standardPrice5 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod5.Id,UnitPrice = 10000, IsActive = true);
        lstPriceBook.add(standardPrice5);
        
        
        PricebookEntry standardPrice8 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod8.Id,UnitPrice = 10000, IsActive = true);
        lstPriceBook.add(standardPrice8); 
        
        PricebookEntry standardPrice10 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod10.Id,UnitPrice = 10000, IsActive = true);
        lstPriceBook.add(standardPrice10);
        
        PricebookEntry standardPrice11 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod11.Id,UnitPrice = 10000, IsActive = true);
        lstPriceBook.add(standardPrice11); 
        
        PricebookEntry standardPrice12 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod12.Id,UnitPrice = 10000, IsActive = true);
        lstPriceBook.add(standardPrice12);
        
        PricebookEntry standardPrice13 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod13.Id,UnitPrice = 10000, IsActive = true);
        lstPriceBook.add(standardPrice13);
        
        insert lstPriceBook;
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        
        // ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        
        contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        Id manualRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Manual'); 
        opp = new Opportunity(amount = 123,Name = 'Test', ChargentSFA__Billing_First__c='sdfsdfsdgsfgsf' , ChargentSFA__Billing_Last__c ='svsvfvvfsf',ChargentSFA__Gateway__c =chrgGtway.id,RecordTypeID = manualRecId,Inst_Sale_Service_End_Date__c=system.today()+ 15,Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print',Inst_Sale_Code__c = 'Promocode',Institutional_Sale__c = TRUE,Institutional_Sale_Stage__c = 'Approved',closedate = system.today()+ 15);        
        insert opp;
        
        
        OpportunityLineItem oppli3 = new OpportunityLineItem();
        oppli3.Quantity=1;
        oppli3.OpportunityId=opp.Id; 
        oppli3.TotalPrice=10;
        oppli3.PriceBookEntryId = standardPrice3.Id;
        insert oppli3;
        
        OpportunityLineItem oppli4 = new OpportunityLineItem();
        oppli4.Quantity=1;
        oppli4.OpportunityId=opp.Id; 
        oppli4.TotalPrice=250;
        oppli4.PriceBookEntryId = standardPrice4.Id;
        insert oppli4;
        
        
        OpportunityLineItem oppli5 = new OpportunityLineItem();
        oppli5.Quantity=1;
        oppli5.OpportunityId=opp.Id; 
        oppli5.TotalPrice=10;
        oppli5.PriceBookEntryId = standardPrice5.Id;
        insert oppli5;
        
        
        OpportunityLineItem oppli8 = new OpportunityLineItem();
        oppli8.Quantity=1;
        oppli8.OpportunityId=opp.Id; 
        oppli8.TotalPrice=10;
        oppli8.PriceBookEntryId = standardPrice8.Id;
        insert oppli8;
        
        
        OpportunityLineItem oppli10 = new OpportunityLineItem();
        oppli10.Quantity=1;
        oppli10.OpportunityId=opp.Id; 
        oppli10.TotalPrice=10;
        oppli10.PriceBookEntryId = standardPrice10.Id;
        insert oppli10;
        
        OpportunityLineItem oppli11 = new OpportunityLineItem();
        oppli11.Quantity=1;
        oppli11.OpportunityId=opp.Id; 
        oppli11.TotalPrice=10;
        oppli11.PriceBookEntryId = standardPrice11.Id;
        insert oppli11;
        
        OpportunityLineItem oppli12 = new OpportunityLineItem();
        oppli12.Quantity=1;
        oppli12.OpportunityId=opp.Id; 
        oppli12.TotalPrice=10;
        oppli12.PriceBookEntryId = standardPrice12.Id;
        insert oppli12;
        
       /* OpportunityLineItem oppli13 = new OpportunityLineItem();
        oppli13.Quantity=1;
        oppli13.OpportunityId=opp.Id; 
        oppli13.TotalPrice=10;
        oppli13.PriceBookEntryId = standardPrice13.Id;
        insert oppli13;
        */
        
        ChargentSFA__Transaction__c tran1 = new ChargentSFA__Transaction__c();
        list<ChargentSFA__Transaction__c> tran = new list<ChargentSFA__Transaction__c>();
        
        tran1.ChargentSFA__Opportunity__c =opp.id;
        tran1.ChargentSFA__Response__c ='0';
        tran1.ChargentSFA__Response_Status__c ='Approved';
        tran1.ChargentSFA__Type__c  ='charge';
        tran.add(tran1);
        insert tran1;
        
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('ERP Program').getRecordTypeId();
        
        contract = new contract();
        contract.Opportunity__c = opp.id;
        contract.AccountId = acc.id;
        contract.recordTypeId = rtId;
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
        exam.exam__c = 'ERP Exam Part I'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false);
        insert attempt;
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'ERP1 test';
        insert reqt;
        
        
        
    }   
    
    static testMethod void myUnitTest_1() {
        
        list<Opportunity> opp1 = new list <Opportunity>();
        
        test.startTest();
        
        testData();
        
        opportunity opportunity2 = [select id, Wiley__c ,Has_Books__c,Auto_Renew__c, ChargentSFA__Billing_First__c , ChargentSFA__Billing_Email__c , ChargentSFA__Billing_Last__c ,Eligible_for_Membership_Extension__c ,Renew_Membership__c,EA_Id__c,Inst_Sale_Emails__c,Institutional_Sale_Stage__c ,Institutional_Sale__c ,RecordTypeId ,Shipping_Country__c ,Undefred_EA_Id__c, Shipping_Street__c, Late_EA_Id__c ,AccountId, stagename from opportunity where id =:opp.id];
   
        opp1.add(opportunity2);
        
        opportunityTriggerHelper.opportunityTriggerHelper(opp1);

        test.stopTest();     
        
    }

    @IsTest
    private static void createAndCloseChinaFrmRegistration(){
        TestClassUtil.isForOldTrigger();
        ExamRegistrationTestDataFactory.setupCaptcha();
        ExamRegistrationTestDataFactory.setupChargent();
        ExamRegistrationTestDataFactory.setupAccountOwner();     
        ExamRegistrationTestDataFactory.setupActivePricebook();
        ExamRegistrationTestDataFactory.setupFeeProducts();
        ExamRegistrationTestDataFactory.setupBookProducts();
        ExamRegistrationTestDataFactory.setupExamRegistrationDependencyObjects();
        
        User user = ExamRegistrationTestDataFactory.createExamRegistration('FRM', 'Check', 'TESTUSERONE', FALSE, TRUE);
        
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName,
            (SELECT Id, Exam_Site__r.Site__c FROM Exam_Registrations__r),
            (SELECT Id, ProductCode, UnitPrice FROM OpportunityLineItems)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
            LIMIT 1
        ];
        
        opportunity.Has_Books__c = true;

        for(OpportunityLineItem oli: opportunity.OpportunityLineItems){
            if(oli.ProductCode == 'FRM1'){
                oli.UnitPrice = 250;
                UPDATE oli;
                break;
            }
        }

        Test.startTest();

        opportunity.StageName = 'Closed';

        opportunityTriggerHelper.isFirstRun = true;
        
        UPDATE opportunity;
        
        Test.stopTest();

    }

    @IsTest
    private static void createAndCloseChinaErpRegistration(){
        TestClassUtil.isForOldTrigger();
        ExamRegistrationTestDataFactory.setupCaptcha();
        ExamRegistrationTestDataFactory.setupChargent();
        ExamRegistrationTestDataFactory.setupAccountOwner();     
        ExamRegistrationTestDataFactory.setupActivePricebook();
        ExamRegistrationTestDataFactory.setupFeeProducts();
        ExamRegistrationTestDataFactory.setupBookProducts();
        ExamRegistrationTestDataFactory.setupExamRegistrationDependencyObjects();
        
        User user = ExamRegistrationTestDataFactory.createExamRegistration('ERP', 'Check', 'TESTUSERONE', FALSE, TRUE);
        system.debug(user);
        Opportunity opportunity = [
            SELECT Id, AccountId, StageName,
            (SELECT Id, Exam_Site__r.Site__c FROM Exam_Registrations__r),
            (SELECT Id, ProductCode, UnitPrice FROM OpportunityLineItems)
            FROM Opportunity 
            WHERE AccountId = :user.AccountId
            LIMIT 1
        ];

        opportunity.Has_Books__c = true;
        
        for(OpportunityLineItem oli: opportunity.OpportunityLineItems){
            if(oli.ProductCode == 'ENC1'){
                oli.UnitPrice = 250;
                UPDATE oli;
                break;
            }
        }

        Test.startTest();

        opportunity.StageName = 'Closed';

        opportunityTriggerHelper.isFirstRun = true;
        
        UPDATE opportunity;
        
        Test.stopTest();

    }
    
}