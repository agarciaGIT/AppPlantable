public class studyMealsDownload {
    
    public List<Ingredient_Item__c> lstIngredients{get;set;}
    public String csvString {get;set;}
    
    public studyMealsDownload () {
        
        csvString='RPT_Dish_Name,RPT_Meal_Name,Ingredient Item Name,Amount,Amount Unit,Vit B12 (mcg),Vit B6 (mg),BetaCaro,Biot,Caff,Calc (mg),Cals (kcal),Carb (g),Caroten,Chln,Chol,Chrom,Copp,Disacc,Fat (g),FatCals,Fiber (g),Flour,Fol_DFE,Folate,Iodine,Iron (mg),Is_Allergen,Magn (mg),Mang,Meal_Name,Moly,MonoFat (g),MonSac,NiacEq,0Carb,Omega3,Omega6,Panto,Phos (mg),PolyFat (g),Pot (mg),Protein (g),Retinol,SatCals,SatFat (g),Sel,Sod (mg),SolFib,Special_Instructions,Sub_Ingredients,SugAdd,Sugar (g),TotFib,TotSolFib,TransFat,Tyrosine,Vit A-IU (IU),Vit A-RAE (mcg),Vit_B1,Vit_B12 (mcg),Vit_B2,Vit_B3,Vit_B6,Vit_C (mg),Vit_D_IU,Vit_D_mcg,Vit_E_a_Toco (mg),Vit_K,Vit_NiacEq,Water,Wgt (g),Zinc (mg)\n';
        lstIngredients = [select Id,RPT_Dish_Name__c,RPT_Meal_Name__c,Name,Amount__c,Amount_Unit__c,B12__c,B6__c,BetaCaro__c,Biot__c,Caff__c,Calc__c,Cals__c,Carb__c,Caroten__c,Chln__c,Chol__c,Chrom__c,Copp__c,Disacc__c,Dish__c,Fat__c,FatCals__c,Fiber__c,Fluor__c,Fol_DFE__c,Folate__c,Ingredient__c,Iodine__c,Iron__c,Is_Allergen__c,Magn__c,Mang__c,Meal_Name__c,Moly__c,MonoFat__c,MonSac__c,NiacEq__c,OCarb__c,Omega3__c,Omega6__c,Panto__c,Phos__c,PolyFat__c,Pot__c,Protein__c,Retinol__c,SatCals__c,SatFat__c,Sel__c,Sod__c,SolFib__c,Special_Instructions__c,Sub_Ingredients__c,SugAdd__c,Sugar__c,TotFib__c,TotSolFib__c,TransFat__c,Tyrosine__c,Vit_A_IU__c,Vit_A_RAE__c,Vit_B1__c,Vit_B12__c,Vit_B2__c,Vit_B3__c,Vit_B6__c,Vit_C__c,Vit_D_IU__c,Vit_D_mcg__c,Vit_E_a_Toco__c,Vit_K__c,Vit_NiacEq__c,Water__c,Wgt__c,Zinc__c  from Ingredient_Item__c where Dish__r.Meal__r.API_Enabled__c = TRUE Order By RPT_Dish_Name__c, RPT_Meal_Name__c limit 100];
        for(Ingredient_Item__c ing :lstIngredients) {
            csvString+=  removeCommas(ing.RPT_Dish_Name__c) + ',' + removeCommas(ing.RPT_Meal_Name__c) + ',' + ing.Name + ',' + formatNull(ing.Amount__c) + ',' + ing.Amount_Unit__c + ',' + formatNull(ing.B12__c) + ',' + formatNull(ing.B6__c) + ',' + formatNull(ing.BetaCaro__c) + ',' + formatNull(ing.Biot__c) + ',' + formatNull(ing.Caff__c) + ',' + formatNull(ing.Calc__c) + ',' + formatNull(ing.Cals__c) + ',' + formatNull(ing.Carb__c) + ',' + formatNull(ing.Caroten__c) + ',' + formatNull(ing.Chln__c) + ',' + formatNull(ing.Chol__c) + ',' + formatNull(ing.Chrom__c) + ',' + formatNull(ing.Copp__c) + ',' + formatNull(ing.Disacc__c) + ',' +  formatNull(ing.Fat__c) + ',' + formatNull(ing.FatCals__c) + ',' + formatNull(ing.Fiber__c) + ',' + formatNull(ing.Fluor__c) + ',' + formatNull(ing.Fol_DFE__c) + ',' + formatNull(ing.Folate__c) + ',' + formatNull(ing.Iodine__c) + ',' + formatNull(ing.Iron__c) + ',' + ing.Is_Allergen__c + ',' + formatNull(ing.Magn__c) + ',' + formatNull(ing.Mang__c) + ',' + removeCommas(ing.Meal_Name__c) + ',' + formatNull(ing.Moly__c) + ',' + formatNull(ing.MonoFat__c) + ',' + formatNull(ing.MonSac__c) + ',' + formatNull(ing.NiacEq__c) + ',' + formatNull(ing.OCarb__c) + ',' + formatNull(ing.Omega3__c) + ',' + formatNull(ing.Omega6__c) + ',' + formatNull(ing.Panto__c) + ',' + formatNull(ing.Phos__c) + ',' + formatNull(ing.PolyFat__c) + ',' + formatNull(ing.Pot__c) + ',' + formatNull(ing.Protein__c) + ',' + formatNull(ing.Retinol__c) + ',' + formatNull(ing.SatCals__c) + ',' + formatNull(ing.SatFat__c) + ',' + formatNull(ing.Sel__c) + ',' + formatNull(ing.Sod__c) + ',' + formatNull(ing.SolFib__c) + ',' + ing.Special_Instructions__c + ',' + removeCommas(ing.Sub_Ingredients__c) + ',' + formatNull(ing.SugAdd__c) + ',' + formatNull(ing.Sugar__c) + ',' + formatNull(ing.TotFib__c) + ',' + formatNull(ing.TotSolFib__c) + ',' + formatNull(ing.TransFat__c) + ',' + formatNull(ing.Tyrosine__c) + ',' + formatNull(ing.Vit_A_IU__c) + ',' + formatNull(ing.Vit_A_RAE__c) + ',' + formatNull(ing.Vit_B1__c) + ',' + formatNull(ing.Vit_B12__c) + ',' + formatNull(ing.Vit_B2__c) + ',' + formatNull(ing.Vit_B3__c) + ',' + formatNull(ing.Vit_B6__c) + ',' + formatNull(ing.Vit_C__c) + ',' + formatNull(ing.Vit_D_IU__c) + ',' + formatNull(ing.Vit_D_mcg__c) + ',' + formatNull(ing.Vit_E_a_Toco__c) + ',' + formatNull(ing.Vit_K__c) + ',' + formatNull(ing.Vit_NiacEq__c) + ',' + formatNull(ing.Water__c) + ',' + formatNull(ing.Wgt__c) + ',' + formatNull(ing.Zinc__c) +  '\n';
        }
        
    }
    public string removeCommas(string inString){
        if(inString == null){
            return '';
        }
        else{return inString.replaceAll(',', ' ');}
    }
    
    public string formatNull(decimal inDecimal){ 
        
        
        if (inDecimal == NULL){
            return '';
        }
        else{
            return String.valueOf(inDecimal);
        }
    }
}