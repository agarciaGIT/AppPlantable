({
    doInit : function(component, event, helper) {
        component.set("v.ErrorMessage","");
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'}, 
            {label: 'Section', fieldName: 'Section__c', type: 'text'}, 
            {label: 'Exam Date', fieldName: 'Exam_Date__c', type: 'date-local',typeAttributes: {  day: 'numeric',  month: 'numeric', year: 'numeric' }}
        ]); 
        var action = component.get("c.getExamRegistrations");  
        action.setParams({ 
            'contactId' :  component.get("v.contactId")
        }); 
        action.setCallback(this, function(response) { 
            var res = response.getReturnValue(); 
            if(res.ErrorMessage != null){
                component.set("v.ErrorMessage",res.ErrorMessage); 
            }else{ 
                var examatt =[];  
                
                for(var i=0;i<res.ExamAttemptList.length;i++){
                    var rec = res.ExamAttemptList[i]; 
                    if(res.ExamAttemptList.length == 2){
                        if(rec.Exam_Site__r.Name.includes('China') && rec.Section__c == 'FRM Part 2'){
                           //do nth
                        }else{
                             examatt.push(rec);
                        }
                    }else{
                        examatt.push(rec);
                    }
                   
                }
                if(res.ExamAttemptList.length != 0){
                component.set("v.data",examatt); 
                }
            } 
        });  
        $A.enqueueAction(action);    
    },onchangeExamAtt : function(component, event, helper){
        var selectedRows = event.getParam('selectedRows'); 
        if(selectedRows.length != 0){
            component.set('v.SelectedExamAtt', selectedRows[0].Id);
            if(selectedRows[0].Section__c ==  'FRM Part 2' || selectedRows[0].Section__c == 'ERP Part II'){
                component.set('v.isSelectedPart2', true);
            }else{
                component.set('v.isSelectedPart2', false); 
            }
            helper.getExamFromto(component);
        }
    },updateDeferral: function(component, event, helper){ 
       
         component.set("v.ErrorMessage",'');
        if(component.get("v.selectedFromDate") == '' || component.get("v.selectedToDate") == ''){
            component.set("v.ErrorMessage",'From and To Date Should not be None');
            return;
        }
         component.set("v.spinner", true);
        var action = component.get("c.saveOpportunityDeferral");  
        action.setParams({ 
            'contactId' :  component.get("v.contactId"),
            'FromDate' :component.get("v.selectedFromDate"),
            'ToDate':component.get('v.selectedToDate'),
            'SelectedExamAtt': component.get('v.SelectedExamAtt'),
            'isSelectedPart2':component.get('v.isSelectedPart2')
        }); 
        action.setCallback(this, function(response) { 
            var res = response.getReturnValue();
            alert(res); 
             helper.redirectpage(component);
        });  
        $A.enqueueAction(action); 
    },closeButton: function(component, event, helper){  
        helper.redirectpage(component);
    },hideSpinner : function(component,event,helper){ 
        component.set("v.spinner", false);
    }
})