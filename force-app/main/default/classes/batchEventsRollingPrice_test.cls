@isTest
public class batchEventsRollingPrice_test {
    static Account acc;
    static Contact contact;
    static Opportunity opp;
    static Account acc1;
    static Contact contact1;
    static Opportunity opp1;
    static Contract contract;
    static Event__c eve;
    static Event_Registration__c er;
    static OpportunityLineItem lineItem;
    static Event_Rate__c rate;
    static Event_Registration__c er1;
    static OpportunityLineItem lineItem1;
    
    static void testData(){
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_Member__c = true, KPI_Membership_Payment_Status__c = 'In Good Standing');
        insert contact;
        
        Acc1 = new Account(Name = 'test1');
        insert acc1;
        
        contact1 = new Contact(lastname = 'Test1',AccountId = acc1.id,email='test@test2.com',KPI_Member__c = false);
        insert contact1;
         
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Events');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
           
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Pay', accountId = acc.id,stageName = 'New Lead',closedate = system.today()- 10, Pricebook2Id = customPB.Id);        
        insert opp;
        
        lineItem = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = customPrice.id,Quantity=1,UnitPrice=234);
        insert lineItem;
        
        opp1 = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = acc1.id,stageName = 'New Lead',Program__c = 'Print',closedate = system.today()- 10, Pricebook2Id = customPB.Id);        
        insert opp1;
        
        lineItem1 = new OpportunityLineItem(OpportunityId = opp1.id,PricebookEntryId = customPrice.id,Quantity=1,UnitPrice=234);
        insert lineItem1;
        
        Eve = new Event__c(Name = 'Event', Start_Date__c = system.today()+15, Grace_Period__c = 5, Event_Cancellation_Days__c = 3, Last_Date_for_Wire_Check_Registration__c = system.today(), Days_Before_Window_Close_Warning__c = 0);
        insert Eve;
        
        rate = new Event_Rate__c(Name = 'Event Rate', Event__c = eve.Id, Start_Date__c = system.today()-7, End_Date__c = system.today()-2, Member_Rate__c = 50, Non_Member_Rate__c = 100 );
        insert rate;
        
        Eve.Status__c = 'Active';
        update Eve;
        
        er = new Event_Registration__c(Opportunity__c =opp.id,Status__c ='Registered', Event__c = eve.Id, Contact__c = contact.Id, Last_Date_For_Rate_Effectiveness__c= system.today()-2);
        insert er;   
        
        er1 = new Event_Registration__c(Opportunity__c =opp1.id,Status__c ='Registered', Event__c = eve.Id, Contact__c = contact1.Id, Last_Date_For_Rate_Effectiveness__c= system.today()-2);
        insert er1;  
    }
  
    static testMethod void unitTest_1(){
    
        testData();
        test.startTest();
        batchEventsRollingPrice events = new batchEventsRollingPrice(NULL);
        Database.executebatch(events, 1);
        
        batchEventsRollingPrice event = new batchEventsRollingPrice(NULL);
        Database.executebatch(event, 1); 
        
        test.stopTest();
    }   
}