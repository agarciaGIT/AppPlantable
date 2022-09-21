public without sharing class mealPickerController  {
    
    @auraEnabled public List<Meal__c> lstMealsData {get;set;}
    @auraEnabled public List<Meal_Line_Item__c> lstMealItems {get;set;}
    @auraEnabled public Map<String, Meal_Line_Item__c> mapMealItems {get;set;}
    @auraEnabled public Map<String, Meal__c> mapMeals {get;set;}
    @auraEnabled public Decimal totalItems {get;set;}
    @auraEnabled public String orderId {get;set;}    
    @auraEnabled public Opportunity opp {get;set;}    
    @auraEnabled public Meal__c selectedMeal {get;set;}
    
    @AuraEnabled
    public static mealPickerController submitMeals(String inObj) {
        
        mealPickerController obj = (mealPickerController)JSON.deserialize(inObj, mealPickerController.class); 
        
        System.debug('obj:' + obj);

        List<Meal_Line_Item__c> lstMealItems = [Select Id, Name, EOrder__c, Meal__c, Quantity__c, Meal_Name__c, Shopify_ID__c from Meal_Line_Item__c where EOrder__c = :obj.orderId];
        System.debug('Remove Meals lstMealItems:' + lstMealItems);
            
        // Remove Meals From Order
        Map<Id,Decimal> mapMeals = new Map<Id,Decimal>();
        for(Meal_Line_Item__c mli :lstMealItems) {
            mapMeals.put(mli.Meal__c,mli.Quantity__c);
        }
        System.debug('mapMeals:' + mapMeals);
        
        // Remove Items from Order
        delete lstMealItems;
        
        // Add Meals to Order
        for(Meal_Line_Item__c mli :obj.lstMealItems) {
            // Blank out ID to insert
            mli.Id = null;
            Decimal getMeal = mapMeals.get(mli.Meal__c);
            if(getMeal != NULL) {
                System.debug('found getMeal:' + getMeal);
                getMeal = getMeal - mli.Quantity__c;
                System.debug('update getMeal:' + getMeal);
                mapMeals.put(mli.Meal__c, getMeal);
            } else {
                mapMeals.put(mli.Meal__c,(mli.Quantity__c*-1));
            }
        }
        System.debug('mapMeals:' + mapMeals);
        
        List<Meal__c> lstUpdateMeals = [Select Id, Name, Inventory__c, Inventory_Sync__c from Meal__c where Id in :mapMeals.keySet()];
        System.debug('lstUpdateMeals:' + lstUpdateMeals);
        
        // Remove meals from inventory
        for(Meal__c mo :lstUpdateMeals) {
            Decimal getQuantity = mapMeals.get(mo.Id);
            if(getQuantity != NULL && getQuantity != 0 && mo.Inventory__c != NULL) {
                mo.Inventory__c += getQuantity;
                mo.Inventory_Sync__c = True;
            }
        }
        System.debug('lstUpdateMeals after Update:' + lstUpdateMeals);
        update lstUpdateMeals;
        
        // Add meals to order
        insert obj.lstMealItems;
        
        // Update Order to Custom
        List<Opportunity> lstOpp = [Select Id, Is_Custom__c from Opportunity where id=:obj.orderId AND Is_Custom__c = False];
        if(lstOpp != NULL && lstOpp.size() > 0) {
            lstOpp[0].Is_Custom__c = True;
            update lstOpp;
        }
        
        List<Shipment__c> lstShip = [select Id, Box_Type__c from Shipment__c where Opportunity__c = :obj.orderId];
        if(lstShip != NULL && lstShip.size() > 0) {
            lstShip[0].Box_Type__c = 'Custom';
            update lstShip;
        }
        
        
        return obj;
    }    
    
    public static mealPickerController mapItemsToList(mealPickerController obj) {
        obj.totalItems=0;
        obj.lstMealItems = new List<Meal_Line_Item__c>();
        
        System.debug('mapItemsToList: ' + obj.mapMealItems);
        
        for(Meal_Line_Item__c mi : obj.mapMealItems.values()) {
            obj.lstMealItems.add(mi);
            obj.totalItems+=mi.Quantity__c;
        }

        System.debug('lstMealItems: ' + obj.mapMealItems);
        System.debug('totalItems: ' + obj.totalItems);

        return obj;
    }    
    
    @AuraEnabled
    public static mealPickerController initClass(String inOrderId, String accessCode, Boolean useOrderNumber) {
        
        System.debug('inOrderId:' + inOrderId);
        System.debug('accessCode:' + accessCode);

        mealPickerController obj = new mealPickerController();
        
        if(accessCode != NULL) {
            
            List<Opportunity> lstEOrders;
            if(useOrderNumber == True) {
                lstEOrders = [select Id, First_Name__c, Last_Name__c, Ship_Date__c from Opportunity where External_Order_Number__c = :accessCode Order BY CreatedDate DESC];
            } else {
                lstEOrders = [select Id, First_Name__c, Last_Name__c, Ship_Date__c from Opportunity where AccountId in (select Id from Account where Study_Access_Key__c = :accessCode) Order BY CreatedDate DESC];
            }
            System.debug('lstEOrders:' + lstEOrders);
            
            if(lstEOrders != NULL && lstEOrders.size() > 0) {
                if(lstEOrders[0].Ship_Date__c != NULL && lstEOrders[0].Ship_Date__c > Date.today()) {
                    obj.opp = lstEOrders[0];
                    inOrderId = lstEOrders[0].id;
                }
            }
            
        } else if(inOrderId != NULL) {
            List<Opportunity> lstEOrders = [select Id, First_Name__c, Last_Name__c from Opportunity where Id = :inOrderId];
            if(lstEOrders != NULL && lstEOrders.size() > 0) {
                obj.opp = lstEOrders[0];
            }
        }
        System.debug('obj.opp:' + obj.opp);
        
        obj.orderId = inOrderId;
        
        List<Meal__c> lstMeals = [select Id, Name, Inventory__c, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c, Dairy_Free__c, Gluten_Free__c, Nut_Free__c, Soy_Free__c from Meal__c where Status__c = 'Active' AND API_Enabled__c = True AND Inventory__c > 0 Order By Name];
        obj.lstMealsData = new List<Meal__c>();
        for(Meal__c m :lstMeals) {
            if(m.Allergens__c != NULL) {
                m.Allergens__c = m.Allergens__c.Replace(';',', ');
            }
            if(m.Type__c == 'Lunch') {
                obj.lstMealsData.add(m);
            }
        }
        for(Meal__c m :lstMeals) {
            if(m.Allergens__c != NULL) {
                m.Allergens__c = m.Allergens__c.Replace(';',', ');
            }
            if(m.Type__c == 'Dinner') {
                obj.lstMealsData.add(m);
            }
        }

        obj.mapMeals = new Map<String, Meal__c>();
        for(Meal__c m :lstMeals) {
            obj.mapMeals.put(m.Id,m);
        }
        
        List<Ingredient_Item__c> lstIng = [select Id, Name, Sub_Ingredients__c, Amount__c, Amount_Unit__c, Wgt__c, Cals__c, Meal_ID__c FROM Ingredient_Item__c where Meal_ID__c in :obj.mapMeals.keySet() Order By Wgt__c Desc];
        for(Ingredient_Item__c ii :lstIng) {
            Meal__c fndMeal = obj.mapMeals.get(ii.Meal_ID__c);
            if(fndMeal != NULL) {
                String ing = ii.Name;
                if(ii.Sub_Ingredients__c != NULL) {
                    ing = ii.Name + ' (' + ii.Sub_Ingredients__c + ')';
                }
                
                if(fndMeal.Description__c == null) {
                    fndMeal.Description__c = ing;
                } else {
                    fndMeal.Description__c += ', '+ ing;
                }
                
                if(fndMeal.Calories_Per_Serving__c == null) {
                    fndMeal.Calories_Per_Serving__c = ii.Cals__c;
                } else if(ii.Cals__c != NULL) {
                    fndMeal.Calories_Per_Serving__c += ii.Cals__c;
                }
            }
            obj.mapMeals.put(fndMeal.Id,fndMeal);
        }
        
        List<Meal_Line_Item__c> lstMealItems = [Select Id, Name, EOrder__c, Meal__c, Quantity__c, Meal_Name__c, Shopify_ID__c from Meal_Line_Item__c where EOrder__c = :inOrderId];
        obj.lstMealItems = lstMealItems;

        obj.totalItems=0;
        obj.mapMealItems = new Map<String, Meal_Line_Item__c>();
        for(Meal_Line_Item__c mi :lstMealItems) {
            obj.mapMealItems.put(mi.Meal__c,mi);
            obj.totalItems+=mi.Quantity__c;
        }
        
        return obj;
    }


    @AuraEnabled
    public static mealPickerController removeBoxItems(String inObj) {
        
        mealPickerController obj = (mealPickerController)JSON.deserialize(inObj, mealPickerController.class); 
        System.debug('obj removeboxitems:' + obj);
        
        obj.lstMealItems = new List<Meal_Line_Item__c>();
        obj.mapMealItems = new Map<String, Meal_Line_Item__c>();
        obj.totalItems=0;
        
        /*
        List<Meal_Line_Item__c> lstMLI = [select Id, Meal__c FROM Meal_Line_Item__c where Id in :obj.lstMealItems];
        System.debug('lstMLI:' + lstMLI);
        for(Meal_Line_Item__c mi :lstMLI){
            obj = removeCartItem(mi.Meal__c, inObj);
            inObj = JSON.serialize(obj);
        }
        */
        return obj;                
    }        
    
    @AuraEnabled
    public static mealPickerController removeCartItem(String itemId, String inObj) {
        
        mealPickerController obj = (mealPickerController)JSON.deserialize(inObj, mealPickerController.class); 
        
        System.debug('remove itemId:' + itemId);
        System.debug('obj:' + obj);
        
        Meal_Line_Item__c fndItem = obj.mapMealItems.get(itemId);
        System.debug('fndItem:' + fndItem);
        
        if(fndItem != NULL) {
            obj.mapMealItems.remove(itemId);
        }
        obj = mapItemsToList(obj);
        return obj;                
    }        
    
    @AuraEnabled
    public static mealPickerController decrementCartItem(String itemId, String inObj) {
        
        mealPickerController obj = (mealPickerController)JSON.deserialize(inObj, mealPickerController.class);         
        
        System.debug('itemId:' + itemId);
        System.debug('obj:' + obj);
        
        Meal_Line_Item__c fndItem = obj.mapMealItems.get(itemId);
        System.debug('fndItem:' + fndItem);
        
        if(fndItem != NULL) {
            if(fndItem.Quantity__c == 1) {
                obj.mapMealItems.remove(itemId);
            } else {
                fndItem.Quantity__c--;
                obj.mapMealItems.put(itemId,fndItem);
            }
        }
        obj = mapItemsToList(obj);
        return obj;                
    }        
    
    @AuraEnabled
    public static mealPickerController incrementCartItem(String itemId, String inObj) {

        mealPickerController obj = (mealPickerController)JSON.deserialize(inObj, mealPickerController.class); 
        
        System.debug('itemId:' + itemId);
        System.debug('obj:' + obj);
        
        Decimal totCnt=0;
        for(Meal_Line_Item__c mi :obj.mapMealItems.values()) {
            totCnt+=mi.Quantity__c;
        }
        System.debug('totCnt:' + totCnt);

        if(totCnt == 12) {
            return obj;
        }
        
        Meal_Line_Item__c fndItem = obj.mapMealItems.get(itemId);
        System.debug('fndItem:' + fndItem);
        
        if(fndItem != NULL) {
            fndItem.Quantity__c++;
            obj.mapMealItems.put(itemId,fndItem);
            System.debug('Add to existing:' + fndItem);

        } else {
            Meal__c fndMeal = obj.mapMeals.get(itemId);
            System.debug('fndMeal:' + fndMeal);
            
            if(fndMeal != NULL) {
                Meal_Line_Item__c newMealItem = new Meal_Line_Item__c();
                newMealItem.Meal__c = itemId;
                newMealItem.Quantity__c = 1;
                newMealItem.Name = fndMeal.Name;
                newMealItem.EOrder__c = obj.orderId;
                obj.lstMealItems.add(newMealItem);
                obj.mapMealItems.put(itemId,newMealItem);
                
                System.debug('Add new:' + newMealItem);                
            }
        }
        obj = mapItemsToList(obj);        
        return obj;        
    }    
    
}