@isTest
public class ExamAttemptsUtils_test{

    static Account account ;
    static Opportunity opportunity; 
    static Contract contract;
    static Contract frmContract;
    static Contract mberContract;
    static Exam_Attempt__c attempt;
    static Exam_Attempt__c attempt1;
    
    
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam__c exam1;
    static Exam_Sites__c exmSite;
    static Exam_Sites__c exmSite1;
    static Site__c site;
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Contract mberContract1;
    
    static void testData(){ 
            
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Hardware');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'ENC',GL_Code__c = '4999',Family = 'Hardware');
        insert prod1;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = standardPrice.id);
        OpportunityLineItem lineItem1 = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice1.id);
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        insert contract;
        contract.Status = 'Activated';
        update contract;
        
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert frmContract;
        frmContract.Status = 'Activated';
        update frmContract;
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert mberContract;
        mberContract.Status = 'Activated';
        update mberContract;
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Student',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert mberContract1;
        mberContract1.Status = 'Activated';
        update mberContract1;
        
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
        
        exam1 = new Exam__c();
        exam1.Exam_Group__c = objExamGrp.id;
        exam1.Exam_Date__c = system.today() + 30;
        exam1.exam__c = 'FRM Part 2'; 
        insert exam1;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite; 
        
        exmSite1 = new Exam_Sites__c(Site__c = site.id,exam__c = exam1.id);
        insert exmSite1; 
        
        attempt = new Exam_Attempt__c(Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false,Candidate_Commitment__c = contract.Id,Result__c = 'Fail');
        insert attempt;
        
        attempt1 = new Exam_Attempt__c();
        attempt1.Opportunity__c = opportunity.id;
        attempt1.Exam_Site__c = exmSite1.id;
        attempt1.Member__c = contact.id;
        attempt1.Candidate_Commitment__c = contract.Id;
        //attempt1.Result__c = 'Fail'; 
        attempt1.Defered__c = 'Approved';
        //attempt1.Section__c = 'FRM Part 2';
        insert attempt1;
    }
    
    static testMethod void unitTest_1(){
        
        testData();
        Map<Id,Exam_Attempt__c> oldMap = new Map<id,Exam_Attempt__c>();
        oldMap.put(attempt.id,attempt);
        List<Exam_Attempt__c> lstNewRecords = new list<Exam_Attempt__c>();
        lstNewRecords.add(attempt);
        test.startTest();
        ExamAttemptsUtils.onBeforeUpdate(oldMap,lstNewRecords);
        test.stopTest();
    }
    
    static testMethod void unitTest_2(){
        
        testData();
        Map<Id,Exam_Attempt__c> oldMap = new Map<id,Exam_Attempt__c>();
        oldMap.put(attempt.id,attempt);
        List<Exam_Attempt__c> lstNewRecords = new list<Exam_Attempt__c>();
        lstNewRecords.add(attempt);
        test.startTest();
        ExamAttemptsUtils.onInsert(oldMap,lstNewRecords);
        test.stopTest();
    }
    
    static testMethod void unitTest_3(){
        
        testdata();
        Set<Id> setEAIDS = new set<id>();
        setEAIDs.add(attempt.Id); 
        test.startTest();
        ExamAttemptsUtils.createIcbrrRecords(setEAIDS);
        test.stopTest();
    }
    
   /* static testMethod void unitTest_4(){
        
        testdata();
        list<Exam_Attempt__c> lstNewRecords = new list<Exam_Attempt__c>();
        lstNewRecords.add(attempt);
        Set<Id> setContacts = new set<id>();
        setContacts.add(contact.id);    
        
        test.startTest();
        ExamAttemptsUtils.validateExamAttempts(lstNewRecords,setContacts);
        test.stopTest();
    }
    
    static testMethod void unitTest_5(){
        testdata();
        list<Exam_Attempt__c> lstNewRecords = new list<Exam_Attempt__c>();
        lstNewRecords.add(attempt);
        Set<Id> setContacts = new set<id>();
        setContacts.add(contact.id);        
        test.startTest();
        ExamAttemptsUtils.validateExamAttempts(lstNewRecords,setContacts);
        test.stopTest();
    }
    
    static testMethod void unitTest_6(){
        testdata();
        list<Exam_Attempt__c> lstNewRecords = new list<Exam_Attempt__c>();
        lstNewRecords.add(attempt);
        Map<Id,id> mapSwapExamSites = new Map<id,id>();
        mapSwapExamSites.put(site.id,site.id);      
        test.startTest();
        ExamAttemptsUtils.updateFRM(lstNewRecords,mapSwapExamSites);
        test.stopTest();
    }*/

}