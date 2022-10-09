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
                console.log(response.getError());
                alert('Problem with connection. Please try again.');
            }
        });
		$A.enqueueAction(action);
        
        
  


    }
})