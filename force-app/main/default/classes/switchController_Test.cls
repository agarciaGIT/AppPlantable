@isTest
public class switchController_Test {
    
    
    static string payType= 'Early';
    static string month = '5';
    static string china = 'true';
    static string  name ;
    static Account acc ;
    static Opportunity opp; 
    static ChargentSFA__Transaction__c chargentTrans;
    static switchController.dataWrapper dataWrapper;
    static Contact contact;
    static list<Exam_Attempt__c> attempt3;
    static Exam_Attempt__c attempt;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contract Contract;
    static list<Contract> contract2;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Candidate_Requirement__c reqt;
    static list<ChargentSFA__Transaction__c> tran;
    static list<Product_Refunds__c> pr;
    
    
    
    static void testData(){ 
        
        
        
        Product2 prod2 = new Product2(Name = 'erp part 1',productCode = 'ENC1E',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod2; 
        
        
        Product2 prod4 = new Product2(Name = 'enrollment',productCode = 'ENC',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod4;
        
        
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice2;
        
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice4;
        
        
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        
        contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        Id manualRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Manual'); 
        opp = new Opportunity(amount = 123,Name = 'Test', ChargentSFA__Gateway__c =chrgGtway.id,RecordTypeID = manualRecId,Inst_Sale_Service_End_Date__c=system.today()+ 15,Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print',Inst_Sale_Code__c = 'Promocode',Institutional_Sale__c = TRUE,Institutional_Sale_Stage__c = 'Approved',closedate = system.today()+ 15);        
        insert opp;
        
        
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Quantity=1;
        oppli1.OpportunityId=opp.Id; 
        oppli1.TotalPrice=10;
        oppli1.PriceBookEntryId = standardPrice4.Id;
        insert oppli1;
        
        ChargentSFA__Transaction__c tran1 = new ChargentSFA__Transaction__c();
        list<ChargentSFA__Transaction__c> tran = new list<ChargentSFA__Transaction__c>();
        
        tran1.ChargentSFA__Opportunity__c =opp.id;
        tran1.ChargentSFA__Response__c ='0';
        tran1.ChargentSFA__Response_Status__c ='Approved';
        tran1.ChargentSFA__Type__c  ='charge';
        tran1.ChargentSFA__Amount__c  =opp.amount;
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
        
        
        switchController.objectWrapper objectWrapper = new switchController.objectWrapper ();
        
        objectWrapper.conid = contact.id;
        objectWrapper.accid =acc.id;
        objectWrapper.cr = contract2;
        objectWrapper.ea =attempt3;
        objectWrapper.opp =opp;
        objectWrapper.tran =tran;
        objectWrapper.pr = pr;
        
        
        switchController.dataWrapper dataWrapper = new switchController.dataWrapper();
        dataWrapper.conid = contact.id;
        dataWrapper.accid =acc.id;  
        dataWrapper.fname ='vivek';
        dataWrapper.lname = 'kathi';
        dataWrapper.examPartOne ='FRM Exam Part I';
        dataWrapper.examPartTwo = 'FRM Exam Part II';
        dataWrapper.enrollment  = true;
        dataWrapper.recurring   = true;
        dataWrapper.email      = 'vivek.reddy@garp.com';
        dataWrapper.examsite    = 'a1uW0000000XMxo';
        dataWrapper.company    = 'garp';
        dataWrapper.addr1      ='111 town square palce';
        dataWrapper.addr2      ='';
        dataWrapper.addr3       = '';
        dataWrapper.country     = 'usa';
        dataWrapper.city        ='jersey city';
        dataWrapper.state       = 'nj';
        dataWrapper.zip         = '08831';
        dataWrapper.saddr       ='111 town';
        dataWrapper.scountry    = 'usa';
        dataWrapper.scity       = 'monroe';
        dataWrapper.sstate      = 'mj';
        dataWrapper.szip        ='08831';
        dataWrapper.phone       ='2012341234';
        dataWrapper.paymentAmt  = 10.00;
        dataWrapper.AUTHCODE    ='12345';
        
        
        
        
        
        
        
    }   
    
    static testMethod void myUnitTest_1() {
        
        testData();
        
        switchController.objectWrapper wrap = new switchController.objectWrapper();
        switchController.dataWrapper dataWrapper = new switchController.dataWrapper();
        
        test.startTest();
        
        opportunity opportunity2 = [select id,stagename, Display_Invoice_Number__c from opportunity where id=:opp.id];
        
        system.debug('opportunity2:'+opportunity2);
        switchController.returndata(opportunity2.Display_Invoice_Number__c);
        // switchController.cancelErpOrder(opportunity2.Display_Invoice_Number__c,'Early','May','No',' ');
        
        opportunity2.stagename='Closed';
        update opportunity2;
        switchController.cancelErpOrder(opportunity2.Display_Invoice_Number__c,'Early','No','a1uW0000000XMxo');
        
        
        test.stopTest();     
        
    }
    
    
    
    
}