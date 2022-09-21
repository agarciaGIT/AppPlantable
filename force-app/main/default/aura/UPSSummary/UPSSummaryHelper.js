({
    parseData : function(component) {
        
        var resp = component.get('v.objClassController');
        
		resp.lstSummaryData = [
			{
                name: "Chef New",
                ice2: 0,
                ice3: 0,
                iceTotal: 0,
                isNames: false,
                ice2Names: '',
                ice3Names: ''
	        },
			{
                name: "Chef New Names",
                ice2: 0,
                ice3: 0,
                iceTotal: 0,
                isNames: true,
                ice2Names: '',
                ice3Names: ''
	        },
			{
                name: "Chef Existing",
                ice2: 0,
                ice3: 0,
                iceTotal: 0,
                isNames: false,
                ice2Names: '',
                ice3Names: ''
	        },
			{
                name: "Custom Existing",
                ice2: 0,
                ice3: 0,
                iceTotal: 0,
                isNames: false,
                ice2Names: '',
                ice3Names: ''
	        },
			{
                name: "Custom Existing Names",
                ice2: 0,
                ice3: 0,
                iceTotal: 0,
                isNames: true,
                ice2Names: '',
                ice3Names: ''
	        },
			{
                name: "Custom NEW",
                ice2: 0,
                ice3: 0,
                iceTotal: 0,
                isNames: false,
                ice2Names: '',
                ice3Names: ''
	        },
			{
                name: "Custom NEW Names",
                ice2: 0,
                ice3: 0,
                iceTotal: 0,
                isNames: true,
                ice2Names: '',
                ice3Names: ''
	        },
			{
                name: "Total",
                ice2: 0,
                ice3: 0,
                iceTotal: 0,
                isNames: false,
                ice2Names: '',
                ice3Names: ''
	        },
            {
                name: "Zipongo Sampler",
                ice2: 0,
                ice3: 0,
                iceTotal: 0,
                isNames: false,
                ice2Names: '',
                ice3Names: ''
        	}
        ];
        
        for(var i=0; i<resp.lstShipments.length; i++) {
            var ship = resp.lstShipments[i];

            if(ship.Product_Code__c != 'ZPSAM') {
                var fnd = _.findWhere(resp.lstSummaryData, {name: 'Total'});
                if(!_.isNull(fnd)) {
                    if(ship.Coolant_Type__c == '2 blocks dry ice') {
                        fnd.ice2++;
                    }
                    if(ship.Coolant_Type__c == '3 blocks dry ice') {
                        fnd.ice3++;
                    }
                    fnd.iceTotal++;
                }
            }
            
            debugger;
            
            if(ship.Product_Code__c == 'QSZJ' || (ship.Product_Code__c == 'E28ZJ ' && ship.Cycle__c == 1)) {
                var fnd = _.findWhere(resp.lstSummaryData, {name: 'Chef New'});
                var fnd1 = _.findWhere(resp.lstSummaryData, {name: 'Chef New Names'});
                if(!_.isNull(fnd) && !_.isNull(fnd1)) {
                    if(ship.Coolant_Type__c == '2 blocks dry ice') {
                        fnd.ice2++;
				        fnd1.ice2Names = fnd1.ice2Names + ship.First_Name__c + ' ' +  ship.Last_Name__c + '<br>';
                    }
                    if(ship.Coolant_Type__c == '3 blocks dry ice') {
                        fnd.ice3++;
				        fnd1.ice3Names = fnd1.ice3Names + ship.First_Name__c + ' ' +  ship.Last_Name__c + '<br>';
                    }
                    fnd.iceTotal++;
                }
            }

            
            if((ship.Product_Code__c == 'MOZJ' && ship.Box_Type__c == 'Chef') || ship.Product_Code__c == 'OTCM') {
                var fnd = _.findWhere(resp.lstSummaryData, {name: 'Chef Existing'});
                if(!_.isNull(fnd) && !_.isNull(fnd1)) {
                    if(ship.Coolant_Type__c == '2 blocks dry ice') {
                        fnd.ice2++;
                    }
                    if(ship.Coolant_Type__c == '3 blocks dry ice') {
                        fnd.ice3++;
                    }
                    fnd.iceTotal++;                    
                }
            }
            

            if((ship.Product_Code__c == 'MOZJ' && ship.Box_Type__c == 'Custom') || 
               (ship.Product_Code__c == 'OTALC' && ship.Is_First_Shipment__c == false) ||
               (ship.Product_Code__c == 'ZPEALC' && ship.Is_First_Shipment__c == false)) {
                var fnd = _.findWhere(resp.lstSummaryData, {name: 'Custom Existing'});
                var fnd1 = _.findWhere(resp.lstSummaryData, {name: 'Custom Existing Names'});
                if(!_.isNull(fnd) && !_.isNull(fnd1)) {
                    if(ship.Coolant_Type__c == '2 blocks dry ice') {
                        fnd.ice2++;
				        fnd1.ice2Names = fnd1.ice2Names + ship.First_Name__c + ' ' +  ship.Last_Name__c + '<br>';
                    }
                    if(ship.Coolant_Type__c == '3 blocks dry ice') {
                        fnd.ice3++;
				        fnd1.ice3Names = fnd1.ice3Names + ship.First_Name__c + ' ' +  ship.Last_Name__c + '<br>';
                    }
                    fnd.iceTotal++;                    
                }
            }

            if((ship.Product_Code__c == 'OTALC' && ship.Is_First_Shipment__c == true) ||
               (ship.Product_Code__c == 'ZPEALC' && ship.Is_First_Shipment__c == true)) {
                var fnd = _.findWhere(resp.lstSummaryData, {name: 'Custom NEW'});
                var fnd1 = _.findWhere(resp.lstSummaryData, {name: 'Custom NEW Names'});
                if(!_.isNull(fnd) && !_.isNull(fnd1)) {
                    if(ship.Coolant_Type__c == '2 blocks dry ice') {
                        fnd.ice2++;
				        fnd1.ice2Names = fnd1.ice2Names + ship.First_Name__c + ' ' +  ship.Last_Name__c + '<br>';
                    }
                    if(ship.Coolant_Type__c == '3 blocks dry ice') {
                        fnd.ice3++;
				        fnd1.ice3Names = fnd1.ice3Names + ship.First_Name__c + ' ' +  ship.Last_Name__c + '<br>';
                    }
                    fnd.iceTotal++;                    
                }
            }
            
            if(ship.Product_Code__c == 'ZPSAM') {
                var fnd = _.findWhere(resp.lstSummaryData, {name: 'Zipongo Sampler'});
                if(!_.isNull(fnd) && !_.isNull(fnd1)) {
                    if(ship.Coolant_Type__c == '2 blocks dry ice') {
                        fnd.ice2++;
                    }
                    if(ship.Coolant_Type__c == '3 blocks dry ice') {
                        fnd.ice3++;
                    }
                    fnd.iceTotal++;                    
                }
            }            
        }

        component.set('v.objClassController', resp);        
    }
})