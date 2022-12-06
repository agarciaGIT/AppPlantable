@isTest
Private class HubspotSyncUpdate_Test1 {
    
    @isTest static void UnitTest1() {
        
        Test.setMock(HttpCalloutMock.class, new HubMockHttpResponseGenerator(200));
        
        Test.startTest();
        HubspotSyncUpdate.syncMethod();
        Test.stopTest();
    }
    
    //For Failure Case
     @isTest static void UnitTest2() {
        
        Test.setMock(HttpCalloutMock.class, new HubMockHttpResponseGenerator(404));
        
        Test.startTest();
        HubspotSyncUpdate.syncMethod();
        Test.stopTest();
    }
}