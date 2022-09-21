({
   onLoad: function(component, event) {
      //call apex class method
      var action = component.get('c.fetchContact');
      action.setCallback(this, function(response){
         //store state of response
         var state = response.getState();
         if (state === "SUCCESS") {
            //set response value in ListOfContact attribute on component.
            component.set('v.ListOfContact', response.getReturnValue());
         }
      });
      $A.enqueueAction(action);
   },
    
   convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
       
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        var columnDivider = ',';
        var lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header
        var headings = ['RPT_Dish_Name','RPT_Meal_Name','Ingredient Item Name','Amount','Amount Unit','B12 (mcg)','B6 (mg)','BetaCaro','Biot','Caff','Calc (mg)','Cals (kcal)','Carb (g)','Caroten','Chln','Chol','Chrom','Copp','Disacc','Fat (g)','FatCals','Fiber (g)','Flour','Fol_DFE','Folate','Iodine','Iron (mg)','Is_Allergen','Magn (mg)','Mang','Meal_Name','Moly','MonoFat (g)','MonSac','NiacEq','0Carb','Omega3','Omega6','Panto','Phos (mg)','PolyFat (g)','Pot (mg)','Protein (g)','Retinol','SatCals','SatFat (g)','Sel','Sod (mg)','SolFib','SugAdd','Sugar (g)','TotFib','TotSolFib','TransFat','Tyrosine','Vit A-IU (IU)','Vit A-RAE (mcg)','Vit_B1','Vit_B12 (mcg)','Vit_B2','Vit_B3','Vit_B6','Vit_C (mg)','Vit_D_IU','Vit_D_mcg','Vit_E_a_Toco (mg)','Vit_K','Vit_NiacEq','Water','Wgt (g)','Zinc (mg)','Sub_Ingredients' ,'Special_Instructions'];  
        var keys = ['RPT_Dish_Name__c','RPT_Meal_Name__c','Name','Amount__c','Amount_Unit__c','B12__c','B6__c','BetaCaro__c','Biot__c','Caff__c','Calc__c','Cals__c','Carb__c','Caroten__c','Chln__c','Chol__c','Chrom__c','Copp__c','Disacc__c','Fat__c','FatCals__c','Fiber__c','Fluor__c','Fol_DFE__c','Folate__c','Iodine__c','Iron__c','Is_Allergen__c','Magn__c','Mang__c','Meal_Name__c','Moly__c','MonoFat__c','MonSac__c','NiacEq__c','OCarb__c','Omega3__c','Omega6__c','Panto__c','Phos__c','PolyFat__c','Pot__c','Protein__c','Retinol__c','SatCals__c','SatFat__c','Sel__c','Sod__c','SolFib__c','SugAdd__c','Sugar__c','TotFib__c','TotSolFib__c','TransFat__c','Tyrosine__c','Vit_A_IU__c','Vit_A_RAE__c','Vit_B1__c','Vit_B12__c','Vit_B2__c','Vit_B3__c','Vit_B6__c','Vit_C__c','Vit_D_IU__c','Vit_D_mcg__c','Vit_E_a_Toco__c','Vit_K__c','Vit_NiacEq__c','Water__c','Wgt__c','Zinc__c','Sub_Ingredients__c','Special_Instructions__c' ];
        
        var csvStringResult = '';
        csvStringResult += headings.join(columnDivider);
        csvStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
           
             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
 
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }   
               
                 var str =  objectRecords[i][skey];
                 if(typeof str == "undefined") { str = ''; }
                 csvStringResult += '"'+ str +'"';
                 
               counter++;
 
            } // inner for loop close 
             csvStringResult += lineDivider;
          }// outer main for loop close 
       
       // return the CSV formate String 
        return csvStringResult;        
    },
})