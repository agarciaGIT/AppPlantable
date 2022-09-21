({
    doInit : function(component, event, helper,params) {
        console.log('calling do int');
        var params ={"name":component.get("v.invoiceNumber")};
        helper.callToServer(
            component,
            "c.getcontact",
            function(response){
                console.log(JSON.stringify(response));
               
                
            },
            params
        );
    }
})