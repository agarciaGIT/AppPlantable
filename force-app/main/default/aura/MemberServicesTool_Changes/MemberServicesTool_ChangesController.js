({
    doInit : function(component, event, helper){
        component.set('v.columns', [
            {label: 'Exam Part', fieldName: 'Section__c', type: 'text'},
            {label: 'Exam Administration', fieldName: 'ExamAdminName', type: 'text'},
            {label: 'Exam Site', fieldName: 'ExamSiteName', type: 'text'},
            {label: 'Exam Date', fieldName: 'Exam_Date__c', type: 'date'},
            {label: 'Result', fieldName: 'Result__c', type: 'text'}
        ]);
        var typeSelected = component.get("v.typeSelected");
        helper.getExamRegistrations(component,event,helper);
    },
    handleSelect : function(component, event, helper) {
        
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        var selectedTypes = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]);
            selectedTypes.push(selectedRows[i].Section__c);
		}
        component.set("v.selectedRegistrations", setRows);
        component.set("v.selectedRegistrationsTypes", selectedTypes);
        
    },onOptionSelectAdmin1: function (component, event, helper) {
        var selectedValue = component.find('part1ExamAdmin').get('v.value');
        var origValue = component.get("v.selectedAdmin1");
        component.set("v.selectedAdmin1",selectedValue);
        helper.getExamSites(component,selectedValue,'Part 1');
        
    },onOptionSelectAdmin2: function (component, event, helper) {
        var selectedValue = component.find('part2ExamAdmin').get('v.value');
        var origValue = component.get("v.selectedAdmin2");
        component.set("v.selectedAdmin2",selectedValue);
        console.log("Check This COndition 2");
        helper.getExamSites(component,selectedValue,'Part 2');
        
    },onExamSiteSelectPart1: function (component, event, helper) {
        var selectedValue = component.find('part1ExamSite').get('v.value');
        var origValue = component.get("v.selectedExamSite1");
        component.set("v.selectedExamSite1",selectedValue);
        
    },onExamSiteSelectPart2: function (component, event, helper) {
        var selectedValue = component.find('part2ExamSite').get('v.value');
        var origValue = component.get("v.selectedExamSite2");
        component.set("v.selectedExamSite2",selectedValue);
        
    },onSubTypeSelect: function (component, event, helper) {
        var selectedValue = component.find('subType').get('v.value');
        var origValue = component.get("v.selectedSubType");
        component.set("v.selectedSubType",selectedValue);
        console.log('test'+selectedValue);
        
    },
    OnclickNextButton: function (component, event, helper){
        var selectedTypes = component.get("v.selectedRegistrationsTypes");
        var selectedRegistrations = component.get("v.selectedRegistrations");
        var typeSelected = component.get("v.typeSelected");
        if(selectedTypes === undefined || selectedTypes.length == 0){
            component.set("v.errorMsg","Please select atleast one Exam Registration to continue");
            component.set("v.showError",true);
        }else if((selectedTypes.includes("FRM Part 1") || selectedTypes.includes("FRM Part 2")) && selectedTypes.includes("SCR")){
            component.set("v.errorMsg","Please select only one from FRM and SCR");
            component.set("v.showError",true);
        }else{
            component.set("v.errorMsg","");
            component.set("v.showError",false);
            if(typeSelected === 'Defer'){
            	helper.getExamGroups(component, event, helper);
            }else if(typeSelected === 'ExamSite'){
                for(var i = 0; i < selectedRegistrations.length; i++){
                    if(selectedRegistrations[i].Section__c === 'FRM Part 1' || selectedRegistrations[i].Section__c === 'SCR'){
                        if(selectedRegistrations[i].Exam_Administration__r.Exam_Group__r.Active__c === false && selectedRegistrations[i].Exam_Administration__r.Exam_Group__r.SCR_Active__c === false){
                            component.set("v.errorMsg","Exam Site change is avaialbale only for Active Exam Groups");
            				component.set("v.showError",true);
                        }else{
                    		helper.getExamSites(component, selectedRegistrations[i].Exam_Administration__c, 'Part 1');
                            component.set("v.errorMsg","");
            				component.set("v.showError",false);
                        }
                    }else if(selectedRegistrations[i].Section__c === 'FRM Part 2'){
                        if(selectedRegistrations[i].Exam_Administration__r.Exam_Group__r.Active__c === false){
                            component.set("v.errorMsg","Exam Site change is avaialbale only for Active Exam Groups");
            				component.set("v.showError",true);
                        }else{
                        	helper.getExamSites(component, selectedRegistrations[i].Exam_Administration__c, 'Part 2');
                            component.set("v.errorMsg","");
            				component.set("v.showError",false);
                        }
                    }
                }
                if(selectedTypes.includes("SCR") || selectedTypes.includes("FRM Part 1")){
                    component.set("v.showExamSitePart1",true);
                    component.set("v.showPicklists",true);
                    component.set("v.showRegistrations",false);
                }
                if(selectedTypes.includes("FRM Part 2")){
                    component.set("v.showExamSitePart2",true);
                    component.set("v.showPicklists",true);
                    component.set("v.showRegistrations",false);
                }
             }
        }
    },
    onExamGrpSelect: function (component, event, helper) {
        var selectedValue = component.find('examGroup').get('v.value');
        component.set("v.selectedGrp",selectedValue);
        var selectedTypes = component.get("v.selectedRegistrationsTypes");
        var selectedRegistrations = component.get("v.selectedRegistrations");
        console.log('selectedgroup:'+selectedValue);
        console.log('existingGroup:'+selectedRegistrations[0].Exam_Administration__r.Exam_Group__c);
        if(selectedValue === selectedRegistrations[0].Exam_Administration__r.Exam_Group__c){
            console.log('Check in here 1');
            component.set("v.disableFutureFreeDeferral",true);
            component.set("v.oneTimeDeferralValue",undefined);
        }else{
            console.log('Check in here 2');
            component.set("v.disableFutureFreeDeferral",false);
        }
        var typeSelected = component.get("v.typeSelected");
        helper.getExamAdmins(component, event, helper);
        if(selectedTypes.includes("SCR")){
            if(typeSelected === 'Defer'){
                component.set("v.showAdmins",true);
                component.set("v.showExamSitePart1",true);
                component.set("v.showRadioGroup",true);
            }
            component.set("v.picklistTitle","Select SCR Exam Administration");
            //component.set("v.showPicklists",true);
        }
        if(selectedTypes.includes("FRM Part 1")){
            if(typeSelected === 'Defer'){
                //console.log('Inside Here');
                component.set("v.showAdmins",true);
                component.set("v.showExamSitePart1",true);
                component.set("v.showRadioGroup",true);
            }
            component.set("v.picklistTitle","Select FRM Part 1 Exam Administration");
            //component.set("v.showPicklists",true);
        }
        if(selectedTypes.includes("FRM Part 2")){
            if(typeSelected === 'Defer'){
                component.set("v.showAdmins2",true);
                component.set("v.showExamSitePart2",true);
                component.set("v.showRadioGroup",true);
            }
            component.set("v.picklist2Title","Select FRM Part 2 Exam Administration");
            //component.set("v.showPicklists",true);
        }
    },
    saveButton : function(component, event, helper) {
        var radioGroup = component.find('radioGroup');
        console.log('radioGroup:'+radioGroup);
        var allValid = false;
        if(radioGroup !== undefined){
            allValid = component.find('radioGroup').reduce(function (validSoFar, inputCmp) {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
            if(allValid){
                component.set("v.errorMsg","");
                component.set("v.showError",false);
                component.set("v.spinner",true);
                helper.saveData(component, event, helper);
            }
        }else{
            component.set("v.errorMsg","");
            component.set("v.showError",false);
            component.set("v.spinner",true);
            helper.saveData(component, event, helper);
        }
	},
    BackToMain : function(component, event, helper) {
		component.set("v.navigateNext",false);
	},
    BackToExamReg : function(component, event, helper) {
		component.set("v.showRegistrations",true);
        component.set("v.showPicklists",false);
	}
})