({
	doInit : function(component, event, helper) { 
        var action=component.get('c.getFromToExamGroupList');  
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue();  
                component.set("v.ExamGroupList", result); 
                helper.getgroupWrapper(component);
            }
        });
        $A.enqueueAction(action);  
        component.set("v.spinner", false); 
    },SearchExamAdministrations : function(component, event, helper) { 
        component.set("v.fromExamAdminList",[]);
        component.set("v.examPartList",[]); 
        component.set("v.isSectionShow",'Group');
        component.set("v.isButtonDisabled", true);
        component.set("v.ToExamAdministrations",[]);
        component.set("v.ExamSiteMapList",[]); 
        component.set("v.examAdminExamList",[]); 
        
        var formToGroupobj = component.get("v.ExadminObj"); 
        component.set("v.isButtonDisabled",true);
        var ExamGroupList = component.get("v.ExamGroupList"); 
        if(formToGroupobj.FromGroupId ==null || formToGroupobj.ToGroupId == null){
            helper.showErrorToast('Please select From and To','error'); 
            return;
        }else if(formToGroupobj.FromGroupId == formToGroupobj.ToGroupId){
            helper.showErrorToast('From Date and To Group Date not be same','error');
            return;
        }else{
            var checkFromGroup = ExamGroupList.filter(obj => (obj.Id === formToGroupobj.FromGroupId)); 
            var checkToGroup = ExamGroupList.filter(obj => (obj.Id === formToGroupobj.ToGroupId));  
            if(checkFromGroup[0].Exam_Date__c > checkToGroup[0].Exam_Date__c){
                helper.showErrorToast('From Date Should be lessthan To Date','error');
                return;
            }
            else{
                component.set("v.spinner", true); 
                helper.getExamAdminList(component,formToGroupobj.FromGroupId,formToGroupobj.ToGroupId);   
            } 
        } 
    },getFromGroupExamSelection:function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');  
        var fromtoEmpty = component.get("v.fromtoEmpty");
        var selobjMap = {};
        var examtype = [];
        var examId = [];
        if(selectedRows.length == 0){
            component.set("v.isButtonDisabled",true);
        }else{
            component.set("v.isButtonDisabled",false);
        };
        for(var i=0;i<selectedRows.length;i++){
            selobjMap[selectedRows[i].Exam__c] = selectedRows[i].Id; 
            examtype.push(selectedRows[i].Exam__c);
            examId.push(selectedRows[i].Id);
        }
        component.set("v.ExadminObj.selectedExamType",examtype); 
        component.set("v.ExadminObj.fromRelatedExams",examId);
        component.set("v.ExadminObj.fromRelatedExamsMap",selobjMap);  
       
    },getAdminFromObject:function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.examPartList",[]);
        if(selectedRows.length != 0){
            component.set("v.ExadminObj.FromExamAdminId",selectedRows[0].Id); 
            helper.getAdminExamExamPartList(component);
        }
    },getselectedExamPart:function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        if(selectedRows.length == 0){
            component.set("v.isButtonDisabled",true);
        }else{
            component.set("v.isButtonDisabled",false);
        } 
        var selobjMap = {};
        var examtype = [];
        var examId = [];
        if(selectedRows.length == 0){
            component.set("v.isButtonDisabled",true);
        }else{
            component.set("v.isButtonDisabled",false);
        };
        for(var i=0;i<selectedRows.length;i++){
            selobjMap[selectedRows[i].Exam__r.Exam__c] = selectedRows[i].Id; 
            examtype.push(selectedRows[i].Exam__r.Exam__c);
            examId.push(selectedRows[i].Id);
        }
        component.set("v.ExadminObj.selectedExamType",examtype); 
        component.set("v.ExadminObj.fromRelatedExams",examId);
        component.set("v.ExadminObj.fromRelatedExamsMap",selobjMap); 
        
    },getToAdminSelection:function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        var ss =  event.getSource().get("v.title");  
        var mapval = component.get("v.ExamToAdminMapData");
        mapval[ss] = selectedRows; 
    },onClickNextButton:function(component, event, helper) {
        
        var fromtoEmpty = component.get("v.fromtoEmpty"); 
        var formToGroupobj = component.get("v.ExadminObj");
        var selExamType =[];
        var countMap = component.get("v.examPartMap");   
        var examTypeLst = []; 
        var frmcount = 0;
        var erpcount = 0;
        var isvalidateFrm = ''; 
        var isvalidateErp = ''; 
        //if(fromtoEmpty =='From To Empty' || fromtoEmpty =='From To Not Empty'){
            selExamType = component.get("v.ExadminObj.selectedExamType");
        //}   
        
        for(var i=0;i<selExamType.length;i++){   
            var selobjexam = selExamType[i]; 
            if(selobjexam.includes('FRM')){
                frmcount ++;  
                if(countMap['FRM'] != frmcount){
                    isvalidateFrm = 'FRM';
                }else{
                    isvalidateFrm = '';
                }
            }else if(selobjexam.includes('ERP')){
                erpcount ++;  
                if(countMap['ERP'] != erpcount){
                    isvalidateErp = 'ERP';
                }else{
                    isvalidateErp = '';
                }
            }  
            examTypeLst.push(selobjexam);
        }
       /* if(isvalidateFrm != '' || isvalidateErp != ''){  
            helper.showErrorToast('Both '+isvalidateFrm+''+isvalidateErp+' Need to be selected','error'); 
            return;
        }else{ */
              component.set("v.spinner", true); 
            component.set("v.examPartList",[]);
            component.set("v.selexamTypeLst",examTypeLst);
            if(fromtoEmpty == "From To Empty"){ 
                var actsite =  component.get("c.getSitesButton");
                $A.enqueueAction(actsite);
            }else{
                helper.getExamAdminToPartList(component,formToGroupobj.FromGroupId,formToGroupobj.ToGroupId,examTypeLst); 
                component.set("v.isSectionShow",'To Exam Admin'); 
            }  
        //} 
    },getSitesButton:function(component, event, helper){ 
        try{
        var examtypetemp =component.get("v.ExadminObj.selectedExamType");
        component.set("v.ExamSiteMapList",null);
        var fromtoEmpty = component.get("v.fromtoEmpty"); 
        var formToGroupobj = component.get("v.ExadminObj");
        var selval = [];
        var examType = []; 
         var isvalidate = true;
        if(fromtoEmpty == 'From To Empty'){
            examType = component.get("v.ExadminObj.selectedExamType");
            selval =  component.get("v.ExadminObj.fromRelatedExams");
        }
        if(fromtoEmpty != 'From To Empty'){
            selval = [];
            examType = [];
            var adminkeyMap ={};
            var mapval = component.get("v.ExamToAdminMapData"); 
            for(var key in mapval){ 
                for(var i=0;i<mapval[key].length;i++){
                    selval.push(mapval[key][i].Id); 
                    adminkeyMap[key] = mapval[key][i].Id;                     
                }
                examType.push(key);
            } 
           
            for(var i=0;i<examtypetemp.length;i++){ 
                if(!examType.includes(examtypetemp[i])){  
                    helper.showErrorToast('Configuration is not valid, Please select all Exam Parts','error'); 
                    return;
                }
                if(examtypetemp[i] == 'FRM Part 2'){
                    var frmpart1obj = mapval['FRM Part 1'];
                    var frmpart2obj = mapval[examtypetemp[i]];
                    if(frmpart1obj != null && frmpart1obj[0].Exam_Date__c !=undefined && frmpart2obj[0].Exam_Date__c !=undefined){ 
                        if(frmpart2obj[0].Exam_Date__c < frmpart1obj[0].Exam_Date__c){ 
                            helper.showErrorToast('FRM Part 1 Invalide Selection','error'); 
                            return;
                        }
                    }else if(frmpart1obj != null && frmpart1obj[0].Exam_End_Date__c !=undefined && frmpart2obj[0].Exam_End_Date__c !=undefined){ 
                        if(frmpart2obj[0].Exam_End_Date__c < frmpart1obj[0].Exam_End_Date__c){ 
                            helper.showErrorToast('FRM Part 1 Invalide Selection','error'); 
                            return;
                        }
                    }else if(frmpart1obj != null && frmpart1obj[0].Exam_Date__c !=undefined && frmpart2obj[0].Exam_End_Date__c !=undefined){ 
                        if(frmpart2obj[0].Exam_End_Date__c < frmpart1obj[0].Exam_Date__c){ 
                            helper.showErrorToast('FRM Part 1 Invalide Selection','error'); 
                            return;
                        }
                    }else if(frmpart1obj != null && frmpart1obj[0].Exam_End_Date__c !=undefined && frmpart2obj[0].Exam_Date__c !=undefined){ 
                        if(frmpart2obj[0].Exam_Date__c < frmpart1obj[0].Exam_End_Date__c){ 
                            helper.showErrorToast('FRM Part 1 Invalide Selection','error'); 
                            return;
                        }
                    }
                }else if(examtypetemp[i] == 'ERP Exam Part II'){
                    var erppart1obj = mapval['ERP Exam Part I'];
                    var erppart2obj = mapval[examtypetemp[i]];
                    if(erppart1obj != null && erppart1obj[0].Exam_Date__c !=undefined && erppart2obj[0].Exam_Date__c !=undefined){ 
                        if(erppart2obj[0].Exam_Date__c < erppart1obj[0].Exam_Date__c){ 
                            helper.showErrorToast('ERP Exam Part I Invalide Selection','error'); 
                            return;
                        }
                    }else if(erppart1obj != null && erppart1obj[0].Exam_End_Date__c !=undefined && erppart2obj[0].Exam_End_Date__c !=undefined){ 
                        if(erppart2obj[0].Exam_End_Date__c < erppart1obj[0].Exam_End_Date__c){ 
                            helper.showErrorToast('ERP Exam Part I Invalide Selection','error'); 
                            return;
                        }
                    }else if(erppart1obj != null && erppart1obj[0].Exam_Date__c !=undefined && erppart2obj[0].Exam_End_Date__c !=undefined){ 
                        if(erppart2obj[0].Exam_End_Date__c < erppart1obj[0].Exam_Date__c){ 
                            helper.showErrorToast('ERP Exam Part I Invalide Selection','error'); 
                            return;
                        }
                    }else if(erppart1obj != null && erppart1obj[0].Exam_End_Date__c !=undefined && erppart2obj[0].Exam_Date__c !=undefined){ 
                        
                        if(erppart2obj[0].Exam_Date__c < erppart1obj[0].Exam_End_Date__c){ 
                            helper.showErrorToast('ERP Exam Part I Invalide Selection','error'); 
                            return;
                        }
                    } 
                }
                
            }
            component.set("v.ExadminObj.ToAdiminSelectionMap",adminkeyMap);
            component.set("v.ExadminObj.selectedExamType",examType);
            component.set("v.ExadminObj.ToExamAdminId",selval);
        }  
        component.set("v.spinner", true); 
        helper.getExamSiteList(component,selval,examType);
        component.set("v.isSectionShow",'Exam Site');
        }catch(e){
          console.log('Exception '+e.message);  
        }
    },getSiteSelection:function(component, event, helper) { 
        var selectedRows = event.getParam('selectedRows');
        var siteclass =  event.getSource().get("v.class"); 
        var selmap = component.get("v.SelectedExamSiteMapList"); 
        var selId = selectedRows.map(e => e); 
        selmap[siteclass] = selId;  
    },saveExamAdmin: function(component, event, helper) {
        var selmap = component.get("v.SelectedExamSiteMapList");
        var fromtoEmpty = component.get("v.fromtoEmpty");
        var examType = component.get("v.ExadminObj.selectedExamType");
        var examsitemap = component.get("v.ExamSiteMapData");   
        var cmpobj =component.get("v.ExadminObj");
        if(cmpobj.ensOfExamGroup == ''){	
             helper.showErrorToast('Please Select End of Exam Group Registration Deferral','error'); 	
            return;	
        }
          component.set("v.spinner", true); 
        var action=component.get('c.saveExamAdmindata'); 
        action.setParams({"siteMap":selmap,"examType":examType,"allexamsitemap":examsitemap,"examwrap":JSON.stringify(cmpobj),"FromToAdminData":fromtoEmpty});
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result != null && result.includes('Success:')){
              	  helper.showErrorToast(result,'success'); 
                }else{
                    helper.showErrorToast(result,'error'); 
                }
            }
             $A.get('e.force:refreshView').fire(); 
        });
        $A.enqueueAction(action);
        
    },backButton: function(component, event, helper) {
        component.set("v.spinner", true); 
        $A.get('e.force:refreshView').fire();
    },hideSpinner : function(component,event,helper){ 
        component.set("v.spinner", false);
    }
    
})