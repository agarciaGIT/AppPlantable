({
    getgroupWrapper : function(component) {
        var action=component.get('c.getwrapper');  
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue();  
                component.set("v.ExadminObj", result); 
            }
        });
        $A.enqueueAction(action); 
    },
    showErrorToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            message:message, 
            duration:'4000',
            key: 'info_alt',
            type: type,
            mode: 'pester'
        });
        toastEvent.fire();
        return;
    },getExamAdminList: function(component,fromId,toId){
        component.set('v.Admincolumns', [
            {label: 'Name', fieldName: 'Name', type: 'text'}, 
            {label: 'Exam Date', fieldName: 'Exam_Date__c', type: 'date-local'},
            {label: 'Exam Start Date', fieldName: 'Exam_Start_Date__c',type: 'date-local'},
            {label: 'Exam End Date', fieldName: 'Exam_End_Date__c', type: 'date-local'},
            {label: 'Exam Type', fieldName: 'Exam_Type__c', type: 'text'}
        ]);  
        var action=component.get('c.getExamAdministrationsList');  
        action.setParams({"fromId":fromId,
                          "toId":toId 
                         });
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue();  
                component.set("v.fromtoEmpty",result.FromToAdminData); 
                if(result.FromToAdminData == 'From To Not Empty'){
               		component.set("v.fromExamAdminList", result.ExamadminFromList);  
                }else if(result.FromToAdminData == 'From To Empty' || result.FromToAdminData == 'From Empty'){
                    this.getExamFromGroupExamList(component,fromId,toId); 
                }else if(result.FromToAdminData == 'To Empty'){
                    this.showErrorToast('Configuration is not valid','error');
                } 
            }
        });
        $A.enqueueAction(action);
    },getExamFromGroupExamList:function(component,fromId,toId){
      component.set('v.columns', [
          {label: 'Exam', fieldName: 'Exam__c', type: 'text'},
          {label: 'Name', fieldName: 'Name', type: 'text'}, 
          {label: 'Exam Date', fieldName: 'Exam_Date__c', type: 'date-local'}
        ]);  
        var action=component.get('c.getExamAdminExamList');  
        action.setParams({"fromId":fromId,
                          "toId":toId 
                         });
        action.setCallback(this, function(response){
            var state = response.getState();  
            var frmCount =1;
			var erpCount = 1;
            if (state === "SUCCESS") {
                var result = response.getReturnValue();  
                component.set("v.examAdminExamList",result); 
                var resMap =  component.get("v.examPartMap");
                for(var i=0;i < result.length;i++){
                    var row = result[i];  
                    if(row.Exam__c.includes('FRM')){
                        resMap["FRM"] = frmCount++; 
                    }else if(row.Exam__c.includes('ERP')){
                        resMap["ERP"] = erpCount++;
                    } 
                }  
                component.set("v.examPartMap",resMap);
            }
        });
        $A.enqueueAction(action);
    },getAdminExamExamPartList: function(component){
        component.set('v.examPartcolumns', [
            {label: 'Exam', fieldName: 'Exam', type: 'text'}, 
            {label: 'Exam Date', fieldName: 'Exam_Date__c', type: 'date-local'},
            {label: 'Exam Start Date', fieldName: 'Exam_Start_Date__c',type: 'date-local'},
            {label: 'Exam End Date', fieldName: 'Exam_End_Date__c', type: 'date-local'},
            {label: 'Delivery Method', fieldName: 'Delivery_Method__c', type: 'text'}
        ]);
        var action=component.get('c.getExamExamPartList');  
        action.setParams({"examAdminId":component.get("v.ExadminObj.FromExamAdminId")});
        action.setCallback(this, function(response){
            var state = response.getState(); 
            var frmCount =1;
            var erpCount = 1;
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var resMap =  component.get("v.examPartMap");
                for(var i=0;i < result.length;i++){
                    var row = result[i];
                    if(row.Exam__c){
                        row.Exam = row.Exam__r.Exam__c; 
                        if(row.Exam.includes('FRM')){
                            resMap["FRM"] = frmCount++; 
                        }else if(row.Exam.includes('ERP')){
                            resMap["ERP"] = erpCount++;
                        }
                    } 
                } 
                component.set("v.examPartList",result);
                component.set("v.examPartMap",resMap);
            }
        });
        $A.enqueueAction(action);
    },getExamAdminToPartList: function(component,fromId,toId,examType){ 
         
        var action=component.get('c.getToExamadminList');  
        action.setParams({"fromId":fromId,"toId":toId,"examType":examType});
        action.setCallback(this, function(response){
            var state = response.getState();   
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                var arrayMapKeys = [];
                for(var key in result){
                    arrayMapKeys.push({key: key, value: result[key]});
                } 
                component.set("v.ToExamAdministrations",arrayMapKeys);  
            }
        });
        $A.enqueueAction(action);
    },getExamSiteList: function(component,selecetedToExam,examType){ 
        component.set('v.ExamSitecolumns', [
            {label: 'Id', fieldName: 'Id', type: 'text'},
            {label: 'Exam Site Name', fieldName: 'Name', type: 'text'},
            {label: 'Site Name', fieldName: 'SiteName', type: 'text'},
            {label: 'Site Code', fieldName: 'SiteCode', type: 'text'}
        ]);
        var action=component.get('c.getExamPartSiteList');  
       // getExamPartSiteList(String fromgroupId,String toGroupId,List<String> selectedGroupFromexam,String selecetedFromExam,List<String> selecetedToExam,List<String> examType,String FromToAdminData)
        var togroup = component.get("v.ExadminObj.ToGroupId");
        action.setParams({"fromgroupId":component.get("v.ExadminObj.FromGroupId"),
                          "toGroupId":component.get("v.ExadminObj.ToGroupId"),
                          "selectedGroupFromexam":component.get("v.ExadminObj.fromRelatedExams"),
                          "selecetedFromExam":component.get("v.ExadminObj.FromExamAdminId"),
                          "selecetedToExam":selecetedToExam,
                          "examType":examType,
                          "FromToAdminData":component.get("v.fromtoEmpty")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var FRMFRPpartlist = {};
                    var arrayMapKeys = [];
                    for(var key in result){
                        for(var i=0;i<result[key].length;i++){
                            var row = result[key][i];
                            if(row.Site__c){
                                row.SiteName =row.Site__r.Name;
                                row.SiteCode = row.Site__r.Site_Code__c;
                            }
                            if(key == 'ERP Exam Part II' || key== 'FRM Part 2'){
                                FRMFRPpartlist[key] = result[key]
                            }
                        } 
                        arrayMapKeys.push({key: key, value: result[key]});
                    }
                	component.set("v.ExamSiteMapData",FRMFRPpartlist);
                    component.set("v.ExamSiteMapList", arrayMapKeys); 
            }
        });
        $A.enqueueAction(action);
    } 
})