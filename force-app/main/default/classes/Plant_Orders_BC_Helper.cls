public class Plant_Orders_BC_Helper {
    
    // AG - This will create a copy of an order the customer needs to be shipped again
    /*
    public static Order reshipOrderBulk(String orderId) {
        Order retOrder;
        
        System.debug('reshipOrder orderId:' + orderId);
        
        List<Order> lstOrder = [select Id,AccountId,EffectiveDate,Status,Plant_Fulfillment_Status__c,pricebook2id,comty_Chargent_Order__c,
                                (Select id, OrderId, Product2Id, UnitPrice, PricebookEntryId, Quantity from OrderItems Limit 1),
                                Plant_Main_Product__c,
                                Plant_Order_Properties__c,
                                Plant_Subscription__c,
                                Plant_Display_Shipping_Date__c,
                                
                                Plant_Order_Properties__r.Plant_Account__c,
                                Plant_Order_Properties__r.Plant_First_Name__c,
                                Plant_Order_Properties__r.Plant_Last_Name__c,
                                Plant_Order_Properties__r.Plant_Email__c,
                                Plant_Order_Properties__r.Plant_Phone__c,
                                Plant_Order_Properties__r.Plant_Can_SMS__c,
                                Plant_Order_Properties__r.Plant_Provider__c,
                                Plant_Order_Properties__r.Plant_Recurrence__c,
                                Plant_Order_Properties__r.RecordTypeId,
                                Plant_Order_Properties__r.Plant_Status__c,
                                
                                Plant_Order_Properties__r.Plant_Meal_Selection__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__c,
                                Plant_Order_Properties__r.Shipping_Address__c,
                                Plant_Order_Properties__r.Plant_Delivery_Date__c,
                                Plant_Order_Properties__r.Plant_Shipping_Date__c,
                                Plant_Order_Properties__r.Delivery_Schedule__c,
                                
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Account__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Number__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.CCV__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_City__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Country__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Expiration_Date__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Phone__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Postal_Code__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Province_State__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street1__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street2__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street3__c,
                                
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Save_Shipping_Address__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Account__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Is_Account_Record__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_First_Name__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Last_Name__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Can_SMS__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Phone__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Street3__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c
                                
                                FROM Order WHERE id = :orderId];
        
        System.debug('lstOrder:' + lstOrder);
        
        if(!lstOrder.isEmpty()) {
            Order orgOrder = lstOrder[0];
            
            newOrderWrapper newOrderWrap = new newOrderWrapper();
            newOrderWrap.AccountId = orgOrder.AccountId;
            newOrderWrap.Product = orgOrder.Plant_Main_Product__c;
            
            newOrderWrap.FirstName = orgOrder.Plant_Order_Properties__r.Plant_First_Name__c;
            newOrderWrap.LastName = orgOrder.Plant_Order_Properties__r.Plant_Last_Name__c;
            newOrderWrap.Email = orgOrder.Plant_Order_Properties__r.Plant_Email__c;
            newOrderWrap.Phone = orgOrder.Plant_Order_Properties__r.Plant_Phone__c;
            newOrderWrap.CanSMS = orgOrder.Plant_Order_Properties__r.Plant_Can_SMS__c;
            newOrderWrap.Provider = orgOrder.Plant_Order_Properties__r.Plant_Provider__c;
            
            String fn='';
            String ln='';
            if(orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c != NULL) {
                System.debug('Plant_Customer_Name__c:' + orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c);
                String[] parts = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c.split(' ');
                System.debug('parts:' + parts);
                if(parts.size() > 1) {
                    newOrderWrap.BillingFirstName = parts[0];
                    newOrderWrap.BillingLastName = parts[1];
                }
            }            
            newOrderWrap.CardNumber = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Number__c;
            newOrderWrap.CardType = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c;
            newOrderWrap.CCV = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.CCV__c;
            newOrderWrap.CardLast4Digits = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c;
            newOrderWrap.BillingCity = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_City__c;
            newOrderWrap.BillingCountry = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Country__c;
            newOrderWrap.BillingCustomerName = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c;
            newOrderWrap.ExpirationDate = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Expiration_Date__c;
            newOrderWrap.BillingPhone = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Phone__c;
            newOrderWrap.BillingPostalCode = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Postal_Code__c;
            newOrderWrap.BillingProvinceState = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Province_State__c;
            newOrderWrap.BillingStreet1 = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street1__c;
            newOrderWrap.BillingStreet2 = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street2__c;
            newOrderWrap.BillingStreet3 = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street3__c;
            
            newOrderWrap.ShippingFirstName = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_First_Name__c;
            newOrderWrap.ShippingLastName = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Last_Name__c;
            newOrderWrap.ShippingPhone = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Phone__c;
            newOrderWrap.ShippingStreet1 = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c;
            newOrderWrap.ShippingStreet2 = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c;
            newOrderWrap.ShippingStreet3 = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street3__c;
            newOrderWrap.ShippingCity = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c;
            newOrderWrap.ShippingProvinceState = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c;
            newOrderWrap.ShippingPostalCode = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c;
            newOrderWrap.ShippingCountry = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c;
            
            System.debug('newOrderWrap:' + newOrderWrap);
            
            // Meals
            newOrderWrap.meals = new List<newOrderMealWrapper>();
            List<Plant_Meal_Selection_Meal__c> mealSelMeals = Plant_Meals_BC.cloneMealSelection(orgOrder.Plant_Order_Properties__r.Plant_Meal_Selection__c, null);
            System.debug('mealSelMeals:' + mealSelMeals);
            
            for(Plant_Meal_Selection_Meal__c m :mealSelMeals) {
                newOrderMealWrapper newMeal = new newOrderMealWrapper();
                newMeal.MealId = m.Plant_Meal__c;
                newMeal.Quantity = Integer.valueOf(m.Plant_Quantity__c);
                newOrderWrap.meals.add(newMeal);
            }
            System.debug('newOrderWrap.meals:' + newOrderWrap.meals);
            
            // Ship ASAP
            Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
            tempAddrsWrap.state=orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c;
            tempAddrsWrap.zip=orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c;
            Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
            System.debug('availableDates_List:' + availableDates_List);
            
            if(availableDates_List.status=='success'){
                
                Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                List<String> DeliveryDateList =new List<String>(avail_DeliveryDaye_Map.Keyset());
                DeliveryDateList.sort();                
                newOrderWrap.deliveryDate = DeliveryDateList[0];
            }
            System.debug('newOrderWrap.deliveryDate:' + newOrderWrap.deliveryDate);
            
            // Create Order
            
            MAP<String,PricebookEntry> bulkPriceBookMap = new MAP<String,PricebookEntry>();
            
            List<PricebookEntry> lstPrice = [select id, Pricebook2Id, Product2Id, UnitPrice, Product2.ProductCode from PricebookEntry];
            System.debug('lstPrice:' + lstPrice);
            for(PricebookEntry pe :lstPrice) {
                bulkPriceBookMap.put(pe.Product2.ProductCode, pe);
            }
            
            // Setup Overrides
            newOrderWrap.ProductOverride = 'ZPEALC';
            newOrderWrap.PriceOverride = 299;
            newOrderWrap.ShippingDateOverride = Date.newInstance(2021,1,1);
            newOrderWrap.ShippingDurationOverride = 2;
            newOrderWrap.OrderNumberOverride = 'S12345';
            newOrderWrap.OrderPropertiesRecordTypeIdOverride = Plant_Utility.GetRecordTypeId('Plant_Order_Properties__c','Legacy');
            newOrderWrap.CloseDateOverride = Date.newInstance(2021,1,1);
            
            retNewOrderWrapper retOrderWrapper = createOrder(newOrderWrap, True, bulkPriceBookMap);
            System.debug('retOrderWrapper:' + retOrderWrapper);
            
            retOrder = retOrderWrapper.newOrder;
            
            // Process return data
            insert retOrderWrapper.newMealSelection;
            retOrderWrapper.newOrderProperties.Plant_Meal_Selection__c = retOrderWrapper.newMealSelection.id;
            
            for(Plant_Meal_Selection_Meal__c msm :retOrderWrapper.newMealSelectionMeals) {
                msm.Plant_Meal_Selection__c = retOrderWrapper.newMealSelection.id;
                insert msm;
            }
            
            insert retOrderWrapper.newPaymentMethod;
            retOrderWrapper.newOrderProperties.Plant_Payment_Method__c = retOrderWrapper.newPaymentMethod.id;
            
            insert retOrderWrapper.newShippingAddress;
            retOrderWrapper.newOrderProperties.Shipping_Address__c = retOrderWrapper.newShippingAddress.id;
            
            insert retOrderWrapper.newOrderProperties;
            retOrderWrapper.newOrder.Plant_Order_Properties__c = retOrderWrapper.newOrderProperties.Id;
            insert retOrderWrapper.newOrder;
            
            retOrderWrapper.newOrderItem.OrderId = retOrderWrapper.newOrder.Id;
            insert retOrderWrapper.newOrderItem;
            
        }
        return retOrder;
    } 
	*/
    
    public static Order reshipOrder(String orderId) {
        Order retOrder;
        
        System.debug('reshipOrder orderId:' + orderId);
        
        List<Order> lstOrder = [select Id,AccountId,EffectiveDate,Status,Plant_Fulfillment_Status__c,pricebook2id,comty_Chargent_Order__c,
                                (Select id, OrderId, Product2Id, UnitPrice, PricebookEntryId, Quantity from OrderItems Limit 1),
                                Plant_Main_Product__c,
                                Plant_Order_Properties__c,
                                Plant_Subscription__c,
                                Plant_Display_Shipping_Date__c,
                                
                                Plant_Order_Properties__r.Plant_Account__c,
                                Plant_Order_Properties__r.Plant_First_Name__c,
                                Plant_Order_Properties__r.Plant_Last_Name__c,
                                Plant_Order_Properties__r.Plant_Email__c,
                                Plant_Order_Properties__r.Plant_Phone__c,
                                Plant_Order_Properties__r.Plant_Can_SMS__c,
                                Plant_Order_Properties__r.Plant_Provider__c,
                                Plant_Order_Properties__r.Plant_Recurrence__c,
                                Plant_Order_Properties__r.RecordTypeId,
                                Plant_Order_Properties__r.Plant_Status__c,
                                
                                Plant_Order_Properties__r.Plant_Meal_Selection__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__c,
                                Plant_Order_Properties__r.Shipping_Address__c,
                                Plant_Order_Properties__r.Plant_Delivery_Date__c,
                                Plant_Order_Properties__r.Plant_Shipping_Date__c,
                                Plant_Order_Properties__r.Delivery_Schedule__c,
                                
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Account__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Number__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.CCV__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_City__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Country__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Expiration_Date__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Phone__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Postal_Code__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Province_State__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street1__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street2__c,
                                Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street3__c,
                                
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Save_Shipping_Address__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Account__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Is_Account_Record__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_First_Name__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Last_Name__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Can_SMS__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Phone__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Street3__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c,
                                Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c
                                
                                FROM Order WHERE id = :orderId];
        
        System.debug('lstOrder:' + lstOrder);
        
        if(!lstOrder.isEmpty()) {
            Order orgOrder = lstOrder[0];
            
            newOrderWrapper newOrderWrap = new newOrderWrapper();
            newOrderWrap.AccountId = orgOrder.AccountId;
            newOrderWrap.Product = orgOrder.Plant_Main_Product__c;
            
            newOrderWrap.FirstName = orgOrder.Plant_Order_Properties__r.Plant_First_Name__c;
            newOrderWrap.LastName = orgOrder.Plant_Order_Properties__r.Plant_Last_Name__c;
            newOrderWrap.Email = orgOrder.Plant_Order_Properties__r.Plant_Email__c;
            newOrderWrap.Phone = orgOrder.Plant_Order_Properties__r.Plant_Phone__c;
            newOrderWrap.CanSMS = orgOrder.Plant_Order_Properties__r.Plant_Can_SMS__c;
            newOrderWrap.Provider = orgOrder.Plant_Order_Properties__r.Plant_Provider__c;
            
            String fn='';
            String ln='';
            if(orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c != NULL) {
                System.debug('Plant_Customer_Name__c:' + orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c);
                String[] parts = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c.split(' ');
                System.debug('parts:' + parts);
                if(parts.size() > 1) {
                    newOrderWrap.BillingFirstName = parts[0];
                    newOrderWrap.BillingLastName = parts[1];
                }
            }            
            newOrderWrap.CardNumber = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Number__c;
            newOrderWrap.CardType = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Type__c;
            newOrderWrap.CCV = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.CCV__c;
            newOrderWrap.CardLast4Digits = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c;
            newOrderWrap.BillingCity = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_City__c;
            newOrderWrap.BillingCountry = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Country__c;
            newOrderWrap.BillingCustomerName = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Customer_Name__c;
            newOrderWrap.ExpirationDate = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Expiration_Date__c;
            newOrderWrap.BillingPhone = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Phone__c;
            newOrderWrap.BillingPostalCode = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Postal_Code__c;
            newOrderWrap.BillingProvinceState = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Province_State__c;
            newOrderWrap.BillingStreet1 = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street1__c;
            newOrderWrap.BillingStreet2 = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street2__c;
            newOrderWrap.BillingStreet3 = orgOrder.Plant_Order_Properties__r.Plant_Payment_Method__r.Plant_Street3__c;
            
            newOrderWrap.ShippingFirstName = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_First_Name__c;
            newOrderWrap.ShippingLastName = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Last_Name__c;
            newOrderWrap.ShippingPhone = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Phone__c;
            newOrderWrap.ShippingStreet1 = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street1__c;
            newOrderWrap.ShippingStreet2 = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street2__c;
            newOrderWrap.ShippingStreet3 = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Street3__c;
            newOrderWrap.ShippingCity = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_City__c;
            newOrderWrap.ShippingProvinceState = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c;
            newOrderWrap.ShippingPostalCode = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c;
            newOrderWrap.ShippingCountry = orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Country__c;
            
            System.debug('newOrderWrap:' + newOrderWrap);
            
            // Meals
            newOrderWrap.meals = new List<newOrderMealWrapper>();
            List<Plant_Meal_Selection_Meal__c> mealSelMeals = Plant_Meals_BC.cloneMealSelection(orgOrder.Plant_Order_Properties__r.Plant_Meal_Selection__c, null);
            System.debug('mealSelMeals:' + mealSelMeals);
            
            for(Plant_Meal_Selection_Meal__c m :mealSelMeals) {
                newOrderMealWrapper newMeal = new newOrderMealWrapper();
                newMeal.MealId = m.Plant_Meal__c;
                newMeal.Quantity = Integer.valueOf(m.Plant_Quantity__c);
                newOrderWrap.meals.add(newMeal);
            }
            System.debug('newOrderWrap.meals:' + newOrderWrap.meals);
            
            // Ship ASAP
            Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
            tempAddrsWrap.state=orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c;
            tempAddrsWrap.zip=orgOrder.Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c;
            Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
            System.debug('availableDates_List:' + availableDates_List);
            
            if(availableDates_List.status=='success'){
                
                Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                List<String> DeliveryDateList =new List<String>(avail_DeliveryDaye_Map.Keyset());
                DeliveryDateList.sort();                
                newOrderWrap.deliveryDate = DeliveryDateList[0];
            }
            System.debug('newOrderWrap.deliveryDate:' + newOrderWrap.deliveryDate);
            
            // Create Order
            retNewOrderWrapper retOrderWrapper = createOrder(newOrderWrap, False, Null);
            System.debug('retOrderWrapper:' + retOrderWrapper);
            
            retOrder = retOrderWrapper.newOrder;
            
            // Stage Payment
            ChargentOrders__ChargentOrder__c corder = stagePayment(newOrderWrap, retOrder.Amount_to_Pay__c);
            insert corder;
            System.debug('corder:' + corder);
            
            retOrder.comty_Chargent_Order__c = corder.id;
            retOrder.Plant_Replacement_Order__c = orderId;
            update retOrder;
            
            // Make Payment
            ChargentOrders__Transaction__c ctrans = makePayment(corder.Id, newOrderWrap, retOrder.Amount_to_Pay__c);
            insert ctrans;
            
        }
        return retOrder;
    }
    
    public class retNewOrderWrapper {
        public Order newOrder;
        public Plant_Order_Properties__c newOrderProperties;
        public Plant_Meal_Selection__c newMealSelection;
        public List<Plant_Meal_Selection_Meal__c> newMealSelectionMeals;
        public Plant_Payment_Method__c newPaymentMethod;
        public Plant_Shipping_Address__c newShippingAddress;
        public OrderItem newOrderItem;
        public String OrgOrderId;
    }
    
    public static retNewOrderWrapper createOrder(newOrderWrapper newOrderWrap, Boolean isBulk, MAP<String,PricebookEntry> bulkPriceBookMap) {
        
        retNewOrderWrapper retWrapper = new retNewOrderWrapper();
        retWrapper.newMealSelectionMeals = new List<Plant_Meal_Selection_Meal__c>();
        
        System.debug('createOrder newOrderWrap:' + newOrderWrap);
        
        if(newOrderWrap != NULL) {
            
            Map<String,String> prodRecTypeIdMap = Plant_Utility.getAvailableOrderType();
            System.debug('prodRecTypeIdMap:' + prodRecTypeIdMap);
            
            Plant_Order_Properties__c newOP = new Plant_Order_Properties__c(
                Plant_Account__c = newOrderWrap.AccountId,
                Plant_First_Name__c = newOrderWrap.FirstName,
                Plant_Last_Name__c = newOrderWrap.LastName,
                Plant_Email__c = newOrderWrap.Email,
                Plant_Phone__c = newOrderWrap.Phone,
                Plant_Can_SMS__c = newOrderWrap.CanSMS,
                Plant_Provider__c = newOrderWrap.Provider,
                Plant_Recurrence__c = 'Once',
                Plant_Status__c = 'Pending Payment'
            );
            if(isBulk && newOrderWrap.OrderPropertiesRecordTypeIdOverride != NULL) {
                newOP.RecordTypeId = newOrderWrap.OrderPropertiesRecordTypeIdOverride;
            } else {
                newOP.RecordTypeId = Plant_Utility.GetRecordTypeId('Plant_Order_Properties__c',newOrderWrap.Product);
            }
            System.debug('newOP:' + newOP);
            
            Plant_Meal_Selection__c newMS = new Plant_Meal_Selection__c();
            String newMSId;
            if(isBulk) {
                retWrapper.newMealSelection = newMS;
            } else {
                if(newOrderWrap.isChefMenu) {
                    newMS.Plant_Make_Chef_Menu__c = true;
                }
                insert newMS;    
                newMSId = newMS.Id;
            }
            System.debug('newMSId:' + newMSId);
            newOP.Plant_Meal_Selection__c = newMSId;
            
            for(newOrderMealWrapper m :newOrderWrap.meals) {
                Plant_Meal_Selection_Meal__c newMSM = new Plant_Meal_Selection_Meal__c(
                    Plant_Meal_Selection__c = newMSId,
                    Plant_Meal__c = m.MealId,
                    Plant_Quantity__c = m.Quantity
                );
                System.debug('newMSM:' + newMSM);
                
                if(isBulk) {
                    retWrapper.newMealSelectionMeals.add(newMSM);
                } else {
                    insert newMSM;    
                }
            }
            
            Plant_Payment_Method__c newPM = new Plant_Payment_Method__c(
                Plant_Account__c = newOrderWrap.AccountId,
                Plant_Is_Account_Record__c = False,
                Plant_Card_Number__c = newOrderWrap.CardNumber,
                Plant_Card_Type__c = newOrderWrap.CardType,
                CCV__c = newOrderWrap.CCV,
                Plant_Card_Last_4_Digits__c = newOrderWrap.CardLast4Digits,
                Plant_City__c = newOrderWrap.BillingCity,
                Plant_Country__c = newOrderWrap.BillingCountry,
                Plant_Customer_Name__c = newOrderWrap.BillingCustomerName,
                Plant_Expiration_Date__c = newOrderWrap.ExpirationDate,
                Plant_Phone__c = newOrderWrap.BillingPhone,
                Plant_Postal_Code__c = newOrderWrap.BillingPostalCode,
                Plant_Province_State__c = newOrderWrap.BillingProvinceState,
                Plant_Street1__c = newOrderWrap.BillingStreet1,
                Plant_Street2__c = newOrderWrap.BillingStreet2,
                Plant_Street3__c = newOrderWrap.BillingStreet3
            );
            System.debug('newPM:' + newPM);
            String newPMId;
            if(isBulk) {
                retWrapper.newPaymentMethod = newPM;
            } else {
                insert newPM;
                newPMId = newPM.Id;
            }
            System.debug('newPMId:' + newPMId);
            newOP.Plant_Payment_Method__c = newPMId;
            
            Plant_Shipping_Address__c newSA = new Plant_Shipping_Address__c(
                Plant_Account__c = newOrderWrap.AccountId,
                Plant_Is_Account_Record__c = false,
                Plant_First_Name__c = newOrderWrap.ShippingFirstName,
                Plant_Last_Name__c = newOrderWrap.ShippingLastName,
                Plant_Can_SMS__c = newOrderWrap.CanSMS,
                Plant_Phone__c = newOrderWrap.ShippingPhone,
                Plant_Street1__c = newOrderWrap.ShippingStreet1,
                Plant_Street2__c = newOrderWrap.ShippingStreet2,
                Plant_Street3__c = newOrderWrap.ShippingStreet3,
                Plant_City__c = newOrderWrap.ShippingCity,
                Plant_Province_State__c = newOrderWrap.ShippingProvinceState,
                Plant_Postal_Code__c = newOrderWrap.ShippingPostalCode,
                Plant_Country__c = newOrderWrap.ShippingCountry
            );
            System.debug('newSA:' + newSA);
            
            String newSAId;
            if(isBulk) {
                retWrapper.newShippingAddress = newSA;
            } else {
                insert newSA;
                newSAId = newSA.Id;
            }
            System.debug('newSAId:' + newSAId);
            
            newOP.Shipping_Address__c = newSAId;
            
            // Shipping Date
            // If bulk skip, just set
            String newOPId;
            String ShippingDateId;
            if(!isBulk) {
                Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                tempAddrsWrap.state=newOrderWrap.ShippingProvinceState;
                tempAddrsWrap.zip=newOrderWrap.ShippingPostalCode;
                Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                System.debug('availableDates_List:' + availableDates_List);
                
                if(availableDates_List.status=='success'){
                    Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                    System.debug('avail_DeliveryDaye_Map:' + avail_DeliveryDaye_Map);
                    
                    newOP.Plant_Delivery_Date__c = Date.valueOf(newOrderWrap.deliveryDate);
                    newOP.Plant_Shipping_Date__c=avail_DeliveryDaye_Map.get(newOrderWrap.deliveryDate).split(':')[0];
                    newOP.Delivery_Schedule__c=avail_DeliveryDaye_Map.get(newOrderWrap.deliveryDate).split(':')[1];  
                    
                    System.debug('newOP.Plant_Delivery_Date__c:' + newOP.Plant_Delivery_Date__c);
                    System.debug('newOP.Plant_Shipping_Date__c:' + newOP.Plant_Shipping_Date__c);
                    System.debug('newOP.Delivery_Schedule__c:' + newOP.Delivery_Schedule__c);
                }
                System.debug('newOP:' + newOP);
                insert newOP;   
                newOPId = newOP.Id;
                ShippingDateId = newOP.Plant_Shipping_Date__c;
            } else {
                retWrapper.newOrderProperties = newOP;
            }
            System.debug('newOPId:' + newOPId);
            System.debug('ShippingDateId:' + ShippingDateId);
            
            // Order Item
            String prodCode;
            if(newOrderWrap.ProductOverride != NULL) {
                prodCode = newOrderWrap.ProductOverride;
            } else if(!Test.isRunningTest()) {
                Map<String, PlantProducts__c> plantProdSettings = PlantProducts__c.getAll();
                System.debug('plantProdSettings:' + plantProdSettings);
                
                PlantProducts__c fndProdCode = plantProdSettings.get(newOrderWrap.Product);
                System.debug('fndProdCode:' + fndProdCode);
                prodCode = fndProdCode.ProductCode__c;
            } else if(Test.isRunningTest()) {
                prodCode='PLANTALC';
            }
            System.debug('prodCode:' + prodCode);
            
            PricebookEntry priceEntry;
            if(isBulk) {
                priceEntry = bulkPriceBookMap.get(newOrderWrap.ProductOverride);
            } else {
                List<PricebookEntry> lstPrice = [select id, Pricebook2Id, Product2Id, UnitPrice from PricebookEntry where Product2.ProductCode = :prodCode];
                System.debug('lstPrice:' + lstPrice);
                priceEntry = lstPrice[0];
            }
            System.debug('priceEntry:' + priceEntry);
            
            if(priceEntry != NULL) {
                
                Decimal amount;
                if(newOrderWrap.PriceOverride != NULL) {
                    amount = newOrderWrap.PriceOverride;
                } else {
                    amount = priceEntry.UnitPrice;
                }
                
                Order newOrder = new Order(
                    AccountId = newOrderWrap.AccountId,
                    Plant_Fulfillment_Status__c = null,
                    Plant_Order_Properties__c = newOPId,
                    Plant_Subscription__c = null,
                    Plant_Shipping_Date__c = ShippingDateId,
                    Status = 'Draft',
                    Pricebook2Id = priceEntry.Pricebook2Id,
                    Amount_to_Pay__c = amount
                );
                if(newOrderWrap.CloseDateOverride != NULL) {
                    newOrder.EffectiveDate = newOrderWrap.CloseDateOverride;
                } else {
                    newOrder.EffectiveDate = Date.Today();
                }
                
                if(newOrderWrap.ShippingDateOverride != NULL) {
                    newOrder.Plant_Legacy_Shipping_Date__c = newOrderWrap.ShippingDateOverride;
                }
                if(newOrderWrap.ShippingDateOverride != NULL && newOrderWrap.ShippingDurationOverride != NULL) {
                    newOrder.Plant_Delivery_Date__c = newOrderWrap.ShippingDateOverride.addDays(newOrderWrap.ShippingDurationOverride);
                }
                if(newOrderWrap.ProductOverride != NULL) {
                    newOrder.Plant_Legacy_Product__c = newOrderWrap.ProductOverride;                    
                }
                if(newOrderWrap.OrderNumberOverride != NULL) {
                    newOrder.Plant_Legacy_Order_Number__c = newOrderWrap.OrderNumberOverride;    
                }
                if(newOrderWrap.PriceOverride != NULL) {
                    newOrder.Plant_Legacy_Amount_Paid__c = newOrderWrap.PriceOverride;
                }
                System.debug('newOrder:' + newOrder);
                
                String newOrderId;
                if(!isBulk) {
                    insert newOrder; 
                    newOrderId = newOrder.Id;
                }
                System.debug('newOrderId:' + newOrderId);
                
                // Return Order
                retWrapper.newOrder = newOrder;
                if(newOrderWrap.OrgOrderId != NULL) {
                    retWrapper.OrgOrderId = newOrderWrap.OrgOrderId;
                }
                
                OrderItem newOrderItem = new OrderItem(
                    OrderId = newOrderId,
                    Quantity = 1,
                    UnitPrice = amount,
                    Product2id = priceEntry.Product2Id,
                    PricebookEntryId = priceEntry.id
                );
                System.debug('newOrderItem:' + newOrderItem);
                
                if(isBulk) {
                    retWrapper.newOrderItem = newOrderItem;
                } else {
                    insert newOrderItem;    
                }
            }
        }
        return retWrapper;
    }
    
    public static ChargentOrders__ChargentOrder__c stagePayment(newOrderWrapper newOrderWrap, Decimal amount) {
        ChargentOrders__ChargentOrder__c corder;
        
        System.debug('stagePayment:' + newOrderWrap);
        System.debug('stagePayment amount:' + amount);
        
        if(newOrderWrap != NULL) {
            corder = new ChargentOrders__ChargentOrder__c(
                ChargentOrders__Account__c = newOrderWrap.AccountId,
                ChargentOrders__Gateway__c = Label.PlantChargentGatewayId,
                ChargentOrders__Subtotal__c = amount,
                ChargentOrders__Payment_Method__c = 'Credit Card',
                ChargentOrders__OrderSource__c = 'E-commerce',
                ChargentOrders__Billing_First_Name__c = newOrderWrap.BillingFirstName,
                ChargentOrders__Billing_Last_Name__c = newOrderWrap.BillingLastName,
                ChargentOrders__Billing_Email__c = newOrderWrap.Email,
                ChargentOrders__Billing_Address__c = newOrderWrap.BillingStreet1,
                ChargentOrders__Billing_Address_Line_2__c = newOrderWrap.BillingStreet2,
                ChargentOrders__Billing_City__c = newOrderWrap.BillingCity,
                ChargentOrders__Billing_State__c = newOrderWrap.BillingProvinceState,
                ChargentOrders__Billing_Zip_Postal__c = newOrderWrap.BillingPostalCode,
                ChargentOrders__Billing_Country__c = newOrderWrap.BillingCountry
            );    
        }
        System.debug('corder:' + corder);
        return corder;
    }
        
    public static ChargentOrders__Transaction__c makePayment(String corderId, newOrderWrapper newOrderWrap, Decimal amount) {
        ChargentOrders__Transaction__c ctrans;
        
        System.debug('makePayment:' + newOrderWrap);
        System.debug('corderId:' + corderId);
        System.debug('amount:' + amount);
        
        ctrans = new ChargentOrders__Transaction__c(
            ChargentOrders__Gateway_Date__c = DateTime.now(),
            ChargentOrders__Order__c = corderId,
            ChargentOrders__Type__c = 'Charge',
            ChargentOrders__Response_Status__c = 'Approved',
            ChargentOrders__Gateway__c = Label.PlantChargentGatewayId,
            ChargentOrders__Reason_Code__c = 200,
            ChargentOrders__Response__c = 'OK',
            ChargentOrders__Authorization__c = '1111111111',
            ChargentOrders__Credit_Card_Name__c = newOrderWrap.BillingFirstName + ' ' + newOrderWrap.BillingLastName,
            ChargentOrders__Tokenization__c = '1111111111',
            ChargentOrders__Card_Last_4__c = newOrderWrap.CardLast4Digits,
            ChargentOrders__Amount__c = amount,
            ChargentOrders__Payment_Method__c = 'Credit Card',
            ChargentOrders__Billing_Address__c = newOrderWrap.BillingStreet1,
            ChargentOrders__Billing_Address_Line_2__c = newOrderWrap.BillingStreet2,
            ChargentOrders__Billing_City__c = newOrderWrap.BillingCity,
            ChargentOrders__Billing_State__c = newOrderWrap.BillingProvinceState,
            ChargentOrders__Billing_Postal_Code__c = newOrderWrap.BillingPostalCode,
            ChargentOrders__Billing_Country__c = newOrderWrap.BillingCountry,
            ChargentOrders__Billing_First__c = newOrderWrap.BillingFirstName,
            ChargentOrders__Billing_Last__c = newOrderWrap.BillingLastName,
            ChargentOrders__Billing_Phone__c = newOrderWrap.Phone,
            ChargentOrders__Billing_Email__c = newOrderWrap.Email
        );
        System.debug('ctrans:' + ctrans);
        return ctrans;
    }
    
    // Load Subscriptions (set Account, Plant_Next_Shipment_Date__c, Plant_Next_Charge_Date__c, Order_Count__c, Plant_Amount__c)
    // Load Meal Selections (just insert with Plant_Make_Chef_Menu__c = True)
    // Load Shipping Addresses and relate to Subscriptions
    // Update Subscriptions, check Plant_Import_Legacy_Data__c to fire
    public static void subscriptionLegacyLoadHandler(SET<String> subIds) {
        
        MAP<String,Plant_Subscription__c> mapSub = new MAP<String,Plant_Subscription__c>();
        SET<Date> shipdates = new SET<Date>();
        SET<String> stcs = new SET<String>();
        SET<String> zips = new SET<String>();
        
        list<Plant_Subscription__c> lstSubs = [select Id, RecordType.Name, Plant_Account__c, Plant_Shipping_Address__r.Plant_Province_State__c, Plant_Shipping_Address__r.Plant_Postal_Code__c,
                                               Plant_Payment_Method__c, Plant_Delivery_Schedule__c, Plant_Shipping_Date__c, Plant_Next_Shipment_Date__c,Plant_Amount__c,Plant_Next_Charge_Date__c, 
                                               Order_Count__c, Plant_Next_Delivery_Date__c from Plant_Subscription__c where id in :subIds];
		System.debug('lstSubs:' + lstSubs);

        if(!lstSubs.isEmpty()) {
            for(Plant_Subscription__c sub :lstSubs) {
                mapSub.put(sub.Id,sub);
                
                if(sub.Plant_Next_Shipment_Date__c != NULL) {
                    shipdates.add(sub.Plant_Next_Shipment_Date__c);
                }
                if(sub.Plant_Shipping_Address__r.Plant_Province_State__c != NULL) {
                    stcs.add(sub.Plant_Shipping_Address__r.Plant_Province_State__c);
                }
                if(sub.Plant_Shipping_Address__r.Plant_Postal_Code__c != NULL) {
                    zips.add(sub.Plant_Shipping_Address__r.Plant_Postal_Code__c);
                }
            }
        }
        System.debug('mapSub:' + mapSub);
        if(!mapSub.isEmpty()) {
                        
            List<Plant_Delivery_Schedule__c> lstDS = [select id, Plant_Shipping_Duration__c, Plant_State_Code__c, Plant_Zip_Code__c from Plant_Delivery_Schedule__c where Plant_State_Code__c = :stcs OR Plant_Zip_Code__c in :zips];
            MAP<String,Plant_Delivery_Schedule__c> mapDelivery = new MAP<String,Plant_Delivery_Schedule__c>();
            if(!lstDS.isEmpty()) {                
                for(Plant_Delivery_Schedule__c ds :lstDS) {
                    mapDelivery.put(ds.Plant_State_Code__c + ':' + ds.Plant_Zip_Code__c, ds);
                }
            }
            System.debug('mapDelivery:' + mapDelivery);
            
            List<Plant_Shipping_Date__c> listSD = [select id, Plant_Shipping_Date__c from Plant_Shipping_Date__c where Plant_Shipping_Date__c in :shipdates];
            System.debug('listSD:' + listSD);
            
            MAP<Date,Plant_Shipping_Date__c> mapSD = new MAP<Date,Plant_Shipping_Date__c>();
            if(!listSD.isEmpty()) {
                for(Plant_Shipping_Date__c sd :listSD) {
                    mapSD.put(sd.Plant_Shipping_Date__c,sd);
                }                
            }
            System.debug('mapSD:' + mapSD);
            
            List<ChargentOrders__ChargentOrder__c> insertChrgOrds = new List<ChargentOrders__ChargentOrder__c>();
            for(Plant_Subscription__c sub :mapSub.values()){
                
                System.debug('sub:' + sub);
                
                Plant_Delivery_Schedule__c fndDS = mapDelivery.get(sub.Plant_Shipping_Address__r.Plant_Province_State__c + ':' + sub.Plant_Shipping_Address__r.Plant_Postal_Code__c);
                Plant_Shipping_Date__c fndSD = mapSD.get(sub.Plant_Next_Shipment_Date__c);
                
                System.debug('fndDS:' + fndDS);
                System.debug('fndSD:' + fndSD);
                
                if(fndDS != NULL && fndSD != NULL) {
                    sub.Plant_Delivery_Schedule__c = fndDS.Id;
                    sub.Plant_Shipping_Date__c = fndSD.Id;
                    sub.Plant_Next_Delivery_Date__c = fndSD.Plant_Shipping_Date__c.addDays(Integer.valueOf(fndDS.Plant_Shipping_Duration__c));
                    System.debug('sub update:' + sub);
                    mapSub.put(sub.id,sub);
                    
                    newOrderWrapper newOrderWrap = new newOrderWrapper();
                    newOrderWrap.AccountId = sub.Plant_Account__c;

                    ChargentOrders__ChargentOrder__c corder = stagePayment(newOrderWrap, sub.Plant_Amount__c);
                    corder.ChargentOrders__Payment_Start_Date__c = sub.Plant_Next_Charge_Date__c;
                    corder.ChargentOrders__Next_Transaction_Date__c = sub.Plant_Next_Charge_Date__c;
                    corder.ChargentOrders__Payment_Count__c = Integer.valueOf(sub.Order_Count__c);                        
                    corder.ChargentOrders__Payment_Frequency__c = 'Weekly';
                    corder.ChargentOrders__Payment_Status__c = 'Recurring';
                    
                    if(sub.RecordType.Name == 'Reboot') {
                        corder.ChargentOrders__Payment_Stop__c = 'Count';
                    } else {
                        corder.ChargentOrders__Payment_Stop__c = 'Unending';
                    }
                    corder.Plant_Migrate_Data_Order__c = sub.Id;
                    System.debug('corder:' + corder);
                    insertChrgOrds.add(corder);
                }

            }
            System.debug('insert insertChrgOrds:' + insertChrgOrds);
            insert insertChrgOrds;
            
            MAP<String,ChargentOrders__ChargentOrder__c> mapCO = new MAP<String,ChargentOrders__ChargentOrder__c>();
            for(ChargentOrders__ChargentOrder__c co :insertChrgOrds) {
                mapCO.put(co.Plant_Migrate_Data_Order__c, co);
            }
            System.debug('mapCO:' + mapCO);
            
            List<Plant_Subscription__c> updateSubs = new List<Plant_Subscription__c>();
            for(Plant_Subscription__c sub :mapSub.values()){
                System.debug('sub:' + sub);
                
                ChargentOrders__ChargentOrder__c fndCO = mapCO.get(sub.Id);
                if(fndCO != NULL) {
                    sub.Plant_Chargent_Order__c = fndCO.Id;
                }
                System.debug('updateSubs:' + sub);
                updateSubs.add(sub);
            }
            update updateSubs;
        }
    }
    
    // AG - Legacy Import Meal Selection
    // Make Meal Selection Chef Menu
    public static void mealSelectionChangeEventHandler(Set<String> mealSelIds) {
        if(!mealSelIds.isEmpty()) {
            List<Plant_Meal_Selection_Meal__c> lstMSM = [select id, Plant_Meal__c, Plant_Quantity__c from Plant_Meal_Selection_Meal__c where Plant_Meal_Selection__r.Plant_Owner__c != NULL AND Plant_Meal_Selection__r.Plant_Description__c = 'Chef Menu'];
            System.debug('lstMSM:' + lstMSM);
            
            if(!lstMSM.isEmpty()) {
                List<Plant_Meal_Selection_Meal__c> insertMSM = new List<Plant_Meal_Selection_Meal__c>();
                for(String ce :mealSelIds) {
                    System.debug('ce:' + ce);
                    
                    for(Plant_Meal_Selection_Meal__c msm :lstMSM) {
                        Plant_Meal_Selection_Meal__c newMSM = new Plant_Meal_Selection_Meal__c(
                            Plant_Meal__c = msm.Plant_Meal__c,
                            Plant_Quantity__c = msm.Plant_Quantity__c,
                            Plant_Meal_Selection__c = ce
                        );
                        insertMSM.add(newMSM);
                    }   
                    System.debug('insertMSM:' + insertMSM);
                }
                insert insertMSM;
            }
        }
    }
    
    public static void apiRequestChangeTriggerHandler(String apiReqId) {
        List<API_Request__c> lstAPIReqs = [select Id, Order__c, Order_Number__c, OrderId__c, Auto_Order_Number__c, 
                                           First_Name__c,Last_Name__c,Customer_Email__c,Created_At__c,
                                           Phone__c, Company__c,Street1__c,Street2__c,City__c,State__c,Zip__c, Country__c,
                                           Ship_Date__c,Is_Custom__c,Shipping_Company__c,Shipping_First_Name__c,Shipping_Last_Name__c,Shipping_Phone__c,
                                           Shipping_Street1__c, Shipping_Street2__c,Shipping_City__c,Shipping_State__c,Shipping_Zip__c,Shipping_Country__c,
                                           Billing_Company__c,Billing_First_Name__c,Billing_Last_Name__c,Billing_Phone__c,Billing_Street1__c,Billing_Street2__c,
                                           Billing_City__c,Billing_State__c,Billing_Zip__c,Billing_Country__c,Charge_Amount__c, Charge_Source__c,
                                           (Select id, Type__c, Code__c, Quantity__c,Amount__c,Ship_Date__c,External_Id__c from  API_Request_Line_Items__r)
                                           from API_Request__c where Request_Type__c = 'Create Order' AND id = :apiReqId];
        
        System.debug('lstAPIReqs:' + lstAPIReqs);
        if(!lstAPIReqs.isEmpty()) {
            API_Request__c apiReq = lstAPIReqs[0];
            List<Account> lstAccts = [select id, Name from Account where Email__c = :apiReq.Customer_Email__c];
            System.debug('lstAccts:' + lstAccts);
            
            Account acct;
            if(!lstAccts.isEmpty()) {
                acct = lstAccts[0];
            } else {
                // TO DO: Create Account
                acct = new Account(
                    Name = apiReq.First_Name__c + ' ' + apiReq.Last_Name__c,
                    RecordTypeId = Plant_Utility.GetRecordTypeId('Account','Individual'),
                    First_Name__c = apiReq.First_Name__c,
                    Last_Name__c = apiReq.Last_Name__c,
                    Email__c = apiReq.Customer_Email__c,
                    Phone = apiReq.Phone__c,
                    BillingStreet = apiReq.Billing_Street1__c,
                    BillingCity = apiReq.Billing_City__c,
                    BillingState = apiReq.Billing_State__c,
                    BillingPostalCode = apiReq.Billing_Zip__c,
                    BillingCountry = apiReq.Billing_Country__c 
                );
                System.debug('insert acct:' + acct);
                insert acct;
                
                Contact cont = new Contact(
                    AccountId = acct.id,
                    FirstName = apiReq.First_Name__c,
                    LastName = apiReq.Last_Name__c,
                    Phone = apiReq.Phone__c,
                    Email = apiReq.Customer_Email__c,
                    MailingStreet = apiReq.Street1__c,
                    MailingCity = apiReq.City__c,
                    MailingState = apiReq.State__c,
                    MailingPostalCode = apiReq.Zip__c,
                    MailingCountry = apiReq.Country__c,
                    RecordTypeId = Plant_Utility.GetRecordTypeId('Contact','Customer')
                );
                System.debug('insert cont:' + cont);
                insert cont;
                
            }
            
            newOrderWrapper newOrderWrap = new newOrderWrapper();
            newOrderWrap.AccountId = acct.Id;
            //newOrderWrap.Product = orgOrder.Plant_Main_Product__c;

            newOrderWrap.FirstName = apiReq.First_Name__c;
            newOrderWrap.LastName = apiReq.Last_Name__c;
            newOrderWrap.Email = apiReq.Customer_Email__c;
            newOrderWrap.Phone = apiReq.Phone__c;
            newOrderWrap.CanSMS = True;
            //newOrderWrap.Provider = orgOrder.Plant_Order_Properties__r.Plant_Provider__c;
            
            newOrderWrap.BillingFirstName = apiReq.Billing_First_Name__c;
            newOrderWrap.BillingLastName = apiReq.Billing_Last_Name__c;
            newOrderWrap.CardNumber = null;
            newOrderWrap.CardType = apiReq.Charge_Source__c;
            newOrderWrap.CCV = null;
            newOrderWrap.CardLast4Digits = null;
            newOrderWrap.BillingCity = apiReq.Billing_City__c;
            newOrderWrap.BillingCountry = apiReq.Billing_Country__c;
            newOrderWrap.BillingCustomerName = apiReq.Billing_First_Name__c + ' ' + apiReq.Billing_Last_Name__c;
            newOrderWrap.ExpirationDate = null;
            newOrderWrap.BillingPhone = apiReq.Billing_Phone__c;
            newOrderWrap.BillingPostalCode = apiReq.Billing_Zip__c;
            newOrderWrap.BillingProvinceState = apiReq.Billing_State__c;
            newOrderWrap.BillingStreet1 = apiReq.Street1__c;
            newOrderWrap.BillingStreet2 = apiReq.Street2__c;
            newOrderWrap.BillingStreet3 = NULL;

            newOrderWrap.ShippingFirstName = apiReq.Shipping_First_Name__c;
            newOrderWrap.ShippingLastName = apiReq.Shipping_Last_Name__c;
            newOrderWrap.ShippingPhone = apiReq.Shipping_Phone__c;
            newOrderWrap.ShippingStreet1 = apiReq.Shipping_Street1__c;
            newOrderWrap.ShippingStreet2 = apiReq.Shipping_Street2__c;
            newOrderWrap.ShippingStreet3 = NULL;
            newOrderWrap.ShippingCity = apiReq.Shipping_City__c;
            newOrderWrap.ShippingProvinceState = apiReq.Shipping_State__c;
            newOrderWrap.ShippingPostalCode = apiReq.Shipping_Zip__c;
            newOrderWrap.ShippingCountry = apiReq.Shipping_Country__c;
            System.debug('newOrderWrap:' + newOrderWrap);
            
            // Meals
            newOrderWrap.meals = new List<newOrderMealWrapper>();

            List<Meal__c> lstMeals = [select id, Shopify_ID__c from Meal__c where API_Enabled__c = true AND Status__c = 'Active' AND Shopify_ID__c != NULL];
            System.debug('lstMeals:' + lstMeals);
            
            MAP<String,Meal__c> mapMeals = new MAP<String,Meal__c>();
            if(!lstMeals.isEmpty()) {
                for(Meal__c m :lstMeals) {
                    mapMeals.put(m.Shopify_ID__c, m);
                }
            }
            System.debug('mapMeals:' + mapMeals);
            
            for(API_Request_Line_Item__c apil :apiReq.API_Request_Line_Items__r) {
                System.debug('apil:' + apil);
                
                if(apil.Type__c == 'Product') {
                    if(apil.Code__c == 'ZPEALC') {
                        newOrderWrap.Product = 'A-la-carte';
                        newOrderWrap.Provider = 'Zipongo';
                        newOrderWrap.ProductOverride = 'ZPEALC';
                        newOrderWrap.PriceOverride = apil.Amount__c; 
                    } else if(apil.Code__c == '3928880709750') {
                        // Study Order
                        newOrderWrap.Product = 'A-la-carte';
                        newOrderWrap.Provider = 'Study';
                        newOrderWrap.PriceOverride = 0;
                        newOrderWrap.isChefMenu = True;
                    }
                } else if(apil.Type__c == 'Meal' && apil.Code__c != NULL) {
                    Meal__c fndMeal = mapMeals.get(apil.Code__c);
                    if(fndMeal != NULL) {
                        newOrderMealWrapper newMeal = new newOrderMealWrapper();
                        newMeal.MealId = fndMeal.Id;
                        newMeal.Quantity = Integer.valueOf(apil.Quantity__c);
                        newOrderWrap.meals.add(newMeal);
                    }
                }
            }
            System.debug('newOrderWrap:' +newOrderWrap);
            System.debug('newOrderWrap.meals:' + newOrderWrap.meals);
            
            List<Plant_Delivery_Schedule__c> lstDS = [select id, Plant_Shipping_Duration__c, Plant_State_Code__c, Plant_Zip_Code__c from Plant_Delivery_Schedule__c where Plant_State_Code__c = :apiReq.Shipping_State__c OR Plant_Zip_Code__c = :apiReq.Shipping_Zip__c];
            System.debug('lstDS:' +lstDS);
            
            MAP<String,Plant_Delivery_Schedule__c> mapDelivery = new MAP<String,Plant_Delivery_Schedule__c>();
            if(!lstDS.isEmpty()) {                
                for(Plant_Delivery_Schedule__c ds :lstDS) {
                    mapDelivery.put(ds.Plant_State_Code__c + ':' + ds.Plant_Zip_Code__c, ds);
                }
            }
            System.debug('mapDelivery:' + mapDelivery);
            
            Date enddt = apiReq.Ship_Date__c.addDays(10);
            List<Plant_Shipping_Date__c> lstShipDates = [select id, Plant_Shipping_Date__c from Plant_Shipping_Date__c where Plant_Shipping_Date__c >= :apiReq.Ship_Date__c];
            System.debug('lstShipDates:' +lstShipDates);

            Date shipDate;
            if(!lstShipDates.isEmpty()) {
                for(Plant_Shipping_Date__c sd :lstShipDates) {
                    if(apiReq.Ship_Date__c >= sd.Plant_Shipping_Date__c) {
                        shipDate = sd.Plant_Shipping_Date__c;
                    }
                }
            }
            System.debug('shipDate:' +shipDate);
            
            if(shipDate != NULL) {
                Plant_Delivery_Schedule__c fndDS = mapDelivery.get(apiReq.Shipping_State__c + ':' + apiReq.Shipping_Zip__c);
                System.debug('fndDS:' +fndDS);
                
                if(fndDS != NULL) {
                    Date dt = shipDate.addDays(Integer.valueOf(fndDS.Plant_Shipping_Duration__c));
                    DateTime dtm = DateTime.newInstance(dt.year(), dt.month(), dt.day());
                    newOrderWrap.deliveryDate = dtm.formatGMT('yyyy-MM-dd');
                }
                System.debug('newOrderWrap.deliveryDate:' +newOrderWrap.deliveryDate);
                
                // Setup Overrides
                //newOrderWrap.ShippingDateOverride = Date.newInstance(2021,1,1);
                //newOrderWrap.ShippingDurationOverride = 2;
                //newOrderWrap.OrderNumberOverride = 'S12345';
                //newOrderWrap.OrderPropertiesRecordTypeIdOverride = Plant_Utility.GetRecordTypeId('Plant_Order_Properties__c','Legacy');
                //newOrderWrap.CloseDateOverride = Date.newInstance(2021,1,1);
                
                
                // Create Order
                retNewOrderWrapper retOrderWrapper = createOrder(newOrderWrap, False, Null);
                System.debug('retOrderWrapper:' + retOrderWrapper);
                
                Order retOrder = retOrderWrapper.newOrder;
                
                // Stage Payment
                ChargentOrders__ChargentOrder__c corder = stagePayment(newOrderWrap, retOrder.Amount_to_Pay__c);
                insert corder;
                System.debug('corder:' + corder);
                
                retOrder.comty_Chargent_Order__c = corder.id;
                update retOrder;
                
                // Make Payment
                ChargentOrders__Transaction__c ctrans = makePayment(corder.Id, newOrderWrap, retOrder.Amount_to_Pay__c);
                insert ctrans;
                
                apiReq.Order__c = retOrder.Id;
                apiReq.Account__c = acct.Id;
                update apiReq;
            }
        }
    }

    
    // AG - Wrapper to create a new order
    public class newOrderMealWrapper{
        public String MealId;   
        public Integer Quantity;
    }
    
    public class newOrderWrapper{
        public String AccountId;
        public String Product;     
        
        // Import
        public String ProductOverride;        
        public Decimal PriceOverride;
        public Date ShippingDateOverride;
        public Integer ShippingDurationOverride;
        public String OrderNumberOverride;
        public String OrderPropertiesRecordTypeIdOverride;
        public Date CloseDateOverride;
        public String OrgOrderId;
        public Boolean isChefMenu;
        
        public List<newOrderMealWrapper> meals;
        public String deliveryDate;
        
        public String FirstName;
        public String LastName;
        public String Email;
        public String Phone;
        public Boolean CanSMS;
        public String Provider;
        
        public String CardNumber;
        public String CardType;
        public String CCV;
        public String CardLast4Digits;
        public String BillingFirstName;
        public String BillingLastName;
        public String BillingCity;
        public String BillingCountry;
        public String BillingCustomerName;
        public Date ExpirationDate;
        public String BillingPhone;
        public String BillingPostalCode;
        public String BillingProvinceState;
        public String BillingStreet1;
        public String BillingStreet2;
        public String BillingStreet3;
        
        public String ShippingFirstName;
        public String ShippingLastName;
        public String ShippingPhone;
        public String ShippingStreet1;
        public String ShippingStreet2;
        public String ShippingStreet3;
        public String ShippingCity;
        public String ShippingProvinceState;
        public String ShippingPostalCode;
        public String ShippingCountry;
    }
    
}