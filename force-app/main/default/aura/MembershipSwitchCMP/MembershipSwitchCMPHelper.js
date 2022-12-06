({
    helperMethod : function(component, event) {
        
        var action = component.get('c.OnclickMembershipSwitch');
        action.setParams({
            InvoiceNumber:component.get("v.InvoiceNumber")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state::>>  '+state);
            if (state === "SUCCESS") {
                component.set("v.spinner",false);
                console.log('response::>>  '+response.getReturnValue());
                var res = response.getReturnValue();
                if(res == 'Success') {
                    component.set("v.navigateNext",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Switch is Completed.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }else {
                    component.set("v.navigateNext",true);
                    /*var msg = 'Invalid Invoice Number.';
                    if(res == 'Invalid Invoice Number'){
                        msg = 'Invalid Invoice Number.';
                    }
                    if(res == 'Refund Opportunity Exists'){
                        msg = 'Refund Opportunity Exists.';
                    }
                    console.log('msg::>>   ',msg);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: msg,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    */
                    component.set("v.spinner",false);
                    component.set("v.errorMsg",res);
                    component.set("v.showError",true);
                }
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                        component.set("v.errorMsg",errors[0].message);
                        component.set("v.showError",true);
                        component.set("v.spinner",false);
                    }
                } else {
                    console.log("Unknown error");
                    component.set("v.errorMsg","Unknown error");
                    component.set("v.showError",true);
                    component.set("v.spinner",false);
                }
            }
            
        });
        $A.enqueueAction(action);
    }
})