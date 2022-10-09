@isTest
public class SwtichFeesForErptoFrm_Test {
    
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
        
        
        
        ed = new Exam_Date__c(Name = 'Test', Date__c = Date.newInstance(2009, 2, 17));
        insert ed;
        
        account = new Account(Name = 'test',BillingCountry='usa');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
       
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'closed',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRMSW',GL_Code__c = '4001',Family = 'Hardware');
        insert prod;
    
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
       
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        
      
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = standardPrice.id);
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
      
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        
        Apexpages.StandardController std = new Apexpages.StandardController(contact);
        SwtichFeesForErptoFrm switcherptofrm = new SwtichFeesForErptoFrm(std);
        switcherptofrm.CreateOpp();
        test.stopTest();
        
    }
    
}