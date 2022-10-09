({
	doinIt : function(component, event, helper) {
        component.set("v.hideSpinner",true);
        var recId = component.get("v.recordId");
        var action = component.get("c.sendNotificationButtonAura");
        component.set("v.msg","Sending...");
        debugger;
        action.setParams({
            notificationId :recId
        });
        action.setCallback(this, function (response) {
            var retVal = response.getReturnValue();
            //alert('ret:' + retVal);
            if(retVal == true) {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            } else {
                component.set("v.msg","Notficiation not approved or already sent.");
            }
        });
        $A.enqueueAction(action);
    }
})