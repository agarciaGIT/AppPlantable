@isTest
private class ChargentSFATransactionTriggerTest {
    
    @TestSetup
    static void createTestData() {
        Integer totalCount = 3;
        List<Opportunity> OppResults=TestDataFactory.createOpportunity(totalCount);
        OppResults[0].StageName = 'New Lead';
        OppResults[1].StageName = 'New Lead';
        insert OppResults;
        
        List<ChargentSFA__Transaction__c> TransactionResults=TestDataFactory.createChargentSFATransaction(totalCount,OppResults);
        TransactionResults[0].ChargentSFA__Response_Status__c = 'Approved';
        TransactionResults[0].ChargentSFA__Type__c = 'Refund';
        TransactionResults[0].ChargentSFA__Recurring__c = false;
        TransactionResults[0].ChargentSFA__Opportunity__c = OppResults[0].Id;
        insert TransactionResults;
    }
    
    
    @isTest static void testChargentSFATransaction(){
        List<ChargentSFA__Transaction__c> TransactionList = [Select Id,ChargentSFA__Opportunity__c  from ChargentSFA__Transaction__c  LIMIT 2];
        TransactionList[0].ChargentSFA__Type__c ='Void';
        update TransactionList;
    }
}