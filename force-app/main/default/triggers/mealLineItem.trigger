trigger mealLineItem on Meal_Line_Item__c (before update) {
    
    for(Integer i=0; i<trigger.new.size(); i++) {
        Meal_Line_Item__c obj = trigger.new[i];
        Meal_Line_Item__c objOld = trigger.old[i]; 
        
        System.debug('obj:' + obj);
        System.debug('objOld:' + objOld);
        
        if(obj.Enable_Inventory_Sync__c == true && obj.Meal__c != objOld.Meal__c) {
            Map<String,Integer> mapMeals = new Map<String,Integer>();
            mapMeals.put(objOld.Meal__c,Integer.valueOf(objOld.Quantity__c));
            mapMeals.put(obj.Meal__c,(Integer.valueOf(obj.Quantity__c)*-1));
            
            System.debug('mapMeals:' + mapMeals);
            
            shopifyClass.updateMealInventory(mapMeals, 0, True);
            
            obj.Enable_Inventory_Sync__c = False;
        }
    }

}