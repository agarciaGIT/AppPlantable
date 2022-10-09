({
    init: function (component, event, helper) {
        helper.init(component, event);
    },
    
    onChangePicklist: function(component, event, helper) {
        var selectedOption = event.getSource().get("v.value");
        console.log('Rev: selPickListValue =========>'+selectedOption );
        component.set('v.dropdownSelected', selectedOption);
    },
    
    onExamReg: function(component, event, helper) {
        var selectedExamReg = event.getSource().get("v.value");
        helper.onExamReg(component,event);
        helper.updateBooleanlstValues(component,selectedExamReg);
        console.log('After : frm1Exists=====>'+component.get("v.frm1Exists"));
        console.log('After : frm2Exists=====>'+component.get("v.frm2Exists"));
        console.log('After : scrExists=====>'+component.get("v.scrExists"));
        if(component.get("v.selectedExamReg") == ''){
            component.set("v.error","");
        }
        console.log('Rev:  ============>'+component.get("v.selectedExamReg") );
        console.log('Rev:  ============>'+component.get("v.mapExamRegistrations"));
        var sendExamReg = '';
        for(var str in selectedExamReg){
            sendExamReg = selectedExamReg[str];
            console.log('sendExamReg======>'+sendExamReg);
            
            helper.getExamAdmins(component,event,sendExamReg);
        }
        
    }, 
    
    onExamAdmin: function(component, event, helper) {
        
        console.log('onclick on exam Admins');
        var selectedExamAdmin = event.getSource().get("v.value");
        var selectedExamAdminName = event.getSource().get("v.name");
        // var selectedExamReg = component.get('v.selectedExamReg');
        var selectedMap ;
        var selectedExamReg = '';
        console.log('selectedExamAdminName====>'+selectedExamAdminName);
        if(selectedExamAdminName == 'frm1ExamAdmin' ){
            selectedMap = component.get("v.frm1MapExamAdmins");
            selectedExamReg = 'FRM Part 1';
        } else if (selectedExamAdminName == 'frm2ExamAdmin') {
            selectedMap = component.get("v.frm2MapExamAdmins");
            selectedExamReg = 'FRM Part 2';
        } else {
            selectedMap = component.get("v.scrMapExamAdmins");
            selectedExamReg = 'SCR';
        }
        var action = component.get("c.getExamSites");
        action.setParams({ selectedExamAdmin : selectedExamAdmin,
                          mapExamAdmins : selectedMap,
                          selectedExamReg : selectedExamReg });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var examSitekeys =[];
                var responseMap = response.getReturnValue();
                var message = '';
                for ( var examSitekey in responseMap) { 
                    examSitekeys.push(examSitekey);
                }
                console.log('responseMap======>'+responseMap);
                if(selectedExamAdminName == 'frm1ExamAdmin' ){
                    console.log('====set frm1 sites====');
                    component.set('v.examFrm1Sites',examSitekeys);
                    component.set('v.mapFrm1ExamSites',responseMap);
                } else if (selectedExamAdminName == 'frm2ExamAdmin') {
                    console.log('====set frm2 sites====');
                    component.set('v.examFrm2Sites',examSitekeys);
                    component.set('v.mapFrm2ExamSites',responseMap);
                } else {
                    console.log('====set scr sites====');
                    component.set('v.examScrSites',examSitekeys);
                    component.set('v.mapScrExamSites',responseMap);
                }
                //  component.set('v.mapExamSites',responseMap);
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            console.log('v.examFrm1Sites=====>'+component.get('v.examFrm1Sites'));
            console.log('v.examFrm2Sites=====>'+component.get('v.examFrm2Sites'));
        });
        $A.enqueueAction(action,1);
        
    },
    
    OnclickNextButton: function (component, event, helper) {
        console.log('selectedFrm2ExamAdmin=======>'+component.get('v.selectedFrm2ExamAdmin'));
        console.log('selectedFrm1ExamAdmin=======>'+component.get('v.selectedFrm1ExamAdmin'));
        if((component.get('v.selectedFrm2ExamAdmin') != "--None--") &
           (component.get('v.selectedFrm1ExamAdmin') != "--None--")) {
            helper.validateExamAdmin(component);
        }
        helper.OnclickNextButton(component);
    },
    
    BackButton : function(component, event, helper) {
        component.set("v.navigateNext",false);
    },
    
    BackButtonOnExamSite : function(component, event, helper) {
        component.set("v.navigateToSites",false);
        component.set("v.showExamRegAdmin",true);
    },
    
    OnClickSave : function(component, event, helper) {
        var radioGroup = component.find('radioGroup');
        console.log('radioGroup======>'+radioGroup);
        var validRadio = false;
        var validExamSite = false;
            var freeDefferalCheck = component.get("v.freeDeferralValue");
            if(freeDefferalCheck !== 'Yes' && freeDefferalCheck !== 'No'){
                console.log('freeDefferalCheck is false');
            } else {
                console.log('freeDefferalCheck is true');
            	validRadio = true;
            }
        
        if(((component.get("v.selectedFrm1ExamSite") == undefined || component.get("v.selectedFrm1ExamSite") == "--None--") & 
            (component.get("v.selectedFrm2ExamSite") == undefined || component.get("v.selectedFrm2ExamSite") == "--None--") & 
            (component.get("v.selectedScrExamSite") == undefined ||component.get("v.selectedScrExamSite") == "--None--"))) 
        {
             console.log(' exam site is false');
            validExamSite = false;
        } else {
            console.log(' exam site is false');
            validExamSite = true;
            
        }
        
        console.log('validExamSite======>'+validExamSite);
        console.log('validRadio======>'+validRadio);
        if(validExamSite == false & validRadio == false) {
            component.set("v.fieldsError","Please select atleast one ExamSite and Free Deferral option");
        } else if (validExamSite == true & validRadio == false) {
            component.set("v.fieldsError","Please select Free Deferral option");
        } else if (validExamSite == false & validRadio == true) {
            component.set("v.fieldsError", 'Select atleast one Exam Site');
        } else {
            component.set("v.fieldsError"," ");
            alert('Technical Glitch Saved');
            component.set("v.navigateToSites",false);
            component.set("v.navigateNext",false);
            helper.OnClickSave(component);
		}
        // console.log('valid======>'+valid);
        console.log(component.get("v.selectedExamReg"));
        console.log(component.get("v.mapExamRegistrations"));
        
    }
})