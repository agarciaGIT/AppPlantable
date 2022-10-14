({
    doInit : function(component, event, helper,params) {
        console.log('calling do int');
        var params ={"name":component.get("v.invoiceNumber")};
        helper.callToServer(
            component,
            "c.returndata",
            function(response){
               
                console.log(JSON.stringify(response));
                component.set("v.invoiceNumber",response.invoiceNumber);
                component.set("v.chinaSelection",response.china); 
                component.set("v.PayType",response.payType);
                var showExamSite =  component.get("v.chinaSelection"); 
                if (showExamSite == "Yes") {     
                    component.set("v.showExamSiteId", true);
                }
                
            },
            params
        );
        
    },
    createSwitchOrder : function(component, event, helper,params) {
    
        var seedetail = component.get("v.invoiceNumber");
        var PayType =  component.get("v.PayType");
        var chinaSelection =  component.get("v.chinaSelection");
        var examsiteid1 = component.get("v.examsiteid");
        
        console.log(seedetail);
        console.log(PayType);
       
        console.log(chinaSelection);
        console.log(examsiteid1);
     
        var params ={"name":seedetail,"payType":PayType,"china":chinaSelection,"examSiteId":examsiteid1};
        
        helper.callToServer(
            component,
            "c.cancelErpOrder",
            function(response){
                console.log(JSON.stringify(response));
                if(response.Message !='null')
                    alert(response.Message); 
            
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