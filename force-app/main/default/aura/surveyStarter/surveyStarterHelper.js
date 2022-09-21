({
	callToServer : function(component, method, callback, params) {
        
    console.log('Calling callToServer function in CallToServerUtility ');
		var action = component.get(method);
        if(params){
            action.setParams(params);
        }
        //console.log(JSON.stringify(params));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('Processed successfully at server');
                callback.call(this,response.getReturnValue());
                
            }else if(state === "ERROR"){
                alert('Problem with connection. Please try again.');
            }
        });
		$A.enqueueAction(action);
    },
    formatDatePart : function(datePart) {
         if(datePart < 10)
            datePart = '0' + datePart;
        return datePart;
    },
    validateInput : function(component, inputField) {
        //debugger;
        var validForm = true;
        var value = inputField.get("v.value");
        var name = inputField.get("v.name");
        if(name != null && name.indexOf(':') > -1) {
            var parts=name.split(":");
            name = parts[0];
            if(parts.length > 1) {
                // Type
                if(parts.length > 1 && parts[1] == 'Number' && isNaN(value) && value != null) {
                    component.set('v.msg', name + " must be a number");
                    inputField.setCustomValidity(name + " must be a number"); 
                    inputField.reportValidity();                        
                    validForm = false;
                }
                // Required
                if(parts.length > 2 && parts[2] == 'Required' && value == null) {
                    component.set('v.msg', name + " is required");
                    inputField.setCustomValidity(name + " is required"); 
                    inputField.reportValidity();                        
                    validForm = false;
                }
                // Min
                if(parts.length > 3 && parts[1] == 'Number' && value < parseInt(parts[3])) {
                    component.set('v.msg', name + " muse be greater than " + parts[3]);
                    inputField.setCustomValidity(name + " muse be greater than " + parts[3]); 
                    inputField.reportValidity();                        
                    validForm = false;
                }
                if(parts.length > 3 && parts[3] == 'Text' && value.length < parseInt(parts[3])) {
                    component.set('v.msg', name + " muse be at least " + parts[3] + "characters");
                    inputField.setCustomValidity(name + " muse be at least " + parts[3] + "characters"); 
                    inputField.reportValidity();                        
                    validForm = false;
                }
                // Max
                if(parts.length > 4 && parts[1] == 'Number' && value > parseInt(parts[4])) {
                    component.set('v.msg', name + " cannot be greater than " + parts[4]);
                    inputField.setCustomValidity(name + " cannot be greater than " + parts[4]); 
                    inputField.reportValidity();                        
                    validForm = false;
                }
                if(parts.length > 4 && parts[4] == 'Text' && value.length < parseInt(parts[4])) {
                    component.set('v.msg', name + " cannot be more than " + parts[4] + "characters");
                    inputField.setCustomValidity(name + " cannot be more than " + parts[4] + "characters"); 
                    inputField.reportValidity();                        
                    validForm = false;
                }
                if(validForm == true) {
                    inputField.setCustomValidity("");
                    inputField.reportValidity();     
                }
                
            }
        }        
        return validForm;
    }
})