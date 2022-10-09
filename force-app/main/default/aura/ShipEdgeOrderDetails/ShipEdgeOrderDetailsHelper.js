({
    fetchOrderList : function(component, event, helper) {
                
        var action = component.get("c.getShipEdgeGetOrderDetails");
        var oppid = component.get("v.recordId");
        
        action.setParams({
            
            OppId:oppid
        });

        action.setCallback(this,function(response){
            
            var state = response.getState();
            if(state === 'SUCCESS'){
                var resp =response.getReturnValue();
                component.set("v.showOrderDetails", resp.showOrderDetails);
                component.set("v.errorMsg", resp.message);
                component.set("v.showError", resp.showError);
                if(resp.showOrderDetails === true){
                    var orderlist =JSON.parse(resp.response);
                    component.set("v.data", orderlist.order.orders);
                }
            }
            else{
                component.set("v.errorMsg",  'Error in getting Order Details');
                component.set("v.showError",tru);
            }
        });
        $A.enqueueAction(action);
    }
 
})