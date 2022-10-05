global class Plant_BatchMigrateOrders implements Database.Batchable<sObject>{
    public String accountID;  
    public String orderID;  
    public DateTime batchLastRun;

    // Testing:
    // DateTime dt = DateTime.now();
	// Id batchJobId = Database.executeBatch(new Plant_BatchMigrateOrders(dt,'0063J000007tnSj',null), 1);
	// Id batchJobId = Database.executeBatch(new Plant_BatchMigrateOrders(dt,null,'0013J00000R2rjs'), 1);

    global Plant_BatchMigrateOrders(DateTime inBatchLastRun, String inOrderID, String inAccountID){
        this.batchLastRun = inBatchLastRun;
        this.orderID = inOrderID;
        this.accountID = inAccountID;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        
        Date oldestClosedDate = Date.newInstance(2020, 1, 1);
        
        if(orderID != NULL) {
            return Database.getQueryLocator('select Id, AccountId, Account.Phone, External_Order_Number__c, Email_Address__c, Fulfilment_Status__c, Order_Source__c, Total_List_Price__c, Amount, CloseDate, Study_Order__c, Order_Date_Time__c, Main_Product__c, Main_Product_Code__c, Shipment_Date__c, Delivery_Date__c, Is_Custom__c, Number_of_Cycles__c, First_Name__c, Last_Name__c from Opportunity where id = :orderID');
        } else if(accountID != NULL) {
            return Database.getQueryLocator('select Id, AccountId, Account.Phone, External_Order_Number__c, Email_Address__c, Fulfilment_Status__c, Order_Source__c, Total_List_Price__c, Amount, CloseDate, Study_Order__c, Order_Date_Time__c, Main_Product__c, Main_Product_Code__c, Shipment_Date__c, Delivery_Date__c, Is_Custom__c, Number_of_Cycles__c, First_Name__c, Last_Name__c from Opportunity where stagename = \'Closed Won\' AND CloseDate >= :oldestClosedDate AND AccountId = :accountID');
        } else {
            return Database.getQueryLocator('select Id, AccountId, Account.Phone, External_Order_Number__c, Email_Address__c, Fulfilment_Status__c, Order_Source__c, Total_List_Price__c, Amount, CloseDate, Study_Order__c, Order_Date_Time__c, Main_Product__c, Main_Product_Code__c, Shipment_Date__c, Delivery_Date__c, Is_Custom__c, Number_of_Cycles__c, First_Name__c, Last_Name__c from Opportunity where stagename = \'Closed Won\' AND CloseDate >= :oldestClosedDate'); 
        }
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        
        MAP<String, Opportunity> mapOpp = new MAP<String, Opportunity>();
        for(Opportunity opp :scope) {
            mapOpp.put(opp.id,opp);
        }
        System.debug('mapOpp:' + mapOpp);
        
        MAP<String, Shipment__c> mapOppShip = new MAP<String, Shipment__c>();
        list<Shipment__c> lstShip = [select Id, Opportunity__c, First_Name__c, Last_Name__c, Phone__c, Street1__c, Street2__c, City__c, State__c, Zip__c, Country__c, Cycle__c, Shipping_Service_Type__c from Shipment__c where Opportunity__c in :mapOpp.keyset()];
		System.debug('lstShip:' + lstShip);
        for(Shipment__c s :lstShip) {
            mapOppShip.put(s.Opportunity__c,s);
        }
        System.debug('mapOppShip:' + mapOppShip);
        
        MAP<String, List<Meal_Line_Item__c>> mapOppMeals = new MAP<String, List<Meal_Line_Item__c>>();
        List<Meal_Line_Item__c> lstMealLines = [select Id, EOrder__c, Meal__c, Quantity__c from Meal_Line_Item__c where EOrder__c in :mapOpp.keyset()];
		System.debug('lstMealLines:' + lstMealLines);
        for(Meal_Line_Item__c mli :lstMealLines) {
            List<Meal_Line_Item__c> mealLst = mapOppMeals.get(mli.EOrder__c);
            if(mealLst == NULL) {
                mealLst = new List<Meal_Line_Item__c>();
            }
            mealLst.add(mli);
            mapOppMeals.put(mli.EOrder__c,mealLst);
        }
        System.debug('mapOppMeals:' + mapOppMeals);
        
        List<Plant_Orders_BC_Helper.newOrderWrapper> newOrderWrappers = new List<Plant_Orders_BC_Helper.newOrderWrapper>();
        for(Opportunity opp :mapOpp.values()) {
            
            Shipment__c fndShip = mapOppShip.get(opp.id);
            if(fndShip != NULL) {
                Plant_Orders_BC_Helper.newOrderWrapper newOrderWrap = new Plant_Orders_BC_Helper.newOrderWrapper();
                newOrderWrap.AccountId = opp.AccountId;
                newOrderWrap.Product = opp.Main_Product_Code__c;
                
                // Setup Overrides
                newOrderWrap.ProductOverride = opp.Main_Product_Code__c;
                newOrderWrap.PriceOverride = opp.Total_List_Price__c;
                newOrderWrap.ShippingDateOverride = opp.Shipment_Date__c;
                newOrderWrap.ShippingDurationOverride = opp.Delivery_Date__c.daysBetween(opp.Shipment_Date__c);
                newOrderWrap.OrderNumberOverride = 'S12345';
                newOrderWrap.OrderPropertiesRecordTypeIdOverride = Plant_Utility.GetRecordTypeId('Plant_Order_Properties__c','Legacy');
                newOrderWrap.CloseDateOverride = Date.newInstance(2021,1,1);
                
                newOrderWrap.FirstName = opp.First_Name__c;
                newOrderWrap.LastName = opp.Last_Name__c;
                newOrderWrap.Email = opp.Email_Address__c;
                newOrderWrap.Phone = opp.Account.Phone; // Add to query 
                newOrderWrap.CanSMS = true;
                newOrderWrap.Provider = 'Plantable'; // TO DO - skip study and zipongo?
                
                newOrderWrap.BillingFirstName = opp.First_Name__c;
                newOrderWrap.BillingLastName = opp.Last_Name__c;
                

                newOrderWrap.CardNumber = null;
                newOrderWrap.CardType = null;
                newOrderWrap.CCV = null;
                newOrderWrap.CardLast4Digits = null;
                newOrderWrap.BillingCity = fndShip.City__c;
                newOrderWrap.BillingCountry = fndShip.Country__c;
                newOrderWrap.BillingCustomerName = fndShip.First_Name__c + ' ' + fndShip.Last_Name__c;
                newOrderWrap.ExpirationDate = null;
                newOrderWrap.BillingPhone = fndShip.Phone__c;
                newOrderWrap.BillingPostalCode = fndShip.Zip__c;
                newOrderWrap.BillingProvinceState = fndShip.State__c;
                newOrderWrap.BillingStreet1 = fndShip.Street1__c;
                newOrderWrap.BillingStreet2 = fndShip.Street2__c;
                newOrderWrap.BillingStreet3 = null;
                
                newOrderWrap.ShippingFirstName = fndShip.First_Name__c;
                newOrderWrap.ShippingLastName = fndShip.Last_Name__c;
                newOrderWrap.ShippingPhone = fndShip.Phone__c;
                newOrderWrap.ShippingStreet1 = fndShip.Street1__c;
                newOrderWrap.ShippingStreet2 = fndShip.Street2__c;
                newOrderWrap.ShippingStreet3 = null;
                newOrderWrap.ShippingCity = fndShip.City__c;
                newOrderWrap.ShippingProvinceState = fndShip.State__c;
                newOrderWrap.ShippingPostalCode = fndShip.Zip__c;
                newOrderWrap.ShippingCountry = fndShip.Country__c;
                newOrderWrap.OrgOrderId = opp.id;
				System.debug('newOrderWrap:' + newOrderWrap);
                
                List<Meal_Line_Item__c> mealLst = mapOppMeals.get(opp.id);
                if(mealLst != NULL) {
                    newOrderWrap.meals = new List<Plant_Orders_BC_Helper.newOrderMealWrapper>();
                    for(Meal_Line_Item__c mli :mealLst) {
                        if(mli.Meal__c != NULL) {
                            Plant_Orders_BC_Helper.newOrderMealWrapper newMeal = new Plant_Orders_BC_Helper.newOrderMealWrapper();
                            newMeal.MealId = mli.Meal__c;
                            newMeal.Quantity = Integer.valueOf(mli.Quantity__c);
                            newOrderWrap.meals.add(newMeal);
                        }
                    }
                }
                
                System.debug('newOrderWrap.meals:' + newOrderWrap.meals);
                newOrderWrappers.add(newOrderWrap);
            }
        }   
        
        MAP<String,PricebookEntry> bulkPriceBookMap = new MAP<String,PricebookEntry>();
        
        List<PricebookEntry> lstPrice = [select id, Pricebook2Id, Product2Id, UnitPrice, Product2.ProductCode from PricebookEntry];
        System.debug('lstPrice:' + lstPrice);
        for(PricebookEntry pe :lstPrice) {
            bulkPriceBookMap.put(pe.Product2.ProductCode, pe);
        }
        System.debug('bulkPriceBookMap:' + bulkPriceBookMap);
        
        MAP<String,Plant_Orders_BC_Helper.retNewOrderWrapper> mapRetOrderWrappers = new MAP<String,Plant_Orders_BC_Helper.retNewOrderWrapper>();
        for(Plant_Orders_BC_Helper.newOrderWrapper now :newOrderWrappers) {
            System.debug('now:' + now);
            
        	Plant_Orders_BC_Helper.retNewOrderWrapper retOrderWrapper = Plant_Orders_BC_Helper.createOrder(now, True, bulkPriceBookMap);  
            System.debug('************* retOrderWrapper:' + retOrderWrapper);
            
            mapRetOrderWrappers.put(retOrderWrapper.OrgOrderId,retOrderWrapper);
        }
        System.debug('mapRetOrderWrappers:' + mapRetOrderWrappers);
        
        // Process Ret Order Wrapeppers
        List<Plant_Meal_Selection__c> insertMS = new List<Plant_Meal_Selection__c>();
        List<Plant_Payment_Method__c> insertPM = new List<Plant_Payment_Method__c>();
        List<Plant_Shipping_Address__c> insertSA = new List<Plant_Shipping_Address__c>();
        List<Plant_Order_Properties__c> insertOP = new List<Plant_Order_Properties__c>();
        List<Plant_Meal_Selection_Meal__c> insertMSM = new List<Plant_Meal_Selection_Meal__c>();
        List<Order> insertORD = new List<Order>();
        List<OrderItem> insertORDI = new List<OrderItem>();
        for(Plant_Orders_BC_Helper.retNewOrderWrapper row :mapRetOrderWrappers.values()) {
            System.debug('row:' + row);
            row.newMealSelection.Plant_Migrate_Data_Order__c = row.OrgOrderId;
            insertMS.add(row.newMealSelection);
            
            row.newPaymentMethod.Plant_Migrate_Data_Order__c = row.OrgOrderId;
            insertPM.add(row.newPaymentMethod);
            
            row.newShippingAddress.Plant_Migrate_Data_Order__c = row.OrgOrderId;
            insertSA.add(row.newShippingAddress);
            
            row.newOrderProperties.Plant_Migrate_Data_Order__c = row.OrgOrderId;
            row.newOrder.Plant_Migrate_Data_Order__c = row.OrgOrderId;
            mapRetOrderWrappers.put(row.OrgOrderId,row);
        }
        System.debug('insertMS:' + insertMS);
        System.debug('insertPM:' + insertPM);
        System.debug('insertSA:' + insertSA);
        System.debug('mapRetOrderWrappers:' + mapRetOrderWrappers);
        
        insert insertMS;
        insert insertPM;
        insert insertSA;
        
        MAP<String,Plant_Meal_Selection__c> mapInsrtMS = new MAP<String,Plant_Meal_Selection__c>();
        for(Plant_Meal_Selection__c ms :insertMS) {
            mapInsrtMS.put(ms.Plant_Migrate_Data_Order__c,ms);
        }
        System.debug('mapInsrtMS:' + mapInsrtMS);
        
        MAP<String,Plant_Payment_Method__c> mapInsrtPM = new MAP<String,Plant_Payment_Method__c>();
        for(Plant_Payment_Method__c pm :insertPM) {
            mapInsrtPM.put(pm.Plant_Migrate_Data_Order__c,pm);
        }
        System.debug('mapInsrtPM:' + mapInsrtPM);
        
        MAP<String,Plant_Shipping_Address__c> mapInsrtSA = new MAP<String,Plant_Shipping_Address__c>();
        for(Plant_Shipping_Address__c sa :insertSA) {
            mapInsrtSA.put(sa.Plant_Migrate_Data_Order__c,sa);
        }
        System.debug('mapInsrtSA:' + mapInsrtSA);
        
        for(Plant_Orders_BC_Helper.retNewOrderWrapper row :mapRetOrderWrappers.values()) {
            
            System.debug('row:' + row);
            
            Plant_Meal_Selection__c findMS = mapInsrtMS.get(row.OrgOrderId);
            Plant_Payment_Method__c findPM = mapInsrtPM.get(row.OrgOrderId);
            Plant_Shipping_Address__c findSA = mapInsrtSA.get(row.OrgOrderId);
            
            System.debug('findMS:' + findMS);
            System.debug('findPM:' + findPM);
            System.debug('findSA:' + findSA);
            
            if(findMS != NULL) {
                row.newOrderProperties.Plant_Meal_Selection__c = findMS.id;                
            }
            if(findPM != NULL) {
                row.newOrderProperties.Plant_Payment_Method__c = findPM.id;                
            }
            if(findSA != NULL) {
                row.newOrderProperties.Shipping_Address__c = findSA.id;                
            }
            System.debug('updated row:' + row);
            mapRetOrderWrappers.put(row.OrgOrderId,row);
            
            insertOP.add(row.newOrderProperties);
            
            // TO DO Meal Selections
            for(Plant_Meal_Selection_Meal__c msm :row.newMealSelectionMeals) {
                msm.Plant_Meal_Selection__c = findMS.Id;
                System.debug('msm:' + msm);
                insertMSM.add(msm);
            }
        }
        System.debug('insertOP:' + insertOP);
        System.debug('insertMSM:' + insertMSM);

        insert insertOP;
        insert insertMSM;
        
        MAP<String,Plant_Order_Properties__c> mapInsrtOP = new MAP<String,Plant_Order_Properties__c>();
        for(Plant_Order_Properties__c op :insertOP) {
            mapInsrtOP.put(op.Plant_Migrate_Data_Order__c,op);
        }
		System.debug('mapInsrtOP:' + mapInsrtOP);
        
		for(Plant_Orders_BC_Helper.retNewOrderWrapper row :mapRetOrderWrappers.values()) {
            Plant_Order_Properties__c fndOP = mapInsrtOP.get(row.OrgOrderId);
            if(fndOP != NULL) {
                row.newOrder.Plant_Order_Properties__c = fndOP.id;
                insertORD.add(row.newOrder);
            }
            mapRetOrderWrappers.put(row.OrgOrderId,row);
        }
        System.debug('insertORD:' + insertORD);
        insert insertORD;
        
        MAP<String,Order> mapInsrtORD = new MAP<String,Order>();
        for(Order ord :insertORD) {
            mapInsrtORD.put(ord.Plant_Migrate_Data_Order__c,ord);
        }
        System.debug('mapInsrtORD:' + mapInsrtORD);
        
        for(Plant_Orders_BC_Helper.retNewOrderWrapper row :mapRetOrderWrappers.values()) {
            Order fndORD = mapInsrtORD.get(row.OrgOrderId);
            System.debug('fndORD:' + fndORD);
            
            if(fndORD!=NULL) {
            	row.newOrderItem.OrderId = fndORD.id; 
                insertORDI.add(row.newOrderItem);
            }
            mapRetOrderWrappers.put(row.OrgOrderId,row);
        }
        System.debug('insertORDI:' + insertORDI);
        insert insertORDI;

        for(Order ord :insertORD) {
            ord.status = 'Activated';
        }
        update insertORD;
        
    }
    
    global void finish(Database.BatchableContext BC){
    }  
}