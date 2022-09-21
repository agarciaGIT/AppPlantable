({    
    handleApplicationEventFired : function (component, event, helper) {
        
        var filterValue = event.getParam("filterValue");
        var filterType = event.getParam("filterType");
        var filtersSupported = component.get("v.filtersSupported");
		//debugger;
        
        if(filtersSupported != null && filtersSupported.length > 0 && filterType != null && filterType.length > 0
          && filtersSupported.indexOf(filterType) > -1) {

            component.set("v.filterValue", filterValue);
            component.set("v.filterType", filterType);
    
            var reportType = component.get("v.reportType");
            if(reportType == 'Doughnut') {
                helper.createChartDoughnut(component);        
            } else if(reportType == 'Lines') {
                helper.createChartLines(component);
            } else if(reportType == 'Table') {
                helper.createChartTable(component);
            }  else if(reportType == 'Overview') {
            	helper.createChartOverview(component);
        	}  else if(reportType == 'TableDetail') {
            	helper.createChartTableDetail(component);
        	}    
        }

    },    
	afterScriptsLoaded : function(component, event, helper) {
        component.set("v.ready", true);
        var reportType = component.get("v.reportType");
        
        //debugger;
        
        if(reportType == 'Doughnut') {
	        helper.createChartDoughnut(component);        
        } else if(reportType == 'Lines') {
            helper.createChartLines(component);
        } else if(reportType == 'Table') {
            helper.createChartTable(component);
        } else if(reportType == 'Overview') {
            helper.createChartOverview(component);
        } else if(reportType == 'TableDetail') {
            helper.createChartTableDetail(component);
        }
        
        
    }
})