public class AG_Plant_Meals_CS {
    
    public class respGetAvailableMeals {
        public String status;
        public Integer statusCode;
        public String statusMessage;
        public List<Meal__c> meals;
    }

    public class respManageMealSelection {
        public String status;
        public Integer statusCode;
        public String statusMessage;
        public Plant_Meal_Selection__c mealSelection;
    }
    
    public static respGetAvailableMeals getAvailableMeals() {
        respGetAvailableMeals resp = new respGetAvailableMeals();
        
        List<Meal__c> lstMeals = AG_Plant_Meals_BC.getAvailableMeals();
        if(!lstMeals.isEmpty()) {
            resp.status = 'success';
            resp.statusCode = 200;
            resp.statusMessage = 'Completed Successfully';
            resp.meals = lstMeals;
        } else {
            resp.status = 'failure';
            resp.statusCode = 404;
            resp.statusMessage = 'No meals found';
        }
        
        return resp;
    }
    
    public static respManageMealSelection addMealsToSelection(String mealSelectionId, String mealId, Integer quantity) {
        respManageMealSelection rmms;
        
        return rmms;    
    }
    
}