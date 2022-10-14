@isTest
public class FBRICBRUtils_test {
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
    static User user;
    static Profile profile;
    static Product_Rate_Offering__c pro; 
    static Product2 prod;
    static Product2 prod1;
    static Product2 prod2;
    static Product2 prod3;
    static Product2 prod4;
    static Product2 prod5;
    static Product2 prod6;
    static Product2 prod7;
    
    static void testData(){ 
        
        List<Product2> lstProd = new List<Product2>();
        prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        lstProd.add(prod);
        prod1 = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        lstProd.add(prod1);
        prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        lstProd.add(prod2);
        prod3 = new Product2(Name = 'Laptop X200',productCode = 'MEMI',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        lstProd.add(prod3); 
        prod4 = new Product2(Name = 'Laptop X200',productCode = 'FCBR',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        lstProd.add(prod4); 
        prod5 = new Product2(Name = 'Laptop X200',productCode = 'CBR',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        lstProd.add(prod5); 
        prod6 = new Product2(Name = 'Laptop X200',productCode = 'SCRM',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        lstProd.add(prod6); 
        prod7 = new Product2(Name = 'Laptop X200',productCode = 'SCR2A',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        lstProd.add(prod7); 
        
        insert lstProd;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        List<PricebookEntry> lstPbe = new List<PricebookEntry>();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        lstPbe.add(standardPrice);
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        lstPbe.add(standardPrice1);
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 1000, IsActive = true);
        lstPbe.add(standardPrice2);
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 1000, IsActive = true);
        lstPbe.add(standardPrice3);
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id,UnitPrice = 1000, IsActive = true);
        lstPbe.add(standardPrice4);
        PricebookEntry standardPrice5 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod5.Id,UnitPrice = 1000, IsActive = true);
        lstPbe.add(standardPrice5);
        PricebookEntry standardPrice6 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod6.Id,UnitPrice = 1000, IsActive = true);
        lstPbe.add(standardPrice6);
        PricebookEntry standardPrice7 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod7.Id,UnitPrice = 1000, IsActive = true);
        lstPbe.add(standardPrice7);
        
        insert lstPbe;
                   
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        List<PricebookEntry> lstCustomPbe = new List<PricebookEntry>();
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        lstCustomPbe.add(customPrice);
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        lstCustomPbe.add(customPrice1);
        PricebookEntry customPrice2 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod2.Id, UnitPrice = 1000, IsActive = true);
        lstCustomPbe.add(customPrice2);
        PricebookEntry customPrice3 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod3.Id, UnitPrice = 1000, IsActive = true);
        lstCustomPbe.add(customPrice3);
        PricebookEntry customPrice4 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        lstCustomPbe.add(customPrice4);
        PricebookEntry customPrice5 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod5.Id, UnitPrice = 1000, IsActive = true);
        lstCustomPbe.add(customPrice5);
        PricebookEntry customPrice6 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod6.Id, UnitPrice = 1000, IsActive = true);
        lstCustomPbe.add(customPrice6);
        PricebookEntry customPrice7 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod7.Id, UnitPrice = 1000, IsActive = true);
        lstCustomPbe.add(customPrice7);
        
        insert lstCustomPbe;
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('SCR Program').getRecordTypeId();
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
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
        
        lead = new Lead(lastname = 'test',firstName = 'test' ,status = 'Open',email= 'test@test.com',company = acc.id);
        insert lead;
        
        contact contact1 = new Contact(recordtypeId = recordtypehelper.getRecordtypeID('Contact','Business Relationship'),lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1;
        profile = [SELECT Id FROM Profile WHERE id = '00e400000017dA8' limit 1]; 
        user = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact1.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        
        
        pro = new Product_Rate_Offering__c();
        pro.Current_Product__c = prod1.id;
        pro.Discount_Product__c = prod2.id;
        pro.Status__c = 'Active';
        pro.Customer_Email__c = contact.email;
        pro.offer_Amount__c = 100;
        insert pro;
        
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
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        list<exam_Sites__c> lstExamSites = new exam_sites__c[]{exmSite};
        list<Candidate_requirement__C> lstCandReqs = new candidate_requirement__c []{reqt};
        FBRICBRUtils.registerExam(lstExamSites, contact.id, lstCandReqs, Contract.ID, opp.Id);
        test.stopTest();
    }
    
    static testMethod void unitTest_2(){
        testData();
        test.startTest();
        
        system.runAs(user){
            FBRICBRUtils.getProductCodes();
        }
        test.stopTest();
    }

    static testMethod void unitTest_3(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('AFREE',new string []{'AFREE'});
        system.runAs(user){
        FBRICBRUtils.generateOrders(mapProdDetails, tempAccount);
        }
        test.stopTest();
    }
   
    static testMethod void unitTest_5(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('MEMI',new string []{'MEMI'});
        FBRICBRUtils.createOpportunity(mapProdDetails, contact, tempAccount, null);
        test.stopTest();
    }
    
    static testMethod void unitTest_6(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('AFREE',new string []{'AFREE','AFREE','AFREE','AFREE'});
        Map<String,Product_Rate_Offering__c> mapRates = new Map<String,Product_Rate_Offering__c>();
        mapRates.put(prod1.ProductCode+':'+prod1.GL_Code__c,pro);
        Map<String,Product_Rate_Offering__c> mapDiscounts = new Map<String,Product_Rate_Offering__c>();
        mapDiscounts.put(prod2.ProductCode+':'+prod2.GL_Code__c,pro);
        FBRICBRUtils.createOppLineItems(opp.Id, mapProdDetails,mapRates,mapDiscounts,contact.id);
        test.stopTest();
    }
    
    static testMethod void unitTest_7(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('MEMI',new string []{'MEMI'});
        FBRICBRUtils.createExamAttempts(mapProdDetails, contact.ID, acc.ID, opp.Id, true);
        test.stopTest();
    }
    
    static testMethod void unitTest_8(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('MEMI',new string []{'MEMI'});
        FBRICBRUtils.checkContractExist(mapProdDetails, acc.id);
        test.stopTest();
    }
}