({
    doInit : function(component, event, helper) {
        var action=component.get('c.getExamAttempt'); 
        component.set("v.spinner", true);
        component.set("v.ErrorMessage","");
        action.setParams({ 
            'recId' : component.get("v.recordId")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.ATAPSIParserList",[]);
                component.set("v.selectedExamReg", result);
                var toastEvent = $A.get("e.force:showToast"); 
                
                if(result.ATA_region_code__c != null && result.ATA_region_name__c != null && result.ATA_Cert_Type__c != null && result.ATA_Cert_id__c != null){
                    component.set("v.selectedExamType","ATA"); 
                }else if(result.ATA_region_code__c == null && result.ATA_region_name__c == null){                    
                    helper.getPsiIntegrationData(component);
                    helper.setPSIParserTableColumns(component); 
                }else{  
                    component.set("v.ErrorMessage","Please Check Exam Registration Configuration");
                }
            } 
        });
        $A.enqueueAction(action);    
    } ,BackButton: function(component, event, helper) {
        //  $A.get("e.force:closeQuickAction").fire();
        var recordId = component.get("v.recordId"); 
        if(component.get("v.UITheme") != 'Theme3'){ 
            sforce.one.navigateToURL('/one/one.app#/sObject/'+recordId+'/view',true); 
        } else { 
            window.location = '/'+recordId;
        } 
    },getATAIntegrationData : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast"); 
        component.set("v.ErrorMessage","");
        var seltype = component.get("v.selectedIntegrationType");
        if(seltype != null && seltype != ''){
            component.set("v.ATAPSIParserList",[]);
            helper.getAtaIntegrationData(component);
            helper.seATAtParserTableColumns(component);
        }else{ 
            component.set("v.ErrorMessage","Please Select Integration Type");
        }
    },hideSpinner : function(component,event,helper){ 
        component.set("v.spinner", false);
    }
})