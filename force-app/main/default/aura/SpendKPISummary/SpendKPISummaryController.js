({
	afterScriptsLoaded : function(component, event, helper) {
        component.set("v.ready", true);
        debugger;
                
		var action = component.get('c.initClass');
        action.setCallback(this,function(response){
            //store state of response
            //debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                //debugger;
                component.set('v.objClassController', resp);
                
                helper.parseData(component);
            }
        });
        $A.enqueueAction(action);
    },
})