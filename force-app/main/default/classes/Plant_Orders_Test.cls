@isTest
public class Plant_Orders_Test {
    
    // @ Default Constructor
    public  Plant_Orders_Test() {
        
    }
    
    
  // AG - test my stuyff
   public testMethod static void Orders_clonePaymentMethod1(){
       
       Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
       insert accounts;
       
       Plant_Payment_Method__c pm = Plant_TestDataFactory.createPaymentMethod(accounts);
       pm.Plant_Is_Account_Record__c = True;
       insert pm;
       
       Plant_Payment_Method__c pm2 = Plant_TestDataFactory.createPaymentMethod(accounts);
       pm2.Plant_Save_Payment_Method__c = True;
       insert pm2;
              
       Plant_Payment_Method__c pmclone = Plant_Orders_BC.clonePaymentMethod(pm, pm.id, True);
       
       List<Plant_Payment_Method__c> lstPayMethods = new List<Plant_Payment_Method__c>();
       lstPayMethods.add(pm);
       Plant_Orders_BC.paymentMethodTriggerHandler(lstPayMethods); 
           
   }
    
    public testMethod static void Orders_TestUpdateInventory1(){
        Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
        insert meal;
        
        List<Meal__c> meals =Plant_TestDataFactory.createMeal(5);
        insert meals;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        List<Plant_Meal_Selection_Meal__c> mealsels = Plant_TestDataFactory.createMealSelMeals(meals, MealSelection);
        insert mealsels;
        
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
        
        List<String> mealSelectionIDs = new List<String>();
        mealSelectionIDs.add(MealSelection.Id);
        Plant_Orders_BC.updateOrderInventory(mealSelectionIDs, false);
        
        List<Meal__c> meals1 =Plant_TestDataFactory.createMeal(3);
        insert meals1;
        
        Plant_Meal_Selection__c Mealselection1=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection1;
        
        List<Plant_Meal_Selection_Meal__c> mealsels1 = Plant_TestDataFactory.createMealSelMeals(meals1, MealSelection1);
        insert mealsels1;
        
        Plant_Orders_BC.replaceOrderInventory(MealSelection.Id, MealSelection1.Id);
        
        Plant_TestDataFactory.creatProduct('PLANTALC');
        Plant_Orders_BC.getPriceBookEntryByProduct('Reboot',null);
    }
    
  
  public testMethod static void Orders_TestPostTrans1(){
        
      Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
      insert meal;
      
      Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
      insert MealSelection;
      
      Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
      insert accounts;
      
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
      
      Order order = Plant_TestDataFactory.creatOrderWithProduct(accounts.Id, 'PLANTALC');
      
      order.status = 'Activated';
      order.Plant_Shipping_Date__c = ShippingDate.Id;
      update order;
      
      
      List<Plant_TransComm_BC.pubTransEvent> pubEvents = new List<Plant_TransComm_BC.pubTransEvent>();
      pubEvents.add(Plant_TransComm_BC.setTransactionEvent('Order Paid',order.AccountId,order.id,null));
          
      Plant_TransComm_BC.publishTransactionEvents(pubEvents);
      Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Paid',order.AccountId,order.id,null));
      
      List<Plant_Transaction__e> lstOrderEvents = new List<Plant_Transaction__e>();
      Plant_Transaction__e newTransEvent = new Plant_Transaction__e(
          Plant_Type__c = 'Order Paid',
          Plant_AccountId__c = order.AccountId,
          Plant_OrderId__c = order.id,
          Plant_SubscriptionId__c = NULL
      );
      lstOrderEvents.add(newTransEvent);
      Plant_Orders_BC.postTransactionOrderHandler(lstOrderEvents);
          
          
  }
    
    
  
  // Test Methods for pre-processOrder 
    public testMethod static void processOrderTest1(){
        cardWrapper cWrapper =new cardWrapper();
        cWrapper.name='Test1';
        cWrapper.cardnumber='123443211234';
        cWrapper.cvv ='332';
        cWrapper.expDate=String.valueof(System.Today()+732);
        
        processOdr_Wrapper pWrap =new processOdr_Wrapper();
        pWrap.orderPropertyId=''; // Order Property Id
        pWrap.accountId='';
        pWrap.lastName='';
        pWrap.firstName='';
        pWrap.phone='';
        pWrap.cardInfo=cWrapper;
        pWrap.sfOrderId='';        // SF Order id (optional: only if case of update)
        pWrap.cTransactionId='';
        
        String jsonBody = Json.serialize(pWrap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/order/ProcessOrder';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setProcessOrder(); 
    }
    
    public testMethod static void processOrderTest2(){
        TransactionReqWrap tWrap=new TransactionReqWrap();
        tWrap.cOrderId='';
        tWrap.sfOrderId='';
        tWrap.orderPropId='';
        tWrap.paymentId='';
        
        String jsonBody = Json.serialize(tWrap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/order/ProcessTransaction';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setProcessOrder(); 
    }    
    public testMethod static void processOrderTest3(){
        processPayment_Wrap pWrap=new processPayment_Wrap();
        pWrap.ObjectId='';
        pWrap.ChargeAmount=10;
        String jsonBody = Json.serialize(pWrap);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/v1/order/ProcessPayment';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setProcessOrder(); 
    }
    /*
// Test Methods for pre-processOrder    
  // @ Method 1
    public testMethod static void Orders_Test1(){
        String jsonBody = '{"String":"String"}';
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/order/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_Orders_SC pOrder=new Plant_Orders_SC();
        Plant_RESTOrders.setPreOrder();
    }
    
    public testMethod static void Orders_Test2(){
        
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
        
        Plant_Utility.addressCapsule aCapsule1 = new Plant_Utility.addressCapsule();
        aCapsule1.street1 = '200 Park Avenue';
        aCapsule1.street2 = 'Midtown'; 
        aCapsule1.street3 = 'Manhattan'; 
        aCapsule1.city = 'New York';
        aCapsule1.state = DeliverySchedule.Plant_State_Code__c; 
        aCapsule1.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule1.country = 'India';
        aCapsule1.phone = '+6543749578';
        aCapsule1.canSMS = True;
        
        Plant_Utility.addressCapsule aCapsule2 = new Plant_Utility.addressCapsule();
        aCapsule2.street1 = '200 Park Avenue';
        aCapsule2.street2 = 'Midtown'; 
        aCapsule2.street3 = 'Manhattan'; 
        aCapsule2.city = 'New York';
         
        aCapsule1.state = DeliverySchedule.Plant_State_Code__c; 
        aCapsule1.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule2.country = 'India';
        aCapsule2.phone = '+6543749578';
        aCapsule2.canSMS = True;
        
        Plant_Utility.wrapMeal wrapMeal=new Plant_Utility.wrapMeal();
        wrapMeal.mealId=meal.id;
        wrapMeal.mealSelectionMealId='';
        List<Plant_Utility.wrapMeal> wrapMeals=new List<Plant_Utility.wrapMeal>();
        wrapMeals.add(wrapMeal);
        
        cardWrapper cWrapper =new cardWrapper();
        cWrapper.name='Test1';
        cWrapper.cardnumber='123443211234';
        cWrapper.cvv ='332';
        cWrapper.expDate=String.valueof(System.Today()+732);
        
        Plant_Orders_Test.opReqWrapper ReqWrapper = new Plant_Orders_Test.opReqWrapper();
        ReqWrapper.product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        ReqWrapper.orderPropertyId=orderProperty.id;
        ReqWrapper.accountId=accounts.id;
        ReqWrapper.mealSelectionId=MealSelection.id;
        ReqWrapper.firstName=accounts.First_Name__c;
        ReqWrapper.lastName=accounts.Last_Name__c;
        ReqWrapper.phone=aCapsule1.phone;
        ReqWrapper.canSMS=aCapsule1.canSMS;
        ReqWrapper.email='abcd@gmail.com';
        ReqWrapper.shippingAddress=aCapsule1;
        ReqWrapper.billingAddress=aCapsule2;
        ReqWrapper.shipASAP='Yes';
        ReqWrapper.shipDate='2022-04-08';
        ReqWrapper.discountCode='';
        ReqWrapper.recurrence='Yes';
        ReqWrapper.cardInformation=cWrapper;
        ReqWrapper.meals=wrapMeals;
        
        
        String jsonBody = JSON.serialize(ReqWrapper);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/order/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setPreOrder();
    }
    
    
    public testMethod static void Orders_Test3(){
        
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
        
        Plant_Utility.addressCapsule aCapsule1 = new Plant_Utility.addressCapsule();
        aCapsule1.street1 = '200 Park Avenue';
        aCapsule1.street2 = 'Midtown'; 
        aCapsule1.street3 = 'Manhattan'; 
        aCapsule1.city = 'New York';
        aCapsule1.state = 'New York'; 
        aCapsule1.zip = '54321';
        aCapsule1.country = 'USA';
        aCapsule1.phone = '+6543749578';
        aCapsule1.canSMS = True;
        
        Plant_Utility.addressCapsule aCapsule2 = new Plant_Utility.addressCapsule();
        aCapsule2.street1 = '200 Park Avenue';
        aCapsule2.street2 = 'Midtown'; 
        aCapsule2.street3 = 'Manhattan'; 
        aCapsule2.city = 'New York';
        aCapsule2.state = 'New York'; 
        aCapsule2.zip = '54321';
        aCapsule2.country = 'USA';
        aCapsule2.phone = '+6543749578';
        aCapsule2.canSMS = True;
        
        Plant_Utility.wrapMeal wrapMeal=new Plant_Utility.wrapMeal();
        wrapMeal.mealId=meal.id;
        wrapMeal.mealSelectionMealId='';
        List<Plant_Utility.wrapMeal> wrapMeals=new List<Plant_Utility.wrapMeal>();
        wrapMeals.add(wrapMeal);
        
        cardWrapper cWrapper =new cardWrapper();
        cWrapper.name='Test1';
        cWrapper.cardnumber='123443211234';
        cWrapper.cvv ='332';
        cWrapper.expDate=String.valueof(System.Today()+732);
        
        Plant_Orders_Test.opReqWrapper ReqWrapper = new Plant_Orders_Test.opReqWrapper();
        ReqWrapper.product='Fake';
        ReqWrapper.orderPropertyId=orderProperty.id;
        ReqWrapper.accountId=accounts.id;
        //ReqWrapper.mealSelectionId=MealSelection.id;
        ReqWrapper.firstName=accounts.First_Name__c;
        ReqWrapper.lastName=accounts.Last_Name__c;
        ReqWrapper.phone=aCapsule1.phone;
        ReqWrapper.canSMS=aCapsule1.canSMS;
        ReqWrapper.email='abcd@gmail.com';
        ReqWrapper.shippingAddress=aCapsule1;
        ReqWrapper.billingAddress=aCapsule2;
        ReqWrapper.shipASAP='Yes';
        ReqWrapper.shipDate='2022-04-08';
        ReqWrapper.discountCode='';
        ReqWrapper.recurrence='Yes';
        ReqWrapper.cardInformation=cWrapper;
        ReqWrapper.meals=wrapMeals;
        
        
        String jsonBody = JSON.serialize(ReqWrapper);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/order/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setPreOrder();
    }
    
    public testMethod static void Orders_Test4(){
        
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
        
        Plant_Utility.addressCapsule aCapsule1 = new Plant_Utility.addressCapsule();
        aCapsule1.street1 = '200 Park Avenue';
        aCapsule1.street2 = 'Midtown'; 
        aCapsule1.street3 = 'Manhattan'; 
        aCapsule1.city = 'New York';
        //aCapsule1.state = DeliverySchedule.Plant_State_Code__c; 
        //aCapsule1.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule1.country = 'US';
        aCapsule1.phone = '+6543749578';
        aCapsule1.canSMS = True;
        
        Plant_Utility.addressCapsule aCapsule2 = new Plant_Utility.addressCapsule();
        aCapsule2.street1 = '200 Park Avenue';
        aCapsule2.street2 = 'Midtown'; 
        aCapsule2.street3 = 'Manhattan'; 
        aCapsule2.city = 'New York';
        //aCapsule2.state = DeliverySchedule.Plant_State_Code__c; 
        //aCapsule2.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule2.country = 'US';
        aCapsule2.phone = '+6543749578';
        aCapsule2.canSMS = True;
        
        Plant_Utility.wrapMeal wrapMeal=new Plant_Utility.wrapMeal();
        wrapMeal.mealId=meal.id;
        wrapMeal.mealSelectionMealId='';
        List<Plant_Utility.wrapMeal> wrapMeals=new List<Plant_Utility.wrapMeal>();
        wrapMeals.add(wrapMeal);
        
        cardWrapper cWrapper =new cardWrapper();
        cWrapper.name='Test1';
        cWrapper.cardnumber='123443211234';
        cWrapper.cvv ='332';
        cWrapper.expDate=String.valueof(System.Today()+732);
        
        Plant_Orders_Test.opReqWrapper ReqWrapper = new Plant_Orders_Test.opReqWrapper();
        ReqWrapper.product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        ReqWrapper.orderPropertyId=orderProperty.id;
        ReqWrapper.accountId=accounts.id;
        ReqWrapper.mealSelectionId=MealSelection.id;
        ReqWrapper.firstName=accounts.First_Name__c;
        ReqWrapper.lastName=accounts.Last_Name__c;
        ReqWrapper.phone='Fake Phone';
        ReqWrapper.canSMS=aCapsule1.canSMS;
        ReqWrapper.email='1234567890';
        ReqWrapper.shippingAddress=aCapsule1;
        ReqWrapper.billingAddress=aCapsule2;
        ReqWrapper.shipASAP='Yes';
        ReqWrapper.shipDate='2022-04-05';
        ReqWrapper.discountCode='';
        ReqWrapper.recurrence='Yes';
        ReqWrapper.cardInformation=cWrapper;
        ReqWrapper.meals=wrapMeals;
        
        
        String jsonBody = JSON.serialize(ReqWrapper);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/order/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setPreOrder();
    }
    
    public testMethod static void Orders_Test8(){
        
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
        
        Plant_Utility.addressCapsule aCapsule1 = new Plant_Utility.addressCapsule();
        aCapsule1.street1 = '200 Park Avenue';
        aCapsule1.street2 = 'Midtown'; 
        aCapsule1.street3 = 'Manhattan'; 
        aCapsule1.city = 'New York';
        aCapsule1.state = DeliverySchedule.Plant_State_Code__c; 
        aCapsule1.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule1.country = 'US';
        aCapsule1.phone = '+6543749578';
        aCapsule1.canSMS = True;
        
        Plant_Utility.addressCapsule aCapsule2 = new Plant_Utility.addressCapsule();
        aCapsule2.street1 = '200 Park Avenue';
        aCapsule2.street2 = 'Midtown'; 
        aCapsule2.street3 = 'Manhattan'; 
        aCapsule2.city = 'New York';
        aCapsule2.state = DeliverySchedule.Plant_State_Code__c; 
        aCapsule2.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule2.country = 'US';
        aCapsule2.phone = '+6543749578';
        aCapsule2.canSMS = True;
        
        Plant_Utility.wrapMeal wrapMeal=new Plant_Utility.wrapMeal();
        wrapMeal.mealId=meal.id;
        wrapMeal.mealSelectionMealId='';
        List<Plant_Utility.wrapMeal> wrapMeals=new List<Plant_Utility.wrapMeal>();
        wrapMeals.add(wrapMeal);
        
        cardWrapper cWrapper =new cardWrapper();
        cWrapper.name='Test1';
        cWrapper.cardnumber='123443211234';
        cWrapper.cvv ='332';
        cWrapper.expDate=String.valueof(System.Today()+732);
        
        Plant_Orders_Test.opReqWrapper ReqWrapper = new Plant_Orders_Test.opReqWrapper();
        ReqWrapper.product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        ReqWrapper.orderPropertyId=orderProperty.id;
        ReqWrapper.accountId=accounts.id;
        ReqWrapper.mealSelectionId=MealSelection.id;
        ReqWrapper.firstName=accounts.First_Name__c;
        ReqWrapper.lastName=accounts.Last_Name__c;
        ReqWrapper.phone='Fake Phone';
        ReqWrapper.canSMS=aCapsule1.canSMS;
        ReqWrapper.email='1234567890';
        ReqWrapper.shippingAddress=aCapsule1;
        ReqWrapper.billingAddress=aCapsule2;
        ReqWrapper.shipASAP='Yes';
        ReqWrapper.shipDate='fake date';
        ReqWrapper.discountCode='';
        ReqWrapper.recurrence='Yes';
        ReqWrapper.cardInformation=cWrapper;
        ReqWrapper.meals=wrapMeals;
        
        
        String jsonBody = JSON.serialize(ReqWrapper);
        //System.debug('==================JOSN Request'+jsonBody);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/order/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setPreOrder();
    }
    
    
    public testMethod static void Orders_Test5(){
        
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
        
        Plant_Utility.addressCapsule aCapsule1 = new Plant_Utility.addressCapsule();
        aCapsule1.street1 = '200 Park Avenue';
        aCapsule1.street2 = 'Midtown'; 
        aCapsule1.street3 = 'Manhattan'; 
        //aCapsule1.city = 'New York';
        //aCapsule1.state = 'New York'; 
        //aCapsule1.zip = '54321';
        aCapsule1.country = 'US';
       // aCapsule1.phone = '+6543749578';
        aCapsule1.canSMS = True;
        
        Plant_Utility.addressCapsule aCapsule2 = new Plant_Utility.addressCapsule();
        aCapsule2.street1 = '200 Park Avenue';
        aCapsule2.street2 = 'Midtown'; 
        aCapsule2.street3 = 'Manhattan'; 
        aCapsule2.city = 'New York';
        //aCapsule2.state = DeliverySchedule.Plant_State_Code__c; 
        //aCapsule2.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule2.country = 'US';
        aCapsule2.phone = '+6543749578';
        aCapsule2.canSMS = True;
        
        Plant_Utility.wrapMeal wrapMeal=new Plant_Utility.wrapMeal();
        wrapMeal.mealId=meal.id;
        wrapMeal.mealSelectionMealId='';
        List<Plant_Utility.wrapMeal> wrapMeals=new List<Plant_Utility.wrapMeal>();
        wrapMeals.add(wrapMeal);
        
        cardWrapper cWrapper =new cardWrapper();
        cWrapper.name='Test1';
        cWrapper.cardnumber='123443211234';
        cWrapper.cvv ='332';
        cWrapper.expDate=String.valueof(System.Today()+732);
        
        Plant_Orders_Test.opReqWrapper ReqWrapper = new Plant_Orders_Test.opReqWrapper();
        ReqWrapper.product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        ReqWrapper.orderPropertyId=orderProperty.id;
        ReqWrapper.accountId=accounts.id;
        ReqWrapper.mealSelectionId=MealSelection.id;
        ReqWrapper.firstName=accounts.First_Name__c;
        ReqWrapper.lastName=accounts.Last_Name__c;
        //ReqWrapper.phone='Fake Phone';
        ReqWrapper.canSMS=aCapsule1.canSMS;
        ReqWrapper.email='1234567890';
        ReqWrapper.shippingAddress=aCapsule1;
        ReqWrapper.billingAddress=aCapsule2;
        ReqWrapper.shipASAP='Yes';
        ReqWrapper.shipDate='2022-04-08';
        ReqWrapper.discountCode='';
        ReqWrapper.recurrence='Yes';
        ReqWrapper.cardInformation=cWrapper;
        ReqWrapper.meals=wrapMeals;
        
        
        String jsonBody = JSON.serialize(ReqWrapper);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/order/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setPreOrder();
    }
   
    
    public testMethod static void Orders_Test6(){
        
        Plant_Orders_Test.opReqWrapper ReqWrapper = new Plant_Orders_Test.opReqWrapper();
        
        String jsonBody=JSON.serialize(ReqWrapper);
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/order/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setPreOrder();
    }
    
    public testMethod static void Orders_Test7(){
        
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
        
        Plant_Discount_Code__c discountCode = Plant_TestDataFactory.createDiscountCode(1, 'Active', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode;
       
        
        Plant_Discount_Code__c discountCode1 = Plant_TestDataFactory.createDiscountCode(1, 'Activ', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode1;
        
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
        
        Plant_Utility.addressCapsule aCapsule1 = new Plant_Utility.addressCapsule();
        aCapsule1.street1 = '200 Park Avenue';
        aCapsule1.street2 = 'Midtown'; 
        aCapsule1.street3 = 'Manhattan'; 
        aCapsule1.city = 'New York';
        aCapsule1.state = DeliverySchedule.Plant_State_Code__c; 
        aCapsule1.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule1.country = 'USA';
        aCapsule1.phone = '+6543749578';
        aCapsule1.canSMS = True;
        
        Plant_Utility.addressCapsule aCapsule2 = new Plant_Utility.addressCapsule();
        aCapsule2.street1 = '200 Park Avenue';
        aCapsule2.street2 = 'Midtown'; 
        aCapsule2.street3 = 'Manhattan'; 
        aCapsule2.city = 'New York';
        aCapsule2.state = DeliverySchedule.Plant_State_Code__c; 
        aCapsule2.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule2.country = 'USA';
        aCapsule2.phone = '+6543749578';
        aCapsule2.canSMS = True;
        
        Plant_Utility.wrapMeal wrapMeal=new Plant_Utility.wrapMeal();
        wrapMeal.mealId=meal.id;
        wrapMeal.mealSelectionMealId='';
        List<Plant_Utility.wrapMeal> wrapMeals=new List<Plant_Utility.wrapMeal>();
        wrapMeals.add(wrapMeal);
        
        cardWrapper cWrapper =new cardWrapper();
        cWrapper.name='Test1';
        cWrapper.cardnumber='123443211234';
        cWrapper.cvv ='332';
        cWrapper.expDate=String.valueof(System.Today()+732);
        
        Plant_Orders_Test.opReqWrapper ReqWrapper = new Plant_Orders_Test.opReqWrapper();
        ReqWrapper.product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        //ReqWrapper.orderPropertyId=orderProperty.id;
        ReqWrapper.accountId=accounts.id;
        ReqWrapper.mealSelectionId=MealSelection.id;
        ReqWrapper.firstName=accounts.First_Name__c;
        ReqWrapper.lastName=accounts.Last_Name__c;
        ReqWrapper.phone=aCapsule1.phone;
        ReqWrapper.canSMS=aCapsule1.canSMS;
        ReqWrapper.email='abcd@gmail.com';
        ReqWrapper.shippingAddress=aCapsule1;
        ReqWrapper.billingAddress=aCapsule2;
        ReqWrapper.shipASAP='Yes';
        ReqWrapper.shipDate=String.valueOf(System.Today()+1);
        ReqWrapper.discountCode=discountCode.Plant_Code__c;
        ReqWrapper.recurrence='Yes';
        ReqWrapper.cardInformation=cWrapper;
        ReqWrapper.meals=wrapMeals;
        
        
        String jsonBody = JSON.serialize(ReqWrapper);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/order/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setPreOrder();
    }
    
   
    // Original Test
    public testMethod static void Orders_Testfinal(){
        
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
        
        Plant_Discount_Code__c discountCode = Plant_TestDataFactory.createDiscountCode(1, 'Active', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode;
       
        
        Plant_Discount_Code__c discountCode1 = Plant_TestDataFactory.createDiscountCode(1, 'Activ', 'Reboot')[0];
        discountCode.Plant_Status__c='Active';
        insert discountCode1;
        
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
        
        Plant_Utility.addressCapsule aCapsule1 = new Plant_Utility.addressCapsule();
        aCapsule1.street1 = '200 Park Avenue';
        aCapsule1.street2 = 'Midtown'; 
        aCapsule1.street3 = 'Manhattan'; 
        aCapsule1.city = 'New York';
        aCapsule1.state = DeliverySchedule.Plant_State_Code__c; 
        aCapsule1.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule1.country = 'USA';
        aCapsule1.phone = '+6543749578';
        aCapsule1.canSMS = True;
        
        Plant_Utility.addressCapsule aCapsule2 = new Plant_Utility.addressCapsule();
        aCapsule2.street1 = '200 Park Avenue';
        aCapsule2.street2 = 'Midtown'; 
        aCapsule2.street3 = 'Manhattan'; 
        aCapsule2.city = 'New York';
        aCapsule2.state = DeliverySchedule.Plant_State_Code__c; 
        aCapsule2.zip = DeliverySchedule.Plant_Zip_Code__c;
        aCapsule2.country = 'USA';
        aCapsule2.phone = '+6543749578';
        aCapsule2.canSMS = True;
        
        Plant_Utility.wrapMeal wrapMeal=new Plant_Utility.wrapMeal();
        wrapMeal.mealId=meal.id;
        wrapMeal.mealSelectionMealId='';
        List<Plant_Utility.wrapMeal> wrapMeals=new List<Plant_Utility.wrapMeal>();
        wrapMeals.add(wrapMeal);
        
        cardWrapper cWrapper =new cardWrapper();
        cWrapper.name='Test1';
        cWrapper.cardnumber='123443211234';
        cWrapper.cvv ='332';
        cWrapper.expDate=String.valueof(System.Today()+732);
        
        Plant_Orders_Test.opReqWrapper ReqWrapper = new Plant_Orders_Test.opReqWrapper();
        ReqWrapper.product=Schema.SObjectType.Plant_Order_Properties__c.getRecordTypeInfosById().get(orderProperty.RecordTypeid).getName();
        ReqWrapper.orderPropertyId=orderProperty.id;
        ReqWrapper.accountId=accounts.id;
        ReqWrapper.mealSelectionId=MealSelection.id;
        ReqWrapper.firstName=accounts.First_Name__c;
        ReqWrapper.lastName=accounts.Last_Name__c;
        ReqWrapper.phone=aCapsule1.phone;
        ReqWrapper.canSMS=aCapsule1.canSMS;
        ReqWrapper.email='abcd@gmail.com';
        ReqWrapper.shippingAddress=aCapsule1;
        ReqWrapper.billingAddress=aCapsule2;
        ReqWrapper.shipASAP='Yes';
        ReqWrapper.shipDate=String.valueOf(System.Today()+1);
        ReqWrapper.discountCode=discountCode.Plant_Code__c;
        ReqWrapper.recurrence='Yes';
        ReqWrapper.cardInformation=cWrapper;
        ReqWrapper.meals=wrapMeals;
        
        
        String jsonBody = JSON.serialize(ReqWrapper);
        
        RestRequest request = new RestRequest();
        request.addHeader('Content-Type', 'application/json');
        request.requestUri= URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexRest/order/v1/*';
        System.debug('@@@@ ENDPOINT ==> '+request.requestUri);
        request.httpMethod='PUT';
        RestContext.request=request;
        request.requestBody = Blob.valueOf(jsonBody);
        
        RestResponse resp = new RestResponse();
        RestContext.response = resp;
        
        Plant_RESTOrders.setPreOrder();
    }
   */
   
    public class processOdr_Wrapper{
        public String orderPropertyId; // Order Property Id
        public String accountId;
        public String lastName;
        public String firstName;
        public String phone;
        public cardWrapper cardInfo;
        public String sfOrderId;        // SF Order id (optional: only if case of update)
        public String cTransactionId;
    }
    
    public class opReqWrapper{
        public String product; // Order Property Record type  
        public String orderPropertyId;
        public String accountId;
        public String mealSelectionId;
        public String firstName;  
        public String lastName;
        public String phone;
        public Boolean canSMS;
        public String email;
        public Plant_Utility.addressCapsule shippingAddress;
        public Plant_Utility.addressCapsule billingAddress;
        public String shipASAP;
        public String shipDate; //YYYY-MM-DD format
        public Plant_Utility.wrapMeal[] meals;// check*****
        public String discountCode;
        public String recurrence;
        public cardWrapper cardInformation;
    }
    public class cardWrapper{
        public String name;
        public String cardnumber;
        public String card_Last_4_Digits;
        public String card_Type;
        public String cvv;
        public String expDate;
    }
    public class TransactionReqWrap{
        public String cOrderId;
        public String sfOrderId;
        public String orderPropId;
        public String paymentId;
    }
    public class processPayment_Wrap{
        public String ObjectId;
        public Decimal ChargeAmount;
    }
}