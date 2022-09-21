({
    
    cometDInit : function(component, helper) {
        
        var obj = component.get("v.objClassController");
        var sessionId = obj.sessionId;
        // Connect to the CometD endpoint
        $.cometd.configure({
            url: window.location.protocol+'//'+window.location.hostname+'/cometd/42.0/',
            requestHeaders: { Authorization: 'OAuth ' + sessionId},
            appendMessageTypeToURL : false
        });
        $.cometd.websocketEnabled = false;
        //debugger;
        if($.cometd.getStatus() == 'disconnected') {
                        
            $.cometd.handshake(function(handshakeReply) {
                if (handshakeReply.successful) {
                    console.log('Connected to CometD.');
                    
                    // Subscribe to platform event
                    var newSubscription = $.cometd.subscribe('/event/New_SMS_Message__e',
                                                             $A.getCallback(function(platformEvent) {
                                                                 console.log('Platform event received: '+ JSON.stringify(platformEvent));
                                                                 helper.checkForNewMessages(component, helper);
                                                             })
                                                            );
                }
            });                
        } else {
            // Subscribe to platform event
            var newSubscription = $.cometd.subscribe('/event/New_SMS_Message__e',
                                                     $A.getCallback(function(platformEvent) {
                                                         console.log('Platform event received: '+ JSON.stringify(platformEvent));
                                                         helper.checkForNewMessages(component, helper);
                                                     })
                                                    );            
            
        }

	},
    formatDateTime : function(resp) {
        
        _.each(resp.lstCaseData, function(item) { 
            item.DateTimeOpen__c = moment(item.CreatedDate).format('M/D h:mm a'); 
        })
        _.each(resp.lstMsgData, function(item) { 
            item.Date_Time__c = moment(item.CreatedDate).format('M/D h:mm a'); 
        })

        return resp;
        
    },
	checkForNewMessages : function(component, helper) {
        var obj = component.get("v.objClassController");
        
        var sObj = JSON.stringify(obj);
        var params ={ sObj : sObj }
        
        var action = component.get('c.checkForNewMSG');
        action.setParams(params);        
        action.setCallback(this,function(response){
            
            var state = response.getState();            
            debugger;
            
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                resp = helper.formatDateTime(resp);
                debugger;
                component.set('v.objClassController', resp);    
                component.set("v.msg", 'New Message');    
            }
        });
        $A.enqueueAction(action);
	},
    selectCase : function(component, caseId, helper) {
        var obj = component.get("v.objClassController");
        
        var sObj = JSON.stringify(obj);
        var params ={  caseId : caseId, sObj : sObj  }        
        //var params ={ sObj : sObj  }        
        
        var action = component.get('c.selectCase');
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
                
                if(resp.lstCaseData != null) {
                    component.set("v.screenStep", 'msgs'); 
                } else {
                    component.set("v.msg", 'Error on Init');    
                }
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);        
    },
    selectContact : function(component, contactId, helper) {
        var obj = component.get("v.objClassController");
        
        var sObj = JSON.stringify(obj);
        var params ={  contactId : contactId, sObj : sObj  }        
        
        var action = component.get('c.selectContact');
        action.setParams(params);
        debugger;
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            debugger;
            
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                resp = helper.formatDateTime(resp);
                //debugger;
                component.set('v.objClassController', resp);                
                
                if(resp.lstCaseData != null) {
                    component.set("v.screenStep", 'msgs'); 
                } else {
                    component.set("v.msg", 'Error on Init');    
                }
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);        
    }
    
})