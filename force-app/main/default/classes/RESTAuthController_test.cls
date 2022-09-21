@isTest 
public class RESTAuthController_test {
    
    public static void setup(){
        
        API_User__c au = new API_User__c(Client_Id__c = '123', Client_Secret__c = 'ABC', Username__c = 'user', Password__c = 'password');
        insert au;
    }
    
    @isTest
    private static void test1(){
        setup();
        Test.startTest();    
        
        //String s = RESTAuthController.generateAccesToken();
        //System.debug('s:' + s);
        
        //RESTAuthController.respAuth ra = RESTAuthController.processAPIAuth();
        //System.debug('ra: ' + ra);
        
        String val = RESTAuthController.verifyToken('xxxxx');
        System.debug('Valid: ' + val);
        
        String jsonReq = '{"grant_type":"password","client_id":"123","client_secret":"ABC","username":"user","password":"password"}';

		RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/auth';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(jsonReq);
        
        RestContext.request = request;
        RestContext.response = response;
        RESTAuthController.postAuth();
        
        Test.stopTest();        
    }
    
}