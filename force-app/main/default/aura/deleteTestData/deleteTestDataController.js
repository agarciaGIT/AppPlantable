({
    
    deleteTestData1 : function(component, event, helper,params) {
        
        var seedetail = component.get("v.garpId");
         component.set('v.loaded','false');        
        console.log('seedetail======>'+seedetail);
        var params ={"name":seedetail};
        helper.callToServer(
        
            component,
            "c.deleteTestData",
            function(response){
                console.log(JSON.stringify(response));
                if(response.Message !='null' && response.Message != 'Call back') 
                {
                    alert(response.Message);
                } else if (response.Message == 'Call back') {
                    console.log('Rev: =====Interval=====');
                    window.setInterval(
                        $A.getCallback(function() {
                            c.deleteTestData1() }),5000);
				}
                component.set('v.loaded', 'true');  
                },
                    params
                    );
        
    },
    
    
    
})