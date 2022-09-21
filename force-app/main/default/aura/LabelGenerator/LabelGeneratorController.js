({
	doInit : function(component, event, helper) {
                
		var action = component.get('c.initClass');
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                component.set('v.objClassController', resp);
                component.set('v.shippingDate', resp.nextShippingDate);
            }
        });
        $A.enqueueAction(action);
    },

    uploadUPS: function(component, event, helper) {
        var URL = '/apex/upsTrackingUpload';
        component.set('v.url', URL);
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": URL
        });
        urlEvent.fire();
    },

    generateUPS: function(component, event, helper) {
        
        var shipdate = component.get('v.shippingDate');
        debugger;
        var arrNames = shipdate.split('-');
        var month='';
        var day='';
        var year='';
        if(arrNames.length > 2) {
            year = arrNames[0];
            month = arrNames[1];
            day = arrNames[2];
            var strDate = month + '/' + day + '/' + year;
            
            var URL = '/apex/onFleetLabelsAsPDF?provider=UPS&shipdate=' + strDate;
            component.set('v.url', URL);
            
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": URL
            });
            urlEvent.fire();
        }
    },

    generateLables: function(component, event, helper) {
		var boxtype = component.get('v.boxType');
        var courier = component.get('v.courier');
        var shipdate = component.get('v.shippingDate');
        
        var arrNames = shipdate.split('-');
        var month='';
        var day='';
        var year='';
        if(arrNames.length > 2) {
            year = arrNames[0];
            month = arrNames[1];
            day = arrNames[2];
            var strDate = month + '/' + day + '/' + year;
            var URL = '/apex/onFleetLabelsAsPDF?provider=' + courier + '&shipdate=' + strDate + '&boxtype=' + boxtype;
            component.set('v.url', URL);
            
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": URL
            });
            urlEvent.fire();
            
        }
       
    }    
})