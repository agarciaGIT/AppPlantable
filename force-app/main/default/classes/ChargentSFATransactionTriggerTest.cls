@isTest
private class ChargentSFATransactionTriggerTest {
    
    @TestSetup
    static void createTestData() {
        TestClassUtil.isForNewTrigger();
        Integer totalCount = 3;
        List<Opportunity> OppResults=TestDataFactory.createOpportunity(totalCount);
        OppResults[0].StageName = 'New Lead';
        OppResults[1].StageName = 'New Lead';
        insert OppResults;
        
        List<ChargentSFA__Transaction__c> TransactionResults=TestDataFactory.createChargentSFATransaction(totalCount,OppResults);
        TransactionResults[0].ChargentSFA__Response_Status__c = 'Approved';
        TransactionResults[0].ChargentSFA__Type__c = 'Charge';
        TransactionResults[0].ChargentSFA__Recurring__c = false;
        TransactionResults[0].ChargentSFA__Opportunity__c = OppResults[0].Id;
        insert TransactionResults;
    }
    
    
    @isTest static void testChargentSFATransaction(){
        TestClassUtil.isForNewTrigger();
        List<ChargentSFA__Transaction__c> TransactionList = [Select Id,ChargentSFA__Opportunity__c  from ChargentSFA__Transaction__c  LIMIT 2];
        update TransactionList;
    }
}