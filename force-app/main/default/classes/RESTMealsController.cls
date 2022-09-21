@RestResource(urlMapping='/meals/*')
global class RESTMealsController {
    
    
    public class respMealItem {
        String meal_name;
        String meal_id;
        Integer quantity;
    }
    
    public class respMeals {
        Integer status_code;
        String status_message;
        String customer_id;
		String customer_email;
        List<respMealItem> meals;
    }
    
    public static respMeals processGETRequest(RestRequest req) {
        respMeals rm = new respMeals();
        rm.status_code = 404;
        
        System.debug('processGETRequest:' + req.requestURI);
        
        String userEmail = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug('userEmail:' + userEmail);
        
        if(userEmail != null) {        
            rm.status_code = 0;
            rm.customer_email = userEmail;
            
            Date tdy = Date.today();
            Date lastMonth = Date.newInstance(tdy.year(), tdy.month()-1, tdy.day());
            System.debug('lastMonth:' + lastMonth);
            
            List<Opportunity> lstOpp = [select ID, AccountID from Opportunity where Email_Address__c = :userEmail AND StageName = 'Closed Won' and CloseDate > :lastMonth Order By CloseDate DESC];
            System.debug('lstOpp:' + lstOpp);
            
            if(lstOpp != NULL && lstOpp.size() > 0) {
                Opportunity opp = lstOpp[0];
                rm.customer_id = opp.AccountId;
                
                List<Meal_Line_Item__c> lstMeals = [select Id, Meal_Name__c, Quantity__c, Shopify_ID__c from Meal_Line_Item__c where EOrder__c = :opp.Id];
                System.debug('lstMeals:' + lstMeals);
                
                if(lstMeals != NULL && lstMeals.size() > 0) {
                    rm.meals = new List<respMealItem>();
                    
                    for(Meal_Line_Item__c mli :lstMeals) {
                        respMealItem rmi = new respMealItem();
                        rmi.meal_name = mli.Meal_Name__c;
                        rmi.meal_id = mli.Shopify_ID__c;
                        rmi.quantity = Integer.valueOf(mli.Quantity__c);
                        
                        System.debug('add meal:' + rmi);
                        
                        rm.meals.add(rmi);
                    }
                }
            }

            
		} else {
            rm.status_code = 503;
            rm.status_message = 'Email Missing';                
        }        
        
        return rm;
    }
    
    @HttpGet  
    global static Void getMeals() {      

        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
		String clientId = RESTAuthController.verifyRequest(req);
        
        if(clientId != null || Test.isRunningTest()) {
            respMeals rm = processGETRequest(req);
            String jsonBody = JSON.serialize(rm); 
            if(rm.status_code != 0) {
                 res.statusCode = rm.status_code;
            } else {
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(jsonBody);
	            res.statusCode = 200;            
            }
        } else {
            res.statusCode = 401;
        }
    }        

}