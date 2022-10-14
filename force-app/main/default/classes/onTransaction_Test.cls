@isTest
public class onTransaction_Test {
    static testmethod void testTransactions(){
        
        TestClassUtil.isForOldTrigger();
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        Account account = new Account(Name = 'test');
         
        Opportunity opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        test.startTest();
        ChargentSFA__Transaction__c payment = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opportunity.id,
                                                                              ChargentSFA__Type__c = 'Charge', 
                                                                              ChargentSFA__Response_Status__c= 'Approved',
                                                                              ChargentSFA__Amount__c = 100,
                                                                              ChargentSFA__Payment_Method__c = 'Credit Card');
        insert payment;
        test.stopTest();
    }
}