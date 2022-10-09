({
	init : function(component, event) {
        
        var action = component.get('c.cloneOpp');
        action.setParams({InvoiceNumber:component.get("v.InvoiceNumber")});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state========>'+state);
            if (state === "SUCCESS") {
                component.set("v.spinner",false);
                console.log('response.getReturnValue()=======>'+response.getReturnValue());
                component.set("v.navigateNext",false);
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
                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
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
        $A.enqueueAction(action,1);
    }
})