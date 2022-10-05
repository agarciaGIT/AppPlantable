@isTest
public class Plant_Orders_BC_Helper_test {
    
        
    
    public testMethod static void Orders_apiReq1(){
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Order order = Plant_TestDataFactory.creatOrderWithProduct(accounts.Id, 'PLANTALC');

        Plant_Meal_Selection__c chefMS = Plant_TestDataFactory.createMealSelection(1)[0];
        chefMS.Plant_Description__c  = 'Chef Menu';
        chefMS.Plant_Owner__c = accounts.id;
        insert chefMS;
        
        List<Meal__c> meals =Plant_TestDataFactory.createMeal(5);
        insert meals;
        
        List<Plant_Meal_Selection_Meal__c> mealsels = Plant_TestDataFactory.createMealSelMeals(meals, chefMS);
        insert mealsels;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 2)[0];
        insert DeliverySchedule;
        
        List<Plant_Shipping_Date__c> lstShippingDates = Plant_TestDataFactory.createShippingDate(5);
        System.debug('lstShippingDates');
        for(Plant_Shipping_Date__c sd :lstShippingDates) {
        	insert sd;    
        }
        
        Plant_TestDataFactory.creatProduct('A-la-carte');
        Plant_TestDataFactory.creatProduct('ZPEALC');
        
        API_Request__c apir = new API_Request__c(
            Order__c = order.id,
            Request_Type__c = 'Create Order',
            Order_Number__c = '123',
            OrderId__c = '123',
            First_Name__c = 'fn',
            Last_Name__c = 'ln',
            Customer_Email__c = 'email@email.com',
            Phone__c = '1234567890',
            Company__c = '',
            Street1__c = '123 State St',
            Street2__c = '',
            City__c = 'Brooklyn',
            State__c = 'NY',
            Zip__c = '12345',
            Country__c = 'US',
            Ship_Date__c = Date.Today()+3,
            Is_Custom__c = False,
            Shipping_Company__c = '',
            Shipping_First_Name__c = 'fn',
            Shipping_Last_Name__c = 'ln',
            Shipping_Phone__c = '1234567890',
            Shipping_Street1__c = '123 State St',
            Shipping_Street2__c = '',
            Shipping_City__c = 'Brooklyn',
            Shipping_State__c = 'NY',
            Shipping_Zip__c = '12345',
            Shipping_Country__c = 'US',
            Billing_Company__c = '',
            Billing_First_Name__c = 'fn',
            Billing_Last_Name__c = 'ls',
            Billing_Phone__c = '1234567890',
            Billing_Street1__c = '123 State St',
            Billing_Street2__c = '',
            Billing_City__c = 'Brooklyn',
            Billing_State__c = 'NY',
            Billing_Zip__c = '12345',
            Billing_Country__c = 'US',
            Charge_Amount__c = 100,
            Charge_Source__c = 'Visa'
        );
        insert apir;

		API_Request_Line_Item__c apil1 = new API_Request_Line_Item__c(
            API_Request__c = apir.id,
            Type__c = 'Product',
            Code__c ='ZPEALC'
        );
        insert apil1;

		API_Request_Line_Item__c apil2 = new API_Request_Line_Item__c(
            API_Request__c = apir.id,
            Type__c = 'Meal',
            Code__c = 'ShopifyID'
        );
        insert apil2;
        
        apir.Enable_Automation__c = True;
        update apir;


        
        Plant_Orders_BC_Helper.apiRequestChangeTriggerHandler(apir.id);
        
    }
    
    public testMethod static void Orders_mealSelChef1(){
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Meal_Selection__c chefMS = Plant_TestDataFactory.createMealSelection(1)[0];
        chefMS.Plant_Description__c  = 'Chef Menu';
        chefMS.Plant_Owner__c = accounts.id;
        insert chefMS;
        
        List<Meal__c> meals =Plant_TestDataFactory.createMeal(5);
        insert meals;
        
        List<Plant_Meal_Selection_Meal__c> mealsels = Plant_TestDataFactory.createMealSelMeals(meals, chefMS);
        insert mealsels;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        Mealselection.Plant_Make_Chef_Menu__c  = True;
        insert MealSelection;
    }
    
    public testMethod static void Orders_subscriptionLoad1(){
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 2)[0];
        System.debug('DeliverySchedule:' + DeliverySchedule);
        insert DeliverySchedule;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
		System.debug('shippingAddress:' + shippingAddress);
        insert shippingAddress;
        
        Plant_Payment_Method__c pm = Plant_TestDataFactory.createPaymentMethod(accounts);
        insert pm;
        
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Subscription__c sub = Plant_TestDataFactory.createSubscription(accounts, shippingAddress, pm, DeliverySchedule, ShippingDate);
        insert sub;
        
        sub.Plant_Import_Legacy_Data__c  = True;
        update sub;
        
        SET<String> subscriptionIDs = new SET<String>();
        subscriptionIDs.add(sub.id);
        Plant_Orders_BC_Helper.subscriptionLegacyLoadHandler(subscriptionIDs);
        
    }
    
    
     public testMethod static void Orders_reshipOrder1(){
        Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
        insert meal;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        List<Meal__c> meals =Plant_TestDataFactory.createMeal(5);
        insert meals;
        
        List<Plant_Meal_Selection_Meal__c> mealsels = Plant_TestDataFactory.createMealSelMeals(meals, MealSelection);
        insert mealsels;
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 2)[0];
        insert DeliverySchedule;
        
        Plant_Payment_Method__c pm = Plant_TestDataFactory.createPaymentMethod(accounts);
        insert pm;
        
        List<Plant_Delivery_Schedule__c> ds = Plant_TestDataFactory.createDeliverySchedule(5, 2);
        insert ds;
        
        
        System.debug('MealSelection:' + MealSelection);
        System.debug('MealSelection:' + mealsels);
        
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        orderProperty.Plant_Meal_Selection__c=MealSelection.id;
        orderProperty.Plant_Payment_Method__c=pm.id;
        orderProperty.Plant_Shipping_Date__c=ShippingDate.id;
        orderProperty.Delivery_Schedule__c=ds[0].id;
        insert orderProperty;
        
        Order order = Plant_TestDataFactory.creatOrderWithProduct(accounts.Id, 'PLANTALC');
        
        order.status = 'Activated';
        order.Plant_Shipping_Date__c = ShippingDate.Id;
        order.Plant_Order_Properties__c = orderProperty.Id;
        update order;
        
        Plant_Orders_BC_Helper.reshipOrder(order.Id);       
    }
    
    public testMethod static void Orders_clonePaymentMethod1(){
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Plant_Payment_Method__c pm = Plant_TestDataFactory.createPaymentMethod(accounts);
        pm.Plant_Is_Account_Record__c = True;
        insert pm;
        
        Plant_Payment_Method__c pm2 = Plant_TestDataFactory.createPaymentMethod(accounts);
        pm2.Plant_Save_Payment_Method__c = True;
        insert pm2;
        
        Plant_Payment_Method__c pmclone = Plant_Orders_BC_Helper.clonePaymentMethod(pm, pm.id, True);
        
        List<Plant_Payment_Method__c> lstPayMethods = new List<Plant_Payment_Method__c>();
        lstPayMethods.add(pm);
        
        List<String> lstUpdatedPayMethodIds = new List<String>();
        
        Plant_Orders_BC_Helper.paymentMethodTriggerHandler(lstPayMethods, lstUpdatedPayMethodIds); 
        
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
        Plant_Orders_BC_Helper.updateOrderInventory(mealSelectionIDs, false);
        
        List<Meal__c> meals1 =Plant_TestDataFactory.createMeal(3);
        insert meals1;
        
        Plant_Meal_Selection__c Mealselection1=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection1;
        
        List<Plant_Meal_Selection_Meal__c> mealsels1 = Plant_TestDataFactory.createMealSelMeals(meals1, MealSelection1);
        insert mealsels1;
        
        Plant_Orders_BC_Helper.replaceOrderInventory(MealSelection.Id, MealSelection1.Id);
        
        Plant_TestDataFactory.creatProduct('PLANTALC');
        Plant_Orders_BC_Helper.getPriceBookEntryByProduct('Reboot',null);
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
        Plant_Orders_BC_Helper.postTransactionOrderHandler(lstOrderEvents);
        
        
    }
    
}