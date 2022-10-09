@isTest

public class batchUnpaidEventRegistrations_test{

    static Account acc;
    static Opportunity opp;
    static Contract contract;
   
    static Event_Registration__c er;
    
    static void testData(){
        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()- 10);        
        insert opp;
        
    	Event__c event = new Event__c();
        event.Status__c = 'Draft';
        event.Name = 'TEST EVENT NAME';
        event.Title__c = 'TEST EVENT TITLE';
        INSERT event;        
        
        er = new Event_Registration__c(Opportunity__c =opp.id, Status__c ='Registered', Event__c=event.Id);
        insert er;
        
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(er.Id, yesterday);
   
      } 
    
    static testMethod void unitTest_1(){
    
        testData();
        test.startTest();
        batchUnpaidEventRegistrations events = new batchUnpaidEventRegistrations(NULL);
        Database.executebatch(events);

        batchUnpaidEventRegistrations events1 = new batchUnpaidEventRegistrations(String.ValueOf(er.Id));
        Database.executebatch(events1);

        test.stopTest();
    }


}