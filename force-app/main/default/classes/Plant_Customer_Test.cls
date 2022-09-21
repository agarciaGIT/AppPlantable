/*
*   @Desciption     :   Class for creating test data 
*   @Create date    :   11-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Main Class		:	Plant_Customer_BC, Plant_Customer_SC, Plant_RESTCustomer
*/
@isTest

public class Plant_Customer_Test {
    
    // Default constructor 
    public testMethod static void  Plant_Customer_Test() {
        Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        Plant_Customer_BC.AccountInfo_Wrap accwrap8=new Plant_Customer_BC.AccountInfo_Wrap();
        accWrap8.authenticationToken=act.plant_Authentication_Token__c;
        accWrap8.email=act.Email__c;
        accwrap8.name=act.Name;
        accwrap8.phone=act.Phone;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        //String jsonBody='{"OrderNumber":"B23456"}';
        
        String jsonBody = JSON.serialize(accwrap8);
        System.debug('AAA Testing JSon'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/Customer/setSubscriptionAddress';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTCustomer.updateCustomerDetails();
        
    }	
    // Desc: Method 1  getSubscriptionInformation
    public testMethod static void CustomerTest1(){
        
        Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        Plant_Customer_BC.AccountInfo_Wrap accwrap8=new Plant_Customer_BC.AccountInfo_Wrap();
        accWrap8.authenticationToken=act.plant_Authentication_Token__c;
        accWrap8.email=act.Email__c;
        accwrap8.name=act.Name;
        accwrap8.phone=act.Phone;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        //String jsonBody='{"OrderNumber":"B23456"}';
        
        String jsonBody = JSON.serialize(accwrap8);
        System.debug('AAA Testing JSon'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/Customer/getSubscriptionInformation';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        
        
        Plant_RESTCustomer.updateCustomerDetails();
        Plant_RESTCustomer.createAccount();
    }
    
    
    
    
    // Desc: Method 2
    public testMethod static void CustomerTest2(){
        Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        
        Plant_Customer_BC.AccountInfo_Wrap accwrap21=new Plant_Customer_BC.AccountInfo_Wrap();
        accwrap21.authenticationToken='';
        accwrap21.email='';
        accwrap21.name='';
        accwrap21.phone='';
        //insert accwrap21;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        //String jsonBody='{"OrderNumber":"B23456"}';
        
        String jsonBody = JSON.serialize(accwrap21);
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
        
    }
    
    // Desc: Method 3
    public testMethod static void CustomerTest3(){
         Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        
        
        
        Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
        insert meal;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Order order = new order(Accountid=accounts.id, EffectiveDate=System.today(), Status ='Draft');
        insert order;
        
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 2)[0];
        insert DeliverySchedule;
        
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        insert orderProperty;
        
        
        Order orders = new Order();
        orders.AccountId='0013J00000Pq2s7QAB';
        
        orders.EffectiveDate = Date.today();
        orders.Status='Draft';
        orders.Amount_to_Pay__c = 5646;
        
        
        //orders.ShipmentDate = orderProperty.ShipmentDate();
        insert orders;
        
        
        Plant_Customer_BC.OrderDetails_Wrap ordwrap3=new Plant_Customer_BC.OrderDetails_Wrap();
        Order ord= new Order();
        ord.Chargent_Order__c ='a113J000000TnlCQAS';
        
        ord.AccountId = '0013J00000PPwgeQAD';
        ord.EffectiveDate = Date.today();
        ord.Status = 'Draft';
        ord.Pricebook2Id = '01s1I000003hj46QAA';
        ord.Chargent_Order__c = ord.id; 
        insert ord;
        //ord.OrderNumber = 00000220;
        ChargentOrders__ChargentOrder__c  chargentOrders = new ChargentOrders__ChargentOrder__c();
        //chargentOrders.ChargentOrders__Charge_Amount__c = 50.9;
       
        //decimal chargentAmount = chargentOrders.ChargentOrders__Charge_Amount__c; 
        chargentOrders.ChargentOrders__Charge_Amount__c = 50;
       chargentOrders.ChargentOrders__Invoice_Number__c = '736578';
         insert chargentOrders;
        //ord.comty_Chargent_Order__r.ChargentOrders__Charge_Amount__c = (Decimal)chargentOrders.ChargentOrders__Charge_Amount__c;
        //ord.comty_Chargent_Order__r.ChargentOrders__Invoice_Number__c ='736578';
        //ord.Plant_Order_Properties__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c = Date.today();
        
        Plant_Shipping_Date__c plantShip = new Plant_Shipping_Date__c();
        plantShip.Plant_Shipping_Date__c = Date.today();
        insert plantShip;
        
        Plant_Order_Properties__c plantOrder = New Plant_Order_Properties__c();
        plantOrder.Plant_Shipping_Date__c = plantShip.Id;
        insert plantOrder;
        
        
        
        Order ord_uth = [select Account.plant_Authentication_Token__c from Order Where AccountId = '0013J00000Pq2s7QAB'];
        ordwrap3.OrderNumber =orders.Id;
        //ordwrap3.plant_Authentication_Token__c =ord_uth.Account.plant_Authentication_Token__c;
        //=================================
       
            
            
            //================================
            
            
            //String jsonBody='{"OrderNumber":"B23456"}';
            
            String jsonBody = JSON.serialize(ordwrap3);
        System.debug('AAA Testing JSon'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/Customer/getorderDetail';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTCustomer.updateCustomerDetails();
        
    }
    
    // Desc: Method 4
    public testMethod static void CustomerTest4(){
        Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        Plant_Customer_BC.AccountInfo_Wrap accwrap4=new Plant_Customer_BC.AccountInfo_Wrap();
        accWrap4.authenticationToken=act.plant_Authentication_Token__c;
        accWrap4.email=act.Email__c;
        accwrap4.name=act.Name;
        accwrap4.phone=act.Phone;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        //String jsonBody='{"OrderNumber":"B23456"}';
        
        String jsonBody = JSON.serialize(accwrap4);
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
        
    }
    
    // Desc: Method 5
    public testMethod static void CustomerTest5(){
        Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        Plant_Customer_BC.AccountInfo_Wrap accwrap5=new Plant_Customer_BC.AccountInfo_Wrap();
        accWrap5.authenticationToken=act.plant_Authentication_Token__c;
        accWrap5.email=act.Email__c;
        accwrap5.name=act.Name;
        accwrap5.phone=act.Phone;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        //String jsonBody='{"OrderNumber":"B23456"}';
        
        String jsonBody = JSON.serialize(accwrap5);
        System.debug('AAA Testing JSon'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/Customer/setSubscriptionPaymentDetails';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTCustomer.updateCustomerDetails();
        
    }
    
    // Desc: Method 6
    public testMethod static void CustomerTest6(){
        Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        Plant_Customer_BC.AccountInfo_Wrap accwrap6=new Plant_Customer_BC.AccountInfo_Wrap();
        accWrap6.authenticationToken=act.plant_Authentication_Token__c;
        accWrap6.email=act.Email__c;
        accwrap6.name=act.Name;
        accwrap6.phone=act.Phone;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        //String jsonBody='{"OrderNumber":"B23456"}';
        
        String jsonBody = JSON.serialize(accwrap6);
        System.debug('AAA Testing JSon'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/Customer/updateCustomerDetails';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTCustomer.updateCustomerDetails();
        
    }
    // Desc: Method 7
    public testMethod static void CustomerTest7(){
        Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        Plant_Customer_BC.AccountInfo_Wrap accwrap7=new Plant_Customer_BC.AccountInfo_Wrap();
        accWrap7.authenticationToken=act.plant_Authentication_Token__c;
        accWrap7.email=act.Email__c;
        accwrap7.name=act.Name;
        accwrap7.phone=act.Phone;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        //String jsonBody='{"OrderNumber":"B23456"}';
        
        String jsonBody = JSON.serialize(accwrap7);
        System.debug('AAA Testing JSon'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/Customer/setDeliveryDate';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTCustomer.updateCustomerDetails();
        
    }
    // Desc: Method 8
    public testMethod static void CustomerTest8(){
        Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        Plant_Customer_BC.AccountInfo_Wrap accwrap8=new Plant_Customer_BC.AccountInfo_Wrap();
        accWrap8.authenticationToken=act.plant_Authentication_Token__c;
        accWrap8.email=act.Email__c;
        accwrap8.name=act.Name;
        accwrap8.phone=act.Phone;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        //String jsonBody='{"OrderNumber":"B23456"}';
        
        String jsonBody = JSON.serialize(accwrap8);
        System.debug('AAA Testing JSon'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/Customer/updateOrderShippingAddress';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTCustomer.updateCustomerDetails();
        
    }
    // Desc: Method 8
    public testMethod static void CustomerTest9(){
        Account act = new Account();
        act.Name='testCustomer2';
        act.plant_Authentication_Token__c = 'U8EPOZUOL3zgGb2CPGFTtb5gGKsMCzhb0EnQkwpGB7Y2jtRYtIFvyQkg0OJOReJp';
        act.plant_TokenCreatedDateTime__c=System.now();
        act.email__c='abc@invalid.com';
        act.phone='0987654321';
        insert act;
        Plant_Customer_BC.AccountInfo_Wrap accwrap9=new Plant_Customer_BC.AccountInfo_Wrap();
        accWrap9.authenticationToken=act.plant_Authentication_Token__c;
        accWrap9.email=act.Email__c;
        accWrap9.name=act.Name;
        accWrap9.phone=act.Phone;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 1)[0];
        insert DeliverySchedule;
        
        //String jsonBody='{"OrderNumber":"B23456"}';
        
        String jsonBody = JSON.serialize(accWrap9);
        System.debug('AAA Testing JSon'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/Customer/setSubscriptionMeals';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        // request.setBody(JSON.serialize(jsonBody));
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTCustomer.updateCustomerDetails();
        
    }
    
    
    
}