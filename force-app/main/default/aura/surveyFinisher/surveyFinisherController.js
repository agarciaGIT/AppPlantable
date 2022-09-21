({
    
    applyCSS: function(cmp, event) {
        var cmpTarget = cmp.find('changeIt');
        $A.util.addClass(cmpTarget, 'changeMe');
    },
    
    removeCSS: function(cmp, event) {
        var cmpTarget = cmp.find('changeIt');
        $A.util.removeClass(cmpTarget, 'changeMe');
    },
    
    displayToolTip: function(cmp, event, helper, params) {
        var toolTipName = event.currentTarget.getAttribute('data-recId')
        var cmpTarget = cmp.find(toolTipName + 'ToolTip');
        $A.util.removeClass(cmpTarget, 'hide');
    },

    displayOutToolTip: function(cmp, event, helper, params) {
        var toolTipName = event.currentTarget.getAttribute('data-recId')
        var cmpTarget = cmp.find(toolTipName + 'ToolTip');
        $A.util.addClass(cmpTarget, 'hide');
    },
    setRate: function(cmp, event, helper, params) {
        var id = event.target.getAttribute('id');
        var scaleVal = null;
           
        var parts=id.split("~");
        if(parts.length > 1) {
            var scaleName = parts[0];
            scaleVal = parseInt(parts[1]);
            
            // Set Class
            for(var i=1; i<=5; i++) {
                if(i <= scaleVal) {
                    var cmpTarget = cmp.find(scaleName + '~' + i);
                    //$A.util.removeClass(cmpTarget, 'rate-deselected');
                    $A.util.addClass(cmpTarget, 'rate-selected');
                } else {
                    var cmpTarget = cmp.find(scaleName + '~' + i);
                    $A.util.removeClass(cmpTarget, 'rate-selected');
                    //$A.util.addClass(cmpTarget, 'rate-deselected');
                }
            }
            
            // Save Value
            var rating = cmp.get("v.rating");
            rating = scaleVal;
			cmp.set('v.rating', rating);              
        }        
        
    },
    setScale: function(cmp, event, helper, params) {
        var id = event.target.getAttribute('id');
        var scaleVal = null;
           
        var parts=id.split("~");
        if(parts.length > 1) {
            var scaleName = parts[0];
            scaleVal = parseInt(parts[1]);
            
            // Set Class
            for(var i=0; i<=10; i++) {
                if(i <= scaleVal) {
                    var cmpTarget = cmp.find(scaleName + '~' + i);
                    $A.util.removeClass(cmpTarget, 'scale-deselected');
                    $A.util.addClass(cmpTarget, 'scale-selected');
                } else {
                    var cmpTarget = cmp.find(scaleName + '~' + i);
                    $A.util.removeClass(cmpTarget, 'scale-selected');
                    $A.util.addClass(cmpTarget, 'scale-deselected');
                }
            }
            
            // Save Value
            var scaleList = cmp.get("v.scaleList");
            for(var i=0; i<scaleList.length; i++) {
                if(scaleList[i].label == scaleName) {
                    scaleList[i].value = scaleVal;
                    cmp.set('v.scaleList', scaleList);  
                }
            }
            
        }        
    },
    doInit : function(component, event, helper, params) {
        
        function isMobile() {
            var check = false;
            (function(a){if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))) check = true;})(navigator.userAgent||navigator.vendor||window.opera);
            return check;            
        }
        
        if (isMobile()) {
        	//document.documentElement.style.fontSize='40px';
        }
        //else {
        //    document.getElementById('mydiv').classList.add("desktopForm");
        //}
        
        var foodItems = [
            {label: "Zucchini Farro Soup", value: false },
            {label: "Rachel's Seed Crumble", value: false },
            {label: "Thai Coconut Red Curry", value: false },
            {label: "Mediterranean Quinoa Salad", value: false },
            {label: "Marcella Inspired Bolognese", value: false },
            {label: "Coronation Salad Wrap", value: false },
            {label: "Broccoli & Cauliflower Risotto", value: false },
            {label: "Cucumber Soup", value: false },
    	];
        
        component.set('v.foodOptions', foodItems);
            
        var inContactId = component.get("v.contactId");
        console.log('calling do int:' + inContactId);
        var params ={  inputId : inContactId  }
        helper.callToServer(
            component,
            "c.initClass",
            function(response){
                console.log(JSON.stringify(response));
                component.set('v.objClassController', response);  
                debugger;
                var sbTarget = component.find('surveyBody');
                $A.util.removeClass(sbTarget, 'hide');
                
            },
            params
        );
    },
    onInputBlur : function(component, event, helper) {
        var isSubmit = component.get('v.submit');
        if(isSubmit == true) {
            var inputField =event.getSource();
            helper.validateInput(component, inputField);
        }
    },
    addSurvey: function(component, event, helper) {
        
        component.set('v.submit', true);
            
        component.set('v.foodMsg', '');
        component.set('v.feelMsg', '');
        component.set('v.coachMsg', '');
        component.set('v.coachDetailMsg', '');
		component.set('v.rankMsg', '');            
        
        var objClassControllerIn = component.get("v.objClassController");
        var objClassController = JSON.parse(JSON.stringify(objClassControllerIn));
            
        var inputId = component.get('v.contactId');
        var foodItems = component.get('v.foodOptions');
        
        var validForm = true;
        
        var myInputs = component.find("surveyBody").find({instancesOf : "lightning:input"});
        for(var i = 0; i < myInputs.length; i++) {
            var inputField = myInputs[i];
            var validFormParts = helper.validateInput(component, inputField);
            if(validFormParts == false) {
                validForm = false;
            }
        }

        //var myInputs = component.find("surveyBody").find({instancesOf : "lightning:select"});
        //for(var i = 0; i < myInputs.length; i++) {
        //    var inputField = myInputs[i];
        //    var value = inputField.get("v.value");
        //    var name = inputField.get("v.name");
            // Required
        //    if(value == null) {
        //        component.set('v.msg', name + " is required");
                //inputField.set('v.validity', {valid:false, valueMissing:true});
        //        inputField.showHelpMessageIfInvalid();
        //        validForm = false;
        //    }
        //    inputField.showHelpMessageIfInvalid();
        //}
        
        //validForm = false;
        debugger;       

		var useCoach = null;
        if(objClassController.healthSurveyItem.Use_Coaching__c == 'Yes') {
            useCoach = true;
        } else if(objClassController.healthSurveyItem.Use_Coaching__c == 'No') {
            useCoach = false;
        }
        //if(useCoach == null) {
        //    component.set('v.coachMsg', 'Please select a choice.');
        //    component.set('v.msg', "Did you utilize the coaching is required");
        //    validForm = false;                               
        //}

        //if(useCoach != null && (objClassController.healthSurveyItem.Coaching_Comments__c == null || objClassController.healthSurveyItem.Coaching_Comments__c == '')) {
        //    component.set('v.coachDetailMsg', 'Please give us some details.');
        //    component.set('v.msg', "Coaching details are required");
        //    validForm = false;                                           
        //}

		var scaleList = component.get("v.scaleList");
        for(var i=0; i<scaleList.length; i++) {
            
            if(scaleList[i].label == 'sleep') {
                if(scaleList[i].value != null) {
                    objClassController.healthSurveyItem.Sleep__c = scaleList[i].value;
                }
        //        } else {
        //            scaleList[i].msg = 'Sleep Index is required'
        //            component.set('v.msg', "Sleep Index is required");
        //            component.set('v.scaleList', scaleList);
        //            validForm = false;
        //        }
            }
            
            if(scaleList[i].label == 'energy') {
                if(scaleList[i].value != null) {
                    objClassController.healthSurveyItem.Energy__c = scaleList[i].value;
                }
        //        } else {
        //            scaleList[i].msg = 'Energy Level is required'
        //            component.set('v.msg', "Energy Level is required");
        //            component.set('v.scaleList', scaleList);
        //            validForm = false;
        //        }
            }

            if(scaleList[i].label == 'stress') {
                if(scaleList[i].value != null) {
                    objClassController.healthSurveyItem.Stress__c = scaleList[i].value;
                }
        //        } else {
        //            scaleList[i].msg = 'Stress Level is required'
        //            component.set('v.msg', "Stress Level is required");
        //            component.set('v.scaleList', scaleList);
        //            validForm = false;
        //        }
            }
            
            if(scaleList[i].label == 'self') {
                if(scaleList[i].value != null) {
                    objClassController.healthSurveyItem.Self_Esteem__c = scaleList[i].value;
                }
        //        } else {
        //            scaleList[i].msg = 'Self-esteem Measure is required'
        //            component.set('v.msg', "Self-esteem Measure is required");
        //            component.set('v.scaleList', scaleList);
        //            validForm = false;
        //        }
            }

            if(scaleList[i].label == 'easy') {
                if(scaleList[i].value != null) {
                    objClassController.healthSurveyItem.How_Easy__c = scaleList[i].value;
                }
            }

            if(scaleList[i].label == 'recommend') {
                if(scaleList[i].value != null) {
                    objClassController.healthSurveyItem.Recommend__c  = scaleList[i].value;
                }
            }

        }

        var strFeel = "";
        if(component.get("v.FeelAfterLostWieght") == true) {
            strFeel += "Lost Weight;";
        }
        if(component.get("v.FeelAfterFeelBetter") == true) {
            strFeel += "Feel Better;";
        }
        if(component.get("v.FeelAfterMoreEnergy") == true) {
            strFeel += "More Energy;";
        }
        if(component.get("v.FeelAfterImprovedMindClarity") == true) {
            strFeel += "Improved Mind Clarity;";
        }        
        if(component.get("v.FeelAfterFewerAfternoonCrashes") == true) {
            strFeel += "Fewer Afternoon Crashes;";
        }        
        if(component.get("v.FeelAfterKickedSugarCravings") == true) {
            strFeel += "Kicked Sugar Cravings;";
        }        
        if(component.get("v.FeelAfterImprovedUnderstanding") == true) {
            strFeel += "Improved Understanding of Food and Body;";
        }        
        if(component.get("v.FeelAfterNewEating") == true) {
            strFeel += "New Way of Eating;";
        }        
        if(component.get("v.FeelAfterClothesBetter") == true) {
            strFeel += "Get into Clothes Better;";
        }

        //if(strFeel == "") {
        //    component.set('v.feelMsg', 'Please select some items.');
        //    component.set('v.msg', "What do you feel after your ReBoot is required");
        //    validForm = false;                   
        //}


		//var rating = component.get("v.rating");
        //if(rating == null) {
        //    component.set('v.overallMsg', "Rank is required");
        //    component.set('v.msg', "Rank is required");
        //    validForm = false;
        //}


        if(validForm == true) {
            
            // Set Values;
            objClassController.healthSurveyItem.Is_Finisher_Survey__c = true;
            
            //objClassController.healthSurveyItem.Well_Being_Index__c = parseInt(objClassController.healthSurveyItem.Well_Being_Index__c); 
            //objClassController.healthSurveyItem.Sleep__c = parseInt(objClassController.healthSurveyItem.Sleep__c);
            //objClassController.healthSurveyItem.Energy__c = parseInt(objClassController.healthSurveyItem.Energy__c);
            //objClassController.healthSurveyItem.Stress__c = parseInt(objClassController.healthSurveyItem.Stress__c);
            //objClassController.healthSurveyItem.Self_Esteem__c = parseInt(objClassController.healthSurveyItem.Self_Esteem__c);
            
            objClassController.healthSurveyItem.Waist__c = parseInt(objClassController.healthSurveyItem.Waist__c);
            objClassController.healthSurveyItem.Hips_Inches__c = parseInt(objClassController.healthSurveyItem.Hips_Inches__c);
            objClassController.healthSurveyItem.Weight__c = parseInt(objClassController.healthSurveyItem.Weight__c);
            
            objClassController.healthSurveyItem.HG_A1C__c = parseInt(objClassController.healthSurveyItem.HG_A1C__c);
            objClassController.healthSurveyItem.Total_Colesterol__c = parseInt(objClassController.healthSurveyItem.Total_Colesterol__c);
            objClassController.healthSurveyItem.LDL__c = parseInt(objClassController.healthSurveyItem.LDL__c);
            objClassController.healthSurveyItem.HS_CRP__c = parseInt(objClassController.healthSurveyItem.HS_CRP__c);            
            objClassController.healthSurveyItem.Feel__c = strFeel;
            
            if(useCoach != null) {
            	objClassController.healthSurveyItem.Use_Coaching__c = useCoach;    
            }
            
            
            var rating = component.get("v.rating");
            objClassController.healthSurveyItem.Rank__c = rating;
                      
            
            var today  = new Date();        
            var mnth = today.getMonth();
            mnth++;
            objClassController.healthSurveyItem.Survey_Date__c = today.getFullYear() + '-' + helper.formatDatePart(mnth) + '-' + helper.formatDatePart(today.getDate()) + 'T' + helper.formatDatePart(today.getHours()) + ':' + helper.formatDatePart(today.getMinutes()) + ':' + helper.formatDatePart(today.getSeconds()) + '.000Z';

            // Send Data
            var strObjClassController = JSON.stringify(objClassController);
            debugger;
            
            var action = component.get('c.setSurvey');
            action.setParams({  strObjClassController : strObjClassController, inputId : inputId });
            action.setCallback(this,function(response){
                //store state of response
                debugger;
                var state = response.getState();
                if (state === "SUCCESS") {
                    //set response value in objClassController attribute on component
                    var resp = response.getReturnValue();
                    component.set('v.invoiceNumber', resp.Id);
                    debugger;
                    var sbTarget = component.find('surveyBody');
                    $A.util.addClass(sbTarget, 'hide');
                    
                    var sbdTarget = component.find('surveyDoneBody');
                    $A.util.removeClass(sbdTarget, 'hide');
                } else {
                    var err = response.getError();    
                    var errMsg = 'There has been an issue submiting your information. Please try again or contact support@euphebe.com';
                    if(err != null && err.length > 0 && err[0].message != null) {
                    	errMsg = err[0].message;
                    } else if(err != null && err.length > 0 && err[0].pageErrors != null && err[0].pageErrors.length > 0 && err[0].pageErrors[0].message != null) {
                        errMsg = err[0].pageErrors[0].message;
                    }
                    
                    component.set('v.msg', errMsg);
                }
            });
            $A.enqueueAction(action); 
            
        }
    }
})