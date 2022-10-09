({
    OnclickNextButton : function(component, event, helper){
        component.set("v.ErrorMessage","");
        var selvalue = component.get("v.selectedValue"); 
        if(selvalue=="None"){ 
            component.set("v.ErrorMessage","Please select the action");
        }else{
            if(selvalue == 'Ups Edit' || selvalue =='Create Switch Exam Fee' || selvalue == 'Switch Exam' || selvalue == 'Scholarship refund' || selvalue =='Update Opportunity Billing Info' || selvalue == 'Update Opportunity Price'){
                selvalue ="NavigateUrl";
            }
            component.set("v.selectedComponent",selvalue); 
        }
    },NextButtonNavigateUrl: function(component, event, helper){
        var invcNum = component.get("v.InvoiceNumber"); 
        if(invcNum == null || invcNum==''){
           component.set("v.ErrorMessage","Please Enter Invoice Number");  
        }else{
             component.set("v.ErrorMessage","");
            helper.getNavigateionUrl(component, event);
        }
    },BackButton: function(component, event, helper){
        component.set("v.selectedComponent","Member Services");
        component.set("v.InvoiceNumber","");
        component.set("v.ErrorMessage","");
        component.set("v.selectedValue","None");
    },showSpinner: function(component, event, helper) { 
        component.set("v.spinner", true);
    }, 
    hideSpinner : function(component,event,helper){ 
        component.set("v.spinner", false);
    }
})