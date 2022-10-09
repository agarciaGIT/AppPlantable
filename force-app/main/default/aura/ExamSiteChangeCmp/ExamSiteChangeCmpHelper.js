({
	examAttemptDetails : function(component,ExamDate) {
        component.set("v.ErrorMessage","");
        component.set('v.ExamAttemptcolumns', [ 
            {label: 'Exam Site Name', fieldName: 'Exam_Site_Name__c', type: 'text'}, 
            {label: 'Site Code', fieldName: 'Site_Code__c', type: 'text'}, 
            {label: 'Section', fieldName: 'Section__c', type: 'text'},
            {label: 'Defered', fieldName: 'Defered__c', type: 'text'},
            {label: 'Exam Date', fieldName: 'Exam_Date__c', type: 'date-local',typeAttributes: { day: 'numeric',  month: 'numeric', year: 'numeric'}}
        ]); 
          
        var action=component.get('c.getexamAttemptDetailsList');
        action.setParams({ 
            'contactId' : component.get("v.contactId")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var examAttempt = [];
                 var result = response.getReturnValue();
                 for(var key in result){ 
                    for(var i=0;i<result[key].length;i++){  
                         examAttempt.push(result[key][i]);  
                  	} 
                  if(key == 'Error'){
                        component.set("v.ErrorMessage","System Shows that member has registered for other program please contact IT"); 
                    }
                }
                component.set("v.ExamAttemptdata", examAttempt); 
            } 
        });
        $A.enqueueAction(action);  
        component.set('v.maxRowSelection', 1);
        component.set('v.isButtonDisabled', true);
    },onchangeExamGroupHelper :function(component, event){
        component.set('v.columns', [
            {label: 'Site Name', fieldName: 'Name', type: 'text'},
            {label: 'Site Code', fieldName: 'Site_Code__c', type: 'text'}, 
            {label: 'Exam Date', fieldName: 'Exam_Date__c', type: 'date-local',typeAttributes: { day: 'numeric',  month: 'numeric', year: 'numeric'}}
        ]); 
        var searchInput = component.find("searchInput"); 
        var selgroup = component.get("v.selectedExamAttempt");
        var action=component.get('c.getSiteList');
         var searchValue = searchInput.get("v.value"); 
        action.setParams({ 
            'examAttemptId' : selgroup,'SearchKey':searchValue
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
    }
})