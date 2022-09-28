/*
*   @Desciption     :   Test Class of Plantable Shipping Service class,
*   @Create date    :   12-04-2022
*   @Author         :   Bhagwan S
*	@Last Updated	:	
_________________________________________________________________________________________________________________________________________________________
    @Main class     :   Plant_Shipping_SC
*/
@isTest
public with sharing class Plant_Shipping_SC_Test {

    // @ Default Constructor
    public Plant_Shipping_SC_Test() {

    }
    
    // AG Methods
    static testMethod void plant_Shipping_GetStates1(){
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/shipping/v1/getshippingstates';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTShipping.checkDeliveryDate();
        
    }
    
    // @ Method 1
    static testMethod void plant_Shipping_Test1(){
        
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        deliveryDateWrapper dDateWrapper1 =new deliveryDateWrapper();
        dDateWrapper1.street1 = '200 Park Avenue';
        dDateWrapper1.street2 = 'Midtown'; 
        dDateWrapper1.street3 = 'Manhattan'; 
        dDateWrapper1.city = 'New York';
        dDateWrapper1.state = DeliverySchedule.Plant_State_Code__c; 
        dDateWrapper1.zip = DeliverySchedule.Plant_Zip_Code__c;
        dDateWrapper1.country = 'USA';
        dDateWrapper1.phone = '+6543749578';
        dDateWrapper1.canSMS = 'Yes';
        
        String jsonBody = JSON.serialize(dDateWrapper1);
        System.debug('AAA Testing JSon'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/shipping/v1/getDeliverydates';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='GET';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTShipping.checkDeliveryDate();
        

    }
    
    // @ Method 2
    static testMethod void plant_Shipping_Test2(){
        String jsonBody = '{}';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/shipping/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='GET';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTShipping.checkDeliveryDate();
        

    }
    
    // @ Method 3
    static testMethod void plant_Shipping_Test3(){
        
        String jsonBody='{"street1":"200 Park Avenue","street2":"Midtown","street3":"Manhattan","city":"New York","state":"New York","zip":"134356","country":"USA","phone":"+6543749578","canSMS":"Yes"}';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/shipping/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        
        request.httpMethod='GET';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTShipping.checkDeliveryDate();
        

    }
    
    // @ Method 4
    static testMethod void plant_Shipping_Test4(){
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
            
        
        deliveryDateWrapper dDateWrapper =new deliveryDateWrapper();
        dDateWrapper.street1 = '200 Park Avenue';
        dDateWrapper.street2 = 'Midtown'; 
        dDateWrapper.street3 = 'Manhattan'; 
        dDateWrapper.city = 'New York';
        dDateWrapper.state = DeliverySchedule.Plant_State_Code__c; 
        dDateWrapper.zip = '54321';
        dDateWrapper.country = 'USA';
        dDateWrapper.phone = '+6543749578';
        dDateWrapper.canSMS = 'Yes';
        
        String jsonBody = JSON.serialize(dDateWrapper);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/shipping/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        
        request.httpMethod='GET';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTShipping.checkDeliveryDate();

    }
    
    // @ Method 5
    static testMethod void plant_Shipping_Test5(){
        
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 2)[0];
        insert DeliverySchedule;
        
        deliveryDateWrapper dDateWrapper1 =new deliveryDateWrapper();
        dDateWrapper1.street1 = '200 Park Avenue';
        dDateWrapper1.street2 = 'Midtown'; 
        dDateWrapper1.street3 = 'Manhattan'; 
        dDateWrapper1.city = 'New York';
        dDateWrapper1.state = DeliverySchedule.Plant_State_Code__c; 
        dDateWrapper1.zip = DeliverySchedule.Plant_Zip_Code__c;
        dDateWrapper1.country = 'USA';
        dDateWrapper1.phone = '+6543749578';
        dDateWrapper1.canSMS = 'Yes';
        
        String jsonBody = JSON.serialize(dDateWrapper1);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/shipping/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        
        request.httpMethod='GET';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTShipping.checkDeliveryDate();

    }
    
    // @ Method 6
    static testMethod void plant_Shipping_Test6(){
        
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 3)[0];
        insert DeliverySchedule;
        
        deliveryDateWrapper dDateWrapper1 =new deliveryDateWrapper();
        dDateWrapper1.street1 = '200 Park Avenue';
        dDateWrapper1.street2 = 'Midtown'; 
        dDateWrapper1.street3 = 'Manhattan'; 
        dDateWrapper1.city = 'New York';
        dDateWrapper1.state = DeliverySchedule.Plant_State_Code__c; 
        dDateWrapper1.zip = DeliverySchedule.Plant_Zip_Code__c;
        dDateWrapper1.country = 'USA';
        dDateWrapper1.phone = '+6543749578';
        dDateWrapper1.canSMS = 'Yes';
        
        String jsonBody = JSON.serialize(dDateWrapper1);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/shipping/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        
        request.httpMethod='GET';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);

        RestResponse resp = new RestResponse();
        RestContext.response = resp;
		
        Plant_RESTShipping.checkDeliveryDate();

    }
    
    // @ Method 7
    static testMethod void plant_Shipping_Test7(){
        Map<String,String> classDetail = Plant_Shipping_BC.getClassDetail();
        Plant_Shipping_BC pShippingBC=new Plant_Shipping_BC();
        Plant_Shipping_BC.getClassDetail();
        Plant_Shipping_SC pShippingSC=new Plant_Shipping_SC();
        Plant_RESTShipping pRESTShipping = new Plant_RESTShipping();
    }
    
	// @ Internal Methods
    static testMethod void plant_Shipping_Int1(){
       
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
       
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 3)[0];
        insert DeliverySchedule;
        System.debug('>> DeliverySchedule: ' + DeliverySchedule);
       
        Plant_Shipping_Address__c ShippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        insert ShippingAddress;
        System.debug('>> ShippingAddress: ' + ShippingAddress);
       
        Plant_Shipping_BC.getClosestShipmentDate(Date.Today(), ShippingAddress.Id,NULL,NULL,NULL);
     	Plant_Shipping_BC.getShippingDuration(ShippingAddress.Id,NULL,NULL);
        
        MAP<String,Plant_Shipping_Address__c> mapShipAddr = new MAP<String,Plant_Shipping_Address__c>();
        MAP<String,Plant_Delivery_Schedule__c> mapDelivSched = new MAP<String,Plant_Delivery_Schedule__c>();

		mapShipAddr.put(ShippingAddress.id,ShippingAddress);
        mapDelivSched.put(DeliverySchedule.Plant_Zip_Code__c + ':' + DeliverySchedule.Plant_State_Code__c,DeliverySchedule);
        List<Plant_Shipping_Date__c> lstSD = [SELECT Id, Name, Plant_Shipping_Date__c, Plant_Total_Orders__c, Max_Orders_Allowed__c, Plant_One_Day_Shipping_Delivery_Date__c, Plant_2_Day_Shipping_Delivery_Date__c, X3_Day_Shipping_Delivery_Date__c, Is_Shipping_Date_Available__c FROM Plant_Shipping_Date__c WHERE Is_Shipping_Date_Available__c=True AND Plant_Shipping_Date__c>TODAY ORDER BY Plant_Shipping_Date__c ASC LIMIT 10];
        
        System.debug('>> mapShipAddr: ' + mapShipAddr);
        System.debug('>> mapDelivSched: ' + mapDelivSched);
        System.debug('>> lstSD: ' + lstSD);
        
        Plant_Shipping_BC.getClosestShipmentDate(Date.Today(), ShippingAddress.Id,mapShipAddr,mapDelivSched,lstSD);
        Plant_Shipping_BC.getShippingDuration(ShippingAddress.Id,mapShipAddr,mapDelivSched);

    }

    public class deliveryDateWrapper{
        public String street1;
        public String street2; 
        public String street3;
        public String city;
        public String state; 
        public String zip;
        public String country;
        public String phone;
        public String canSMS;
    }

}