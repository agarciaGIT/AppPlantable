({
    searchEmail : function(component, event, helper){
        var searchKey = component.find("searchKey").get("v.value");
        var toastEvent = $A.get("e.force:showToast");
        if(searchKey!= null && searchKey!='' && searchKey!='undefined'){ 
            var action = component.get("c.findByEmail");
            action.setParams({
                emailsearchKey : searchKey
            });
            action.setCallback(this, function(response){
                var state = response.getState(); 
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();  
                    // call the helper function which "return" the CSV data as a String   
                    var csv = this.convertArrayOfObjectsToCSV(component,res);   
                    if (csv == null){return;}  
                    // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self'; // 
                    hiddenElement.download = 'ExportData.csv';  // CSV file Name* you can change it.[only name not .csv] 
                    document.body.appendChild(hiddenElement); // Required for FireFox browser
                    hiddenElement.click(); // using click() js function to download csv file
                    
                }
            });
            $A.enqueueAction(action);
        }else if(searchKey==''){ 
            toastEvent.setParams({
                title : 'Error',
                message:'Please enter email',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
        }
        toastEvent.fire();
    },      
    convertArrayOfObjectsToCSV : function(component,objectRecords){ 
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        component.set("v.spinner", true); 
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            component.set("v.spinner", false); 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'No Records Found',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            }); 
            toastEvent.fire();
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        var columnDivider = ',';
        var lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key  
        // this labels use in CSV file header
        var headings = ['RPT_Meal_Name','RPT_Dish_Name','Ingredient Item Name','Amount Unit','Shipment Date','B12 (mcg)','B6 (mg)','BetaCaro','Biot','Caff','Calc (mg)','Cals (kcal)','Carb (g)','Caroten','Chln','Chol','Chrom','Copp','Disacc','Fat (g)','FatCals','Fiber (g)','Flour','Fol_DFE','Folate','Iodine','Iron (mg)','Is_Allergen','Magn (mg)','Mang','Moly','MonoFat (g)','MonSac','NiacEq','0Carb','Omega3','Omega6','Panto','Phos (mg)','PolyFat (g)','Pot (mg)','Protein (g)','Retinol','SatCals','SatFat (g)','Sel','Sod (mg)','SolFib','SugAdd','Sugar (g)','TotFib','TotSolFib','TransFat','Tyrosine','Vit A-IU (IU)','Vit A-RAE (mcg)','Vit_B1','Vit_B12 (mcg)','Vit_B2','Vit_B3','Vit_B6','Vit_C (mg)','Vit_D_IU','Vit_D_mcg','Vit_E_a_Toco (mg)','Vit_K','Vit_NiacEq','Water','Wgt (g)','Zinc (mg)','Sub_Ingredients' ,'Special_Instructions'];  
        var keys = ['RPT_Meal_Name__c','RPT_Dish_Name__c','Name','Amount_Unit__c','ShipmentDate','B12__c','B6__c','BetaCaro__c','Biot__c','Caff__c','Calc__c','Cals__c','Carb__c','Caroten__c','Chln__c','Chol__c','Chrom__c','Copp__c','Disacc__c','Fat__c','FatCals__c','Fiber__c','Fluor__c','Fol_DFE__c','Folate__c','Iodine__c','Iron__c','Is_Allergen__c','Magn__c','Mang__c','Moly__c','MonoFat__c','MonSac__c','NiacEq__c','OCarb__c','Omega3__c','Omega6__c','Panto__c','Phos__c','PolyFat__c','Pot__c','Protein__c','Retinol__c','SatCals__c','SatFat__c','Sel__c','Sod__c','SolFib__c','SugAdd__c','Sugar__c','TotFib__c','TotSolFib__c','TransFat__c','Tyrosine__c','Vit_A_IU__c','Vit_A_RAE__c','Vit_B1__c','Vit_B12__c','Vit_B2__c','Vit_B3__c','Vit_B6__c','Vit_C__c','Vit_D_IU__c','Vit_D_mcg__c','Vit_E_a_Toco__c','Vit_K__c','Vit_NiacEq__c','Water__c','Wgt__c','Zinc__c','Sub_Ingredients__c','Special_Instructions__c' ];
        var csvStringResult = '';
        csvStringResult += headings.join(columnDivider);
        csvStringResult += lineDivider;
        var amap ={};
        for(var i=0; i < objectRecords.length; i++){ 
            var key = objectRecords[i].ingredientItem.RPT_Dish_Name__c; 
            amap[key] = amap[key] || [];
            amap[key].push(objectRecords[i]);
        }  
        var rowcountss = 2;
        var rowcount = 1; 
        var rowcolumcountMap = {};
        for ( var key in amap ) { 
            var objectdata = amap[key]; 
            for(var i=0; i < objectdata.length; i++){ 
                counter = 0;
                var titalsummap = {};
                for(var sTempkey in keys) {
                    var skey = keys[sTempkey] ; 
                    if(counter > 0){ 
                        csvStringResult += columnDivider; 
                    } 
                    var str; 
                    if(skey == 'ShipmentDate'){
                        str = objectdata[i].shipmentDate;
                    }else{
                        str = objectdata[i].ingredientItem[skey];
                    }
                    
                    if(typeof str != "undefined" && typeof str == "number") { 
                        var keyval = skey+''+key;
                        rowcolumcountMap[keyval] = rowcolumcountMap[keyval] || [];
                        rowcolumcountMap[keyval].push(str);
                    }
                    if(typeof str == "undefined") { str = ''; }
                    csvStringResult += '"'+ str +'"'; 
                    counter++;  
                } 
                csvStringResult += lineDivider;
                rowcount = rowcount+1; 
            }   
            //csvStringResult +=lineDivider; 
            //total 
            for(var sTempkey in keys) {
                var skey = keys[sTempkey]+''+key;   
                if(sTempkey == 0){
                    csvStringResult += 'Total,';
                }else{  
                    if(rowcolumcountMap[skey] != undefined && rowcolumcountMap[skey] != 'undefined'){ 
                        var columncount = 0;
                        for(var j=0; j < rowcolumcountMap[skey].length; j++){  
                            columncount =  columncount+rowcolumcountMap[skey][j];  
                        }  
                        csvStringResult += columncount +',';  
                    }else{
                        csvStringResult += '' +','; 
                    } 
                }  
            }   
            csvStringResult +=lineDivider;
            //total 75%
            for(var sTempkey in keys) {
                var skey = keys[sTempkey]+''+key;   
                if(sTempkey == 0){
                    csvStringResult += '75% of Total,';
                }else{  
                    if(rowcolumcountMap[skey] != undefined && rowcolumcountMap[skey] != 'undefined'){ 
                        var columncount = 0;
                        for(var j=0; j < rowcolumcountMap[skey].length; j++){  
                            columncount =  columncount+rowcolumcountMap[skey][j];  
                        }   
                        csvStringResult += (columncount * 0.75) +',';   
                    }else{
                        csvStringResult += '' +','; 
                    } 
                }  
            }   
            csvStringResult +=lineDivider; 
            //total 50%
            for(var sTempkey in keys) {
                var skey = keys[sTempkey]+''+key;   
                if(sTempkey == 0){
                    csvStringResult += '50% of Total,';
                }else{  
                    if(rowcolumcountMap[skey] != undefined && rowcolumcountMap[skey] != 'undefined'){ 
                        var columncount = 0;
                        for(var j=0; j < rowcolumcountMap[skey].length; j++){  
                            columncount =  columncount+rowcolumcountMap[skey][j];  
                        }   
                        csvStringResult += (columncount * 0.50) +',';  
                    }else{
                        csvStringResult += '' +','; 
                    } 
                }  
            }   
            csvStringResult +=lineDivider;  
            //total 25%
            for(var sTempkey in keys) {
                var skey = keys[sTempkey]+''+key;   
                if(sTempkey == 0){
                    csvStringResult += '25% of Total,';
                }else{  
                    if(rowcolumcountMap[skey] != undefined && rowcolumcountMap[skey] != 'undefined'){ 
                        var columncount = 0;
                        for(var j=0; j < rowcolumcountMap[skey].length; j++){  
                            columncount =  columncount+rowcolumcountMap[skey][j];  
                        }   
                        csvStringResult += (columncount * 0.25) +',';  
                    }else{
                        csvStringResult += '' +','; 
                    } 
                }  
            }   
            csvStringResult +=lineDivider; 
            csvStringResult +=lineDivider; 
        } 
       // return the CSV formate String 
       component.set("v.spinner", false); 
       return csvStringResult;        
   } 
})