@isTest
public class AccountSuggesticLastSeenbatchTest {
    public static testMethod void accountSuggesticBatchTest(){
        Test.startTest();  
        Account acc = new Account();
        acc.Name='Test Account';
        acc.Email__c='test@test.com';
        acc.Batch_Last_KPI__c=null;
        acc.Reboot_Start_Date__c = system.today();
        acc.Product_Count_ZJ_Reboot__c = 1;
        acc.BillingStreet='25 Jackson\n\rApt 1C';
        insert acc; 
        AccountSuggesticLastSeenbatch bte = new AccountSuggesticLastSeenbatch();
        AccountSuggesticLastSeenbatch bt = new AccountSuggesticLastSeenbatch('SELECT Id,Email__c FROM Account Limit 1');
        database.executeBatch(bt); 
        Test.stopTest();
    }
}