({
	parseData : function(component) {
        
        var resp = component.get('v.objClassController');
        //debugger;

		resp.lstSummaryData = [
			{
                name: "Quickstarts",
                total: 0,
                percent: 0
	        },
			{
                name: "Reboot starts",
                total: 0,
                percent: 0
	        },
			{
                name: "Reboot week 2-4",
                total: 0,
                percent: 0
	        },
			{
                name: "Subscription Chef",
                total: 0,
                percent: 0
	        },
			{
                name: "One Time Chef",
                total: 0,
                percent: 0
	        },
			{
                name: "Subscription Custom",
                total: 0,
                percent: 0
	        },
			{
                name: "One Time Custom NEW",
                total: 0,
                percent: 0
	        },
			{
                name: "One Time Custom Existing",
                total: 0,
                percent: 0
	        },
			{
                name: "Zipongo Custom NEW",
                total: 0,
                percent: 0
	        },
			{
                name: "Zipongo Custom Existing",
                total: 0,
                percent: 0
	        },
			{
                name: "Total Boxes",
                total: 0,
                percent: 100
	        },
            {
                name: "New Clients",
                total: 0,
                percent: 0
        	},
            {
                name: "Existing Clients",
                total: 0,
                percent: 0
        	},
            {
                name: "Zipongo Sampler",
                total: 0,
                percent: 0
        	}
        ];
        
        for(var i=0; i<resp.lstShipments.length; i++) {
            var ship = resp.lstShipments[i];

            if(ship.Product_Code__c != 'ZPSAM') {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Total Boxes'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
            }
            
            if(ship.Product_Code__c == 'QSZJ') {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Quickstarts'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'New Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }                
            }
            
            if(ship.Product_Code__c == 'E28ZJ' && ship.Cycle__c == 1) {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Reboot starts'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'New Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }
            }

            if(ship.Product_Code__c == 'E28ZJ' && ship.Cycle__c > 1) {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Reboot week 2-4'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }                
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'Existing Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }                
            }

            if(ship.Product_Code__c == 'MOZJ' && ship.Box_Type__c == 'Chef') {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Subscription Chef'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'Existing Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }                
            }

            if(ship.Product_Code__c == 'OTCM') {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'One Time Chef'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'Existing Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }                
            }
            
            if(ship.Product_Code__c == 'MOZJ' && ship.Box_Type__c == 'Custom') {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Subscription Custom'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'Existing Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }                
            }
            
            if(ship.Product_Code__c == 'OTALC' && ship.Is_First_Shipment__c == true) {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'One Time Custom NEW'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'New Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }                
            }
            
            if(ship.Product_Code__c == 'OTALC' && ship.Is_First_Shipment__c == false) {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'One Time Custom Existing'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'Existing Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }                
            }
            
            if(ship.Product_Code__c == 'ZPEALC' && ship.Is_First_Shipment__c == true) {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Zipongo Custom NEW'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'New Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }                
            }
            
            if(ship.Product_Code__c == 'ZPEALC' && ship.Is_First_Shipment__c == false) {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Zipongo Custom Existing'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
                var fndTotal1 = _.findWhere(resp.lstSummaryData, {name: 'Existing Clients'});
                if(!_.isNull(fndTotal1)) {
                    fndTotal1.total++;
                }                
            }

            if(ship.Product_Code__c == 'ZPSAM') {
                var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Zipongo Sampler'});
                if(!_.isNull(fndTotal)) {
                    fndTotal.total++;
                }
            }
            
        }

        var total = 0;
		var fndTotal = _.findWhere(resp.lstSummaryData, {name: 'Total Boxes'});        
        if(!_.isNull(fndTotal)){
            total = fndTotal.total;
        }
        
        if(total > 0) {            
            _.each(resp.lstSummaryData, function(sumdata) {
                if(sumdata.name != 'Total Boxes' && sumdata.name != 'Zipongo Sampler') {
                    if(sumdata.total > 0) {
                        sumdata.percent = Math.round((sumdata.total / total)*100).toFixed(0);
                    }
                }
            });
        }

        component.set('v.objClassController', resp);        
	}
})