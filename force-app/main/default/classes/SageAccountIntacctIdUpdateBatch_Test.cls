@isTest
public class SageAccountIntacctIdUpdateBatch_Test {
    
    @isTest
    Static void unitTest(){
        
        Account Acc = new Account(Name = 'test',GARP_ID__c ='12345');
        insert acc;
        
        
        Test.startTest();
        database.executeBatch(new SageAccountIntacctIdUpdateBatch());
        Test.stopTest();
    }

}