@isTest
public class Plant_AppAnalytics_test {

    // @ Method 1    
    static testMethod void plant_GetOnBoardingStatus_Tests(){
        
        // Create Onboard
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        string jsonBody = '{ "accountId": "'+acct.Id+'", "lastLogin": "2022-09-16T09:49:00.000" }';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/appanalytics/login';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.requestBody = Blob.valueOf(jsonBody);
        request.httpMethod='POST';
        System.debug('@#### req => '+request);
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        Plant_RESTOnboarding prestMeal=new Plant_RESTOnboarding();

        Plant_RESTAppAnalytics.postAppAnalytics();
    }
}