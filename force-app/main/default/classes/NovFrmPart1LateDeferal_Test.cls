@isTest
public class NovFrmPart1LateDeferal_Test {

    
   
        
     static Account account ;
    static case case1 ;
    static Opportunity opportunity; 
    static Exam_Attempt__c attempt;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Exam_Date__c ed;
    
    static void testData(){
        
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');  
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        
        
        ed = new Exam_Date__c(Name = 'Test', Date__c = Date.newInstance(2019,11, 16));
        insert ed;
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
       
       
        case1 = new case(contactid =contact.id);
        insert case1;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'closed',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4020',Family = 'Hardware');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'ENC',GL_Code__c = '4020',Family = 'Hardware');
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
      
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = standardPrice.id);
        OpportunityLineItem lineItem1 = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice1.id);
        
        contract cont  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = account.id); 
        insert cont;
        cont.Status = 'Activated';
        update cont;
        
        Candidate_Requirement__c reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = cont.id;
        reqt.name = 'PASS FRM1';
        insert reqt;
        
         Candidate_Requirement__c reqt1 = new Candidate_Requirement__c();
        reqt1.Candidate_Commitment__c = cont.id;
        reqt1.name = 'PASS FRM2';
        insert reqt1;
       
        
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true; 
        objExamGrp.Exam_Date__c = Date.newInstance(2019,11, 16); 
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = Date.newInstance(2019,09, 16).addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = Date.newInstance(2019,09, 16).addDays(10);
        objExamGrp.Last_Date_For_Standard_Registration__c = Date.newInstance(2019,09, 16).addDays(11);
        objExamGrp.Last_Date_For_Late_Registration__c = Date.newInstance(2019,09, 16).addDays(12);  
        insert objExamGrp;
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite; 
        
        attempt = new Exam_Attempt__c(Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false,Candidate_Requirement__c = reqt.id, Candidate_Commitment__c =cont.id , November_Deferred__c =true);
        insert attempt;
      

    }
    
    static testMethod void Unit_test()
    {
        test.starttest();
        testData();
        
        NovFrmPart1LateDeferal frm = new NovFrmPart1LateDeferal();
        database.executeBatch(frm,1);
        test.stopTest();
        
    }
    
}