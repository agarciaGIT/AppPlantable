/*
*   @Desciption     :   Plantable DiscountCodes Service class, execute request in sf and return result
*   @Create date    :   07-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Main class     :   Plan_DiscountCodes_SC
*/

@isTest
public with sharing class Plant_DiscountCodes_SC_Test {

    //@ Default Contructor
    public Plant_DiscountCodes_SC_Test() {

    }
     //@ Method 1
     static testMethod void Plant_DiscountCodes_Test1(){
         
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
        
        Plant_Discount_Code__c discountCode = Plant_TestDataFactory.createDiscountCode(1, 'Active', '')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode;
         
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        insert orderProperty;
         
        Plant_Order_Properties__c orderProperty1 = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty1.Plant_Account__c= accounts.id;
        orderProperty1.Shipping_Address__c=shippingAddress.id;
        insert orderProperty1;
         
        Plant_Discount_Selection__c discountSelection =new Plant_Discount_Selection__c();
        discountSelection.Plant_Discount_Code__c=discountCode.id;
        discountSelection.Plant_Order_Properties__c=orderProperty.id;
        insert discountSelection;
        
        Plant_Related_Code__c RelatedCode=new Plant_Related_Code__c();
        RelatedCode.Plant_Discount_Code_Master__c=discountCode.id;
        RelatedCode.Plant_Discount_Code_Related__c=discountCode.Id;
        insert RelatedCode;
         
        dcReqWrapper dcw=new dcReqWrapper();
        dcw.OrderId=orderProperty1.id;
        dcw.Product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();//dcw.Product=orderProperty.RecordTypeId;
        dcw.DisCode=discountCode.Plant_Code__c;
        
       	String jsonBody=JSON.serialize(dcw);

        String myJSON3='{"Exception":"Exception"}';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/discount/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTDiscountCodes.setDcode();
         
        
    }
    
    //@ Method 2
    static testMethod void Plant_DiscountCodes_Test2(){
                
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
        
        Plant_Discount_Code__c discountCode = Plant_TestDataFactory.createDiscountCode(1, 'Active', '')[0];
        discountCode.Plant_Status__c='Draft';
        insert discountCode;
        
             
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        insert orderProperty;
        
        Plant_Discount_Selection__c discountSelection =new Plant_Discount_Selection__c();
        discountSelection.Plant_Discount_Code__c=discountCode.id;
        discountSelection.Plant_Order_Properties__c=orderProperty.id;
        insert discountSelection;
        
        Plant_Discount_Selection__c discountSelection1 =new Plant_Discount_Selection__c();
        discountSelection1.Plant_Discount_Code__c=discountCode.id;
        discountSelection1.Plant_Order_Properties__c=orderProperty.id;
        insert discountSelection1;
        
        Plant_Related_Code__c RelatedCode=new Plant_Related_Code__c();
        RelatedCode.Plant_Discount_Code_Master__c=discountCode.id;
        RelatedCode.Plant_Discount_Code_Related__c=discountCode.Id;
        insert RelatedCode;
        
        dcReqWrapper dcw=new dcReqWrapper();
        dcw.OrderId=orderProperty.id;
        dcw.Product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();//dcw.Product=orderProperty.RecordTypeId;
        dcw.DisCode=discountCode.Plant_Code__c;
        
       	String jsonBody=JSON.serialize(dcw);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/discount/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTDiscountCodes.setDcode();
    }
    
    //@ Method 3
    static testMethod void Plant_DiscountCodes_Test3(){
                
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
        
        Plant_Discount_Code__c discountCode = Plant_TestDataFactory.createDiscountCode(1, 'Active', 'Reboot')[0];
        discountCode.Plant_Status__c='draft';
        insert discountCode;
       
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        insert orderProperty;
        
               
        dcReqWrapper dcw1=new dcReqWrapper();
        dcw1.OrderId='kjafjsdnf';
        dcw1.Product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();//dcw1.Product=orderProperty.RecordTypeId;
        dcw1.DisCode=discountCode.Plant_Code__c;
        
        
        
        String jsonBody=JSON.serialize(dcw1);
        
        // @ Running Tests
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/discount/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTDiscountCodes.setDcode();
    }
    
    //@ Method 4
    static testMethod void Plant_DiscountCodes_Test4(){
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
        
        Plant_Discount_Code__c discountCode = Plant_TestDataFactory.createDiscountCode(1, 'Active', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode;
        
        Plant_Discount_Code__c discountCode2 = Plant_TestDataFactory.createDiscountCode(1, 'Actives', 'Reboot')[0];
        discountCode2.Plant_Status__c='Active';
        insert discountCode2;
        
        Plant_Discount_Code__c discountCode1 = Plant_TestDataFactory.createDiscountCode(1, 'Activ', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode1;
        
             
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        insert orderProperty;
        
        Plant_Discount_Selection__c discountSelection =new Plant_Discount_Selection__c();
        discountSelection.Plant_Discount_Code__c=discountCode.id;
        discountSelection.Plant_Order_Properties__c=orderProperty.id;
        insert discountSelection;
        
        Plant_Discount_Selection__c discountSelection1 =new Plant_Discount_Selection__c();
        discountSelection1.Plant_Discount_Code__c=discountCode1.id;
        discountSelection1.Plant_Order_Properties__c=orderProperty.id;
        insert discountSelection1;
        
        Plant_Related_Code__c RelatedCode=new Plant_Related_Code__c();
        RelatedCode.Plant_Discount_Code_Master__c=discountCode1.id;
        RelatedCode.Plant_Discount_Code_Related__c=discountCode.Id;
        insert RelatedCode;
        
        dcReqWrapper dcw=new dcReqWrapper();
        dcw.OrderId=orderProperty.id;
        dcw.Product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();//dcw.Product=orderProperty.RecordTypeId;
        dcw.DisCode=discountCode.Plant_Code__c;
        
       	String jsonBody=JSON.serialize(dcw);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/discount/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTDiscountCodes.setDcode();
    }
    
    //@ Method 5
    static testMethod void Plant_DiscountCodes_Test5(){
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
        
        Plant_Discount_Code__c discountCode = Plant_TestDataFactory.createDiscountCode(1, 'Active', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode;
        
        Plant_Discount_Code__c discountCode1 = Plant_TestDataFactory.createDiscountCode(1, 'Activ', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode1;
        
             
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        insert orderProperty;
        
        Plant_Discount_Selection__c discountSelection =new Plant_Discount_Selection__c();
        discountSelection.Plant_Discount_Code__c=discountCode.id;
        discountSelection.Plant_Order_Properties__c=orderProperty.id;
        insert discountSelection;
        

        
        Plant_Related_Code__c RelatedCode=new Plant_Related_Code__c();
        RelatedCode.Plant_Discount_Code_Master__c=discountCode.id;
        RelatedCode.Plant_Discount_Code_Related__c=discountCode.Id;
        insert RelatedCode;
        
        dcReqWrapper dcw=new dcReqWrapper();
        dcw.OrderId=orderProperty.id;
        dcw.Product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        //dcw.Product=orderProperty.RecordTypeId;
        dcw.DisCode=discountCode.Plant_Code__c;
        
       	String jsonBody=JSON.serialize(dcw);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/discount/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTDiscountCodes.setDcode();
    }
    
    //@ Method 6
    static testMethod void Plant_DiscountCodes_Test6(){
                
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
        
        Plant_Discount_Code__c discountCode = Plant_TestDataFactory.createDiscountCode(1, 'Active', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode;
       
        
        Plant_Discount_Code__c discountCode1 = Plant_TestDataFactory.createDiscountCode(1, 'Activ', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode1;
        
             
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        insert orderProperty;
        //String Name = Schema.getGlobalDescribe().get(orderProperty).getDescribe().getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        
        Plant_Discount_Selection__c discountSelection =new Plant_Discount_Selection__c();
        discountSelection.Plant_Discount_Code__c=discountCode.id;
        discountSelection.Plant_Order_Properties__c=orderProperty.id;
        insert discountSelection;
        
        Plant_Discount_Selection__c discountSelection1 =new Plant_Discount_Selection__c();
        discountSelection1.Plant_Discount_Code__c=discountCode1.id;
        discountSelection1.Plant_Order_Properties__c=orderProperty.id;
        insert discountSelection1;
        
        Plant_Related_Code__c RelatedCode=new Plant_Related_Code__c();
        RelatedCode.Plant_Discount_Code_Master__c=discountCode.id;
        RelatedCode.Plant_Discount_Code_Related__c=discountCode1.Id;
        insert RelatedCode;
        
        //String namee=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        dcReqWrapper dcw=new dcReqWrapper();
        dcw.OrderId=orderProperty.id;
        dcw.Product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        dcw.DisCode=discountCode.Plant_Code__c;
        
       	String jsonBody=JSON.serialize(dcw);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/discount/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTDiscountCodes.setDcode();
    }
    
    //@ Method 7
    static testMethod void Plant_DiscountCodes_Test7(){
         
        
        String jsonBody='{"Exception":"Exception"}';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/discount/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTDiscountCodes.setDcode();
		
        Map<String,String> classDetail = Plant_DiscountCodes_BC.getClassDetail();
        Plant_DiscountCodes_BC piscountCodesBC=new Plant_DiscountCodes_BC();
        Plant_Shipping_BC.getClassDetail();
        Plant_DiscountCodes_SC pDiscountCodesSC=new Plant_DiscountCodes_SC();
        Plant_RESTDiscountCodes pRESTDiscountCodes = new Plant_RESTDiscountCodes();
        
    }
    
    
    
    public class dcReqWrapper{
        public String OrderId;// Order Property Id
        public String Product; // Order Property Record type 
        public String DisCode;
        
        }
}