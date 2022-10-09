@IsTest
public with sharing class IpDataApiControllerTest {

    @IsTest
    static void fetchIpSuccess(){
        Test.setMock(HttpCalloutMock.class, new IpDataApiControllerHttpMock());
        Test.startTest();
        new IpDataApiController(new sfdcAppRemoter());
        Test.stopTest();
    }

}