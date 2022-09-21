/*
*   @Desciption     :   Test Class of Plantable Meals Service class,
*   @Create date    :   12-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Main class     :   Plant_AuthorizeController_SC, Plant_AuthorizeController_BC
*/
@isTest
public class plant_AuthorizeController_Test {
    @testSetup
    public static void testsetup(){
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcdefghijklmnopqrstuvwxyz';
    	accounts.plant_AuthenticationToken__c='abcdefghijklmnopqrstuvwxyz';
        accounts.plant_TokenCreatedDateTime__c=System.now();
        insert accounts;
    }
   
public testMethod static void AuthorizeTest1(){
       	
    	Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcd';
    	accounts.plant_AuthenticationToken__c='abcd';
        insert accounts;
    	plant_AuthorizeController.userInfoReqWrap uRap=new plant_AuthorizeController.userInfoReqWrap();
    	uRap.email='xyz.ab@tmail.com';
   		urap.password='12345';
        String jsonBody = Json.serialize(urap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/authenticate/GetAccessToken';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
       	plant_RESTAuthorizeController.getAuthorizationToken(); 
        
    }
    public testMethod static void AuthorizeTest4(){
       	
    	Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcd';
    	accounts.plant_AuthenticationToken__c='abcd';
        insert accounts;
    	plant_AuthorizeController.userInfoReqWrap uRap=new plant_AuthorizeController.userInfoReqWrap();
    	uRap.email='';
   		urap.password='12345';
        String jsonBody = Json.serialize(urap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/authenticate/GetAccessToken';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
       	plant_RESTAuthorizeController.getAuthorizationToken(); 
        
    }
    public testMethod static void AuthorizeTest5(){
       	
    	Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcd';
    	accounts.plant_AuthenticationToken__c='abcd';
        insert accounts;
    	plant_AuthorizeController.userInfoReqWrap uRap=new plant_AuthorizeController.userInfoReqWrap();
    	uRap.email='xyz.ab@tmail.com';
   		urap.password='1245';
        String jsonBody = Json.serialize(urap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/authenticate/GetAccessToken';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
       	plant_RESTAuthorizeController.getAuthorizationToken(); 
        
    }
     public testMethod static void AuthorizeTest21(){
       	Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.abc@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcd';
    	accounts.plant_AuthenticationToken__c='abcd';
        insert accounts;
    	plant_AuthorizeController.userInfoReqWrap uRap=new plant_AuthorizeController.userInfoReqWrap();
    	uRap.email='';
   		urap.password='12345';
        String jsonBody = Json.serialize(urap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/authenticate/GenerateAccessToken';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
       	plant_RESTAuthorizeController.getAuthorizationToken(); 
        
    }
    public testMethod static void AuthorizeTest22(){
       	Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcd';
    	accounts.plant_AuthenticationToken__c='abcd';
        insert accounts;
    	plant_AuthorizeController.userInfoReqWrap uRap=new plant_AuthorizeController.userInfoReqWrap();
    	uRap.email='xyz.ab@tmail.com';
   		urap.password='12345';
        String jsonBody = Json.serialize(urap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/authenticate/GenerateAccessToken';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
       	plant_RESTAuthorizeController.getAuthorizationToken(); 
        
    }
    
    public testMethod static void AuthorizeTest2(){
       	Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.abc@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcd';
    	accounts.plant_AuthenticationToken__c='abcd';
        insert accounts;
    	plant_AuthorizeController.userInfoReqWrap uRap=new plant_AuthorizeController.userInfoReqWrap();
    	uRap.email='xyz.abc@tmail.com';
   		urap.password='12345';
        String jsonBody = Json.serialize(urap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/authenticate/GenerateAccessToken';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
       	plant_RESTAuthorizeController.getAuthorizationToken(); 
        
    }
    
    public testMethod static void AuthorizeTest3(){
       	Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcd';
    	accounts.plant_AuthenticationToken__c='abcd';
        insert accounts;    	
    	plant_AuthorizeController.userInfoReqWrap uRap=new plant_AuthorizeController.userInfoReqWrap();
    	uRap.email='xyz.ab@tmail.com';
   		urap.password='12345';
        String jsonBody = Json.serialize(urap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/authenticate/RefreshAccessToken';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
       	plant_RESTAuthorizeController.getAuthorizationToken(); 
        
    }
    public testMethod static void AuthorizeTest6(){
       	Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcd';
    	accounts.plant_AuthenticationToken__c='abcd';
        insert accounts;    	
    	plant_AuthorizeController.userInfoReqWrap uRap=new plant_AuthorizeController.userInfoReqWrap();
    	uRap.email='xy.ab@tmail.com';
   		urap.password='12345';
        String jsonBody = Json.serialize(urap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/authenticate/Refresh';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
       	plant_RESTAuthorizeController.getAuthorizationToken(); 
        
    }
    public testMethod static void AuthorizeTest9(){
       	Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
    	accounts.Email__c ='xyz.ab@tmail.com';
    	accounts.plant_UserPasswaord__c='12345';
    	accounts.plant_Authentication_Token__c='abcd';
    	accounts.plant_AuthenticationToken__c='abcd';
        insert accounts;    	
    	plant_AuthorizeController.userInfoReqWrap uRap=new plant_AuthorizeController.userInfoReqWrap();
    	uRap.email='xy.ab@tmail.com';
   		urap.password='12345';
        String jsonBody = Json.serialize(urap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/authenticate/GenerateAccessToken';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
       	plant_RESTAuthorizeController.getAuthorizationToken(); 
        
    }
    public testMethod static void AuthorizeTest7(){
       	Account accounts=[Select id, name, plant_Authentication_Token__c from Account Limit 1];
		String token=accounts.plant_Authentication_Token__c;
        String token1='Rahul';
        plant_AuthorizeController.validateAccessToken('', accounts.id, token);
        plant_AuthorizeController.validate_ByAccessToken(token);
        plant_AuthorizeController.validateAccessToken('', accounts.id, token1);
        plant_AuthorizeController.validate_ByAccessToken(token1);
    
    }
    
    public testMethod static void AuthorizeTest8(){
       	Account accounts=[Select id, name, plant_Authentication_Token__c from Account Limit 1];
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
                
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        insert orderProperty;
		
        String token=accounts.plant_Authentication_Token__c;
        String token1='Rahul';
        plant_AuthorizeController.validateAccessToken(orderProperty.id, '', token);
        plant_AuthorizeController.validateAccessToken(orderProperty.id, '', token1);
       
    }
    
}