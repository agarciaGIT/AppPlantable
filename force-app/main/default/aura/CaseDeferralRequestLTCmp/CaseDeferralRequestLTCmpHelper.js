({
    getExamFromto : function(component) {
        var action = component.get("c.getFromToDateList");  
        action.setParams({ 
            'SelectedExamAtt' :  component.get("v.SelectedExamAtt")
        }); 
        action.setCallback(this, function(response) { 
            var res = response.getReturnValue();  
            component.set("v.FromDateList",res.FromExamDate); 
            component.set("v.ToDateList",res.ToExamDate);   
        });  
        $A.enqueueAction(action); 
    },redirectpage:function(component) {
        var recordId = component.get("v.caseId"); 
        if(component.get("v.UITheme") != 'Theme3'){ 
            sforce.one.navigateToURL('/one/one.app#/sObject/'+recordId+'/view',true); 
        } else { 
            window.location = '/'+recordId;
        }  
    }
})