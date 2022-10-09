@isTest
public class FontevaUpdatesTriggerTest {
    @isTest static void testEvent() {
        Account account = new Account(Name = 'test');
        insert account;
        
        Fonteva_Updates__e fontUpd = new Fonteva_Updates__e();
        fontUpd.Account_Id__c = account.Id;
        Test.startTest();
        EventBus.publish(fontUpd);
        Test.stopTest();
    }
}