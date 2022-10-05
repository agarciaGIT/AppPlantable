@isTest
public class Plant_TransComm_test {

    // @ Creating new Contact
    public static Contact createContact(String acctId, String fname, String lname, String phone, String email){
        Contact newCont = new Contact(
            AccountId = acctId,
            FirstName = fname,
            LastName = lname,
            Phone = phone,
			Email = email      
        );
        return newCont;
    }
    
    public static Plant_Payment_Method__c createPaymentMethod(Account acct){
    	Plant_Payment_Method__c newPay = new Plant_Payment_Method__c(
        	Plant_Account__c = acct.id,
            Plant_Card_Type__c = 'Visa',
            Plant_Card_Number__c = '4242424242424242'
        );
        return newPay;
    }
    
    public static Plant_Transaction_Comm__c createTransComm(String orderId, String subscriptionId, String type){
		Plant_Transaction_Comm__c newTransComm = new Plant_Transaction_Comm__c(
        	Plant_Status__c = 'Created',
            Plant_Type__c = type,
            Plant_Order__c = orderId,
            Plant_Transaction_Date_Time__c = DateTime.now(),
            Plant_Subscription__c = subscriptionId
        );  
        return newTransComm;
    }
    
    public static Plant_Shipping_Address__c createShippingAddress() {
    	Plant_Shipping_Address__c shipAddr = new Plant_Shipping_Address__c(
            Plant_Street1__c = '25A Jackson Pl',
            Plant_Street2__c = '',
            Plant_City__c = 'Brooklyn',
            Plant_Province_State__c	= 'NY',
			Plant_Country__c = 'US',
			Plant_Postal_Code__c = '11209'
        );
        return shipAddr;
    }
    

    // @ Method 1    
    static testMethod void plant_emailTracker_Test1(){
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;
        
		Plant_Transaction_Comm__c transcomm = createTransComm(null, null, 'Order Paid');
        transcomm.Plant_Account__c = acct.id;
        insert transcomm;
        
        Plant_TransComm_BC.emailTracker();
    }
    
    // @ Method 1    
    static testMethod void plant_PaidOrder_Test1(){
    
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;    
        
        Contact cont = createContact(acct.id,'fname','lname','1234567890','email@email.com');
        insert cont;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= acct.id;
        insert shippingAddress;
        
        List<Meal__c> meals =Plant_TestDataFactory.createMeal(5);
        insert meals;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        List<Plant_Meal_Selection_Meal__c> mealsels = Plant_TestDataFactory.createMealSelMeals(meals, MealSelection);
        insert mealsels;
        
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= acct.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        orderProperty.Plant_Meal_Selection__c = MealSelection.id;
        insert orderProperty;
        
        Plant_Shipping_Address__c shipAddr = createShippingAddress();
        insert shipAddr;
        
        Plant_Subscription__c sub = new Plant_Subscription__c(Plant_Start_Date__c = Date.Today(), Plant_Account__c=acct.id, Plant_Status__c='Active',Plant_Shipping_Address__c = shipAddr.id, Plant_Meal_Selection__c = MealSelection.id);
        insert sub;
        
        Order order = new order(AccountId=acct.id, EffectiveDate=System.today(), Status ='Draft',Plant_Order_Properties__c=orderProperty.id, Plant_Subscription__c = sub.id);
        insert order;
        
        Plant_Payment_Method__c pay = createPaymentMethod(acct);
        insert pay;
        
        Plant_Transaction_Comm__c transcomm = createTransComm(order.id, null, 'Order Paid');
        transcomm.Plant_Account__c = acct.id;
        insert transcomm;
        
        Plant_TransComm_BC.sendTransComm(transcomm.id);


        Plant_Transaction_Comm__c transcomm1 = createTransComm(null, sub.id, 'Subscription Created');
        transcomm1.Plant_Account__c = acct.id;
        insert transcomm1;
        
        Plant_TransComm_BC.sendTransComm(transcomm1.id);
        
        Plant_TransComm_BC.setTransactionEvent('Order Paid', acct.id, order.id, null);
        
        Plant_TransComm_BC.pubTransEvent pte = new Plant_TransComm_BC.pubTransEvent();
        pte.type = 'Order Paid';
        pte.accountId = 'Order Paid';
        pte.orderId = order.id;
        pte.subscriptionId = null;
        pte.scheduleDateTime = null;

        Plant_TransComm_BC.publishTransactionEvent(pte);
        
		List<Plant_TransComm_BC.pubTransEvent> pubEvents = new List<Plant_TransComm_BC.pubTransEvent>();
        pubEvents.add(Plant_TransComm_BC.setTransactionEvent('Order Paid',acct.id, order.id, null));
        Plant_TransComm_BC.publishTransactionEvents(pubEvents);
        
    }
    
    static testMethod void plant_PaidOrder_Test2(){
    
        Account acct = Plant_TestDataFactory.createAccounts(1)[0];
        insert acct;    
        
        Contact cont = createContact(acct.id,'fname','lname','1234567890','email@email.com');
        insert cont;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= acct.id;
        insert shippingAddress;
        
        List<Meal__c> meals =Plant_TestDataFactory.createMeal(5);
        insert meals;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        List<Plant_Meal_Selection_Meal__c> mealsels = Plant_TestDataFactory.createMealSelMeals(meals, MealSelection);
        insert mealsels;
        
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= acct.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        orderProperty.Plant_Meal_Selection__c = MealSelection.id;
        insert orderProperty;

        Plant_Shipping_Address__c shipAddr = createShippingAddress();
        insert shipAddr;
        
        Plant_Subscription__c sub = new Plant_Subscription__c(Plant_Start_Date__c = Date.Today(), Plant_Account__c=acct.id, Plant_Status__c='Active',Plant_Shipping_Address__c = shipAddr.id, Plant_Meal_Selection__c = MealSelection.id);
        insert sub;
        
        Order order = new order(AccountId=acct.id, EffectiveDate=System.today(), Status ='Draft',Plant_Order_Properties__c=orderProperty.id, Plant_Subscription__c = sub.id);
        insert order;
        
        Plant_Payment_Method__c pay = createPaymentMethod(acct);
        insert pay;
        
        Date dt = Date.today();
        Plant_TransComm_BC.stageScheduledTransComm('Order Paid', acct.id, order.id, null, dt);

		DateTime dtn = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 8, 0, 0);
        Database.executeBatch(new Plant_BatchSendScheduledTransComm(dtn,NULL));
        
        Plant_TransComm_BC.cancelStagedScheduledTransComm('Order Paid', acct.id, order.id, null);
        
    }
    
    static testMethod void plant_BatchScheduledSend(){
        
    }
}