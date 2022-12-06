@isTest
public class batchRecCardTypeUpdateSage_Test {
    
    static Opportunity opp4 = new Opportunity();
    @testSetup
    static void testdata(){
        
        Account acc = new Account(name = 'Test Account2', Calculated_Expire_Date__c = system.today(), Last_Contract_Exp_Calc__c = system.today());
        insert acc;
        
        Opportunity opp = new Opportunity(accountId = acc.id,Company__c = 'GARP',ChargentSFA__Payment_Method__c= 'Credit card',ChargentSFA__Card_Type__c = 'Visa',
                                           name='Test Name',StageName='Closed',CloseDate=system.today());
        insert opp;
        
        Opportunity opp1 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,Cloned_From__c = opp.id,
                                           company__c = 'Payment', accountId = acc.id,stageName = 'Closed',ChargentSFA__Payment_Method__c= 'Credit card',
                                           closedate = system.today()+ 15,ChargentSFA__Payment_Status__c='Recurring',ChargentSFA__Payment_Frequency__c='Annual');  
        insert opp1;

    }
    
    @isTest 
    static void unitTest(){
        
        Test.startTest();
        
        Database.executeBatch(new batchRecCardTypeUpdateSage());
        
        Test.stopTest();
    }

}