({
    doInit : function(component, event, helper) {
                
        component.set("v.spinner", true);
        
   	},
    afterScriptsLoaded : function(component, event, helper) {
        console.log('Scripts Loaded');

		var action = component.get('c.initClass');
        var params ={  }        
        action.setParams(params);
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            debugger;
            
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                debugger;
                
                resp = helper.formatDateTime(resp);
                
                component.set('v.objClassController', resp);                                
               	if(resp == null) {
                    component.set("v.msg", 'Error on Init');                       
                } else {
					helper.cometDInit(component,helper);
                    
                    var caseId = component.get("v.recordId");                    
                    if(caseId == null) {
                    	caseId = component.get("v.caseId");
                    }                    
                    
                    if(caseId != null && caseId.indexOf('500') == 0) {
                        component.set("v.screenStep", 'pick'); 
                        if(caseId != null && caseId.length > 0) {
                            helper.selectCase(component, caseId, helper);
                            component.set("v.oneCase", true);
                        }
                    } else if(caseId != null && caseId.indexOf('003') == 0) {
                        component.set("v.oneCase", true);
                        helper.selectContact(component, caseId, helper);
                    } else {
                        component.set("v.screenStep", 'pick'); 
                    }
                    
                    
                }
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);        
    },
    subscribe : function(component, event, helper) {
        /*
        const empApi = component.find('empApi');
        empApi.setDebugFlag(true);
        alert('sub');
        
        // Register error listener and pass in the error handler function
        empApi.onError($A.getCallback(error => {
            // Error can be any type of error (subscribe, unsubscribe...)
            console.error('EMP API error: ', error);
        }));
            
        // Replay option to get new events
        const replayId = -1;
            
        // Subscribe to an event
        empApi.subscribe('/event/New_SMS_Message__e', replayId, $A.getCallback(eventReceived => {
            // Process event (this is called each time we receive an event)
            console.log('Received event ', JSON.stringify(eventReceived));
            alert('Received event');
        }))
        .then(subscription => {
            // Confirm that we have subscribed to the event channel.
            // We haven't received an event yet.
            console.log('Subscribed to channel ', subscription.channel);
            component.set("v.msg", 'Subscribed to channel');
             alert('Subscribed to channel');
        });    
        */
    },
    getContactData : function(component, event, helper) {
                
        component.set("v.spinner", true);
        
        var obj = component.get("v.objClassController");
        var contactFilter = component.get("v.contactFilter");
        
        var sObj = JSON.stringify(obj);
        var params ={ sObj : sObj, filter: contactFilter  }        

		var action = component.get('c.findContact');
        action.setParams(params);
        //debugger;
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            //debugger;
            
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                resp = helper.formatDateTime(resp);
                //debugger;
                component.set('v.objClassController', resp);                
                component.set("v.screenStep", 'pickContact');
            } else {
                component.set("v.msg", 'Error on Refresh'); 
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    refreshMessages : function(component, event, helper, params) {
    	helper.checkForNewMessages(component, helper);
    },
    refreshCaseDataApp : function(component, event, helper) {
                
        component.set("v.spinner", true);
        
        var obj = component.get("v.objClassController");
        
        var sObj = JSON.stringify(obj);
        var params ={ sObj : sObj  }        

		var action = component.get('c.refreshCaseData');
        action.setParams(params);
        //debugger;
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            //debugger;
            
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                resp = helper.formatDateTime(resp);
                //debugger;
                component.set('v.objClassController', resp);                
                component.set("v.screenStep", 'pick');
            } else {
                component.set("v.msg", 'Error on Refresh'); 
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },    
    loginApp : function(component, event, helper) {
                
        component.set("v.spinner", true);
        
        var appPassword = component.get("v.appPassword");
        var obj = component.get("v.objClassController");
        
        var sObj = JSON.stringify(obj);
        var params ={  appPassword : appPassword, sObj : sObj  }        

		var action = component.get('c.smsLogin');
        action.setParams(params);
        //debugger;
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            //debugger;
            
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                resp = helper.formatDateTime(resp);
                //debugger;
                component.set('v.objClassController', resp);                
                component.set("v.spinner", false);
               	if(resp.lstCaseData != null) {
                    component.set("v.screenStep", 'pick'); 
                } else {
                    component.set("v.msg", 'Error on Init');    
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleSelectCase : function(component, event, helper, params) {
        
        var caseId = event.target.getAttribute('id');

        component.set("v.spinner", true);
        
        helper.selectCase(component, caseId, helper);
        
    },
    handleSelectContact : function(component, event, helper, params) {
        
        var contactId = event.target.getAttribute('id');
		var obj = component.get("v.objClassController");
        
        component.set("v.spinner", true);
        
        obj.selectedContact = _.findWhere(obj.lstContactData, {Id : contactId});
        
        if(obj.selectedContact != null) {
	        helper.selectContact(component, contactId, helper);
        }
        
        component.set("v.spinner", false);
        
    },    
    handleSendSMS : function(component, event, helper, params) {
        component.set("v.spinner", true);
        
        var obj = component.get("v.objClassController");
        var msg = component.get("v.newMsg");
        
        var sObj = JSON.stringify(obj);
        var params ={  msg : msg, sObj : sObj  }        

		var action = component.get('c.sendSMS');
        action.setParams(params);
        debugger;
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            var msg = component.set("v.newMsg","");
            debugger;
            
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                resp = helper.formatDateTime(resp);
                debugger;
                component.set('v.objClassController', resp);                
                component.set("v.spinner", false);
               	if(resp.lstCaseData != null) {
                    component.set("v.screenStep", 'msgs'); 
                } else {
                    component.set("v.msg", 'Error on Init');    
                }
            }
        });
        $A.enqueueAction(action);
    },  
    handleCloseCase : function(component, event, helper, params) {
        component.set("v.spinner", true);
        
        var obj = component.get("v.objClassController");
        
        var sObj = JSON.stringify(obj);
        var params ={ sObj : sObj  }        

		var action = component.get('c.closeCase');
        action.setParams(params);
        debugger;
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            var msg = component.set("v.msg","");
            debugger;
            
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                resp = helper.formatDateTime(resp);
                debugger;
                component.set('v.objClassController', resp);                
                component.set("v.spinner", false);
               	if(resp.statusMsg != null) {
                    component.set("v.msg", resp.statusMsg);    
                } else {
                    component.set("v.screenStep", 'pick'); 
                }
            }
        });
        $A.enqueueAction(action);
    },      
    backToCase : function(component, event, helper, params) {
        component.set("v.screenStep", 'pick'); 
    },  
    handleIsOpenToggle: function(component, event, helper) {
        const isOpen = component.get('v.isOpen');
        const openDelay = component.get('v.openDelay');
        if (!isOpen) {
            component.set('v.openState', 'opening');
            setTimeout($A.getCallback(function() {
                component.set('v.openState', 'open');
                component.set("v.isOpen", true);
                        
		        var obj = component.get("v.objClassController");
                var id = event.target.getAttribute('id');
                var meal=null;
                for(var i=0; i<obj.lstMealsData.length; i++) {
                    if(obj.lstMealsData[i].Id == id) {
                        meal = obj.lstMealsData[i];
                    }
                }
                if(meal!=null) {
                    component.set("v.mealName", meal.Name);
                    component.set("v.mealDesc", meal.Description__c);
                }
                
            }), 1);
        } else {
            component.set('v.openState', 'closing');
            setTimeout($A.getCallback(function() {
                component.set('v.openState', 'closed');
                component.set("v.isOpen", false);
            }), openDelay);
        }
    },    
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
        var id = event.target.getAttribute('id');
        component.set("v.mealDesc", id);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },    
        

})