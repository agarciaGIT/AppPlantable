trigger Plant_MealSelectionTrigger on Plant_Meal_Selection__c (after insert) {
    
    Set<String> mealSelIds = new Set<String>();
    for(Plant_Meal_Selection__c ms :Trigger.new){
        if (ms.Plant_Make_Chef_Menu__c == TRUE) {
            mealSelIds.add(ms.id);
        }
    }
    if(!mealSelIds.isEmpty()) {
        System.debug('mealSelIds:' + mealSelIds);
    	Plant_Orders_BC_Helper.mealSelectionChangeEventHandler(mealSelIds);
    }

}