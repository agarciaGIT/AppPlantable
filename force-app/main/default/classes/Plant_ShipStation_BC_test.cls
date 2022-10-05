@isTest
public class Plant_ShipStation_BC_test {

    Static Account acct;
    Static Order ord;
    /*
    Static Opportunity opp1;
    
    Static Product2 prod1;
    Static Product2 prod2;
    
    static Meal__c m;
    static Meal_Line_Item__c mli;
    */
    
    public static void setup(){
        acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
        ord = Plant_TestDataFactory.creatOrderWithProduct(acct.Id, 'Reboot');
        
        List<Meal__c> meals =Plant_TestDataFactory.createMeal(5);
        insert meals;
        
        Plant_Meal_Selection__c ms = Plant_TestDataFactory.createMealSelection(1)[0];
        ms.Plant_Type__c = 'Custom';
        insert ms;
        
        List<Plant_Meal_Selection_Meal__c> mealsels = Plant_TestDataFactory.createMealSelMeals(meals, ms);
        insert mealsels;
        
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        ShippingDate.Plant_Shipping_Date__c = Date.today().AddDays(7);
        System.debug('*****ShippingDate.Plant_Shipping_Date__c:' + ShippingDate.Plant_Shipping_Date__c);
        insert ShippingDate;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= acct.id;
        insert shippingAddress;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 2)[0];
        insert DeliverySchedule;
        
        Plant_Payment_Method__c pm = Plant_TestDataFactory.createPaymentMethod(acct);
        insert pm;
        
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= acct.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        orderProperty.Plant_Meal_Selection__c=ms.id;
        orderProperty.Plant_Payment_Method__c=pm.id;
        orderProperty.Plant_Shipping_Date__c=ShippingDate.id;
        orderProperty.Delivery_Schedule__c=DeliverySchedule.id;
        insert orderProperty;        
        
        ord.Plant_Order_Properties__c = orderProperty.id;
        ord.Plant_Fulfillment_Status__c = 'New Order - Ready to Pack';
        ord.Status = 'Activated';
        ord.Type = 'New Customer';
        update ord;

		List<Order> ord = [select Id, Status, Plant_Fulfillment_Status__c, Plant_Is_Test__c, Plant_Shipment_Date__c, Plant_Meal_Selection_Type__c from Order where id = :ord.id];
		System.Debug('~~~~' + ord);
    }
    
    @isTest
    private static void test1(){
        setup();
        Test.startTest();    
        
        List<List<String>> inputParams = new List<List<String>>{
            new List<String>{'setOrderToShip',ord.Id} 
        };
        
        Plant_ShipStation_BC.shipStationMethods(inputParams);        
        Plant_ShipStation_BC.getOrder('123');

        List<List<String>> inputParams1 = new List<List<String>>{
            new List<String>{'syncAwaitingShipment'} 
        };        
        Plant_ShipStation_BC.shipStationMethods(inputParams1);

        Date tdy =Date.today().AddDays(7);
        DateTime dt = DateTime.newInstance(tdy.year(), tdy.month(), tdy.day());
        String strDt = dt.format('YYYY-MM-dd');
        List<List<String>> inputParams2 = new List<List<String>>{
            new List<String>{'syncAllOrdersNeedsPacking',strDt,null} 
        };        
        Plant_ShipStation_BC.shipStationMethods(inputParams2);
        
        List<List<String>> inputParams3 = new List<List<String>>{
            new List<String>{'syncCustomZipOrdersNeedsPacking',strDt,null} 
        };        
        Plant_ShipStation_BC.shipStationMethods(inputParams3);
        
        Plant_ShipStation_BC.syncShipStationOrders(strDt, 'syncAwaitingShipment');
        Plant_ShipStation_BC.syncShipStationOrders(strDt, 'syncAllOrdersNeedsPacking');
        Plant_ShipStation_BC.syncShipStationOrders(strDt, 'syncCustomZipOrdersNeedsPacking');

        List<List<String>> inputParams4 = new List<List<String>>{
            new List<String>{'voidLabel','1234'} 
        };        
        Plant_ShipStation_BC.shipStationMethods(inputParams4);
        
        Test.stopTest();        
    }
    
     @isTest
    private static void test2(){
        
        setup();
        Test.startTest();   
        
        
        Plant_RESTShipStationWebhooks.postWebHook();
        Plant_RESTShipStationWebhooks.processWebhook(null);
        
        Test.stopTest();    
    }
    
     @isTest
    private static void test3(){
        
        setup();
        Test.startTest();   
        
        
        DateTime dt = DateTime.now();
        //ord.Plant_Fulfillment_Status__c = 'New Order - Do not Pack';
		//update ord;
        Database.executeBatch(new Plant_BatchUpdateOrderFulfillmentStatus(ord.id,'ReadyToPack'));
        Database.executeBatch(new Plant_BatchUpdateOrderFulfillmentStatus(ord.id,'Shipped'));
 
        Test.stopTest();    
    }
}