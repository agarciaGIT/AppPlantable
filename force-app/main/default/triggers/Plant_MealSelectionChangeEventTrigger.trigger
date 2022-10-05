trigger Plant_MealSelectionChangeEventTrigger on Plant_Meal_Selection__ChangeEvent (after insert) {
/*
    System.debug('!!!!Plant_Meal_Selection__ChangeEvent');
    
    // AG - Used for legacy data load - then can deactivate.
    MAP<String,Plant_Meal_Selection__ChangeEvent> mapMS = new MAP<String,Plant_Meal_Selection__ChangeEvent>();
    
    for(Plant_Meal_Selection__ChangeEvent event :Trigger.new){
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
    	List<String> ids = header.getRecordIds();    
        if (header.changetype == 'CREATE' && event.Plant_Make_Chef_Menu__c == TRUE) {
            mapMS.put(ids[0],event);
        }
    }
    System.debug('mapMS:' + mapMS);
    Plant_Orders_BC_Helper.mealSelectionChangeEventHandler(mapMS);
*/    
}