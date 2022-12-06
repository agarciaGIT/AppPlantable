({
	init: function (component, event, helper) {
        //MembershipSwitchCMP
        console.log('in MembershipSwitchCMP   v.InvoiceNumber::>>  '+component.get("v.InvoiceNumber"));
        component.set("v.spinner",true);
        helper.helperMethod(component, event);
    }
})