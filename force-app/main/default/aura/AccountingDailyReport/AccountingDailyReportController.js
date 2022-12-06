({
	afterScriptsLoaded: function(component, event, helper) {
    	console.log('afterScriptsLoaded');
        debugger;

        var action=component.get('c.initClass');
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {                
                var result = response.getReturnValue(); 
                console.log(JSON.stringify(response));
                component.set("v.objClassController",result);
                var orderMap = result.orderTransMap;
                var cols = [
                            {label: 'Status', fieldName: 'Status__c', type: 'text',initialWith:80},
                            {label: 'Company', fieldName: 'Company__c', type: 'text',initialWith:80},
                            {label: 'Type', fieldName: 'Transaction_Type__c', type: 'text',initialWith:80},
                            {label: 'Total', fieldName: 'Total_Amount__c', type: 'decimal',initialWith:80},
                            {label: 'Invoice Number', fieldName: 'Invoice_Number__c', type: 'text',initialWith:80}, 
                            {label: 'GARP ID', fieldName: 'GARP_ID__c', type: 'text',initialWith:80},
                            {label: 'First Name', fieldName: 'First_Name__c', type: 'text',initialWith:80}, 
                            {label: 'Last Name', fieldName: 'Last_Name__c', type: 'text',initialWith:80},
                            {label: 'Country', fieldName: 'Country__c', type: 'text',initialWith:80}, 
                            {label: 'State', fieldName: 'State__c', type: 'text',initialWith:80}, 
                            {label: 'Exam Site', fieldName: 'Exam_Site__c', type: 'text',initialWith:80}, 
                            {label: 'Paid Date', fieldName: 'Paid_Date_Time__c', type: 'date',
                                typeAttributes: {
                                    weekday: 'short',
                                    year: 'numeric',
                                    month: 'short',
                                    day: 'numeric',
                                    hour: '2-digit',
                                    minute: '2-digit'
                                },initialWith:80},
                            {label: 'Payment Method', fieldName: 'Gateway_ID__c', type: 'text',initialWith:80},
                            {label: 'PayPal Trans ID', fieldName: 'Payment_Method__c', type: 'text',initialWith:80}
                        ];
                for(var i=0; i<orderMap.length; i++) {
                    cols.push(
                        {label: orderMap[i].Name, fieldName: orderMap[i].Field_Name__c, type: 'text',initialWith:80} 
                    );
                }
                var m = moment().format("YYYY-MM-DD");
                component.set("v.objClassController.startDate",m);
                component.set("v.objClassController.pageSize",component.get("v.pageSize"));
                component.set("v.objClassController.pageNumber",1);
                
                component.set("v.objClassController.endDate",m);
                component.set("v.objClassController.endDate",m);

				component.set('v.Reportcolumns', cols);                         
			} 
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);    
	},
    refresh : function(component, event, helper) {
        component.set("v.spinner", true);
        
        var action=component.get('c.getOrderTransactions');
        action.setParams({ 
            'obj' : component.get("v.objClassController"),
            'usePaging' : true
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.objClassController",result); 
                component.set("v.ReportList",result.lstOrderTransItems); 
                component.set("v.dataSize", result.lstOrderTransItems.length-1);
                component.set("v.totalSize", result.totalSize);
                
                var totalPages = (component.get("v.totalSize") / component.get("v.pageSize"));
                component.set("v.totalPages", totalPages);
            } 
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);    

    },
    doInit : function(component, event, helper) {
        component.set("v.spinner", true);
        component.set("v.ErrorMessage","");        
        component.set("v.ReportList",[]);
        
    },
    handlePrev : function(component, event, helper) {
        component.set("v.spinner", true);
        component.set("v.objClassController.pageNumber",component.get("v.objClassController.pageNumber") - 1);

        // De-Select everything
        var c = component.find("transTable")
        c.set("v.selectedRows", []);
        component.set('v.objClassController.selectedRows', []);
        component.set('v.selectedRowsCount', 0);        
        
        var action=component.get('c.getOrderTransactions');
        action.setParams({ 
            'obj' : component.get("v.objClassController"),
            'usePaging' : true
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.objClassController",result); 
                component.set("v.ReportList",result.lstOrderTransItems); 
                
                if(component.get("v.objClassController.pageNumber") == component.get("v.totalPages")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }                
                component.set("v.dataSize", result.lstOrderTransItems.length-1);
            } 
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);            
    },
    handleNext : function(component, event, helper) {
        component.set("v.spinner", true);
        component.set("v.objClassController.pageNumber",component.get("v.objClassController.pageNumber") + 1);
		
        // De-Select everything
        var c = component.find("transTable")
        c.set("v.selectedRows", []);
        component.set('v.objClassController.selectedRows', []);
        component.set('v.selectedRowsCount', 0);        

        var action=component.get('c.getOrderTransactions');
        action.setParams({ 
            'obj' : component.get("v.objClassController"),
            'usePaging' : true
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.objClassController",result); 
                component.set("v.ReportList",result.lstOrderTransItems); 
                
                if(component.get("v.objClassController.pageNumber") == component.get("v.totalPages")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }                
                component.set("v.dataSize", result.lstOrderTransItems.length-1);
            } 
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);    
    },
    approveSelectedItems : function(component, event, helper) {
		component.set("v.spinner", true);
                
        var action=component.get('c.approveSelectedRows');
        action.setParams({ 
            'obj' : component.get("v.objClassController")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.objClassController",result); 

                // De-Select everything
                var c = component.find("transTable")
                c.set("v.selectedRows", []);
                component.set('v.objClassController.selectedRows', []);
                component.set('v.selectedRowsCount', 0);        
                
                component.set("v.ReportList",result.lstOrderTransItems); 
                component.set("v.dataSize", result.lstOrderTransItems.length-1);
                component.set("v.totalSize", result.totalSize);
                
                var totalPages = (component.get("v.totalSize") / component.get("v.pageSize"));
                component.set("v.totalPages", totalPages);
                
            } 
            
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);            
    },
    approveAllItems : function(component, event, helper) {
		component.set("v.spinner", true);
                
        var action=component.get('c.approveAllRowItems');
        action.setParams({ 
            'obj' : component.get("v.objClassController")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
				component.set("v.objClassController",result); 
                
                // De-Select everything
                var c = component.find("transTable")
                c.set("v.selectedRows", []);
                component.set('v.objClassController.selectedRows', []);
                component.set('v.selectedRowsCount', 0);        
                
                component.set("v.ReportList",result.lstOrderTransItems); 
                component.set("v.dataSize", result.lstOrderTransItems.length-1);
                component.set("v.totalSize", result.totalSize);
                
                var totalPages = (component.get("v.totalSize") / component.get("v.pageSize"));
                component.set("v.totalPages", totalPages);
                
            } 
            
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);          
        
    },
    updateSelectedText : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var totalLine=-1;
        for(var i=0; i<selectedRows.length; i++) {
            if(selectedRows[i].Company__c === null || typeof selectedRows[i].Company__c === "undefined") {
                totalLine=i;
            }
        }
		if(totalLine > -1) {
            selectedRows.splice(totalLine,1);
        }
        component.set('v.objClassController.selectedRows', selectedRows);
        component.set('v.selectedRowsCount', selectedRows.length);
    }
    
    
})