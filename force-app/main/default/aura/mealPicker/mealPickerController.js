({
    
    handleIsOpenToggle: function(component, event, helper) {
        const isOpen = component.get('v.isOpen');
        const openDelay = component.get('v.openDelay');
        if (!isOpen) {
            
            var obj = component.get("v.objClassController");
            var id = event.target.getAttribute('id');
            var meal=null;
            for(var i=0; i<obj.lstMealsData.length; i++) {
                if(obj.lstMealsData[i].Id == id) {
                    meal = obj.lstMealsData[i];
                    obj.selectedMeal = obj.lstMealsData[i];
                }
            }
            if(meal!=null) {
                component.set("v.mealName", meal.Name);
                component.set("v.mealType", meal.Type__c);
                component.set("v.mealDesc", meal.Description__c);
                component.set("v.mealAllergen", meal.Allergens__c);
                component.set("v.mealGlutenFree", meal.Gluten_Free__c);
                component.set("v.mealNutFree", meal.Nut_Free__c);
                component.set("v.mealDairlFree", meal.Dairy_Free__c);
            }
            
            component.set('v.openState', 'opening');
            setTimeout($A.getCallback(function() {
                        
                component.set('v.objClassController', obj);
                component.set('v.openState', 'open');
                component.set("v.isOpen", true);

                
            }), 1);
        } else {
            component.set('v.openState', 'closing');
            setTimeout($A.getCallback(function() {
                component.set('v.openState', 'closed');
                component.set("v.isOpen", false);

                component.set("v.mealName", "");
                component.set("v.mealType", "");
                component.set("v.mealDesc", "");
                component.set("v.mealAllergen", "");
                component.set("v.mealGlutenFree", false);
                component.set("v.mealNutFree", false);
                component.set("v.mealDairlFree", false);                
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
    
    submitCode: function(component, event, helper) {
                
        var obj = component.get("v.objClassController");
        var accessCode = component.get("v.accessCode");
        var useOrderNumber = component.get("v.useOrderNumber");  
        
        component.set("v.msg", null); 
                
		var action = component.get('c.initClass');
        var params ={  inOrderId : null, accessCode : accessCode, useOrderNumber : useOrderNumber  }        

        action.setParams(params);
        debugger;
        component.set("v.spinner", true);
                
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                resp = helper.prepMealData(resp);
                debugger;
                component.set('v.objClassController', resp);
                component.set("v.spinner", false);
                
                if(resp.opp != null) {
                    component.set("v.screenStep", 'pick');    
                } else {
                    component.set("v.msg", 'Order not found.');    
                }
                
            }
        });
        $A.enqueueAction(action);
        
    },    
    submitMeal: function(component, event, helper) {
                
        var inOrderId = component.get("v.orderId");
        var obj = component.get("v.objClassController");

        var cnt=0;
        for(var i=0; i<obj.lstMealItems.length; i++) {
            cnt+=obj.lstMealItems[i].Quantity__c;
        }
        if(cnt < 12) {
			component.set("v.msg", "You must select 12 items.");
			return;            
        }
        
		var action = component.get('c.submitMeals');

        var sObj = JSON.stringify(obj);        
        var params ={  inObj : sObj  }        
        action.setParams(params);
        component.set("v.spinner", true);
        
        action.setCallback(this,function(response){
            //store state of response
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                resp = helper.prepMealData(resp);
                debugger;
                component.set('v.objClassController', resp);
                component.set("v.screenStep", 'done'); 
            } else {
                component.set("v.msg", "Error saving meals.");
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
        
    },
    
    removeItem: function(component, event, helper, params) {
        var itemId = event.target.getAttribute('id');
        var obj = component.get("v.objClassController");
        
        console.log('calling removeItem itemId:' + itemId);
        console.log('calling removeItem obj:' + obj);

        component.set("v.msg", "");
        
		var action = component.get('c.removeCartItem');
		var sObj = JSON.stringify(obj);                
        var params ={  itemId : itemId, inObj : sObj  }        
        action.setParams(params);
        component.set("v.spinner", true);
        
        action.setCallback(this,function(response){
            //store state of response
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                resp = helper.prepMealData(resp);
                debugger;
                component.set('v.objClassController', resp);
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    subItem: function(component, event, helper, params) {
        var itemId = event.target.getAttribute('id');
        var obj = component.get("v.objClassController");
        
        console.log('calling subItem itemId:' + itemId);
        console.log('calling subItem obj:' + obj);

        component.set("v.msg", "");

		var action = component.get('c.decrementCartItem');
		var sObj = JSON.stringify(obj);                        
        var params ={  itemId : itemId, inObj : sObj  }        
        action.setParams(params);
        component.set("v.spinner", true);
        action.setCallback(this,function(response){
            //store state of response
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                resp = helper.prepMealData(resp);
                debugger;
                component.set('v.objClassController', resp);
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    addItem: function(component, event, helper, params) {
        var itemId = event.target.getAttribute('id');
        var obj = component.get("v.objClassController");
        
        console.log('calling addItem itemId:' + itemId);
        console.log('calling addItem obj:' + obj);

        component.set("v.msg", "");
        
		var action = component.get('c.incrementCartItem');
        var sObj = JSON.stringify(obj);
        var params ={  itemId : itemId, inObj : sObj  }        
        action.setParams(params);
        
		component.set("v.spinner", true);
        
        action.setCallback(this,function(response){
            //store state of response
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                resp = helper.prepMealData(resp);
                debugger;
                component.set('v.objClassController', resp);
            }
            component.set("v.spinner", false);


        });
        $A.enqueueAction(action);
    },
    clearMeals: function(component, event, helper, params) {
        var obj = component.get("v.objClassController");
        component.set("v.msg", "");
        
		var action = component.get('c.removeBoxItems');
        var sObj = JSON.stringify(obj);
        var params ={inObj : sObj  }        
        action.setParams(params);
        
		component.set("v.spinner", true);
        
        action.setCallback(this,function(response){
            //store state of response
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                debugger;
                component.set('v.objClassController', resp);
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    
    
	doInit : function(component, event, helper) {
                
		var action = component.get('c.initClass');
        var inOrderId = component.get("v.orderId");
        var accessCode = null;
        var useOrderNumber = false;
        
        console.log('calling do int:' + inOrderId);
        
        var params ={  inOrderId : inOrderId, accessCode : accessCode, useOrderNumber : useOrderNumber  }        
        action.setParams(params);
        
        action.setCallback(this,function(response){
            //store state of response
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in objClassController attribute on component
                var resp = response.getReturnValue();
                debugger;
                
                resp = helper.prepMealData(resp);
                component.set('v.objClassController', resp);
                component.set('v.orderId', resp.orderId);
                
                component.set("v.spinner", false);
               	if(resp.opp != null) {
                    component.set("v.screenStep", 'pick');    
                } else {
                    //component.set("v.msg", 'Order not found.');    
                }
            }
        });
        $A.enqueueAction(action);
    }

})