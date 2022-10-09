({
    init : function(component, event) {
        var action = component.get('c.getPicklistValues');
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state========>'+state);
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()=======>'+response.getReturnValue());
                component.set('v.options', response.getReturnValue());
            }
        });
        $A.enqueueAction(action,1);
        
        // component.set('v.garpId','1711609');
        var examRegAction = component.get("c.getExamRegistrations");
         examRegAction.setParams({garpId:component.get("v.garpId")});
          console.log('garpID======>'+component.get("v.garpId"));
        // examRegAction.setParams({ garpId : '1711609' });
        examRegAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // alert("From server: " + response.getReturnValue());
                var examRegkeys =[];
                var responseMap = response.getReturnValue();
                for ( var examRegkey in responseMap) { 
                    examRegkeys.push({
                        label: examRegkey,
                        value:examRegkey
                    });
                }
                console.log('v.examRegistrations=========>'+component.get('v.examRegistrations'));
                component.set('v.examRegistrations', examRegkeys);
                component.set('v.mapExamRegistrations', responseMap);
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
        });
        $A.enqueueAction(examRegAction,2);
        console.log("selected exam reg====>"+component.get("v.selectedExamReg"));
    },
    
    onExamReg: function(component, event) { 
        var selectedExamReg = event.getSource().get("v.value");
        var examRegistrations = component.get("v.examRegistrations") ;
        var listedExamReg = [] ;
        for (var a in examRegistrations){
            listedExamReg.push(examRegistrations[a].value);
        }
        console.log('listedExamReg========>'+listedExamReg);
        console.log('Rev: examRegistrations ============>'+examRegistrations.values() );
        console.log('Rev: selectedExamReg ============>'+selectedExamReg );
        console.log('mapExamRegistrations=======>'+component.get("v.mapExamRegistrations"));
        // var actionOnExamAdminstration = component.get("c.getValidateExamAdmin"); 
        
        var frm1Exists = component.get("v.frm1Exists");
        var frm2Exists = component.get("v.frm2Exists");
        var scrExists = component.get("v.scrExists");
        
        console.log('selectedExamReg.length=====>'+selectedExamReg.length);
        if(selectedExamReg.length == 1) {
            console.log('Entered validation loop1');
            for(var string in selectedExamReg){
                console.log('String=====>'+selectedExamReg[string]);
                if(selectedExamReg[string] == 'FRM Part 1' & scrExists == false) {
                    if(listedExamReg.includes('FRM Part 2')){
                        component.set("v.error","select FRM Part 2");
                        // alert('Select FRM part 2 exam and change the values');  
                    }
                    component.set("v.frm1Exists",true);
                    component.set('v.selectedExamReg',selectedExamReg);
                    
                } else if(selectedExamReg[string] =='FRM Part 2' & scrExists == false)
                { 
                    component.set("v.frm2Exists",true); 
                    component.set('v.selectedExamReg',selectedExamReg);
                }
                    else if(selectedExamReg[string] =='SCR' & (frm1Exists == false && frm2Exists == false))   
                    { 
                        component.set("v.scrExists",true); 
                        component.set('v.selectedExamReg',selectedExamReg);
                    } 
            }
            console.log('frm1Exists=====>'+component.get("v.frm1Exists"));
            console.log('frm2Exists=====>'+component.get("v.frm2Exists"));
            console.log('scrExists=====>'+component.get("v.scrExists"));
        } else {
            console.log('Entered validation loop2');
            if(selectedExamReg.length > 1){
                for(var string in selectedExamReg){
                    if (selectedExamReg[string] =='SCR' & (frm1Exists == true || frm2Exists == true))
                    {  
                        this.removeChecklistValue(component,selectedExamReg,'SCR');
                        alert('Cannot select SCR as FRM is already selected');
                    } else if(selectedExamReg[string] =='FRM Part 1' & scrExists == true )
                    {
                        this.removeChecklistValue(component,selectedExamReg,'FRM Part 1');
                        alert('Cannot select FRM as SCR is already selected');
                    } else if(selectedExamReg[string] =='FRM Part 2' & scrExists == true )
                    {
                        this.removeChecklistValue(component,selectedExamReg,'FRM Part 2');
                        alert('Cannot select FRM as SCR is already selected');
                    }
                    if(selectedExamReg[string] =='FRM Part 2' & frm1Exists == true){
                        component.set("v.error","");
                    } 
                }
            }
        }
	},
    
    getExamAdmins : function(component, event, sendExamReg) {
        var action = component.get("c.getExamAdmins");
            action.setParams({ examReg : sendExamReg,
                              examRegs : component.get("v.mapExamRegistrations") });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // alert("From server: " + response.getReturnValue());
                    var examAdminkeys =[];
                    var responseMap = response.getReturnValue();
                    for ( var examAdminkey in responseMap) { 
                        examAdminkeys.push(examAdminkey);
                    }
                    if(sendExamReg == 'FRM Part 1'){
                        component.set('v.frm1ExamAdmins', examAdminkeys);
                        component.set('v.frm1MapExamAdmins',responseMap);                    
                        console.log('FRM Part 1====>'+ component.get('v.frm1ExamAdmins', examAdminkeys));
                    } else if (sendExamReg == 'FRM Part 2'){
                        component.set('v.frm2ExamAdmins', examAdminkeys);
                        component.set('v.frm2MapExamAdmins',responseMap);
                        console.log('FRM Part 2====>'+ component.get('v.frm2ExamAdmins', examAdminkeys));
                    } else {
                        component.set('v.scrExamAdmins', examAdminkeys);
                        component.set('v.scrMapExamAdmins',responseMap);
                    }
                    // component.set('v.examAdmins', examAdminkeys);
                    // component.set('v.mapExamAdmins',responseMap);
                    // alert('v.examAdmins======>'+examAdminkeys);
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
            });
            $A.enqueueAction(action,2);
	},
    
    removeChecklistValue : function(component,selectedExamReg, string) {
        console.log('Helper String recieved====>'+string);
        var index = selectedExamReg.indexOf(string);
                    if (index !== -1) {
                        selectedExamReg.splice(index, 1);
                    }
    }, 
    
    updateBooleanlstValues : function(component,selectedExamReg) {
        
        component.set("v.scrExists",false); 
        component.set("v.frm1Exists",false);
        component.set("v.frm2Exists",false);
        for(var lst in selectedExamReg) {
            if(selectedExamReg[lst] == 'SCR'){
                component.set("v.scrExists",true); 
            } else if (selectedExamReg[lst] == 'FRM Part 1') {
                component.set("v.frm1Exists",true); 
            } else {
                component.set("v.frm2Exists",true); 
            }
        }
    }, 
    validateExamAdmin :function(component) {
        var selectedExamReg = component.get('v.selectedExamReg');
        console.log('scrExists====>'+component.get('v.scrExists'))
       /* if(component.get('v.scrExists') != true) {
        if((component.get('v.selectedFrm2ExamAdmin') != "undefined" || component.get('v.selectedFrm2ExamAdmin') != "--None--") & 
           (component.get('v.selectedFrm1ExamAdmin') != "undefined" || component.get('v.selectedFrm1ExamAdmin') != "--None--")
          ) 
        {*/
            var action = component.get("c.getvalidateFrm1Frm2");
            action.setParams({ SelectedFrm1ExamAdmin : component.get('v.selectedFrm1ExamAdmin'),
                          frm1MapExamAdmins : component.get('v.frm1MapExamAdmins'),
                          SelectedFrm2ExamAdmin : component.get('v.selectedFrm2ExamAdmin'),
                          frm2MapExamAdmins : component.get('v.frm2MapExamAdmins'),
                          selectedExamRegs : selectedExamReg});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state======>'+state);
            if (state === "SUCCESS") {
                var validationResponse = response.getReturnValue();
                // alert('validationResponse=====>'+validationResponse);
                if(validationResponse == 'false'){
                    component.set("v.fieldsError","FRM Part 1 should be taken before FRM Part 2");
                } else if (validationResponse != 'true' & validationResponse != ''){
                    component.set("v.fieldsError",validationResponse);
                } 
            } else if (state === "INCOMPLETE") {
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
        });
            $A.enqueueAction(action,1);
       // }
  //  }
},
    OnclickNextButton : function(component){
        var selectedExamReg = component.get('v.selectedExamReg');
        if(component.get('v.examFrm1Sites') == '' & component.get("v.frm1Exists") == true){
            component.set('v.frm1SiteMessage','No frm1 sites');
        } else {
            component.set('v.frm1SiteMessage','');
        }
        if(component.get('v.examFrm2Sites') == '' & component.get("v.frm2Exists") == true){
            component.set('v.frm2SiteMessage','No frm2 sites');
        } else {
            component.set('v.frm2SiteMessage','');
        }
        if(component.get('v.examScrSites') == '' & component.get("v.scrExists") == true){
            component.set('v.scrSiteMessage','No scr sites');
        } else {
            component.set('v.scrSiteMessage','');
        }
        if (component.get("v.dropdownSelected") == "--None--") {
            component.set("v.fieldsError","Select atleast a value from dropdown");
        } else if (component.get("v.frm1Exists") == false &
                   component.get("v.frm2Exists") == false &
                   component.get("v.scrExists") == false) 
        {
            component.set("v.fieldsError","Please select atleast one exam Registration and corresponding exam Adminstration.");
        } else if ((component.get("v.selectedFrm1ExamAdmin") == undefined || component.get("v.selectedFrm1ExamAdmin") == "--None--") & 
                   (component.get("v.selectedFrm2ExamAdmin") == undefined || component.get("v.selectedFrm2ExamAdmin") == "--None--") & 
                   (component.get("v.selectedScrExamAdmin") == undefined ||component.get("v.selectedScrExamAdmin") == "--None--"))
        { 
            component.set("v.fieldsError","Select atleast one Exam Administration");
        } else if (component.get("v.error") != "" ) {
            component.set("v.fieldsError", 'select FRM Part 2 as FRM part 1 is selected');
        } else {
            component.set("v.fieldsError"," ");
            component.set("v.navigateToSites",true);
            component.set("v.showExamRegAdmin",false);
            // alert(component.get("v.navigateToSites",true));
        }
    },
    
    OnClickSave : function(component) {
        var action = component.get("c.getSaveRecord");
        var examDetails = {
            'garpId': component.get("v.garpId"),
            'selectedExamRegs' : component.get("v.selectedExamReg"),
            'examRegs' : component.get("v.mapExamRegistrations"),
            'SelectedFrm1ExamAdmin' : component.get("v.selectedFrm1ExamAdmin"),
            'frm1MapExamAdmins' : component.get("v.frm1MapExamAdmins"),
            'SelectedFrm2ExamAdmin' : component.get("v.selectedFrm2ExamAdmin"),
            'frm2MapExamAdmins' : component.get("v.frm2MapExamAdmins"),
            'SelectedScrExamAdmin' : component.get("v.selectedScrExamAdmin"),
            'scrMapExamAdmins' : component.get("v.scrMapExamAdmins"),
            'frm1Exists' : component.get("v.frm1Exists"),
            'frm2Exists' : component.get("v.frm2Exists"),
            'scrExists' : component.get("v.scrExists"),
            'examFrm1Sites' : component.get("v.selectedFrm1ExamSite"),
            'mapFrm1ExamSites' : component.get("v.mapFrm1ExamSites"),
            'examFrm2Sites' : component.get("v.selectedFrm2ExamSite"),
            'mapFrm2ExamSites' : component.get("v.mapFrm2ExamSites"),
            'examScrSites' : component.get("v.selectedScrExamSite"),
            'mapScrExamSites' : component.get("v.mapScrExamSites"),
            'freeDefferalCheck' : component.get("v.freeDeferralValue"),
            // 'oneTimeDeferralCheck' : component.get("v.oneTimeDeferralValue")
        };
        action.setParams({examDetails :JSON.stringify(examDetails)});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
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
        });
        $A.enqueueAction(action,1);
	}
})