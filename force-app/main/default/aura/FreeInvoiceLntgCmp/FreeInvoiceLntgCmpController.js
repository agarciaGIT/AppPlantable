({
	init: function (component, event, helper) {
        component.set("v.spinner",true);
        console.log('component.get("v.InvoiceNumber")========>'+component.get("v.InvoiceNumber"));
        helper.init(component, event);
    }
})