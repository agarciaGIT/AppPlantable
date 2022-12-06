@isTest

Private class HubspotSyncUpdate_Test {
    
    
        @isTest  static void HubCallout() {
            // Set mock callout class 
            
            Test.setMock(HttpCalloutMock.class, new HubMockHttpResponseGenerator(200));
            
            // Call method to test.
            // This causes a fake response to be sent
            // from the class that implements HttpCalloutMock.
            // List<String> response = new List<String>();
            Test.startTest();
            List<string> response = HubspotSyncUpdate.syncMethod();
            Test.stopTest();
            
            System.assertEquals('Sync Request Succeeded', response[0]); 
            
        }
    
    @isTest static void HubCallout2() {
        
        Test.setMock(HttpCalloutMock.class, new HubMockHttpResponseGenerator(404));
        
        Test.startTest();
        List<string> response = HubspotSyncUpdate.syncMethod();
        Test.stopTest();
        System.assertEquals(true, response[0].contains('404')); 
    }
}