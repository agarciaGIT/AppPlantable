/*
*   @Desciption     :   Plantable Meals API class
*   @Create date    :   21-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Test class     :   
*/

@RestResource(urlMapping='/v1/meals/*')
global class Plant_RESTMeals {
    // @ constructor
    global Plant_RESTMeals() {
        
    }
    
    // # Get:1
    @HttpGet  
    global static void getActivMeals() {  
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;  
        res.addHeader('Content-Type', 'application/json');
        
        try{
            String reqResource_endString = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            if(reqResource_endString=='list'){
                System.debug('######@@ Meal List endpoint');
                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_Meals_SC.getMealList();
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## success');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## error');
                }   
                
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            else if(reqResource_endString=='chefmenu'){
                System.debug('######@@ chefmenu endpoint');
                // call get meal service class method
                Plant_Utility.responseWrapper respWrap = Plant_Meals_SC.getChefMenu_SC();
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## success');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## error');
                }   
                
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            else if(reqResource_endString=='ingredients'){
                System.debug('######@@ ingredients endpoint');
                
                String param_mealId = req.params.get('mealId');
                System.debug('@@@@@## PARAMERER => '+param_mealId);
                
                if(!String.isBlank(param_mealId)){
                    Plant_Utility.responseWrapper respWrap = Plant_Meals_SC.getIngredientDetails(param_mealId);
                    if(respWrap.statusCode=='200'){
                        res.statusCode = Integer.valueOf(respWrap.statusCode);
                        System.debug('@@@@## success ingredient ');
                    }
                    else{
                        res.statusCode = Integer.valueOf(respWrap.statusCode);
                        System.debug('@@@@## error ingred');
                    }   
                    
                    String jsonRespBody = JSON.serialize(respWrap); 
                    res.responseBody = Blob.valueOf(jsonRespBody);
                }
            }
            else{
                Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500','Service not found! Invalid endpoint',new Plant_Utility.responseListWrapper(new List<String>()));
                res.statusCode = 500;
                String jsonErrRespBody = JSON.serialize(respWrapErr); 
                res.responseBody = Blob.valueOf(jsonErrRespBody);
            }
            
        }
        catch(Exception ex){
            System.debug('@@@@@@ exception encounter => '+ex+' MSG: '+ex.getMessage()+' LINE: '+ex.getLineNumber()+' CAUSE: '+ex.getCause());
            Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500',ex.getMessage(),new Plant_Utility.responseListWrapper(new List<String>()));
            res.statusCode = 500;
            String jsonErrRespBody = JSON.serialize(respWrapErr); 
            res.responseBody = Blob.valueOf(jsonErrRespBody);
        }              
    }
    
    // # Set: 1
    /*
    @HttpPost
    global static void setMealSelection() {  
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;  
        res.addHeader('Content-Type', 'application/json');
        
        try{
            String reqResource_endString = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            if(reqResource_endString=='MealSelection'){
                String mealJson = req.requestBody.toString();
                Plant_Meals_BC.MealSelectionReq_Wrapper reqWrapper = new Plant_Meals_BC.MealSelectionReq_Wrapper().parse(mealJson);
                System.debug('@@@@# REQUEST JSON BODY: '+mealJson);
                System.debug('@@@@# REQUEST wrapper BODY: '+reqWrapper);
                
                // call service class method
                Plant_Utility.responseWrapper respWrap = Plant_Meals_SC.setMealSelection(reqWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## success');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## error');
                }   
                
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody);  
            }
            else if(reqResource_endString=='getingredients'){
                System.debug('######@@ Ingredient endpoitn');
          
                String mealJson = req.requestBody.toString();
                System.debug('@@@@@## PARAMERER => '+mealJson);
                
                Plant_Meals_BC.autorize_MealReq reqWrapper = new Plant_Meals_BC.autorize_MealReq().parse(mealJson);
                Plant_Utility.responseWrapper respWrap = Plant_Meals_SC.getIngredientDetails(reqWrapper);
                if(respWrap.statusCode=='200'){
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## success ingredient ');
                }
                else{
                    res.statusCode = Integer.valueOf(respWrap.statusCode);
                    System.debug('@@@@## error ingred');
                }   
                
                String jsonRespBody = JSON.serialize(respWrap); 
                res.responseBody = Blob.valueOf(jsonRespBody); 
            }
            else{
                Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500','Service not found! Invalid endpoint',new Plant_Utility.responseListWrapper(new List<String>()));
                res.statusCode = 500;
                String jsonErrRespBody = JSON.serialize(respWrapErr); 
                res.responseBody = Blob.valueOf(jsonErrRespBody);
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@ exception encounter => '+ex+' MSG: '+ex.getMessage()+' LINE: '+ex.getLineNumber()+' CAUSE: '+ex.getCause());
            Plant_Utility.responseWrapper respWrapErr = new Plant_Utility.responseWrapper('error','500',ex.getMessage(),new Plant_Utility.responseListWrapper(new List<String>()));
            res.statusCode = 500;
            String jsonErrRespBody = JSON.serialize(respWrapErr); 
            res.responseBody = Blob.valueOf(jsonErrRespBody);
        } 
        
    }
*/
}