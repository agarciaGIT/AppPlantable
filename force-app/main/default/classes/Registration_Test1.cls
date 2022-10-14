@isTest
private class Registration_Test1 {
    
    static Account acc ;
    static Opportunity opp; 
    static ChargentSFA__Transaction__c chargentTrans;
    static TempAccount tempaccount;
    static Contact contact;
    static contact contact1;
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
    
    static Exam_Attempt__c attempt1;
    static Exam_Attempt__c attempt2;
    static Exam_Sites__c exmSite1;
    static Site__c site1;
    static Exam__c exam1;
    
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
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
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
        opp = new Opportunity(amount = 123,Name = 'Test',RecordTypeID = manualRecId,Inst_Sale_Service_End_Date__c=system.today()+ 15,Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print',Inst_Sale_Code__c = 'Promocode',Institutional_Sale__c = TRUE,Institutional_Sale_Stage__c = 'Approved',closedate = system.today()+ 15);        
        insert opp;
        
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
        
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Quantity=2;
        oppli.OpportunityId=opp.Id; 
        oppli.TotalPrice=10;
        oppli.PriceBookEntryId = customPrice2.Id;
        insert oppli;
        
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Quantity=2;
        oppli1.OpportunityId=opp.Id; 
        oppli1.TotalPrice=10;
        oppli1.PriceBookEntryId = customPrice3.Id;
        insert oppli1;
        
        OpportunityLineItem oppli2 = new OpportunityLineItem();
        oppli2.Quantity=2;
        oppli2.OpportunityId=opp.Id; 
        oppli2.TotalPrice=10;
        oppli2.PriceBookEntryId = customPrice4.Id;
        insert oppli2;
        
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
        
        contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        contact1 = new Contact(recordtypeid = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship'),lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false);
        insert attempt;
        
        attempt1 = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact1.id,cancelled__c = false);
        insert attempt1;
        
        attempt2 = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact1.id,cancelled__c = true);
        insert attempt2;        
        
        lead = new Lead(lastname = 'test',firstName = 'test' ,status = 'Open',email= 'test@test.com',company = acc.id);
        insert lead;
        
        /*      exam1 = new Exam__c();
exam1.Exam_Group__c = objExamGrp.id;
exam1.Exam_Date__c = system.today() + 30;
exam1.exam__c = 'FRM Part 1'; 
insert exam1;

site1 = new Site__c(name = 'test1',Display_Address__c = 'test1',active__c = true,Non_selectable__c = false);
insert site1; 

exmSite1 = new Exam_Sites__c(Site__c = site1.id,exam__c = exam1.id);
insert exmSite1;*/
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        chapMeeting = new Chapter_Meeting__c();
        insert chapMeeting;
        
        meetingReg = new Chapter_Meeting_Registration__c();
        meetingReg.Chapter_Meeting__c = chapMeeting.id;
        meetingReg.contact__c = contact.id;
        insert meetingReg;
        
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
        registration.setContactInfo(TempAccount);
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
            registration.createCandidateRequirements(contract.id,tempAccount);
            registration.CreateContract(acc.id,tempAccount,opp.id,contact.id);
            registration.chapterMeetingRegister(contact.id,null,true);
        }catch(Exception ex){}
        
        registration.getPrice('GL0008');
        
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
            tempaccount.isIcbrChecked = false;
            tempaccount.isErpChecked = true;
            registration.createCandidateRequirements(contract.id,tempAccount);
            registration.CreateContract(acc.id,tempAccount,opp.id,contact.id);
        }catch(Exception ex){}
        
        registration.updateSelfRelations(new Candidate_Requirement__c []{ reqt },tempAccount);
        registration.getCandidatesReqByName(new Candidate_Requirement__c []{ reqt });
        registration.registerExam(new  Exam_Sites__c [] {exmSite}, contact.ID, new Candidate_Requirement__c [] {reqt}, contract.id,  opp.Id);
        registration.Charge( opp.Id,'03','1988','Credit Card','VISA','721','123432156788765');
        registration.chapterMeetingRegister(contact.id,chapMeeting.id,false);
        test.stoptest();  
    }
    
    //in progress
    static testMethod void myUnitTest_9() { 
        testdata();
        test.starttest();
        try{
            registration.getProductCodesBasedOnFilters1(new Exam_Attempt__c [] {attempt},new user(id = userinfo.getUserId()));
            registration.getFRMExams(new user(id = userinfo.getUserId()));
            registration.getERPExams(new user(id = userinfo.getUserId()));
            registration.getFBRICBRProductCodes('fbr',null);
            registration.getExamFee1(new Exam__c[] {exam});
            registration.getPrice('');
            
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    
    //in progress
    static testMethod void myUnitTest_10() { 
        testdata();
        test.starttest();
        try{
            registration.getProductCodes1('frm',contact.email);
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    
    //in progress
    static testMethod void myUnitTest_11() { 
        testdata();
        test.starttest();
        try{
            registration.getProductCodes1('frm',contact.email);
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    //in progress
    static testMethod void myUnitTest_12() { 
        testdata();
        test.starttest();
        try{
            registration.getFBRICBRProductCodes('fbr',contact.email);
            registration.getFBRICBRProductCodes('ICBRR',contact.email);
            registration.getFBRICBRProductCodes('WILEY',contact.email);
            registration.getFBRICBRProductCodes('INDIVIDUAL',contact.email);
            registration.getFBRICBRProductCodes('STUDENT',contact.email);
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
                registration.getProductCodes();
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
            tempaccount.webcastId= '';
            registration.verifyBulkOrderReturnData bulkTest = new registration.verifyBulkOrderReturnData();
            registration.createWebcastRegistration(tempAccount,contact.id);
            registration.insertWebcastRegistration(tempAccount,contact.id);
            
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    
}