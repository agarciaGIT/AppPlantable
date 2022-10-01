/*
*   @Desciption     :   Plantable Meals Business class, execute request in sf and return result
*   @Create date    :   04-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/

public  class Plant_Meals_BC {

    // Default constructor
    public Plant_Meals_BC() {

    }

     // @Method 0
    // desc:  Return list of available methods for this class
    public static Map<String,String> getClassDetail(){
        Map<String,String> metodsMap = new Map<String,String>();
        //string Name, String Type, String rtnType, String param, String detail
        metodsMap.put('getAllActiveMeals',Plant_Utility.setMethodEntry('getAvailableDates', 'get', 'Plant_Utility.responseWrapper','NONE', 'Return all active Meals records'));
        metodsMap.put('updateMealSelection',Plant_Utility.setMethodEntry('updateMealSelection', 'set', 'Plant_Utility.responseWrapper','MealSelectionReq_Wrapper wrapper object', 'Ad new meal list from Meal selection'));
        return metodsMap;
    }

    // ------------------------------------------------------------------------------------------------------------------------ // ** Default

    // @Method 1
    // desc:    Return all active Meals records
    public Plant_Utility.responseWrapper  getAllActiveMeals(){
       Map<Id, Meal__c> resultMeal_Map = new Map<Id, Meal__c>([SELECT Name, Id, Meal_Description__c, Nutritional_Label_Image_URL__c, Type__c, Cuisine__c, Calories_Per_Serving__c, Proteins__c, Image_URL__c, Allergens__c, Menu_Name__c, Inventory__c, Inventory_Sync__c, API_Enabled__c, Zipongo_Sampler__c, Dairy_Free__c, Gluten_Free__c, Nut_Free__c, Inventory_Sync_Off_Call__c, Low_Inventory_Alert_Date_Time__c, Sort_Rank__c, Soy_Free__c, Favorites__c, Status__c, Affiliate_Gift__c, Suggestic_ID__c, Shopify_ID__c FROM Meal__c WHERE Status__c='Active' AND Inventory__c>0  Limit 49999]);

       Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','List of available meal received',new Plant_Utility.responseListWrapper(resultMeal_Map.values()));
        return responseWrap;
    }

     // @Method 1.2
    // desc:    Return all active Meals records
    public Plant_Utility.responseWrapper  getIngredientDetail(String param_MealId){
        
        String statusCode='';
        String status='';
        String msg='';
        Map<Id, List<Dish__c>> meal_DishesList_Map = new Map<Id, List<Dish__c>>();
        
        if(param_MealId!=null){
                           
                 // String mealId='';
                if(param_MealId=='' || [SELECT Id from Meal__c where Id=:param_MealId].size()!=1){     
                    System.debug('####@@ reqWrap.mealId==> '+param_MealId);
                    System.debug('####@@ size==> '+[SELECT Id from Meal__c where Id=:param_MealId].size());
                    // Error Result
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','501','Invalid meal Id: '+param_MealId,new Plant_Utility.responseListWrapper(new List<String>()));
                    return responseWrap;
                }
                

                // iterate Dish & ingredient list
                for(Dish__c dis : [SELECT id, Meal__c, A_la_carte_Available__c, Meal_Name__c, Steps_to_Prepare__c, Vegan__c, Vegetarian__c, (SELECT Id, Name, B6__c, Dish__c, Ingredient__c, Special_Instructions__c, B12__c, Vit_B6__c, Vit_B12__c, SugAdd__c, Meal_Name__c, Fiber__c, Iron__c, Is_Allergen__c, RPT_Dish_Name__c, Meal_ID__c, RPT_Meal_Name__c, NiacEq__c, Sub_Ingredients__c, RPT_Meal_Name_ID__c, RPT_Dish__c, Active__c, Protein__c, Start_Date__c, End_Date__c, Tyrosine__c, Zinc__c, Amount_Unit__c, Amount__c, FatCals__c, SatCals__c, SolFib__c, MonSac__c, Disacc__c, OCarb__c, TransFat__c, Chol__c, Water__c, Caroten__c, Retinol__c, BetaCaro__c, Vit_B1__c, Vit_B2__c, Vit_B3__c, Vit_NiacEq__c, Biot__c, Vit_D_IU__c, Vit_D_mcg__c, Folate__c, Fol_DFE__c, Vit_K__c, Panto__c, Chrom__c, Copp__c, Fluor__c, Iodine__c, Mang__c, Moly__c, Sel__c, Omega3__c, Omega6__c, Alc__c, Caff__c, Chln__c, Calc__c, Cals__c, Carb__c, Fat__c, Magn__c, MonoFat__c, Phos__c, PolyFat__c, Pot__c, SatFat__c, Sod__c, Sugar__c, TotFib__c, TotSolFib__c, Vit_A_IU__c, Vit_A_RAE__c, Vit_C__c, Vit_E_a_Toco__c, Wgt__c FROM Ingredient_Item__r) FROM Dish__c WHERE Meal__c=:param_MealId AND Meal__c!=null]){
                    
                    if(!meal_DishesList_Map.containsKey(dis.Meal__c)){
                        List<Dish__c> newDishList = new List<Dish__c>();
                        newDishList.add(dis);
                        meal_DishesList_Map.put(dis.Meal__c,newDishList);
                    }
                    else {
                        meal_DishesList_Map.get(dis.Meal__c).add(dis);
                    }
                    
                }
                
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','List of available meal received',new Plant_Utility.responseListWrapper(meal_DishesList_Map.values()));
                return responseWrap;
                
            
        }
        else{
            // incorrect request body
            statusCode='503';
            status='error';
            msg='Service Unavailable';
        }
 
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(meal_DishesList_Map.values()));
        return responseWrap;
     }


    // @Method 2
    // desc:  add/Sub Meal in "Meal Selection" object
    // expeted JSON: 
    public Plant_Utility.responseWrapper updateMealSelection(MealSelectionReq_Wrapper reqWrap){
        List<Plant_Meal_Selection_Meal__c> updatedMeal_List = new List<Plant_Meal_Selection_Meal__c>();
        List<Object> resp_RecList = new List<Object>();
        String status='';
        String statusCode='';
        String msg='';

        try{            
            if(reqWrap.mealSelectionId!='' && reqWrap.mealSelectionId!=null){
                
                List<Plant_Meal_Selection_Meal__c> add_MealList = new List<Plant_Meal_Selection_Meal__c>();
                List<Plant_Meal_Selection_Meal__c> remove_MealList = new List<Plant_Meal_Selection_Meal__c>(); 

               // ~~ update meal selection logic ~~
                    // remove all meal selection meal(junction record) for meal selection
                    List<Plant_Meal_Selection_Meal__c> list_mealToRemove =  [SELECT id FROM Plant_Meal_Selection_Meal__c WHERE Plant_Meal_Selection__c=:reqWrap.mealSelectionId];
                    if(!list_mealToRemove.isEmpty()){
                        delete list_mealToRemove;
                    }
                    else {
                        // no meal to remove
                    }

                    // add new meal list to Meal selection
                        // iterate through mealList
                    for(Plant_Utility.wrapMeal mealRec : reqWrap.mealList){
                        Plant_Meal_Selection_Meal__c mealSm = new Plant_Meal_Selection_Meal__c();
                        mealSm.Plant_Meal_Selection__c = reqWrap.mealSelectionId;
                        mealSm.Plant_Meal__c = mealRec.mealId;
                        mealSm.Plant_Quantity__c= Integer.valueOf(mealRec.quantity);
                        updatedMeal_List.add(mealSm);
                    }

                    if(!updatedMeal_List.isEmpty()){
                        insert updatedMeal_List;
                        status = 'success';
                        statusCode='200';
                        msg='Meal added successfully!';
                    }
                    else {
                        // no meal to add
                        status = 'error';
                        statusCode='503';
                        msg='Meal added successfully!';
                        msg='No meal added, Please check meal list';
                    }

               
                
            }
            else{
                // NO MEAL SELECTION ID FOUND
                status = 'error';
                statusCode='503';
                msg='Service Unavailable: Meal Selection not found!';
            }

        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
        }
        
        // Final Result
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(updatedMeal_List));
        return responseWrap;
    }

    // @Method 3
    // desc:    Return all chefMeals records
    public Plant_Utility.responseWrapper  getChefMenu(){
        String status='';
        String statusCode='';
        String msg='';
        //Custom Settings Planatable Internal Account...
        Map<string, plantable_Constants__c> mapCustomSettings=plantable_Constants__c.getall();
        plantable_Constants__c CustomSetting=mapCustomSettings.get('DevConstant');
        List<Plant_Meal_Selection__c> chefMeal_List=new List<Plant_Meal_Selection__c>();
        if(CustomSetting != null){
        chefMeal_List=[Select id, (SELECT Plant_Meal__r.Name, Plant_Meal__r.Id, Plant_Meal__r.Meal_Description__c,
        Plant_Meal__r.Nutritional_Label_Image_URL__c, Plant_Meal__r.Type__c, Plant_Meal__r.Cuisine__c, Plant_Meal__r.Calories_Per_Serving__c,
        Plant_Meal__r.Proteins__c, Plant_Meal__r.Image_URL__c, Plant_Meal__r.Allergens__c, Plant_Meal__r.Menu_Name__c, Plant_Meal__r.Inventory__c, 
        Plant_Meal__r.Inventory_Sync__c, Plant_Meal__r.API_Enabled__c,
        Plant_Meal__r.Zipongo_Sampler__c, Plant_Meal__r.Dairy_Free__c, Plant_Meal__r.Gluten_Free__c, Plant_Meal__r.Nut_Free__c, Plant_Meal__r.Inventory_Sync_Off_Call__c, 
        Plant_Meal__r.Low_Inventory_Alert_Date_Time__c, Plant_Meal__r.Sort_Rank__c, Plant_Meal__r.Soy_Free__c, Plant_Meal__r.Favorites__c, Plant_Meal__r.Status__c, 
        Plant_Meal__r.Affiliate_Gift__c, Plant_Meal__r.Suggestic_ID__c, Plant_Meal__r.Shopify_ID__c FROM Meal_Selection_Meals__r  Limit 49999) 
           from Plant_Meal_Selection__c where Plant_Owner__c=:CustomSetting.Plantable_Internal_Account__c Limit 1];
           status='Success';
           statusCode='200';
           msg='List of chef meal received';
        }
        else {
            status='Error';
           statusCode='500';
           msg='No chef meals received';

        } 
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(chefMeal_List));
         return responseWrap;
     }

    // AG - Internal Methods
    public static List<Plant_Meal_Selection_Meal__c> cloneMealSelection(string mealSelectionId, String newMealSelId) {
        List<Plant_Meal_Selection_Meal__c> mealSelectionMeal_List;
        List<Plant_Meal_Selection__c> chefMeal_List=[Select id,(SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Plant_Meal_Selection__c, Plant_Meal__c, Plant_Quantity__c FROM Meal_Selection_Meals__r Limit 200), 
                                                     OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Plant_Description__c, Plant_Owner__c from Plant_Meal_Selection__c where id=:mealSelectionId];
        // Cloning Meal Selection Meal Item for the related Opportunity Meal
        if(!chefMeal_List.isEmpty() && !chefMeal_List[0].Meal_Selection_Meals__r.isEmpty()){
            
            mealSelectionMeal_List=new List<Plant_Meal_Selection_Meal__c>();
            for(Plant_Meal_Selection_Meal__c mealSelectionMeal:chefMeal_List[0].Meal_Selection_Meals__r){
                Plant_Meal_Selection_Meal__c SelectionMeal=new Plant_Meal_Selection_Meal__c();
                SelectionMeal = mealSelectionMeal.clone(false, true, false, false);
                SelectionMeal.Plant_Meal_Selection__c=newMealSelId;
                mealSelectionMeal_List.add(SelectionMeal);
            }
        }
        return mealSelectionMeal_List;
    }
    
    
    
    // @Wrapper(w) class
    // desc:  hold user input for iteration
    public class MealSelectionReq_Wrapper{
        public String mealSelectionId; // meal selection Id
        public Plant_Utility.wrapMeal[] mealList;

        //w Mehod 1
        //w desc:   parse and return wrapper object
        public MealSelectionReq_Wrapper parse(String json){
            return (MealSelectionReq_Wrapper)System.JSON.deserialize(json, MealSelectionReq_Wrapper.class);
        }
    }

     // @Wrapper(w) class: 2
    // desc:  return Meal List with Dish & Ingredient
    public class MealItems{
        public Meal__c mealRec; // meal selection Id
        public List<Dish__c> dishNd_Ingredient ;

        public MealItems(Meal__c mel, List<Dish__c> dihList){
            this.mealRec = mel;
            this.dishNd_Ingredient=dihList;
            
        }
    }

     // @Wrapper(w) class: 3
    // desc:  return Meal List with Dish & Ingredient
    public class autorize_MealReq{
        public String mealId; // meal selection Id
        //public String authenticationToken;

        public autorize_MealReq parse(String json_po){
            return (autorize_MealReq)JSON.deserialize(json_po, autorize_MealReq.class);
        }
    }
}