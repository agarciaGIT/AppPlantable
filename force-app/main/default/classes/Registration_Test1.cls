@isTest
private class Registration_Test1 {
    
    static Account acc ;
    static Opportunity opp,opp1; 
    static TempAccount tempaccount;
    static Contact contact;
    static contact contact1;
    static Team_Registration__c TeamReg;
    static Exam_Attempt__c attempt;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contract contract,Contract1;
    static Lead lead;
    static Pricebook2 customPB;
    static Exam_Group__c objExamGrp;
    static Exam__c exam,exam4,exam2,exam3;
    static Candidate_Requirement__c reqt,reqt1,reqt2,reqt3,reqt4;
    static Chapter__c chapter;
    static Chapter_Meeting__c chapMeeting ;
    static Chapter_Meeting_Registration__c meetingReg;
    
    static Exam_Attempt__c attempt1;
    static Exam_Attempt__c attempt2;
    static Exam_Sites__c exmSite1;
    static Site__c site1;
    static Exam__c exam1;
    static Registration.wrapperProductInfo reg = new Registration.wrapperProductInfo();
    static Map<String,Registration.wrapperProductInfo> RegWrapProdInfo= new Map<String,Registration.wrapperProductInfo>();    
    
    static List<Product_Rate_Offering__c> ProRateList = new List<Product_Rate_Offering__c>();
    static List<Product2> Product2List = new List<Product2>();
    
    static List<Team_Registration_Products__c> TeamRegList = new List<Team_Registration_Products__c>();
    Static Event__c Eventobj = new Event__c();
    Static Event_Registration__c eventRegistrationForEventobj = new Event_Registration__c();
    
    Static tempAccount.productDefinition prd = new tempAccount.productDefinition();
    static List<tempAccount.productDefinition> prdList = new List<tempAccount.productDefinition>();
    
    static registration.verifyBulkOrderReturnData verBulkRet = new registration.verifyBulkOrderReturnData();
	static registration.bulkOrderReturnData bulkTest = new registration.bulkOrderReturnData();
    static List<Opportunity> opplist = new List<Opportunity>() ;
    @testSetup
    static void setupTestData(){
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testContact',AccountId = ac.Id);
        insert con;  
        
        Profile pf= [Select Id from profile where Name='Customer Community']; //System Administrator
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', lastName = 'XYZ', email = uniqueName + '@test' + orgId + '.org',ContactId = con.Id, 
                         Username = uniqueName + '@test' + orgId + '.org', EmailEncodingKey = 'ISO-8859-1',IsActive =true, 
                         Alias = uniqueName.substring(18, 23), TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US', ProfileId = pf.Id);
        insert uu;
    }
    
    static void testData(){ 
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod2; 
        
        Product2 prod3 = new Product2(Name = 'Laptop X200',productCode = 'FRM2S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod3;
        
        Product2 prod4 = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod4;
        
        Product2 prod5 = new Product2(Name = 'Laptop X200',productCode = 'FCBR',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod5;
        
        Product2 prod6 = new Product2(Name = 'Laptop X200',productCode = 'FBRNM',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod6;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice2;
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice3;
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice4;
        PricebookEntry standardPrice5 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod5.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice5;
        PricebookEntry standardPrice6 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod6.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice6;
        
        customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(
            Name = 'Test',
            ChargentBase__Active__c = TRUE,
            ChargentBase__Test_Mode__c = TRUE
        );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        
        Id manualRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Manual'); 
        Id manualRecId1 = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
        Opportunity opp0 = new Opportunity(amount = 0,Name = 'Test1',RecordTypeID = manualRecId,
                                           accountId = acc.id,stageName = 'closed',Program__c = 'Print',
                                           Institutional_Sale__c = False,closedate = system.today()+ 15); 
        
        insert opp0;
        
        Opportunity opp1 = new Opportunity(amount = 0,Name = 'Test-opp1',RecordTypeID = manualRecId1, 
                              Inst_Sale_Service_End_Date__c=system.today()+ 120,
                              accountId = acc.id,stageName = 'closed',Institutional_Sale__c = True,
                              Institutional_Sale_Stage__c = 'Draft',Inst_Sale_Emails__c = 'test1@test.com',
                              closedate = system.today()+ 125,Inst_Sale_Opp__c = opp0.id,
                              Inst_Sale_Email_Domain_Verification__c = 'test1@testmail.com');
        insert opp1;        
        
        opp = new Opportunity(amount = 123,Name = 'Test',RecordTypeID = manualRecId, 
                              Inst_Sale_Service_End_Date__c=system.today()+ 15,
                              Eligible_for_Membership_Extension__c = false,company__c = 'Payment', 
                              accountId = acc.id,stageName = 'New Lead',Program__c = 'Print',
                              Inst_Sale_Code__c = 'Promocode',Institutional_Sale__c = True,
                              Institutional_Sale_Stage__c = 'Approved',Inst_Sale_Emails__c = 'test@test.com',
                              closedate = system.today()+ 15,Inst_Sale_Opp__c = opp1.id,
                              Inst_Sale_Email_Domain_Verification__c = 'test@testmail.com');        
        insert opp;
        
        //opplist.add(opp);
        PricebookEntry customPrice2 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod2.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice2;
        
        PricebookEntry customPrice3 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod3.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice3;
        
        PricebookEntry customPrice4 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod4.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice4;
        
        PricebookEntry customPrice5 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod5.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice5;
        
        PricebookEntry customPrice6 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod6.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice6;
        
        Product2List = [select id,productCode ,GL_Code__c from product2];
        for(Integer i=0;i<Product2List.size();i++)
            TeamRegList.add(new Team_Registration_Products__c(Name = 'TeamRegProduct'+i,Product_Code__c = Product2List[i].productCode,
                                                              GL_Code__c = Product2List[i].GL_Code__c));
        insert TeamRegList; 
        
        
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Quantity=2;
        oppli.OpportunityId=opp.Id; 
        oppli.TotalPrice=10;
        oppli.PriceBookEntryId = customPrice.Id;
        insert oppli;
        
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Quantity=2;
        oppli1.OpportunityId=opp.Id; 
        oppli1.TotalPrice=10;
        oppli1.PriceBookEntryId = customPrice1.Id;
        insert oppli1;
        
        OpportunityLineItem oppli2 = new OpportunityLineItem();
        oppli2.Quantity=2;
        oppli2.OpportunityId=opp.Id; 
        oppli2.TotalPrice=10;
        oppli2.PriceBookEntryId = customPrice2.Id;
        insert oppli2;
        OpportunityLineItem oppli3 = new OpportunityLineItem();
        oppli3.Quantity=2;
        oppli3.OpportunityId=opp.Id; 
        oppli3.TotalPrice=10;
        oppli3.PriceBookEntryId = customPrice3.Id;
        insert oppli3;
        OpportunityLineItem oppli4 = new OpportunityLineItem();
        oppli4.Quantity=2;
        oppli4.OpportunityId=opp.Id; 
        oppli4.TotalPrice=10;
        oppli4.PriceBookEntryId = customPrice4.Id;
        insert oppli4;
        OpportunityLineItem oppli5 = new OpportunityLineItem();
        oppli5.Quantity=2;
        oppli5.OpportunityId=opp.Id; 
        oppli5.TotalPrice=10;
        oppli5.PriceBookEntryId = customPrice5.Id;
        insert oppli5;
        OpportunityLineItem oppli6 = new OpportunityLineItem();
        oppli6.Quantity=2;
        oppli6.OpportunityId=opp.Id; 
        oppli6.TotalPrice=10;
        oppli6.PriceBookEntryId = customPrice6.Id;
        insert oppli6;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('FRM Program').getRecordTypeId();
        contract = new Contract(Opportunity__c = opp.id,AccountId = acc.id,recordTypeId = rtId);
        insert contract;
        
        Contract  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId,
                                 Membership_Type__c = 'Individual',Enrollment_paid_for_2009__c = False,
                                 recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,
                                 ContractTerm = 12,StartDate = Date.newInstance(2009, 2, 17));
        insert contract; 
        contract.Status = 'Activated';
        update contract;
        
        Contract1  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId,
                                  Membership_Type__c = 'Individual',Enrollment_paid_for_2009__c = False,
                                  recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program'),
                                  ContractTerm = 12,StartDate = Date.newInstance(2009, 2, 17));
        insert contract1; 
        contract1.Status = 'Activated';
        update contract1;
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true;
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        objExamGrp.Loading_Exam_Results__c = true;
        insert objExamGrp;
        
        exam = new Exam__c();
        exam.Name = 'FRM Exam';
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exam4 = new Exam__c();
        exam4.Name = 'FRM Exam';
        exam4.Exam_Group__c = objExamGrp.id;
        exam4.Exam_Date__c = system.today() + 30;
        exam4.exam__c = 'FRM Part 2'; 
        insert exam4;	
        
        exam2 = new Exam__c();
        exam2.Exam_Group__c = objExamGrp.id;
        exam2.Exam_Date__c = system.today() + 30;
        exam2.exam__c = 'ERP Exam Part II'; 
        insert exam2;	
        
        exam3 = new Exam__c();
        exam3.Exam_Group__c = objExamGrp.id;
        exam3.Exam_Date__c = system.today() + 30;
        exam3.exam__c = 'ERP Exam Part I'; 
        insert exam3;	
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        exmSite1 = new Exam_Sites__c(Site__c = site.id,exam__c = exam2.id);
        insert exmSite1;
        
        contact = new Contact(lastname = 'Test',AccountId = opp.AccountId,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        contact1 = new Contact(recordtypeid = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship'),lastname = 'Test',AccountId = opp.AccountId,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Candidate_Commitment__c =contract.id,Member__c = contact.id,cancelled__c = false);
        insert attempt;
        
        attempt1 = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite1.id,Candidate_Commitment__c =contract1.id,Member__c = contact.id,cancelled__c = false);
        insert attempt1;
        
        attempt2 = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact1.id,cancelled__c = true);
        insert attempt2;        
        
        lead = new Lead(lastname = 'test',firstName = 'test' ,status = 'Open',email= 'test@test.com',company = acc.id);
        insert lead;
        
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        reqt.Exam__c = 'FRM Part I';
        insert reqt;
        
        reqt1 = new Candidate_Requirement__c();
        reqt1.Candidate_Commitment__c = contract.id;
        reqt1.name = 'Pass ERP';
        reqt1.Exam__c = 'ERP Part II';
        insert reqt1;
        
        reqt2 = new Candidate_Requirement__c();
        reqt2.Candidate_Commitment__c = contract.id;
        reqt2.Exam__c = 'ERP Part I';
        reqt2.name = 'Job Requirement';
        insert reqt2;
        
        reqt3 = new Candidate_Requirement__c();
        reqt3.Candidate_Commitment__c = contract.id;
        reqt3.name = 'Pass FRM2';
        reqt3.Exam__c = 'FRM Part II';
        insert reqt3;
        
        
        reqt4 = new Candidate_Requirement__c();
        reqt4.Candidate_Commitment__c = contract.id;
        reqt4.name = 'Pass FRM1';
        insert reqt4;
        
        chapter = new Chapter__c(Name = 'TestChapter', Status__c = 'Active');
        insert chapter;
        
        chapMeeting = new Chapter_Meeting__c(Name='Test Chapter Meeting', 
                                             Start__c=System.now().addDays(15), 
                                             End__c=System.now().addDays(15).addHours(2),Chapter__c = chapter.Id);
        insert chapMeeting;
        
        meetingReg = new Chapter_Meeting_Registration__c();
        meetingReg.Chapter_Meeting__c = chapMeeting.id;
        meetingReg.contact__c = contact.id;
        insert meetingReg;
        
        String recordTypeEventConvention    = RecordTypeHelper.GetRecordTypeId('Event__c', 'Convention');
		
        Eventobj.RecordTypeId    = recordTypeEventConvention;
        Eventobj.Start_Date__c   = Date.today().addDays(58);
        Eventobj.End_Date__c     = Date.today().addDays(60);
        Eventobj.Name            = 'EVENT';
        INSERT Eventobj;


        eventRegistrationForEventobj.Contact__c = contact.Id;
        eventRegistrationForEventobj.Event__c = Eventobj.Id;
        INSERT eventRegistrationForEventobj;
        
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
        tempAccount.isEventChecked = false;
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
        tempAccount.eppHelp =false;
        tempAccount.promoCode = 'Promocode';
        tempAccount.isWebcastChecked = false;
        tempAccount.chapterMeetingRegistrationId = '';
        
        TeamReg = new Team_Registration__c(BD_Rep_Email__c='test123@gmail.com',Name='test team reg',
                                           Contact__c=contact.Id,
                                           Discounted_Price__c = 3.4,End_Date__c=system.today(),
                                           Start_Date__c=system.today()-1,Access_Code__c = 'test',
                                           Manual_Invoice_Number__c='INV-000115',
                                           Payment_Status__c='paid',Exam_Type__c='FRR',
                                           Seats_Allowed__c =4,Seats_Used__c=1);
        insert TeamReg;
        
        List<String> NewProdCodes1 = new List<String>{'FBRNM','FCBR','FBRA','CBR','CBRNM','MEMI','MEMC',
            'MEMS','MEMW','MEMR','CHLF','CHNDF','SLSTX','SHIP','PRFEE','MISC','MEMF'};
            List<String> GL_CodeList = new List<String>{'4000','4000','4000','4000','4000','4040',
                '4040','4040','2007','2007','2008','2009','4999','4999','4999','4999','4999'};        
                List<Product2> Product2List = new List<Product2>();
        for(Integer i=0;i<NewProdCodes1.size(); i++){
            Product2List.add(new Product2(Name = 'Laptop X200',productCode = NewProdCodes1[i],GL_Code__c = GL_CodeList[i],
                                          Family = 'Hardware',isActive = true));
        
            TeamRegList.add(new Team_Registration_Products__c(Name = 'TeamRegProduct'+i,Product_Code__c = Product2List[i].productCode,
                                                              GL_Code__c = Product2List[i].GL_Code__c));
        }
        insert Product2List;
        for(Integer i=0;i<Product2List.size(); i++){
            insert(new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = Product2List[i].Id,UnitPrice = 10000, IsActive = true));
            insert(new PricebookEntry(Pricebook2Id = customPB.id,Product2Id = Product2List[i].Id,UnitPrice = 10000, IsActive = true));
        }
        List<Product_Rate_Offering__c> ProRateList = new List<Product_Rate_Offering__c>();
        tempAccount.productDefinition prd1 = new tempAccount.productDefinition();
        for(Integer i=0;i<Product2List.size(); i++){    
            prd1.ProductCode = Product2List[i].productCode;
            prd1.GLCode = Product2List[i].GL_Code__c;
            prdList.add(prd1);
            ProRateList.add(new Product_Rate_Offering__c(Current_Product__c = Product2List[i].id,Attestation_Required__c = True,
                                                         Discount_Product__c = Product2List[Product2List.size()-i-1].id,Status__c = 'Active',Customer_Email__c = 'test@test.com',
                                                         offer_Amount__c = 100));
        }
        insert ProRateList;
        
        
    }
    
    static testMethod void myUnitTest_1() {
        
        testData();
        
        test.startTest();
        
        registration reg = new registration();
        registration.wrapperSetLead wrpLead = new registration.wrapperSetLead();
        registration.wrapperCheckExistingMember wrpExstMbr = new registration.wrapperCheckExistingMember();
        registration.wrapperCreateOrder wrpOrder = new registration.wrapperCreateOrder();
        registration.wrapperGetContact wrpGetCon = new registration.wrapperGetContact(); 
        registration.wrapperProductInfo wrpPrdInfo = new registration.wrapperProductInfo(); 
        registration.wrapperCreateWebcastRegistration wrpWbcReg = new registration.wrapperCreateWebcastRegistration(); 
        
        registration.removeOrder(opp.Id, true, true);
        //registration.removeOrder(wrpGetCon.TempAccount,opp.id); 
        registration.CheckExistingMember('test1@test1.com'); 
        registration.setLead('test2@test2.com','test','test','Individual',null); 
        tempAccount.Email = 'test@test2.com';
        registration.GetMember(tempAccount);
        registration.checkLead(tempAccount);
        tempAccount.contactId = null;
        tempAccount.id = lead.id;
        registration.returnBool(true);    
        tempAccount.productDefinition prd = new tempAccount.productDefinition ();           
        prd.ProductCode = 'MEMI';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd };  
            tempAccount.wiley = 'true';
        registration.CreateMemberShipContract(tempAccount,acc.id,opp.id,contract.id,true);
        
        registration.GetBussinessContact(tempAccount);
        reg.changeExamSite(attempt1.Id, exmSite.Id);
        
        
        
        test.stopTest();     
        
    }
    
    static testMethod void myUnitTest_2() {
        
        testData();
        test.startTest();
        
        registration reg = new registration();
        registration.wrapperSetLead wrpLead = new registration.wrapperSetLead();
        registration.wrapperCheckExistingMember wrpExstMbr = new registration.wrapperCheckExistingMember();
        registration.wrapperCreateOrder wrpOrder = new registration.wrapperCreateOrder();
        registration.wrapperGetContact wrpGetCon = new registration.wrapperGetContact(); 
        registration.wrapperProductInfo wrpPrdInfo = new registration.wrapperProductInfo(); 
        registration.wrapperCreateWebcastRegistration wrpWbcReg = new registration.wrapperCreateWebcastRegistration();
        registration.getContactInfo(contact.id);
        registration.CheckExistingMember('test@test.com');
        registration.setLead('test@test.com','test','test','Individual',null);
        registration.registrationDate();
        registration.testDate();
        tempAccount.Email = 'test@test.com';
        registration.GetMember(tempAccount);
        registration.checkLead(tempAccount);
        registration.setLead(tempAccount);
        //registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true);
        tempAccount.wiley = 'true';
        registration.CreateMemberShipContract(tempAccount,acc.id,opp.id,contract.id,true);
        test.stopTest();
    } 
    
    
    static testMethod void myUnitTest_3() {
        
        testData();
        test.startTest();
        //registration.updateOpportunityInfo1(tempAccount,opp.id);
        tempAccount.autoRenew = true;
        registration.updateOpportunityinfoForMembers(opp.id,tempAccount);
        registration.getActiveSites();
        registration.returnBool(null);
        registration.updateContactInfo(tempAccount,contact.id,null);
        registration.updateAccountInfo(tempAccount,Acc.id);
        registration.updateOpportunityInfo(tempAccount,opp.id,true,true,false,null,false);
        
        try{
            registration.createOppLineItems(opp.id,tempAccount,null);
        }catch(Exception ex){}
        //registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true);
        registration.createContract(acc.id,tempAccount,opp.id,contact.id);
        registration.createopportunity(contact,tempAccount);    
        registration.returnBool(true);
        tempAccount.productDefinition prd = new tempAccount.productDefinition ();       
        prd.ProductCode = 'MEMS';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd };  
            tempAccount.wiley = 'true';
        registration.CreateMemberShipContract(tempAccount,acc.id,opp.id,contract.id,true);
        test.stopTest();
    }
    
    
    static testMethod void myUnitTest_4() { 
        
        testData();
        test.startTest();
        registration.updateContactInfo(tempAccount,contact.id,null);
        tempAccount.productDefinition prd = new tempAccount.productDefinition ();
        prd.ProductCode = 'MEMI';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd };  
            tempAccount.MailingCountry = 'US';      
        registration.updateContactInfo(tempAccount,contact.id,null);
        tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
        prd1.ProductCode = 'MEMS';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 };   
            tempAccount.MailingCountry = 'US';
        registration.updateContactInfo(tempAccount,contact.id,null); 
        list<Exam__c> exams = new list<Exam__c>();
        exams.add(exam);    
        registration.getExamFee(exams);
        tempAccount.isErpChecked = true;
        registration.createContract(acc.id,tempAccount,opp.id,contact.id);
        test.stopTest();
    }
    
    static testMethod void myUnitTest_5() {
        testdata();
        test.starttest();
        try{ 
            tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
            prd1.ProductCode = 'FRM1E';
            tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 }; 
                tempAccount.isIcbrChecked = false;
            registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true,null,false);//hardcoding in main class
        }catch(Exception ex){}
        
        try{
            tempAccount.isFBRChecked = true;
            tempAccount.isFrmChecked = true;
            registration.createOrder(tempAccount);//hardcoding in main class
        }catch(Exception ex){}
        tempAccount.contactId = null;
        
        try{
            registration.createOrder(tempAccount);//hardcoding in main class
        }catch(Exception ex){}
        try{
            tempAccount.isFBRChecked = true;
            tempAccount.isFrmChecked = true;
            registration.createOrderForPortalUsers(tempAccount);//hardcoding in main class
        }catch(Exception ex){}
        
        test.stoptest(); 
    }
    
    
    static testMethod void myUnitTest_6() { 
        testdata();
        test.starttest();
        try{
            tempaccount.Wiley = 'true';
            tempaccount.isFBRChecked = true;
            tempaccount.isFrmChecked = false;
            registration.createCandidateRequirements(contract.id,tempAccount);
            tempaccount.isFbraChecked = true;
            registration.CreateContract(acc.id,tempAccount,opp.id,contact.id);
        }catch(Exception ex){}
        
        test.stoptest(); 
    }
    
    static testMethod void myUnitTest_7() { 
        testdata();
        test.starttest();
        try{
            tempaccount.Wiley = 'true';
            tempaccount.isFBRChecked = false;
            tempaccount.isFrmChecked = false;
            tempaccount.isIcbrChecked = true;
            tempaccount.isFbraChecked = true;
            Tempaccount.isErpChecked = True;
            Tempaccount.isFbraChecked = True;
            registration.createCandidateRequirements(contract.id,tempAccount);
            
            registration.CreateContract(acc.id,tempAccount,opp.id,contact.id);
            registration.chapterMeetingRegister(contact.id,null,true);
        }catch(Exception ex){}
        
        registration.getPrice('GL0008');
        registration.getPrice('GL0009');
        registration.getPrice('GL0016');
        test.stoptest(); 
    }
    
    static testMethod void myUnitTest_8() { 
        testdata();
        test.starttest();
        
        registration reg = new registration();
        try{
            tempaccount.Wiley = 'true';
            tempaccount.isFBRChecked = false;
            tempaccount.isFrmChecked = false;
            tempaccount.isIcbrChecked = True;
            tempaccount.isErpChecked = true;
            
            registration.createCandidateRequirements(contract.id,tempAccount);
            registration.CreateContract(acc.id,tempAccount,opp.id,contact.id);
        }catch(Exception ex){}
        tempaccount.isFRMChecked = True;
        tempaccount.isERPChecked = True;
        registration.updateSelfRelations(new Candidate_Requirement__c []{ reqt,reqt1,reqt2,reqt3,reqt4 },tempAccount);
        registration.getCandidatesReqByName(new Candidate_Requirement__c []{ reqt,reqt1,reqt2,reqt3,reqt4 });
        registration.registerExam(new  Exam_Sites__c [] {exmSite}, contact.ID, new Candidate_Requirement__c [] {reqt,reqt1,reqt2,reqt3,reqt4}, contract.id,  opp.Id);
        registration.Charge( opp.Id,'03','1988','Credit Card','VISA','721','123432156788765');
        registration.chapterMeetingRegister(contact.id,chapMeeting.id,false);
        //registration.Charge( opp1.Id,null,null,null,null,null,null);
        test.stoptest();  
    }
    
    //in progress
    static testMethod void myUnitTest_9() { 
        testdata();
        test.starttest();
        try{
            RegWrapProdInfo = registration.getProductCodesBasedOnFilters1(new Exam_Attempt__c [] {attempt},new user(id = userinfo.getUserId()));
            reg = RegWrapProdInfo.get('DeferredPayment');
            registration.getFRMExams(new user(id = userinfo.getUserId()));
            registration.getERPExams(new user(id = userinfo.getUserId()));
            registration.getFBRICBRProductCodes('fbr',null,'test');
            //registration.getExamFee1(new Exam__c[] {exam});
            registration.getExamFee1(new Exam__c[] {exam,exam4,exam2,exam3});
            registration.getPrice('');
            
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    
    //in progress
    static testMethod void myUnitTest_10() { 
        testdata();
        test.starttest();
        try{
            RegWrapProdInfo = registration.getProductCodes1('frm',contact.email);
            reg = RegWrapProdInfo.get('DeferredPayment');
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    
    //in progress
    static testMethod void myUnitTest_11() { 
        testdata();
        test.starttest();
        try{
            RegWrapProdInfo = registration.getProductCodes1('frm',contact.email);
            reg = RegWrapProdInfo.get('MEMI');
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    //in progress
    static testMethod void myUnitTest_12() { 
        testdata();
        
        test.starttest();
        try{
            
            registration.getFBRICBRProductCodes('fbr',contact.email,'Test');
            registration.getFBRICBRProductCodes('ICBRR',contact.email,'Test');
            
            registration.getFBRICBRProductCodes('FBRA',contact.email,'Test');
            registration.getFBRICBRProductCodes('WILEY',contact.email,'Test');
            registration.getFBRICBRProductCodes('INDIVIDUAL',contact.email,'Test');
            registration.getFBRICBRProductCodes('STUDENT',contact.email,'Test');
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    
    
    //in progress
    static testMethod void myUnitTest_13() { 
        testdata();
        test.starttest();
        try{
            Profile p = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
            User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
            attempt.Candidate_Commitment__c = contract.id;
            update attempt;
            System.runAs(u2) {
                tempAccount.contactId = contact.id;     
                RegWrapProdInfo = registration.getProductCodes();
                reg = RegWrapProdInfo.get('CanadianTax');
                registration.getFRMExams(u2);
            }
        }catch(Exception ex){}
        test.stoptest();   
    }
    
    //in progress
    static testMethod void myUnitTest_14() { 
        testdata();
        test.starttest();
        try{
            registration.getMiscellaneousProdCodes(null);
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    //in progress
    static testMethod void myUnitTest_15() { 
        testdata();
        test.starttest();
        try{
            Profile p = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
            User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
            attempt.Candidate_Commitment__c = contract.id;
            update attempt;
            System.runAs(u2) {
                Id erpRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
                contract.recordtypeId = erpRecordTypeId;
                update contract;
                registration.getERPExams(u2);
            }
        }catch(Exception ex){}
        try{
            registration.createExamAttemptsForICBR(TempAccount , contact.ID, acc.ID,  opp.Id, new  Candidate_Requirement__c [] {reqt},  contract.ID);
        }catch(Exception ex){}
        test.stoptest();   
    }
    
    static testMethod void myUnitTest_16() {
        
        testData();
        test.startTest();
        registration reg = new registration();
        registration.bulkOrderReturnData bulkTest = new registration.bulkOrderReturnData();
        Id manualRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Manual');
        //Id manualRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
        list<opportunity> opps = new list<opportunity>();
        opps.add(opp);    
        registration.getBulkOrders('promocode');
        test.stopTest();
    }
    
    static testMethod void myUnitTest_17() { 
        testdata();
        test.starttest();
        registration reg = new registration();
        try{
            tempaccount.Wiley = 'true';
            tempaccount.isFBRChecked = false;
            tempaccount.isFrmChecked = false;
            tempaccount.isIcbrChecked = false;
            tempaccount.isErpChecked = false;
            tempaccount.isEventChecked = true;
            registration.verifyBulkOrderReturnData bulkTest = new registration.verifyBulkOrderReturnData();
            registration.createEventRegistration(tempAccount,contact.id,acc.id,opp.id,bulkTest,false);
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    static testMethod void myUnitTest_18() { 
        Webcast__c webcast =  new Webcast__c();
        webcast.Name='Test Webcast';
        webcast.Status__c = 'Active';
        INSERT webcast;
        
        Presenter__c presenter = new Presenter__c();
        presenter.Webcast__c = webcast.Id;
        INSERT presenter;
        testdata();
        test.starttest();
        registration reg = new registration();
        try{
            tempaccount.Wiley = 'true';
            tempaccount.isFBRChecked = false;
            tempaccount.isFrmChecked = false;
            tempaccount.isIcbrChecked = false;
            tempaccount.isErpChecked = false;
            tempaccount.isEventChecked = false;
            tempaccount.isWebcastChecked = true;
            tempaccount.webcastId= webcast.Id;
            registration.verifyBulkOrderReturnData bulkTest = new registration.verifyBulkOrderReturnData();
            registration.insertWebcastRegistration(tempAccount,contact.id);
            registration.createWebcastRegistration(tempAccount,contact.id);
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    
    static testMethod void myUnitTest_new1() { 
        testdata();
        test.starttest();
        registration reg = new registration();
        MAP<Id,Contact> conMap = new MAP<Id,Contact>([SELECT Id FROM Contact]);
        User usr = [SELECT id, ContactId FROM User WHERE IsActive=TRUE AND contactId IN:conMap.keySET() LIMIT 1];
        system.debug('usr::>>  '+usr);
        system.runAs(usr){
            tempaccount.Wiley = 'true';
            tempaccount.isFBRChecked = false;
            tempaccount.isFrmChecked = false;
            tempaccount.isIcbrChecked = false;
            tempaccount.isErpChecked = false;
            tempaccount.isEventChecked = false;
            tempaccount.isWebcastChecked = true;
            tempaccount.webcastId= '';
            tempaccount.Id= contact.id;
            tempaccount.jobtitle = 'Test';
            tempaccount.Company = 'Test';
            tempaccount.idName = 'Test';
            tempaccount.Title = 'Associate';
            tempaccount.idFirstName = 'Test1';
            tempaccount.idMiddleName = 'Test2';
            tempaccount.idLastName = 'Test3';
            tempaccount.Birthdate = '12/27/2013';
            tempaccount.ID_Expiration_Date = '12/27/2023';
            tempaccount.Expected_Graduation_Date = '12/27/2023';
            tempaccount.idType = 'Passport';
            tempaccount.idNumber = '123456Test';
            tempaccount.Full_Name_in_Chinese = 'Test';
            tempaccount.idLocation = 'China';
            tempaccount.Gender = 'Male';
            tempaccount.HomePhone = '1234567890';
            tempaccount.JobFunction = 'Lending';
            tempaccount.RiskSpecialty = 'Data Risk';
            tempaccount.RiskManagementWorkingYear = '2022';
            tempaccount.IndustryWorkingYear = '2022';
            tempaccount.Years_of_Experience = '2022';
            tempaccount.Experience = '1-5';
            tempaccount.Industry = 'Government';
            tempaccount.howDidYouHear = 'Advertisement';
            tempaccount.howDidYouHearOther = 'Advertisement';
            tempaccount.School = 'test';
            tempaccount.Degree_Program_Name = 'test';
            tempaccount.sessionToken = 'test';
            tempaccount.MailingStreet = 'test';
            tempaccount.MailingStreet2 = 'test';
            tempaccount.MailingStreet3 = 'test';
            tempaccount.MailingCity = 'test';
            tempaccount.MailingState = 'TX';
            tempaccount.MailingCountry = 'US';
            tempaccount.MailingPostalCode = '12345';
            tempaccount.paymentMethod = 'Wire';
            tempaccount.Membership_Type = 'Individual';
            tempaccount.chapterMeetingRegistrationId = meetingReg.Id;
            tempaccount.CIA = FALSE;
            tempaccount.CAIA = FALSE;
            tempaccount.CMT = FALSE;
            tempaccount.CQF = FALSE;
            tempaccount.CFP = FALSE;
            tempaccount.examAttemptId = attempt.Id;
            
            
            registration.setContactInfo(TempAccount);
            registration.clearIDContactInfo();
            registration.getProductCodes();
            
            registration.createChapterMeetingRegistration(TempAccount,contact.Id);
            registration.createChapterMeetingRegistration(TempAccount,null);
            registration.setChapterMeetingRegistration(TempAccount,contact.Id,opp.Id,TRUE);
            registration.isUserAnAlumni('test@test.com');
            registration.publicChapterMeetingRegister(chapMeeting.Id,True,'test@test.com');
            tempAccount.promoCode = null;
            tempaccount.contactId = contact.id;
            tempaccount.emailEventsSubscription=true;
            tempaccount.emailWebcastsSubscription= true;
            tempaccount.emailChapterMeetingsSubscription= true;
            registration.createOrderForPortalUsers(TempAccount);
            registration.createOrder(tempAccount);
        }/*catch(Exception ex){
system.debug('The following exception has occurred: ' + ex.getMessage());
}*/
        
        
        test.stoptest();  
    }
    
    static testMethod void myUnitTest_5Clone1() {
        testdata();
        test.starttest();
        try{ 
            List<Product2> ProductUpdate = new List<Product2>();
            for(Product2 p2 : [SELECT id,ProductCode FROM Product2]){
                p2.ProductCode = 'FBRNM';
                ProductUpdate.add(p2);
            }
            update ProductUpdate;
            opp.Inst_Sale_Code__c = 'FBRNM';
            update opp;
            tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
            tempAccount.promoCode = 'FBRNM';
            prd1.ProductCode = 'FBRNM';
            tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 }; 
                tempAccount.isFbrChecked = true;
            registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true,null,false);//hardcoding in main class
        }catch(Exception ex){}
        
        try{
            List<Product2> ProductUpdate = new List<Product2>();
            for(Product2 p2 : [SELECT id,ProductCode FROM Product2]){
                p2.ProductCode = 'ENC1E';
                ProductUpdate.add(p2);
            }
            update ProductUpdate;
            opp.Inst_Sale_Code__c = 'ENC1E';
            update opp;
            tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
            tempAccount.promoCode = 'ENC1E';
            prd1.ProductCode = 'ENC1E';
            tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 }; 
                tempAccount.isErpChecked = true;
            registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true,null,false);//hardcoding in main class
        }catch(Exception ex){}
        //tempAccount.contactId = null;
        
        try{
            registration.createOrder(tempAccount);//hardcoding in main class
        }catch(Exception ex){}
        try{
            tempAccount.isFBRChecked = true;
            tempAccount.isFrmChecked = true;
            registration.createOrderForPortalUsers(tempAccount);
            
        }catch(Exception ex){}
        
        test.stoptest(); 
    }
    
    static testMethod void myUnitTest_5Clone3() {
        testdata();
        
        List<Exam_Attempt__c> lstExamApptempts = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c ea : [SELECT id,Defered__c from Exam_Attempt__c] ){
            ea.Defered__c = 'Pending';
            lstExamApptempts.add(ea);
        }
        update lstExamApptempts;
        test.starttest();
        try{ 
            List<Product2> ProductUpdate = new List<Product2>();
            for(Product2 p2 : [SELECT id,ProductCode FROM Product2]){
                p2.ProductCode = 'FBRNM';
                ProductUpdate.add(p2);
            }
            update ProductUpdate;
            opp.Inst_Sale_Code__c = 'FBRNM';
            update opp;
            tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
            tempAccount.promoCode = 'FBRNM';
            prd1.ProductCode = 'FBRNM';
            tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 }; 
                tempAccount.isFbrChecked = true;
            registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true,null,false);//hardcoding in main class
        }catch(Exception ex){}
        
        try{
            registration.createOrder(tempAccount);//hardcoding in main class
        }catch(Exception ex){}
        try{
            tempAccount.isFBRChecked = true;
            tempAccount.isFrmChecked = true;
            registration.createOrderForPortalUsers(tempAccount);
            
            
            tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
            tempAccount.promoCode = 'FBRNM';
            prd1.ProductCode = 'FBRNM';
            tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 }; 
                
                tempAccount.isErpChecked = FALSE;
            tempAccount.isFrmChecked = FALSE;
            registration.createOrderForPortalUsers(tempAccount);
        }catch(Exception ex){}
        
        test.stoptest(); 
    }
    
    static testMethod void myUnitTest_5Clone2() {
        testdata();
        test.starttest();
        
        registration.setLeadFromMarketingEmail('elseTest@test.com');
        registration.setLeadFromMarketingEmail('test@test.com');
        try{ 
            List<Product2> ProductUpdate = new List<Product2>();
            for(Product2 p2 : [SELECT id,ProductCode FROM Product2]){
                p2.ProductCode = 'ENC2E';
                ProductUpdate.add(p2);
            }
            update ProductUpdate;
            opp.Inst_Sale_Code__c = 'ENC2E';
            update opp;
            tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
            tempAccount.promoCode = 'ENC2E';
            prd1.ProductCode = 'ENC2E';
            tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 }; 
                tempAccount.isFbrChecked = true;
            tempAccount.isErpChecked = true;
            registration.verifyBulkOrder(tempAccount);
            registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true,null,false);//hardcoding in main class
        }catch(Exception ex){}
        
        try{
            List<Product2> ProductUpdate = new List<Product2>();
            for(Product2 p2 : [SELECT id,ProductCode FROM Product2]){
                p2.ProductCode = 'ENC';
                ProductUpdate.add(p2);
            }
            update ProductUpdate;
            opp.Inst_Sale_Code__c = 'ENC';
            update opp;
            tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
            tempAccount.promoCode = 'ENC';
            prd1.ProductCode = 'ENC';
            tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 }; 
                tempAccount.isErpChecked = true;
            registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true,null,false);//hardcoding in main class
        }catch(Exception ex){}
        //tempAccount.contactId = null;
        
        try{
            registration.createOrder(tempAccount);//hardcoding in main class
        }catch(Exception ex){}
        try{
            tempAccount.isFBRChecked = true;
            tempAccount.isFrmChecked = true;
            registration.createOrderForPortalUsers(tempAccount);//hardcoding in main class
        }catch(Exception ex){}
        
        test.stoptest(); 
    }
    
    @isTest
    static void myUnitTest_19() { 
        testdata();
        
        User u =  [select Id, Email from User where contactId = :contact.Id];
        
        test.starttest();
        try{
            RegWrapProdInfo = registration.getProductCodes1('FRM',contact.email);
            reg = RegWrapProdInfo.get('FRM');
            
        }catch(Exception ex){}
        try{
            RegWrapProdInfo = registration.getProductCodes1('FBR',contact.email);
            reg = RegWrapProdInfo.get('Affiliate');
        }catch(Exception ex){}
        
        try{
            RegWrapProdInfo = registration.getProductCodes1('ERP',contact.email);
            reg = RegWrapProdInfo.get('FreeMembership');
            
            System.runas(u){
                RegWrapProdInfo = registration.getProductCodes();
                reg = RegWrapProdInfo.get('TAX');
                contract.Status = 'Completed';
                update contract;
                RegWrapProdInfo = registration.getProductCodes();
                reg = RegWrapProdInfo.get('Shipping');
            }
            
        }catch(Exception ex){}
        registration.getMiscellaneousProdCodes(null);
        test.stoptest();  
    }
    
    @isTest
    static void myUnitTest_20(){
        
        testdata();
        verBulkRet.bord = Registration.getBulkOrders('Promocode');
        Product2 Product2ele = [select id,productCode,GL_Code__c from Product2 where productCode = 'AFREE' and GL_Code__c = '4999' limit 1];
        
        tempAccount.productDefinition prd = new tempAccount.productDefinition();
       
        
        ProRateList.add(new Product_Rate_Offering__c(Current_Product__c = Product2ele.id,
                                                     Attestation_Required__c = True,
                                                     Discount_Product__c = Product2ele.id,
                                                     Status__c = 'Active',
                                                     Customer_Email__c = 'test@test.com',
                                                     offer_Amount__c = 100));
        insert ProRateList;
       
        
       insert(new Team_Registration_Products__c(Name = 'TeamRegProduct-20',Product_Code__c = Product2ele.productCode,
                                                              GL_Code__c = Product2ele.GL_Code__c));
        
        prd.ProductCode = 'AFREE';
        prd.GLCode = '4999';
        prd.relatedId = Eventobj.id;
        prdList.add(prd);
        
        prd.ProductCode = 'SLSTX';
        prd.GLCode = '4999';
        prd.relatedId = Eventobj.id;
        prdList.add(prd);
        
        prd.ProductCode = 'SHIP';
        prd.GLCode = '4999';
        prd.relatedId = Eventobj.id;
        prdList.add(prd);
        
        prd.ProductCode = 'CHLF';
        prd.GLCode = '2008';
        prd.relatedId = Eventobj.id;
        prdList.add(prd);
        
        prd.ProductCode = 'CHNDF';
        prd.GLCode = '2009';
        prd.relatedId = Eventobj.id;
        prdList.add(prd);
        
        prd.ProductCode = 'FRM1S';
        prd.GLCode = '4999';
        prd.relatedId = Eventobj.id;
        prdList.add(prd);
       
        
        tempAccount.productcode1 = prdList ; 
        tempAccount.promoCode = 'Promocode';
        tempAccount.Email = 'test@test.com';
        tempAccount.teamCode = 'test';
        tempAccount.IsFrmChecked = True;
        tempAccount.Membership_Type = 'SHIP';
        tempAccount.siteName = 'defChinained';
        tempAccount.siteId = exmSite.id;
        tempAccount.opportunityId = opp.id;
        
        
        Test.startTest();
        
        verBulkRet = registration.verifyBulkOrder(tempAccount);
        //bulkTest.oppData = opplist; //new List<Opportunity> opplist{opp,opp1};
		//verBulkRet.bord = bulkTest;
        registration.createOppLineItems(opp.id,tempAccount,verBulkRet);
        
        Opportunity opp2 = [Select id,amount,stageName from Opportunity where stageName = 'closed' limit 1];
        
        
        site.Is_OSTA_Information_Required__c = False;
        update site;
        
        attempt.Opportunity__c = opp2.id;
        update attempt;
        
        Site__c site1 = new Site__c(name = 'test',Is_OSTA_Information_Required__c = True,Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site1; 
        Exam_Sites__c exmSite3 =  new Exam_Sites__c(Site__c = site1.id,exam__c = exam.id);
        insert exmSite3;
        
        tempAccount.siteId = exmSite3.id;
        tempAccount.opportunityId = opp2.id;
        for(Integer i; i<[select id,productCode,GL_Code__c from Product2].size() ; i++){
        prd.ProductCode = Product2List[i].productCode;
        prd.GLCode = Product2List[i].productCode;
        prd.relatedId = Eventobj.id;
        prdList.add(prd);
        }
        
        tempAccount.productcode1 = prdList;        
        System.debug('verBulkRet--bulkTest--bulkTest.oppData' + verBulkRet + bulkTest + bulkTest.oppData);
        registration.createOppLineItems(opp2.id,tempAccount,verBulkRet);
        Tempaccount.isErpChecked = True;
        tempAccount.opportunityId = opp.id;
        registration.CreateContract(acc.id,tempAccount,opp.id,contact.id);
        Test.stoptest();
    }
    
}