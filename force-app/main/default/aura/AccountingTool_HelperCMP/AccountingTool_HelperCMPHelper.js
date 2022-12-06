({
    getAllProducts : function(component,event,helper) {
        var action = component.get("c.getAllProducts");
        action.setParams({InvoiceNumber:component.get("v.invNum")});
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    console.log('row::>>   ',row);
                    if (row.Product2.ProductCode) row.ProductCode = row.Product2.ProductCode;
                    if (row.Product2.Name) row.ProductName = row.Product2.Name;
                }
                component.set("v.OLIList", rows);
                component.set("v.showList", true);
            }else{
                component.set("v.showList", false);
                component.set("v.errorMsg","Its not a valid Invoice Number");
                component.set("v.showError",true);
            }
        });
        $A.enqueueAction(action);
    },
    /*
    saveData : function(component, event, helper) {
        
        var selectedRegs = component.get("v.selectedOLI");
        
        var wrapper = '';
        console.log(wrapper);
        var action = component.get("c.createNewOppAndOli");  //saveData  createNewOppAndOli    createNewOpportunity
        action.setParams({requestWrapper:JSON.stringify(wrapper)});
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.spinner",false);
                if(response.getReturnValue() === "SUCCESS"){
                    component.set("v.errorMsg","");
                    component.set("v.showError",false);
                    component.set("v.saveCompleted",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Data saved successfully',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }else{
                    component.set("v.errorMsg",response.getReturnValue());
                    component.set("v.showError",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    */
    checkMaxDiscount : function(component,event,helper) {
        var minPrice = 100000000;
        var currentPrice ;
        var allSelectedOLI = component.get("v.selectedOLI");
        console.log('allSelectedOLI::>>   ',allSelectedOLI);
        for (var i = 0; i < allSelectedOLI.length; i++) {
            var row = allSelectedOLI[i];
            console.log('row::>>   ',row);
            if(row.UnitPrice < minPrice){
                minPrice = row.UnitPrice;
            }
            component.set("v.maxDiscount",minPrice);
        }
    }
})