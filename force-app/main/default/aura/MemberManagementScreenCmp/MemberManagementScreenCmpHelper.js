({
	 getNavigateionUrl : function(component,event) {
          var action = component.get("c.getnavigateToURL"); 
         action.setParams({ 
            'selectedEvent' : component.get("v.selectedValue"),
             'InvoiceNumber':component.get("v.InvoiceNumber")
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var urlEvent = $A.get("e.force:navigateToURL");
                var res = response.getReturnValue();  
                if(res != 'Invalid Invoice Number'){
                    if(urlEvent) { 
                        urlEvent.setParams({
                            "url": res
                        }); 
                        urlEvent.fire();
                    } else {
                        window.location = res
                    }
                }else{
                    component.set("v.ErrorMessage",res); 
                }
            }
        });
        $A.enqueueAction(action);  
    },
})