@RestResource(urlMapping='/products/*')
global class RESTProductsController {
    
    public class respProductDetailItem {
        String meal_id;
        String meal_name;
        List<String> allergens;
        Decimal calories_per_serving;
        String cuisine;        
        String description;        
        String image;        
        List<String> proteins;    
        String type;
        respProductItemNutrition nutrition;
    }

    public class respIngredientItem {
        String name;
    }
    
    public class respMealProductDetailIngredientItem {
        String name;
        Decimal wgt;
        List<respIngredientItem> ingredients;
    }
    
    public class respMealProductDetailItem {
        List<String> allergens;
        Decimal calories_per_serving;
        String cuisine;        
        List<String> proteins;    
        String type;
        respProductItemNutrition nutrition;
        List<respMealProductDetailIngredientItem> ingredients_details;
        List<String> ingredients;
    }
    
    public class respMealProductItem {
        String code;
        String name;
        String description;
        Decimal price;
        Integer quanity_in_stock;
        String image;
        String type;
        Decimal minimum_quantity;
        respMealProductDetailItem details;
    }
        
    public class respProductItem {
        String code;
        String name;
        String description;
        Decimal price;
        Integer quanity_in_stock;
        String image;
        String type;
        Decimal minimum_quantity;
        List<respProductDetailItem> details;
    }

    public class respProductItemNutrition {
        Decimal b12;
        Decimal b6;
        Decimal calories;
        Decimal calcium;
        Decimal carbohydrates;
        Decimal fat;
        Decimal fiber;
        Decimal iron;
        Decimal magnesium;
        Decimal monounsaturated_fat;
        Decimal niaceq;
        Decimal phosphorus;
        Decimal polyunsaturated_fat;
        Decimal potassium;
        Decimal protein;
        Decimal saturated_fat;
        Decimal sodium;
        Decimal sugar;
        //Decimal tyrosine;
        Decimal vitamin_a_iu;
        Decimal vitamin_a_rae;
        Decimal vitamin_c;
        Decimal vitamin_e;
        Decimal weight;
        Decimal zinc;
    }
    
    public class respNutritionUnits {
        String name;
        String unit;
    }
    
    public class respProducts {
        Integer status_code;
        List<respNutritionUnits> units;
        List<respMealProductItem> products;
        
    }
    
    
    public static List<String> multiPickToListString(String strIn) {
        List<String> outArr = new List<String>();
        if(strIn != NULL)
            return strIn.split(';');
        else return outArr;
    }
    
    public static Decimal adddIngItem(Decimal orgVal, Decimal addVal) {
        if(orgVal != null && addVal != NULL) {
            return orgVal + addVal;
        } else if(orgVal == NULL && addVal != NULL) {
            return addVal;
        } else if(orgVal != NULL && addVal == NULL) {
            return orgVal;
        } 
        return 0;
    }
    
    public static respProducts processRequest(String strRoute) {
        
        String ZPProd = 'ZPEALC';        
        if(strRoute == 'sampler') {
            ZPProd = 'ZPSAM'; 
        }
        List<Product2> lstProd = [select Id, Name, Minimum_Meals__c from Product2 where ProductCode = :ZPProd];
        
        System.debug('lstProd:' + lstProd);
        
        List<PricebookEntry> lstPbe = [Select  Id, Name, Unitprice, Product2Id From PricebookEntry Where Product2Id in :lstProd];
        
        System.debug('lstPbe:' + lstPbe);
        
        MAP<String, Decimal> mapPrice = new MAP<String, Decimal>();
        for(PricebookEntry pbe :lstPbe) {
            mapPrice.put(pbe.Product2Id, pbe.UnitPrice);
        }
        
        System.debug('mapPrice:' + mapPrice);
        
        List<Meal__c> lstMeal;
        if(strRoute == 'sampler') {
	        lstMeal = [select Id, Name, Inventory__c, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where Zipongo_Sampler__c = True];
        } else {
			lstMeal = [select Id, Name, Inventory__c, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where API_Enabled__c = True];            
        }
        System.debug('lstMeal:' + lstMeal);
        
        MAP<String, Meal__c> mapMeal = new MAP<String, Meal__c>();
        for(Meal__c m :lstMeal) {
            mapMeal.put(m.Id, m);
        }
        
        List<Dish__c> lstDishes = [select Id, Meal__c from Dish__c where Meal__c in :mapMeal.KeySet()];
        MAP<String, String> mapDish = new MAP<String, String>();
        for(Dish__c d :lstDishes ) {
            mapDish.put(d.Id, d.Meal__c );
        }
        
        List<Ingredient_Item__c> lstIng = [select Id, Name, Sub_Ingredients__c, Alc__c, Amount__c, Amount_Unit__c, BetaCaro__c, Biot__c, Caff__c, Calc__c, Cals__c, Carb__c, Caroten__c, Chln__c, Chol__c, Chrom__c, Copp__c, Disacc__c, Dish__c, Fat__c, FatCals__c, Fluor__c, Fol_DFE__c, Folate__c, Ingredient__c, Iodine__c, Iron__c, Is_Allergen__c, Magn__c, Mang__c, Meal_ID__c, Moly__c, MonoFat__c, MonSac__c, NiacEq__c, OCarb__c, Omega3__c, Omega6__c, Panto__c, Phos__c, PolyFat__c, Pot__c, Protein__c, Retinol__c, SatCals__c, SatFat__c, Sel__c, Sod__c, Special_Instructions__c, Sugar__c, TotFib__c, TotSolFib__c, TransFat__c, Tyrosine__c, Vit_A_IU__c, Vit_A_RAE__c, Vit_B1__c, Vit_B2__c, Vit_B3__c, Vit_B6__c, Vit_B12__c, Vit_C__c, Vit_D_IU__c, Vit_D_mcg__c, Vit_E_a_Toco__c, Vit_K__c, Vit_NiacEq__c, Water__c, Wgt__c, Zinc__c FROM Ingredient_Item__c where Meal_ID__c in :mapMeal.keySet() Order By Wgt__c Desc];

        MAP<String,MAP<String,Decimal>> mapIng = new MAP<String,MAP<String,Decimal>>();
        MAP<String,LIST<String>> mapAlg = new MAP<String,LIST<String>>();
        MAP<String,LIST<String>> mapPro = new MAP<String,LIST<String>>();
        MAP<String,Decimal> mapCals = new MAP<String,Decimal>();
     
        for(Ingredient_Item__c ing :lstIng) {
            
            system.debug('***ing:' + ing);

            Decimal fndCals = mapCals.get(ing.Meal_ID__c);
            if(ing.Cals__c != null) {
                if(fndCals == NULL) {
                    mapCals.put(ing.Meal_ID__c, ing.Cals__c);
                } else {
                    mapCals.put(ing.Meal_ID__c, fndCals + ing.Cals__c);
                }
            }
            
            String ingName = ing.Name;
            if(ing.Sub_Ingredients__c != NULL) {
                ingName = ingName + '~' + ing.Sub_Ingredients__c;
            }
            
            MAP<String,Decimal> fndIng = mapIng.get(ing.Meal_ID__c);
            if(fndIng == NULL) {
                MAP<String,Decimal> newIng = new MAP<String,Decimal>();
                newIng.put(ingName,ing.Wgt__c);
                mapIng.put(ing.Meal_ID__c, newIng);

            } else {
                
                Decimal fndWgt = fndIng.get(ingName);
                if(fndWgt == NULL) {
                    fndIng.put(ingName,ing.Wgt__c);
                } else {
                    Decimal newWgt = fndWgt + ing.Wgt__c;
                    fndIng.put(ingName,newWgt);
                }
                mapIng.put(ing.Meal_ID__c, fndIng);
            }
            
            //if(ing.Sub_Ingredients__c != NULL) {
            //    List<String> subIng = ing.Sub_Ingredients__c.Split(',');
            //    for(String sing :subIng) {
            //        fndIng.add(sing);
            //    }
            //    mapIng.put(ing.Meal_ID__c, fndIng);
            //}

        	List<String> fndIngStr = new List<String>();
            fndIngStr = mapPro.get(ing.Meal_ID__c);
            if(fndIngStr == NULL) {
                List<String> newIng = new List<String>();
                if(ing.Protein__c > 3) {
                    newIng.add(ing.Name);
                }
                mapPro.put(ing.Meal_ID__c, newIng);
            } else {
                if(ing.Protein__c > 3) {
                    fndIngStr.add(ing.Name);
                    mapPro.put(ing.Meal_ID__c, fndIngStr);
                }
           }

            
            fndIngStr = mapAlg.get(ing.Meal_ID__c);
            if(fndIngStr == NULL) {
                List<String> newIng = new List<String>();
                if(ing.Is_Allergen__c == True) {
                    newIng.add(ing.Name);
                }
                mapAlg.put(ing.Meal_ID__c, newIng);
            } else {
                if(ing.Is_Allergen__c == True) {
                    fndIngStr.add(ing.Name);
                    mapAlg.put(ing.Meal_ID__c, fndIngStr);
                }                
            }
        }

        AggregateResult[] groupedResults
          = [select Dish__c, SUM(Alc__c), SUM(BetaCaro__c), SUM(Biot__c), SUM(Caff__c), SUM(Calc__c), SUM(Cals__c), SUM(Carb__c), SUM(Caroten__c), SUM(Chln__c), SUM(Chol__c), SUM(Chrom__c), SUM(Copp__c), SUM(Disacc__c), SUM(Fat__c), SUM(FatCals__c), SUM(Fluor__c), SUM(Fol_DFE__c), SUM(Folate__c), SUM(Iodine__c), SUM(Iron__c), SUM(Magn__c), SUM(Mang__c), SUM(Moly__c), SUM(MonoFat__c), SUM(MonSac__c), SUM(NiacEq__c), SUM(OCarb__c), SUM(Omega3__c), SUM(Omega6__c), SUM(Panto__c), SUM(Phos__c), SUM(PolyFat__c), SUM(Pot__c), SUM(Protein__c), SUM(Retinol__c), SUM(SatCals__c), SUM(SatFat__c), SUM(Sel__c), SUM(Sod__c), SUM(Sugar__c), SUM(TotFib__c), SUM(TotSolFib__c), SUM(TransFat__c), SUM(Tyrosine__c), SUM(Vit_A_IU__c), SUM(Vit_A_RAE__c), SUM(Vit_B1__c), SUM(Vit_B2__c), SUM(Vit_B3__c), SUM(Vit_B6__c), SUM(Vit_B12__c), SUM(Vit_C__c), SUM(Vit_D_IU__c), SUM(Vit_D_mcg__c), SUM(Vit_E_a_Toco__c), SUM(Vit_K__c), SUM(Vit_NiacEq__c), SUM(Water__c), SUM(Wgt__c), SUM(Zinc__c) from Ingredient_Item__c where Meal_ID__c in :mapMeal.keySet() GROUP BY Dish__c];
          
        //for (AggregateResult ar : groupedResults)  {
        //    System.debug('Dish__c' + ar.get('Dish__c'));
        //    System.debug('Average amount' + ar.get('expr4'));
        //}
        //System.debug('groupedResults:' + groupedResults);
        
        
        MAP<String, Ingredient_Item__c> mapIngredient = new MAP<String, Ingredient_Item__c>();
        
        for (AggregateResult ar : groupedResults)  {
        
            String dishId = (String)ar.get('Dish__c');
            String mealId = mapDish.get(dishId);
        
            Ingredient_Item__c fndIngItem = mapIngredient.get(mealId);
            if(fndIngItem == NULL) {
                
                Ingredient_Item__c i = new Ingredient_Item__c();
                
                i.Alc__c = adddIngItem((Decimal)ar.get('expr0'), NULL);
                i.BetaCaro__c = adddIngItem((Decimal)ar.get('expr1'), NULL);
                i.Biot__c = adddIngItem((Decimal)ar.get('expr2'), NULL);
                i.Caff__c = adddIngItem((Decimal)ar.get('expr3'), NULL);
                i.Calc__c = adddIngItem((Decimal)ar.get('expr4'), NULL);
                i.Cals__c = adddIngItem((Decimal)ar.get('expr5'), NULL);
                i.Carb__c = adddIngItem((Decimal)ar.get('expr6'), NULL);
                i.Caroten__c = adddIngItem((Decimal)ar.get('expr7'), NULL);
                i.Chln__c = adddIngItem((Decimal)ar.get('expr8'), NULL);
                i.Chol__c = adddIngItem((Decimal)ar.get('expr9'), NULL);
                i.Chrom__c = adddIngItem((Decimal)ar.get('expr10'), NULL);
                i.Copp__c = adddIngItem((Decimal)ar.get('expr11'), NULL);
                i.Disacc__c = adddIngItem((Decimal)ar.get('expr12'), NULL);
                i.Fat__c = adddIngItem((Decimal)ar.get('expr13'), NULL);
                i.FatCals__c = adddIngItem((Decimal)ar.get('expr14'), NULL);
                i.Fluor__c = adddIngItem((Decimal)ar.get('expr15'), NULL);
                i.Fol_DFE__c = adddIngItem((Decimal)ar.get('expr16'), NULL);
                i.Folate__c = adddIngItem((Decimal)ar.get('expr17'), NULL);
                i.Iodine__c = adddIngItem((Decimal)ar.get('expr18'), NULL);
                i.Iron__c = adddIngItem((Decimal)ar.get('expr19'), NULL);
                i.Magn__c = adddIngItem((Decimal)ar.get('expr20'), NULL);
                i.Mang__c = adddIngItem((Decimal)ar.get('expr21'), NULL);
                i.Moly__c = adddIngItem((Decimal)ar.get('expr22'), NULL);
                i.MonoFat__c = adddIngItem((Decimal)ar.get('expr23'), NULL);
                i.MonSac__c = adddIngItem((Decimal)ar.get('expr24'), NULL);
                i.NiacEq__c = adddIngItem((Decimal)ar.get('expr25'), NULL);
                i.OCarb__c = adddIngItem((Decimal)ar.get('expr26'), NULL);
                i.Omega3__c = adddIngItem((Decimal)ar.get('expr27'), NULL);
                i.Omega6__c = adddIngItem((Decimal)ar.get('expr28'), NULL);
                i.Panto__c = adddIngItem((Decimal)ar.get('expr29'), NULL);
                i.Phos__c = adddIngItem((Decimal)ar.get('expr30'), NULL);
                i.PolyFat__c = adddIngItem((Decimal)ar.get('expr31'), NULL);
                i.Pot__c = adddIngItem((Decimal)ar.get('expr32'), NULL);
                i.Protein__c = adddIngItem((Decimal)ar.get('expr33'), NULL);
                i.Retinol__c = adddIngItem((Decimal)ar.get('expr34'), NULL);
                i.SatCals__c = adddIngItem((Decimal)ar.get('expr35'), NULL);
                i.SatFat__c = adddIngItem((Decimal)ar.get('expr36'), NULL);
                i.Sel__c = adddIngItem((Decimal)ar.get('expr37'), NULL);
                i.Sod__c = adddIngItem((Decimal)ar.get('expr38'), NULL);
                i.Sugar__c = adddIngItem((Decimal)ar.get('expr39'), NULL);
                i.TotFib__c = adddIngItem((Decimal)ar.get('expr40'), NULL);
                i.TotSolFib__c = adddIngItem((Decimal)ar.get('expr41'), NULL);
                i.TransFat__c = adddIngItem((Decimal)ar.get('expr42'), NULL);
                i.Tyrosine__c = adddIngItem((Decimal)ar.get('expr43'), NULL);
                i.Vit_A_IU__c = adddIngItem((Decimal)ar.get('expr44'), NULL);
                i.Vit_A_RAE__c = adddIngItem((Decimal)ar.get('expr45'), NULL);
                i.Vit_B1__c = adddIngItem((Decimal)ar.get('expr46'), NULL);
                i.Vit_B2__c = adddIngItem((Decimal)ar.get('expr47'), NULL);
                i.Vit_B3__c = adddIngItem((Decimal)ar.get('expr48'), NULL);
                i.Vit_B6__c = adddIngItem((Decimal)ar.get('expr49'), NULL);
                i.Vit_B12__c = adddIngItem((Decimal)ar.get('expr50'), NULL);
                i.Vit_C__c = adddIngItem((Decimal)ar.get('expr51'), NULL);
                i.Vit_D_IU__c = adddIngItem((Decimal)ar.get('expr52'), NULL);
                i.Vit_D_mcg__c = adddIngItem((Decimal)ar.get('expr53'), NULL);
                i.Vit_E_a_Toco__c = adddIngItem((Decimal)ar.get('expr54'), NULL);
                i.Vit_K__c = adddIngItem((Decimal)ar.get('expr55'), NULL);
                i.Vit_NiacEq__c = adddIngItem((Decimal)ar.get('expr56'), NULL);
                i.Water__c = adddIngItem((Decimal)ar.get('expr57'), NULL);
                i.Wgt__c = adddIngItem((Decimal)ar.get('expr58'), NULL);
                i.Zinc__c = adddIngItem((Decimal)ar.get('expr59'), NULL);
                
                mapIngredient.put(mealId, i);    
            } else {
                
                fndIngItem.Alc__c = adddIngItem(fndIngItem.Alc__c, (Decimal)ar.get('expr0'));
                fndIngItem.BetaCaro__c = adddIngItem(fndIngItem.BetaCaro__c, (Decimal)ar.get('expr1'));
                fndIngItem.Biot__c = adddIngItem(fndIngItem.Biot__c, (Decimal)ar.get('expr2'));
                fndIngItem.Caff__c = adddIngItem(fndIngItem.Caff__c, (Decimal)ar.get('expr3'));
                fndIngItem.Calc__c = adddIngItem(fndIngItem.Calc__c, (Decimal)ar.get('expr4'));
                fndIngItem.Cals__c = adddIngItem(fndIngItem.Cals__c, (Decimal)ar.get('expr5'));
                fndIngItem.Carb__c = adddIngItem(fndIngItem.Carb__c, (Decimal)ar.get('expr6'));
                fndIngItem.Caroten__c = adddIngItem(fndIngItem.Caroten__c, (Decimal)ar.get('expr7'));
                fndIngItem.Chln__c = adddIngItem(fndIngItem.Chln__c, (Decimal)ar.get('expr8'));
                fndIngItem.Chol__c = adddIngItem(fndIngItem.Chol__c, (Decimal)ar.get('expr9'));
                fndIngItem.Chrom__c = adddIngItem(fndIngItem.Chrom__c, (Decimal)ar.get('expr10'));
                fndIngItem.Copp__c = adddIngItem(fndIngItem.Copp__c, (Decimal)ar.get('expr11'));
                fndIngItem.Disacc__c = adddIngItem(fndIngItem.Disacc__c, (Decimal)ar.get('expr12'));
                fndIngItem.Fat__c = adddIngItem(fndIngItem.Fat__c, (Decimal)ar.get('expr13'));
                fndIngItem.FatCals__c = adddIngItem(fndIngItem.FatCals__c, (Decimal)ar.get('expr14'));
                fndIngItem.Fluor__c = adddIngItem(fndIngItem.Fluor__c, (Decimal)ar.get('expr15'));
                fndIngItem.Fol_DFE__c = adddIngItem(fndIngItem.Fol_DFE__c, (Decimal)ar.get('expr16'));
                fndIngItem.Folate__c = adddIngItem(fndIngItem.Folate__c, (Decimal)ar.get('expr17'));
                fndIngItem.Iodine__c = adddIngItem(fndIngItem.Iodine__c, (Decimal)ar.get('expr18'));
                fndIngItem.Iron__c = adddIngItem(fndIngItem.Iron__c, (Decimal)ar.get('expr19'));
                fndIngItem.Magn__c = adddIngItem(fndIngItem.Magn__c, (Decimal)ar.get('expr20'));
                fndIngItem.Mang__c = adddIngItem(fndIngItem.Mang__c, (Decimal)ar.get('expr21'));
                fndIngItem.Moly__c = adddIngItem(fndIngItem.Moly__c, (Decimal)ar.get('expr22'));
                fndIngItem.MonoFat__c = adddIngItem(fndIngItem.MonoFat__c, (Decimal)ar.get('expr23'));
                fndIngItem.MonSac__c = adddIngItem(fndIngItem.MonSac__c, (Decimal)ar.get('expr24'));
                fndIngItem.NiacEq__c = adddIngItem(fndIngItem.NiacEq__c, (Decimal)ar.get('expr25'));
                fndIngItem.OCarb__c = adddIngItem(fndIngItem.OCarb__c, (Decimal)ar.get('expr26'));
                fndIngItem.Omega3__c = adddIngItem(fndIngItem.Omega3__c, (Decimal)ar.get('expr27'));
                fndIngItem.Omega6__c = adddIngItem(fndIngItem.Omega6__c, (Decimal)ar.get('expr28'));
                fndIngItem.Panto__c = adddIngItem(fndIngItem.Panto__c, (Decimal)ar.get('expr29'));
                fndIngItem.Phos__c = adddIngItem(fndIngItem.Phos__c, (Decimal)ar.get('expr30'));
                fndIngItem.PolyFat__c = adddIngItem(fndIngItem.PolyFat__c, (Decimal)ar.get('expr31'));
                fndIngItem.Pot__c = adddIngItem(fndIngItem.Pot__c, (Decimal)ar.get('expr32'));
                fndIngItem.Protein__c = adddIngItem(fndIngItem.Protein__c, (Decimal)ar.get('expr33'));
                fndIngItem.Retinol__c = adddIngItem(fndIngItem.Retinol__c, (Decimal)ar.get('expr34'));
                fndIngItem.SatCals__c = adddIngItem(fndIngItem.SatCals__c, (Decimal)ar.get('expr35'));
                fndIngItem.SatFat__c = adddIngItem(fndIngItem.SatFat__c, (Decimal)ar.get('expr36'));
                fndIngItem.Sel__c = adddIngItem(fndIngItem.Sel__c, (Decimal)ar.get('expr37'));
                fndIngItem.Sod__c = adddIngItem(fndIngItem.Sod__c, (Decimal)ar.get('expr38'));
                fndIngItem.Sugar__c = adddIngItem(fndIngItem.Sugar__c, (Decimal)ar.get('expr39'));
                fndIngItem.TotFib__c = adddIngItem(fndIngItem.TotFib__c, (Decimal)ar.get('expr40'));
                fndIngItem.TotSolFib__c = adddIngItem(fndIngItem.TotSolFib__c, (Decimal)ar.get('expr41'));
                fndIngItem.TransFat__c = adddIngItem(fndIngItem.TransFat__c, (Decimal)ar.get('expr42'));
                fndIngItem.Tyrosine__c = adddIngItem(fndIngItem.Tyrosine__c, (Decimal)ar.get('expr43'));
                fndIngItem.Vit_A_IU__c = adddIngItem(fndIngItem.Vit_A_IU__c, (Decimal)ar.get('expr44'));
                fndIngItem.Vit_A_RAE__c = adddIngItem(fndIngItem.Vit_A_RAE__c, (Decimal)ar.get('expr45'));
                fndIngItem.Vit_B1__c = adddIngItem(fndIngItem.Vit_B1__c, (Decimal)ar.get('expr46'));
                fndIngItem.Vit_B2__c = adddIngItem(fndIngItem.Vit_B2__c, (Decimal)ar.get('expr47'));
                fndIngItem.Vit_B3__c = adddIngItem(fndIngItem.Vit_B3__c, (Decimal)ar.get('expr48'));
                fndIngItem.Vit_B6__c = adddIngItem(fndIngItem.Vit_B6__c, (Decimal)ar.get('expr49'));
                fndIngItem.Vit_B12__c = adddIngItem(fndIngItem.Vit_B12__c, (Decimal)ar.get('expr50'));
                fndIngItem.Vit_C__c = adddIngItem(fndIngItem.Vit_C__c, (Decimal)ar.get('expr51'));
                fndIngItem.Vit_D_IU__c = adddIngItem(fndIngItem.Vit_D_IU__c, (Decimal)ar.get('expr52'));
                fndIngItem.Vit_D_mcg__c = adddIngItem(fndIngItem.Vit_D_mcg__c, (Decimal)ar.get('expr53'));
                fndIngItem.Vit_E_a_Toco__c = adddIngItem(fndIngItem.Vit_E_a_Toco__c, (Decimal)ar.get('expr54'));
                fndIngItem.Vit_K__c = adddIngItem(fndIngItem.Vit_K__c, (Decimal)ar.get('expr55'));
                fndIngItem.Vit_NiacEq__c = adddIngItem(fndIngItem.Vit_NiacEq__c, (Decimal)ar.get('expr56'));
                fndIngItem.Water__c = adddIngItem(fndIngItem.Water__c, (Decimal)ar.get('expr57'));
                fndIngItem.Wgt__c = adddIngItem(fndIngItem.Wgt__c, (Decimal)ar.get('expr58'));
                fndIngItem.Zinc__c = adddIngItem(fndIngItem.Zinc__c, (Decimal)ar.get('expr59'));                
                mapIngredient.put(mealId, fndIngItem);  
            }
            
        }
        
        //system.assert(false, 'BOOM!mapIngredient:'+ mapIngredient + ':');
        
        List<respProductItem> respProds = new List<respProductItem>();
        List<respMealProductItem> respMealProds = new List<respMealProductItem>();        
        List<respNutritionUnits> respNutUnits = new List<respNutritionUnits>();
        
        respNutritionUnits rn1 = new respNutritionUnits();
        rn1.name='b12';
        rn1.unit='mcg';
        respNutUnits.add(rn1);
        respNutritionUnits rn2 = new respNutritionUnits();
        rn2.name='b6';
        rn2.unit='mg';
        respNutUnits.add(rn2);
        respNutritionUnits rn3 = new respNutritionUnits();
        rn3.name='calcium';
        rn3.unit='mg';
        respNutUnits.add(rn3);
        respNutritionUnits rn4 = new respNutritionUnits();
        rn4.name='carbohydrates';
        rn4.unit='g';
        respNutUnits.add(rn4);
        respNutritionUnits rn5 = new respNutritionUnits();
        rn5.name='calories';
        rn5.unit='kcal';
        respNutUnits.add(rn5);
        respNutritionUnits rn6 = new respNutritionUnits();
        rn6.name='fat';
        rn6.unit='g';
        respNutUnits.add(rn6);
        respNutritionUnits rn7 = new respNutritionUnits();
        rn7.name='fiber';
        rn7.unit='g';
        respNutUnits.add(rn7);
        respNutritionUnits rn8 = new respNutritionUnits();
        rn8.name='iron';
        rn8.unit='mg';
        respNutUnits.add(rn8);
        respNutritionUnits rn9 = new respNutritionUnits();
        rn9.name='magnesium';
        rn9.unit='mg';
        respNutUnits.add(rn9);
        respNutritionUnits rn10 = new respNutritionUnits();
        rn10.name='monounsaturated_fat';
        rn10.unit='g';
        respNutUnits.add(rn10);
        respNutritionUnits rn11 = new respNutritionUnits();
        rn11.name='phosphorus';
        rn11.unit='mg';
        respNutUnits.add(rn11);
        respNutritionUnits rn12 = new respNutritionUnits();
        rn12.name='polyunsaturated_fat';
        rn12.unit='g';
        respNutUnits.add(rn12);
        respNutritionUnits rn13 = new respNutritionUnits();
        rn13.name='potassium';
        rn13.unit='mg';
        respNutUnits.add(rn13);
        respNutritionUnits rn14 = new respNutritionUnits();
        rn14.name='protein';
        rn14.unit='g';
        respNutUnits.add(rn14);
        respNutritionUnits rn15 = new respNutritionUnits();
        rn15.name='saturated_fat';
        rn15.unit='g';
        respNutUnits.add(rn15);
        respNutritionUnits rn16 = new respNutritionUnits();
        rn16.name='sodium';
        rn16.unit='mg';
        respNutUnits.add(rn16);
        respNutritionUnits rn17 = new respNutritionUnits();
        rn17.name='sugar';
        rn17.unit='g';
        respNutUnits.add(rn17);
        respNutritionUnits rn18 = new respNutritionUnits();
        rn18.name='vitamin_a_iu';
        rn18.unit='iu';
        respNutUnits.add(rn18);
        respNutritionUnits rn19 = new respNutritionUnits();
        rn19.name='vitamin_a_rae';
        rn19.unit='mcg';
        respNutUnits.add(rn19);
        respNutritionUnits rn20 = new respNutritionUnits();
        rn20.name='vitamin_c';
        rn20.unit='mg';
        respNutUnits.add(rn20);
        respNutritionUnits rn21 = new respNutritionUnits();
        rn21.name='vitamin_e';
        rn21.unit='mg';
        respNutUnits.add(rn21);
        respNutritionUnits rn22 = new respNutritionUnits();
        rn22.name='weight';
        rn22.unit='g';
        respNutUnits.add(rn22);
        respNutritionUnits rn23 = new respNutritionUnits();
        rn23.name='zinc';
        rn23.unit='mg';
        respNutUnits.add(rn23);
            
        for(Product2 prod :lstProd) {
            
            System.debug('prod:' + prod);
            
            respProductItem rpi = new respProductItem();
            
            // Setup Default Values
            rpi.code = '';
            rpi.name = prod.Name;
            rpi.description = '';
            rpi.image = '';
            rpi.quanity_in_stock = 0;
            
            Decimal fndPrice = mapPrice.get(prod.Id);
            if(fndPrice != NULL) {
                rpi.price = fndPrice;
            } else {
                rpi.quanity_in_stock = 0;
            }
            
            List<respProductDetailItem> lstDetailsTemp = new List<respProductDetailItem>();
            
            rpi.details = lstDetailsTemp;
            rpi.type = '';
            Integer minMeals = 14;
            if(prod.Minimum_Meals__c != NULL) {
                rpi.minimum_quantity = Integer.ValueOf(prod.Minimum_Meals__c);
                minMeals = Integer.ValueOf(prod.Minimum_Meals__c);
            }
            
            for(Meal__c fndMeal :lstMeal) {
                
                respMealProductItem rpiMeal = new respMealProductItem();
                rpiMeal.code = rpi.code;
                rpiMeal.price = rpi.price;                        
                if(fndMeal.Inventory__c != NULL && fndMeal.Inventory__c > 0) {
                    rpiMeal.quanity_in_stock = Integer.valueOf(fndMeal.Inventory__c);
                } else {
                    rpiMeal.quanity_in_stock = 0;
                }
                
                System.debug('rpiMeal:' + rpiMeal);                        
                System.debug('fndMeal:' + fndMeal);
                
                if(fndMeal != null) {
                    
                    Ingredient_Item__c fndIng = mapIngredient.get(fndMeal.Id);
                    
                    if(fndIng != NULL) {
                        
                        // Find Protiens and Allergens in Ingredient
                        List<String> protiens = new List<String>();
                        List<String> allergens = new List<String>();
                        List<respMealProductDetailIngredientItem> ingsNames = new List<respMealProductDetailIngredientItem>();
                        List<String> ings = new List<String>();
                        Decimal calories;
                        
                        System.debug('~~~lstIng:' + lstIng);
                        
                        MAP<String,Decimal> mealIngs = mapIng.get(fndMeal.Id); 
                        Decimal cnt1=1;
                        for(String ii :mealIngs.keySet()) {
                            Decimal wgt = mealIngs.get(ii);
                            respMealProductDetailIngredientItem nii = new respMealProductDetailIngredientItem();
                            nii.wgt = wgt;
                            List<respIngredientItem> rmiiList = new List<respIngredientItem>();
                            nii.ingredients = rmiiList;
                            String ingNameSimple = ii;
                            
                            if(ii.indexOf('~') > -1) {
                                List<String> str1 = ii.split('~');
                                if(str1.size() > 1) {
                                    ingNameSimple = str1[0];
                                    List<String> str2 = str1[1].split(',');
                                    for(String str :str2) {
                                        respIngredientItem rmii = new respIngredientItem();
                                        rmii.name = str;
                                        rmiiList.add(rmii);
                                    }
                                    nii.ingredients = rmiiList;
                                }
                            }
                            
                            nii.name = ii;
                            ings.add(ingNameSimple);
                            ingsNames.add(nii);
                            cnt1++;
                        }
                        
                        protiens = mapPro.get(fndMeal.Id); 
                        allergens = mapAlg.get(fndMeal.Id);
                        calories = mapCals.get(fndMeal.Id);
                        System.debug('Loop Done:' + lstIng.size());
                        
                        respMealProductDetailItem prd = new respMealProductDetailItem();
                        prd.allergens = allergens;
                        prd.proteins = protiens;
                        prd.ingredients_details = ingsNames;
                        prd.ingredients = ings;
                        prd.calories_per_serving = mapCals.get(fndMeal.Id);
                        prd.cuisine = RESTAuthController.getBlankValue(fndMeal.Cuisine__c);
                        
                        prd.type = RESTAuthController.getBlankValue(fndMeal.Type__c);
                        
                        // Add Nutrition
                        respProductItemNutrition rpin = new respProductItemNutrition();
                        
                        rpin.b12 = fndIng.Vit_B12__c;
                        rpin.b6 = fndIng.Vit_B6__c;
                        rpin.calcium = fndIng.Calc__c;
                        rpin.carbohydrates = fndIng.Carb__c;
                        rpin.calories = fndIng.Cals__c;
                        rpin.fat = fndIng.Fat__c;
                        rpin.fiber = fndIng.TotFib__c;
                        rpin.iron = fndIng.Iron__c;
                        rpin.magnesium = fndIng.Magn__c;
                        rpin.monounsaturated_fat = fndIng.MonoFat__c;
                        rpin.niaceq = fndIng.NiacEq__c;
                        rpin.phosphorus = fndIng.Phos__c;
                        rpin.polyunsaturated_fat = fndIng.PolyFat__c;
                        rpin.potassium = fndIng.Pot__c;
                        rpin.protein = fndIng.Protein__c;
                        rpin.saturated_fat = fndIng.SatFat__c;
                        rpin.sodium = fndIng.Sod__c;
                        rpin.sugar = fndIng.Sugar__c;
                        //rpin.tyrosine = fndIng.Tyrosine__c;
                        rpin.vitamin_a_iu = fndIng.Vit_A_IU__c;
                        rpin.vitamin_a_rae = fndIng.Vit_A_RAE__c;
                        rpin.vitamin_c = fndIng.Vit_C__c;
                        rpin.vitamin_e = fndIng.Vit_E_a_Toco__c;
                        rpin.weight = fndIng.Wgt__c;
                        rpin.zinc = fndIng.Zinc__c;
                        
                        prd.nutrition = rpin;
                        
                        //lstDetails.add(prd);
                        rpiMeal.details = prd;
                        rpiMeal.type = 'Meal';
                        rpiMeal.name = fndMeal.Name;
                        rpiMeal.description = RESTAuthController.getBlankValue(fndMeal.Description__c);
                        rpiMeal.image = RESTAuthController.getBlankValue(fndMeal.Image_URL__c);
                        rpiMeal.minimum_quantity = minMeals;
                        rpiMeal.code = fndMeal.Shopify_ID__c;
                        
                        if(fndPrice != NULL) {
                            rpiMeal.price = fndPrice / minMeals;
                            rpiMeal.price = rpiMeal.price.setScale(2);
                        } else {
                            rpiMeal.price = 0;
                        }
                        
                        respMealProds.add(rpiMeal);
                    }
                }
            }
            
        }
        
        respProducts rp = new respProducts();
        rp.status_code = 0;
        rp.products = respMealProds;
        rp.units = respNutUnits;
        system.debug('respMealProds:' + respMealProds);
        return rp;
    }
    
    @HttpGet  
    global static Void getProducts() {      

        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        String clientId = RESTAuthController.verifyRequest(req);
        
        if(clientId != null || Test.isRunningTest()) {
            String reqRoute = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            //system.assert(false, 'BOOM!mapIngredient:'+ reqRoute + ':');
            
            System.debug('reqRoute:' + reqRoute);
            respProducts rp = processRequest(reqRoute);
            String jsonBody = JSON.serialize(rp); 
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(jsonBody);
            res.statusCode = 200;
        } else {
            res.statusCode = 401;
        }
    }
}