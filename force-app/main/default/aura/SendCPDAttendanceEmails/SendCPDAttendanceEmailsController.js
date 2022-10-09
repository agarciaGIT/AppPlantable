({
	doInit: function(component, event) {
        var action = component.get("c.sendEmailBatch");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state = "Success"){
                component.set("v.responseMessage", response.getReturnValue());
                component.set("v.showMessage", true);
            }else if(state = "Error"){
                component.set("v.responseMessage", "Process Failed");
                component.set("v.showMessage", true);
            }
        });
        $A.enqueueAction(action);
    }
})