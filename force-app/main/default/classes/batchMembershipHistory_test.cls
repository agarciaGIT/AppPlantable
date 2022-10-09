@isTest
public class batchMembershipHistory_test {
    
    Static Contact contact;
    Static Account account;
    
	public static void setup(){
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@garpautoqaqatesting.com',MailingCountry='China',Membership_Status_By_Year__c='~2011:Individual New Comp^Good^None~2012:Individual New Comp^Lapsed^None~2013:Individual New Comp^Lapsed^None~2014:Individual New Comp^Lapsed^None~2015:Individual New Comp^Lapsed^None~2016:Individual Renew^Good^FRM~2017:Individual Renew^Good^FRM',Membership_2015_Status__c='Individual New Comp^Lapsed^None',
                             Membership_2016_Status__c='Individual Renew^Good^FRM',
                             Membership_2017_Status__c='Individual Renew^Good^FRM',
                              Membership_Type__c = 'Individual'                          
                             );
        insert contact;
        
    }
    
    @isTest
    private static void testBatch(){
        
        setup();
        Test.startTest();    
                
        batchMembershipHistory batch = new batchMembershipHistory(2017,null);
        Database.executeBatch(batch);

        Test.stopTest();        
    }
    
}