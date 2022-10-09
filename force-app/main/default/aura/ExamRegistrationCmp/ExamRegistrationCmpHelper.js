({
    getExamgroup : function(component,event) {
        var action = component.get("c.getExamTypeList");   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                 var exgroup = [];
                for(var key in result){
                    exgroup.push({key: key, value: result[key]});
                } 
                component.set("v.ExamGroupMap", exgroup);
            }
        });
        $A.enqueueAction(action); 
    },onchangeExamGroupHelper :function(component, event){
        component.set('v.columns', [
            {label: 'Site Name', fieldName: 'Name', type: 'text'},
            {label: 'Site Code', fieldName: 'Site_Code__c', type: 'text'}, 
            {label: 'Exam Date', fieldName: 'Exam_Date__c', type: 'date-local',typeAttributes: {  day: 'numeric',  month: 'numeric', year: 'numeric' }}
        ]); 
        var searchInput = component.find("searchInput");
        var searchValue = searchInput.get("v.value"); 
        var selgroup = component.get("v.SelectedExamGroup");
        var action=component.get('c.getActiveSiteList');
        action.setParams({ 
            'examGroupId' : selgroup,'SearchKey':searchValue
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue(); 
                component.set("v.data", rows); 
            }
        });
        $A.enqueueAction(action);    
        
        component.set('v.maxRowSelection', 1);
        component.set('v.isButtonDisabled', true);
    },
})