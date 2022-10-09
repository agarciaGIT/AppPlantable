({
    
    createScholarshipRefund : function(component, event, helper,params) {
    
        var OppId = component.get("v.OppId");
       
        console.log(OppId);
       
        var params ={"oppid1":OppId};
        
        helper.callToServer(
            component,
            "c.Pricecal",
            function(response){
                console.log(JSON.stringify(response));
                if(response !='null')
                    alert(response); 
            
            },
            params
        );
  
    },
    
    showSpinner: function(component, event, helper) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event, helper) {
        //alert('hideSpinner');
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    }
    
})