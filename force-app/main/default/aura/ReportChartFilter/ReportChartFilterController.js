({
	selFilter : function(component, event, helper) {
        
        var filterUnit = component.get("v.filterUnit");
        var filterValue = component.get("v.filterValue");
        var filterType = component.get("v.filterType");
        
        if(filterUnit == "MonthYear") {

            var filterValueMonth = component.get("v.filterValueMonth");
            var filterValueYear = component.get("v.filterValueYear");
            filterValue = 'Shipment__c.RPT_Scheduled_Date_Month__c:' + filterValueMonth + '~' +
            			  'Shipment__c.RPT_Scheduled_Date_Year__c:' + filterValueYear;            
        }
        
        var appEvent = $A.get("e.c:ReportChartFilterAppEvent");        
        appEvent.setParams({ "filterUnit" : filterUnit, "filterValue" : filterValue, "filterType" : filterType });
        appEvent.fire();
	},    
	afterScriptsLoaded : function(component, event, helper) {
        component.set("v.ready", true);
        var filterValue = component.get("v.filterValue");
        var filterType = component.get("v.filterType");
        var filterUnit = component.get("v.filterUnit");
        //debugger;
        
        if(filterUnit != null && filterUnit.length > 0 && filterUnit == 'Weekly') {
	    	filterValue = 'THIS WEEK';
            component.set("v.filterValue",filterValue);
        }
        if(filterUnit != null && filterUnit.length > 0 && filterUnit == 'Monthly') {
	    	filterValue = 'THIS MONTH';
            component.set("v.filterValue",filterValue);
        }
        if(filterUnit != null && filterUnit.length > 0 && filterUnit == 'MonthYear') {
            var tdy = new Date;
            var mnth = tdy.getMonth();
            mnth++;
            var yr = tdy.getFullYear();
	    	filterValue = 'Shipment__c.RPT_Scheduled_Date_Month__c:' + mnth + '~Shipment__c.RPT_Scheduled_Date_Year__c:' + yr;
            component.set("v.filterValue",filterValue);
            component.set("v.filterValueMonth",mnth);
            component.set("v.filterValueYear",yr);
        }

        //debugger;
        
        // note different syntax for getting application event
        var appEvent = $A.get("e.c:ReportChartFilterAppEvent");
        
        appEvent.setParams({ "filterUnit" : filterUnit, "filterValue" : filterValue, "filterType" : filterType });
        appEvent.fire();

    }
})