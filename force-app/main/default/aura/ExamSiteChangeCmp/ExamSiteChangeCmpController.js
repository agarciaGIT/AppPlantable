({
	OnclickSearchButton : function(component, event, helper) {
		 var garp  = component.get("v.GARPId");
        component.set("v.ExamAttemptdata", []); 
        component.set("v.data", []); 
        component.set('v.selectedSite', null);
        component.set('v.selectedExamAttempt', null);  
         if(garp == null){
            component.set("v.ErrorMessage","Please Enter GARP Member Id");
        }else{  
            var action = component.get("c.GARPIdValidation");  
            action.setParams({ 
                'GARPId' : garp
            }); 
            action.setCallback(this, function(response) { 
                var res = response.getReturnValue(); 
                if(res == "Error"){
                     component.set("v.ErrorMessage","Invalid GARP Member Id");
                }else if(res =="Error Address"){
                    component.set("v.ErrorMessage","Billing Address Not found");
                }else{  
                    component.set("v.RegistredFRMProgram","showGroup");
                    component.set("v.contactId",res);  
                    helper.examAttemptDetails(component);
                } 
            });  
            $A.enqueueAction(action);    
        } 
	},BackButton : function(component, event, helper) {
        component.set("v.selectedComponent","Member Services");
    },OnclickExamAttemptdata : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        if(selectedRows.length != 0){
      	  component.set('v.selectedExamAttempt', selectedRows[0].Id);
        }
        component.set("v.data", []); 
        component.set('v.selectedSite', null); 
        helper.onchangeExamGroupHelper(component,event); 
    },onchangeExamGroup: function(component, event, helper) {
         component.set("v.data", []); 
        component.set('v.selectedSite', null); 
        helper.onchangeExamGroupHelper(component,event); 
    },OnclickselectedExamSite : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        if(selectedRows.length != 0){
            component.set('v.selectedSite', selectedRows[0].Id); 
        }
    },UpdateExamSiteChange :function(component, event, helper) {
        var siteId = component.get("v.selectedSite");  
         var examattemptId = component.get("v.selectedExamAttempt");
         component.set("v.ErrorMessage",""); 
        if(siteId != null && examattemptId != null){
        var action = component.get("c.ExamSiteChangeUpdate");  
            action.setParams({ 
                'siteId' : siteId,
                'examAttemptId' : examattemptId,
                'contactId' : component.get("v.contactId")
            }); 
            action.setCallback(this, function(response) { 
                var res = response.getReturnValue();   
                component.set("v.examstatusList",res);
                component.set("v.isModalOpen",true);
            });  
            $A.enqueueAction(action); 
        }else{
            component.set("v.ErrorMessage","Please select Exam Site and Exam Attempt"); 
        }
    },closepopup : function(component, event, helper) { 
    	component.set("v.isModalOpen",false); 
       component.set("v.selectedComponent","Member Services");
    }
})