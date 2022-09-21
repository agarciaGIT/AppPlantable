@RestResource(urlMapping='/ag-meals/*')
global class AG_Plant_RESTMeals {
    
    
    public class requestManageMealSelection {
        public String mealSelectionId;
        public String mealId;
        public String method;
        public Integer quantity;
    }
    
    @HttpPut  
    global static Void putMeals() { 
    
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        String clientId = RESTAuthController.verifyRequest(req);
        
        if(clientId != null || Test.isRunningTest()) {
            
            String rawJson = req.requestBody.toString();
        	requestManageMealSelection rmms = (requestManageMealSelection)JSON.deserialize(rawJson, requestManageMealSelection.class);
            
            if(rmms.method == 'Add' && rmms.quantity != NULL && rmms.mealSelectionId != NULL && rmms.mealId != NULL) {
                AG_Plant_Meals_CS.addMealsToSelection(rmms.mealSelectionId, rmms.mealId, rmms.quantity);
                
            } else if(rmms.method == 'Substract' && rmms.quantity != NULL && rmms.mealSelectionId != NULL && rmms.mealId != NULL) {
                
            } else if(rmms.method == 'Clear' && rmms.mealSelectionId != NULL) {
                
            } else if(rmms.method == 'Chef' && rmms.mealSelectionId != NULL) {
                
            } else {
                res.statusCode = 500;                
            }
            
        } else {
            res.statusCode = 401;
        }
    }
    
    @HttpGet  
    global static Void getMeals() {  
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        String clientId = RESTAuthController.verifyRequest(req);
        
        if(clientId != null || Test.isRunningTest()) {
            
            // Get meals
			AG_Plant_Meals_CS.respGetAvailableMeals resp = AG_Plant_Meals_CS.getAvailableMeals();
            
            // Return Response
			res.statusCode = resp.statusCode;
            String jsonBody = JSON.serialize(resp); 
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(jsonBody);
        } else {
            res.statusCode = 401;
        }
        
    }
}