public class AG_Plant_Meals_BC {

    // Get Available Meals
    public static List<Meal__c> getAvailableMeals() {
        return [SELECT Name, Id, Description__c, Type__c, Cuisine__c, Calories_Per_Serving__c, Proteins__c, Image_URL__c, Allergens__c, Menu_Name__c, Inventory__c, Inventory_Sync__c, API_Enabled__c, Zipongo_Sampler__c, Dairy_Free__c, Gluten_Free__c, Nut_Free__c, Inventory_Sync_Off_Call__c, Low_Inventory_Alert_Date_Time__c, Sort_Rank__c, Soy_Free__c, Favorites__c, Status__c, Affiliate_Gift__c, Suggestic_ID__c, Shopify_ID__c FROM Meal__c WHERE Status__c='Active' AND Inventory__c>0  Limit 49999];
    }
    
    // Set Meals to Selection
    public static Plant_Meal_Selection__c setMealSelection(List<Meal__c> meals) {
        Plant_Meal_Selection__c ms;
        
        return ms;
    }
}