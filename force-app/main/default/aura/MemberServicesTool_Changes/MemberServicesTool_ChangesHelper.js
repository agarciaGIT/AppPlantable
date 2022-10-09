({
    getExamRegistrations : function(component,event,helper) {
        var action = component.get("c.getRegistrations");
        action.setParams({garpId:component.get("v.garpId")});
        action.setCallback(this,function(response){
        	var state = response.getState();
            if(state === "SUCCESS"){
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Exam_Administration__c) row.ExamAdminName = row.Exam_Administration__r.Name;
                    if (row.Exam_Site__c) row.ExamSiteName = row.Exam_Site__r.Name;
                }
                component.set("v.registrations", rows);
                
            }
        });
        $A.enqueueAction(action);
    },
    getExamGroups : function(component,event,helper) {
        var action = component.get("c.getExamGroups");
        action.setParams({examAttemptList:component.get("v.selectedRegistrations")});
        action.setCallback(this,function(response){
        	var state = response.getState();
            if(state === "SUCCESS"){
                var rows = response.getReturnValue();
                component.set("v.examGrpOptions", rows);
                component.set("v.showPicklists",true);
                component.set("v.showExamGrp",true);
                component.set("v.showRegistrations",false);
            }
        });
        $A.enqueueAction(action);
    },
	getExamAdmins : function(component,event,helper) {
        var groupId = component.get("v.selectedGrp");
		var action = component.get("c.getExamAdministrations");
        action.setParams({examGroupId:groupId,examAttemptList:component.get("v.selectedRegistrations")});
        action.setCallback(this,function(response){
        	var state = response.getState();
            if(state === "SUCCESS"){
                var responseMap = response.getReturnValue();
                if(responseMap.hasOwnProperty(1)){
                    component.set("v.part1AdminOptionsMap",responseMap[1]);
                    var examAdmins =[];
                    var examAdminMap = responseMap[1];
                    for ( var key in examAdminMap) {
                        examAdmins.push(examAdminMap[key]);
                    }
                    component.set('v.part1AdminOptions', examAdmins);
                }
                if(responseMap.hasOwnProperty(2)){
                    component.set("v.part2AdminOptionsMap",responseMap[2]);
                    var examAdmins =[];
                    var examAdminMap = responseMap[2];
                    for ( var key in examAdminMap) { 
                        examAdmins.push(examAdminMap[key]);
                    }
                    component.set('v.part2AdminOptions', examAdmins);
                }
            }
        });
        $A.enqueueAction(action);
	},
    getExamSites : function(component,adminId,examPart) {
        var selectedTypes = component.get("v.selectedRegistrationsTypes");
        var part1Admins = component.get("v.part1AdminOptionsMap");
        var part2Admins = component.get("v.part2AdminOptionsMap");
		var action = component.get("c.getExamSites");
        action.setParams({examAdminId:adminId,selectedTypes:selectedTypes,examType:examPart});
        action.setCallback(this,function(response){
        	var state = response.getState();
            if(state === "SUCCESS"){
                if(part1Admins != null && part1Admins[adminId] != null && part1Admins[adminId].Exam_Group__r.Active__c === false && part1Admins[adminId].Exam_Group__r.SCR_Active__c === false){
                     component.set("v.showExamSitePart1",false);
                }
                if(part2Admins!= null && part2Admins[adminId] != null && part2Admins[adminId].Exam_Group__r.Active__c === false){
                    component.set("v.showExamSitePart2",false);
                }
                if(examPart == "Part 1"){
                    component.set("v.part1ExamSiteOptions",response.getReturnValue());
                }else if(examPart == "Part 2"){
                    component.set("v.part2ExamSiteOptions",response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
	},
    saveData : function(component, event, helper) {
        var garpId = component.get("v.garpId");
        var selectedRegs = component.get("v.selectedRegistrations");
        var selectedAdmin1 = component.get("v.selectedAdmin1");
        var selectedAdmin2 = component.get("v.selectedAdmin2");
        var selectedExamSite1 = component.get("v.selectedExamSite1");
        var selectedExamSite2 = component.get("v.selectedExamSite2");
        var freeDefferalCheck = component.get("v.freeDeferralValue");
        var oneTimeDeferralCheck = component.get("v.oneTimeDeferralValue");
        var part1Admins = component.get("v.part1AdminOptionsMap");
        var part2Admins = component.get("v.part2AdminOptionsMap");
        var typeSelected = component.get("v.typeSelected");
        var subType = component.get("v.selectedSubType");
        //console.log('Admin 1:'+selectedAdmin1);
        //console.log('Admin 2:'+selectedAdmin2);
        var movingToActiveGroup = false;
        if(typeSelected === 'Defer' && selectedAdmin1 !== undefined){
            if(part1Admins[selectedAdmin1].Exam_Group__r.Active__c === true && selectedRegs[0].Exam_Administration__r.Exam_Group__r.Active__c === false){
				movingToActiveGroup = true;                
            }else if(part1Admins[selectedAdmin1].Exam_Group__r.SCR_Active__c === true && selectedRegs[0].Exam_Administration__r.Exam_Group__r.SCR_Active__c === false){
                movingToActiveGroup = true;
            }
        }else if(typeSelected === 'Defer' && selectedAdmin2 !== undefined){
            if(part2Admins[selectedAdmin2].Exam_Group__r.Active__c === true && selectedRegs[0].Exam_Administration__r.Exam_Group__r.Active__c === false){
            	movingToActiveGroup = true;
            }
        }
        var wrapper = {'garpId':garpId,
                       'registrations':selectedRegs,
                       'part1Administration':selectedAdmin1,
                       'part2Administration':selectedAdmin2,
                       'part1ExamSite':selectedExamSite1,
                       'part2ExamSite':selectedExamSite2,
                       'freeDeferral':freeDefferalCheck,
                       'movingToActiveGroup':movingToActiveGroup,
                       'oneTimeDeferral':oneTimeDeferralCheck,
                       'changeType':typeSelected,
                       'subType':subType};
        console.log(wrapper);
		var action = component.get("c.saveData");
        action.setParams({requestWrapper:JSON.stringify(wrapper)});
        action.setCallback(this,function(response){
        	var state = response.getState();
            //console.log('State'+state);
            if(state === "SUCCESS"){
                component.set("v.spinner",false);
                if(response.getReturnValue() === "SUCCESS"){
                    component.set("v.errorMsg","");
            		component.set("v.showError",false);
                    component.set("v.saveCompleted",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Data saved successfully',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }else{
                    component.set("v.errorMsg",response.getReturnValue());
            		component.set("v.showError",true);
                }
            }else{
                component.set("v.errorMsg","Data save failed, please contact Admin");
            	component.set("v.showError",true);
                component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
	}
})