({
	callToServer : function(component, method, callback, params) {
        
    console.log('Calling callToServer function in CallToServerUtility ');
        console.log('Before Params');
    console.log('Params1======>'+params);
		var action = component.get(method);
        console.log('Params2======>'+params);
        if(params){
            console.log('Params======>'+params);
            action.setParams(params);
        }
        console.log('JSON=======>'+JSON.stringify(params));
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state======>'+state);
            if (state === "SUCCESS") {
                //alert('Processed successfully at server');
                callback.call(this,response.getReturnValue());
                
            }else if(state === "ERROR"){
                alert('Problem with connection. Please try again.');
            }
        });
		$A.enqueueAction(action);
        
        
  


    }
})