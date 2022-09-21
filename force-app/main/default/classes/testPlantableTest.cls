@isTest
Public class testPlantableTest {
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        //test.startTest();
        Account act = new Account();
        act.Name='testCustomer211';
        //act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        insert act;
        
        //Plant_Customer_BC.updateAccountInfo(Plant_Customer_BC.AccountInfo_Wrap act);
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
       /* HttpResponse res = Plant_Customer_BC.updateAccountInfo();
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());*/
    }

public testMethod static void CustomerTest3(){
        
    Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
    insert ShippingDate;
    
    Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
    insert DeliverySchedule;
    
    String jsonBody='{"OrderNumber":"B23456"}';
    
    //String jsonBody = JSON.serialize(dDateWrapper1);
    System.debug('AAA Testing JSon'+jsonBody);
    RestRequest request = new RestRequest();
    request.addHeader('Content-Type', 'application/json');
    request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/Customer/getorders';
    System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
    // request.setBody(JSON.serialize(jsonBody));
    request.httpMethod='PUT';
    RestContext.request=request;
    request.requestBody = Blob.valueOf(jsonBody);
    
    RestResponse resp = new RestResponse();
    RestContext.response = resp;
    
    Plant_RESTCustomer.updateCustomerDetails();
    //test.stopTest();
}

}