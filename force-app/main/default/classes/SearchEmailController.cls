public class SearchEmailController {
    
    @AuraEnabled
    public static List<csvIngredientItem> findByEmail(String emailsearchKey) {
         List<csvIngredientItem> lstIngredients = new List<csvIngredientItem>(); 
        if(emailsearchKey!= null){
            Map<Id,Meal_Line_Item__c> mealIdsMap = new Map<Id,Meal_Line_Item__c>(); 
            for(Meal_Line_Item__c mlitem:[Select Id,Meal__c,EOrder__c,EOrder__r.Shipment_Date__c From Meal_Line_Item__c Where EOrder__r.Email_Address__c =:emailsearchKey and EOrder__r.Email_Address__c != null and Meal__c != null]){
                mealIdsMap.put(mlitem.Meal__c,mlitem);
            }   
            if(mealIdsMap.size() >0){
                for(Ingredient_Item__c ingItem:[select Id, Dish__r.Meal__c,RPT_Dish_Name__c,RPT_Meal_Name__c,Name,Amount__c,Amount_Unit__c,B12__c,B6__c,BetaCaro__c,Biot__c,Caff__c,Calc__c,Cals__c,Carb__c,Caroten__c,Chln__c,Chol__c,
                                                Chrom__c,Copp__c,Disacc__c,Dish__c,Fat__c,FatCals__c,Fiber__c,Fluor__c,Fol_DFE__c,Folate__c,Ingredient__c,Iodine__c,Iron__c,Is_Allergen__c,Magn__c,Mang__c,Meal_Name__c,Moly__c,MonoFat__c,
                                                MonSac__c,NiacEq__c,OCarb__c,Omega3__c,Omega6__c,Panto__c,Phos__c,PolyFat__c,Pot__c,Protein__c,Retinol__c,SatCals__c,SatFat__c,Sel__c,Sod__c,SolFib__c,Special_Instructions__c,Sub_Ingredients__c,
                                                SugAdd__c,Sugar__c,TotFib__c,TotSolFib__c,TransFat__c,Tyrosine__c,Vit_A_IU__c,Vit_A_RAE__c,Vit_B1__c,Vit_B12__c,Vit_B2__c,Vit_B3__c,Vit_B6__c,Vit_C__c,Vit_D_IU__c,Vit_D_mcg__c,Vit_E_a_Toco__c,Vit_K__c,Vit_NiacEq__c,
                                                Water__c,Wgt__c,Zinc__c,Active__c from Ingredient_Item__c where Dish__r.Meal__r.API_Enabled__c = TRUE  AND Dish__r.Meal__c In:mealIdsMap.keySet() and Start_Date__c <= TODAY and (End_Date__c = null OR End_Date__c >=TODAY)  Order By RPT_Dish_Name__c, RPT_Meal_Name__c]){
                    csvIngredientItem ingItemobj = new csvIngredientItem();
                    ingItemobj.ingredientItem = ingItem;
                    if(mealIdsMap.containsKey(ingItem.Dish__r.Meal__c)){
                        ingItemobj.shipmentDate = mealIdsMap.get(ingItem.Dish__r.Meal__c).EOrder__r.Shipment_Date__c;
                    }
                    lstIngredients.add(ingItemobj);
                } 
            }
        } 
        return lstIngredients;
    }
    
    public class csvIngredientItem{
        @AuraEnabled
        public Ingredient_Item__c ingredientItem = new Ingredient_Item__c();
        @AuraEnabled
        public Date shipmentDate;
    }
}