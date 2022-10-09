({
    SearchButton : function(component, event, helper) {
        var garp = component.get("v.GARPId");
        component.set("v.SelectedcurrentExamGrp",null);
        component.set("v.SelectedFreeDeferral",null);
        component.set("v.SelectedChargeProcessing",null);
        component.set("v.selectedSite",null); 
        component.set("v.data",[]);
        if(garp == null){
            component.set("v.ErrorMessage","Please Enter GARP Member Id");
        }else{ 
            component.set("v.ErrorMessage","");
            var action = component.get("c.GARPIdValidation");  
            action.setParams({ 
                'GARPId' : garp
            }); 
            action.setCallback(this, function(response) { 
                var res = response.getReturnValue();  
                if(res == "Error"){
                    component.set("v.ErrorMessage","Invalid GARP Member Id");
                }else if(res == "Error Address"){
                    component.set("v.ErrorMessage","Billing Address Not found"); 
                }else{  
                    component.set("v.ScreenSelection","UnDeferral Selection");
                    component.set("v.contactId",res); 
                }  
            });  
            $A.enqueueAction(action);    
        }
    },
    handleChange : function(component, event, helper) {
        component.set("v.selectedSite",null); 
        component.set("v.data",[]);
        component.set("v.SelectedDeferralFrom","None");
        component.set("v.SelectedDeferralTo","None");
        var changeValue = event.getParam("value"); 
        var action = component.get("c.getExamGroupsList");   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.TempExamGroupMap", result); 
                var exgroup = [];
                for(var key in result){ 
                    exgroup.push({key: key, value: result[key]});
                }
                component.set("v.ExamGroupMap", exgroup); 
                
            }
        });
        $A.enqueueAction(action); 
    },BackButton : function(component, event, helper) {
        component.set("v.GARPId",null);
        component.set("v.selectedComponent","Member Services");
    },SearchExamAttempt: function(component, event, helper) {
        component.set("v.ErrorMessage","");
        var selval = component.get("v.SelectedcurrentExamGrp");
        var FromGroup = component.get("v.SelectedDeferralFrom");
        var ToGroup = component.get("v.SelectedDeferralTo");
        var examgroup = component.get("v.TempExamGroupMap");
        var FreeDeferral= component.get("v.SelectedFreeDeferral");
        var ChargeProcess= component.get("v.SelectedChargeProcessing");
        if(selval == null){
            component.set("v.ErrorMessage","Please select Do you want to move Registration");  
            return;
        }
        if(FreeDeferral == null){
            component.set("v.ErrorMessage","Please select Free Deferral");  
            return;
        }
        if(FreeDeferral == 'No' && ChargeProcess == null){
            component.set("v.ErrorMessage","Please select Charge Processing"); 
            return;
        } 
        if(FromGroup != 'None' && FromGroup != null){
            component.set("v.FromExamDate",examgroup[FromGroup].Exam_Date__c);
        }
        if(ToGroup != 'None' && ToGroup != null){
            component.set("v.ToExamdate",examgroup[ToGroup].Exam_Date__c);
        }
        if(selval == 'Yes'){ 
            if(FromGroup != 'None' && ToGroup != 'None'){ 
                if(examgroup[FromGroup].Exam_Date__c <= examgroup[ToGroup].Exam_Date__c){
                    component.set("v.ErrorMessage","Deferral From Should be less than Deferral To"); 
                }else{
                    helper.examAttemptDetails(component,examgroup[FromGroup].Exam_Date__c);
                    component.set("v.ScreenSelection","Site Selection"); 
                } 
            }else{
                component.set("v.ErrorMessage","Please Select Deferral From and Deferral To");
                
            }
        }else if(selval == "No"){
            if(ToGroup != 'None'){
                helper.examAttemptDetails(component,examgroup[ToGroup].Exam_Date__c);
                component.set("v.ScreenSelection","Site Selection"); 
            }  else{
                component.set("v.ErrorMessage","Please Select Deferral To");
            }
        }
    },OnclickselectedExamSite: function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
       if(selectedRows.length != 0){
            component.set('v.selectedSite', selectedRows[0].Id);
        }
    },updateDeferral: function(component, event, helper) { 
        var action = component.get("c.updateDeferralDetail");  
        action.setParams({ 
            'examAttemptId' : component.get('v.selectedSite'),
            'currentExamGrp' : component.get('v.SelectedcurrentExamGrp'),
            'FreeDeferral' : component.get('v.SelectedFreeDeferral'),
            'ChargeProcessing' : component.get('v.SelectedChargeProcessing'),
            'FromExamDate' : component.get('v.FromExamDate'),
            'ToExamdate' : component.get('v.ToExamdate')
        }); 
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                 var res = response.getReturnValue();  
                 component.set("v.isModalOpen",true); 
                 component.set("v.DeferredstatusList",res);  
            }
        });  
        $A.enqueueAction(action);    
    },closepopup : function(component, event, helper) { 
    	component.set("v.isModalOpen",false); 
        component.set("v.selectedComponent","Member Services");
    },handleFreeDeferral: function(component, event, helper) { 
        component.set("v.SelectedChargeProcessing",null); 
    },BackButtonUnDeferral: function(component, event, helper) { 
        component.set("v.ErrorMessage","");
        component.set("v.SelectedcurrentExamGrp",null);
        component.set("v.SelectedFreeDeferral",null);
        component.set("v.SelectedChargeProcessing",null);
        component.set("v.selectedSite",null); 
        component.set("v.data",[]);
    	component.set("v.ScreenSelection",null);
    }
})