({
	doInit : function(component, event, helper) {
                
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
                component.set('v.shippingDate', resp.nextShippingDate);
                
                helper.parseData(component);
            }
        });
        $A.enqueueAction(action);
    },

    refreshData: function(component, event, helper) {
		var action = component.get('c.initClass');
        action.setParams({  inDate : component.get('v.shippingDate')  });
        
        action.setCallback(this,function(response){
            //store state of response
            //debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                //debugger;
                component.set('v.objClassController', resp);
                component.set('v.shippingDate', resp.nextShippingDate);
                
                helper.parseData(component);
            }
        });
        $A.enqueueAction(action);
    },   
    afterScriptsLoaded: function(component, event, helper) {
    
    	console.log('hi');
	}
})