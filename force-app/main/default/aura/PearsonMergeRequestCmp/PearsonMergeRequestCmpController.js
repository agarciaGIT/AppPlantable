({
	init : function(component, event, helper) {
        component.set("v.ErrorMessage","");
        component.set("v.SelectedExamGroup","");
        // component.set("v.data",[]);  
        var garp = component.get("v.garpId");
        if(garp == null){
            component.set("v.ErrorMessage","Please Enter GARP Id");
        }else{ 
            component.set("v.isshow",false);
            var action = component.get("c.GARPIdMergeRequest");  
            action.setParams({ 
                'GARPId' : garp
            }); 
            action.setCallback(this, function(response) { 
                var res = response.getReturnValue();  
                if (res == "Error") { 
                     component.set("v.ErrorMessage","Invalid GARP Member Id");
                }else if(res == "Error Info"){
                    component.set("v.ErrorMessage","Required SCR information is missing First Name, Last Name,Billing Address etc.. "); 
                }else if(res == "Error Contract"){
                    component.set("v.ErrorMessage","Pearson Merge Request Contract Not Found"); 
                }else{
                    component.set("v.retuenMessage",res);  
                    component.set("v.isshow",true);
                } 
            });  
            $A.enqueueAction(action);    
        }
    },BackButton : function(component, event, helper) {
        component.set("v.navigateNext",false);
        component.set("v.ErrorMessage","");
        component.set("v.selectedComponent","Member Services");
    }
})