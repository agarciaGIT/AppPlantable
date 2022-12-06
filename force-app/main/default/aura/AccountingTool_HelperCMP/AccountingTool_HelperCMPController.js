({
    doInit : function(component, event, helper){
        component.set('v.columns', [ {label: 'Product Name', fieldName: 'ProductName', type: 'text'},
                                    {label: 'Product Code', fieldName: 'ProductCode', type: 'text'},
                                    {label: 'Product Id', fieldName: 'Product_ID__c', type: 'text'},
                                    {label: 'Total Price', fieldName: 'UnitPrice', type: 'text'}]);
        helper.getAllProducts(component,event,helper);
    },
    
    handleSelect : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]);
        }
        component.set("v.selectedOLI", setRows);
    },
    
    OnclickSaveButton: function (component, event, helper){
        component.set("v.spinner",true);
        //helper.checkMaxDiscount(component, event, helper);
        var allTrue = true;
        var allSelectedOLI = component.get("v.selectedOLI");  //selectedRegistrations
        var picklistOptionSelected = component.get("v.optionSelected");
        //var amountValue = component.get("v.amountEntered");
        var discount = component.get("v.maxDiscount");
        console.log('allSelectedOLI  ::>>   ',allSelectedOLI);
        console.log('picklistOptionSelected  ::>>   ',picklistOptionSelected);
        
        component.set("v.errorMsg","");
        component.set("v.ErrorMessage","");
        component.set("v.ErrorMessageText","");
        
        if(allSelectedOLI === undefined || allSelectedOLI.length == 0){
            console.log('in here 1');
            component.set("v.errorMsg","Please select atleast one to continue.");
            component.set("v.showError",true);
            component.set("v.spinner",false);
            allTrue = false;
        }
        if(picklistOptionSelected === undefined || picklistOptionSelected === ''){
            console.log('in here 2');
            component.set("v.ErrorMessage","Please select atleast one to continue.");
            component.set("v.showError",true);
            component.set("v.spinner",false);
            allTrue = false;
        }
        /*
        if(amountValue === undefined || amountValue === ''){
            console.log('in here 3');
            component.set("v.ErrorMessageText","Please enter a value.");
            component.set("v.showError",true);
            component.set("v.spinner",false);
            allTrue = false;
        }
        if(amountValue > discount){
            console.log('in here 4');
            component.set("v.ErrorMessageText","Discount not be greater than Total Price of the selected Item.");
            component.set("v.showError",true);
            component.set("v.spinner",false);
            allTrue = false;
        }
        */
        if(allTrue){
            component.set("v.errorMsg","");
            component.set("v.showError",false);
            
            var action = component.get("c.createNewOppAndOli");
            action.setParams({
                InvoiceNumber:component.get("v.invNum"),
                oliList:component.get("v.selectedOLI"),
                ProductCodeSelected:picklistOptionSelected
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state ::>>   ',state);
                var response = response.getReturnValue();
                //var responseMsg = response.getReturnValue();
                console.log('response is  ::>>   ',response);
                if(state == "SUCCESS"){
                    console.log('in here');
                    if(response == 'Success'){
                        console.log('in here1');
                        component.set("v.saveCompleted",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success',
                            message: 'Data saved successfully',
                            duration:' 500',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        component.set("v.spinner",false);
                        $A.get('e.force:refreshView').fire();
                    }
                    if(response.includes("Refund Opportunity")){
                        console.log('in here2');
                        /*
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message: 'Refund Opportunity Exists',
                            duration:' 500',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        */
                        component.set("v.spinner",false);
                        component.set("v.errorMsg",response);
                        component.set("v.showError",true);
                    }
                }else{
                    console.log('in here2');
                    component.set("v.spinner",false);
                    component.set("v.errorMsg",response);
                    component.set("v.showError",true);
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    
    BackToMain : function(component, event, helper) {
        component.set("v.navigateNext",false);
    }
})