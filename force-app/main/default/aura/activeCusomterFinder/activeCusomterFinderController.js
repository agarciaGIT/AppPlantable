({
	doInit : function(component, event, helper) {
                
        debugger;
        var selectDate = new Date();
        var strDate = component.get('v.selectDate');
        if(strDate != null) {
            selectDate = new Date(strDate);
        }
        var mnth = selectDate.getMonth()+1;
        var strDate =  mnth + '/' + selectDate.getDate() + '/' + selectDate.getFullYear();            
        
		var action = component.get('c.getData');
        action.setParams({  inSelectDate : strDate  });
        action.setCallback(this,function(response){
            //store state of response
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                //debugger;
                component.set('v.accountListsData', resp);
                component.set('v.selectDate', resp.selectDate);
            }
        });
        $A.enqueueAction(action);
    },

    downloadData: function(component, event, helper) {
		var action = component.get('c.getData');
        var strDate = component.get('v.selectDate');
        var selectDate = new Date(strDate);
        var mnth = selectDate.getMonth()+1;
        var strDate =  mnth + '/' + selectDate.getDate() + '/' + selectDate.getFullYear();            
		var dom = window.location.hostname;
        var URL = "https://" + dom + "/apex/activeCustomerAsCSV?selectDate=" + strDate;
		var win = window.open(URL, "_blank");
    },   
    
    afterScriptsLoaded: function(component, event, helper) {
    
    	console.log('hi');
	}
})