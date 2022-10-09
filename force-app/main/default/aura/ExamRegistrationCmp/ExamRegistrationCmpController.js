({
    OnclickNextButton : function(component, event, helper) {
        component.set("v.ErrorMessage","");
        component.set("v.SelectedExamGroup","");
        component.set("v.data",[]);  
        var garp = component.get("v.GARPId");
        if(garp == null){
            component.set("v.ErrorMessage","Please Enter GARP Id");
        }else{ 
            component.set("v.isshow",false);
            var action = component.get("c.GARPIdValidation");  
            action.setParams({ 
                'GARPId' : garp
            }); 
            action.setCallback(this, function(response) { 
                var res = response.getReturnValue();  
                if (res == "Error") { 
                     component.set("v.ErrorMessage","Invalid GARP Member Id");
                }else if(res == "Error Address"){
                    component.set("v.ErrorMessage","Billing Address Not found"); 
                }else if(res == "Error ERP"){
                    component.set("v.ErrorMessage","We can't perform this operation"); 
                }else{
                    component.set("v.contactId",res); 
                    component.set("v.isshow",true);
                    helper.getExamgroup(component, event);
                } 
            });  
            $A.enqueueAction(action);    
        }
    }
    ,BackButton : function(component, event, helper) {
        component.set("v.ErrorMessage","");
        component.set("v.selectedComponent","Member Services");
    },BacktoExamRegistration: function(component, event, helper) {
         component.set("v.ErrorMessage","");
        component.set("v.isshow",false);
        component.set("v.RegistredFRMProgram","showGroup"); 
    }, onchangeExamGroup : function(component, event, helper) {
        component.set("v.data",[]);
        component.set('v.selectedSite', null);
        helper.onchangeExamGroupHelper(component,event); 
    }, OnclickselectedSite: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows'); 
        if(selectedRows.length != 0){
            cmp.set('v.selectedSite', selectedRows[0].Id);
        } 
    }, 
    NextExamRegistration : function(component,event,helper){
        if(component.get("v.selectedSite") != null){
         var action = component.get("c.ExamRegistration");   
            action.setParams({ 
                'ContactId' : component.get("v.contactId"),
                'examGroupId' : component.get("v.SelectedExamGroup"),
                'selectedSite' : component.get("v.selectedSite")
            }); 
            action.setCallback(this, function(response) { 
                var result = response.getReturnValue();  
                 component.set("v.ExamPartoptionsMap",result);
                var arrayMapKeys = [];   
                for(var key in result){
                    for(var i=0;i<result[key].length;i++){
                        arrayMapKeys.push({label: result[key][i], value: result[key][i]});
                    } 
                    component.set("v.RegistredFRMProgram",key); 
                    if(key == 'Error'){
                        component.set("v.ErrorMessage","Not able to Register"); 
                    }
                }
                component.set("v.ExamPartoptions", arrayMapKeys);
                if(arrayMapKeys.length == 0){
                    component.set("v.ErrorMessage","Not able to Register"); 
                    component.set("v.RegistredFRMProgram","Error"); 
                }
            });  
            $A.enqueueAction(action); 
        }else{
            component.set("v.ErrorMessage","Please Select Exam Site"); 
        }
    },CreateExamRegistration  : function(component,event,helper){ 
        var action = component.get("c.CreateExamRegistrations");  
        if(component.get("v.selectedPayType") == null || component.get("v.selectedExamPart") == null){
            component.set("v.ErrorMessage","Please select Pay Type/Exam Part");
        }else{
             component.set("v.ErrorMessage","");
            action.setParams({ 
                'contactId' : component.get("v.contactId"),
                'examGroupId' : component.get("v.SelectedExamGroup"),
                'selectedSite' : component.get("v.selectedSite"),
                'payType' : component.get("v.selectedPayType"),
                'selexamPart' : component.get("v.selectedExamPart"),
                'examRegistredMap': component.get("v.ExamPartoptionsMap")
            }); 
            action.setCallback(this, function(response) { 
                var res = response.getReturnValue();   
                 component.set("v.isModalOpen",true); 
                 component.set("v.DeferredstatusList",res); 
            });  
            $A.enqueueAction(action); 
        }
    },closepopup : function(component, event, helper) { 
    	component.set("v.isModalOpen",false); 
        component.set("v.selectedComponent","Member Services");
    },
})