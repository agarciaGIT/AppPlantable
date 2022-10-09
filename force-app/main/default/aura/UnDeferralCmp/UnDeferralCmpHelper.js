({
    examAttemptDetails : function(component,ExamDate) {
        var selval = component.get("v.SelectedcurrentExamGrp");
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Exam Site Name', fieldName: 'Exam_Site_Name__c', type: 'text'}, 
            {label: 'Site Code', fieldName: 'Site_Code__c', type: 'text'}, 
            {label: 'Section', fieldName: 'Section__c', type: 'text'},
            {label: 'Defered', fieldName: 'Defered__c', type: 'text'},
            {label: 'Exam Date', fieldName: 'Exam_Date__c', type: 'date-local',typeAttributes: { day: 'numeric',  month: 'numeric', year: 'numeric'}}
        ]); 
        
        var action=component.get('c.getexamAttemptDetailsList');
        action.setParams({ 
            'contactId' : component.get("v.contactId"),
            'ExamDate' : ExamDate 
        }); 
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var examAttempt = [];
                 var result = response.getReturnValue();
                 for(var key in result){ 
                    for(var i=0;i<result[key].length;i++){ 
                       
                       if((selval == 'Yes' && result[key][i].Defered__c =='Approved') || (selval=='No' && result[key][i].Defered__c == 'Pending')){
                          examAttempt.push(result[key][i]);
                       }
                  } 
                  if(key == 'Error'){
                        component.set("v.ErrorMessage","System Shows that member has registered for other program please contact IT"); 
                    }
                }
                component.set("v.data", examAttempt); 
            }
        });
        $A.enqueueAction(action);  
        component.set('v.maxRowSelection', 1);
        component.set('v.isButtonDisabled', true);
    }
})