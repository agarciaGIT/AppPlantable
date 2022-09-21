({
    parseData : function(component) {
        
        var resp = component.get('v.objClassController');
        debugger;	
        
        // Init Vals
        for(var i=0; i<3; i++) {
            resp.lstSummaryData[i].E28Cnt = 0;
            resp.lstSummaryData[i].alacarte = '';
            resp.lstSummaryData[i].alacarteCnt = 0;

            resp.lstSummaryData[i].mom = '';
            resp.lstSummaryData[i].momCnt = 0;
            resp.lstSummaryData[i].lunch = '';
            resp.lstSummaryData[i].lunchCnt = 0;

            resp.lstSummaryData[i].total = 0;
            resp.lstSummaryData[i].swap = '';
            resp.lstSummaryData[i].swapCnt = 0;
            resp.lstSummaryData[i].isNew = '';
            resp.lstSummaryData[i].isNewCnt = 0;
        }
        
        function setCount(shipItem, summaryData) {
          	if(shipItem.Box_Type__c == 'A-la-carte') {
                summaryData.alacarteCnt++;
                summaryData.alacarte += summaryData.alacarteCnt + '. ' + shipItem.First_Name__c + ' ' + shipItem.Last_Name__c + '<br>';
                summaryData.total++;
            } else if(shipItem.Box_Type__c == 'Mom') {
                summaryData.momCnt++;
                summaryData.mom += summaryData.momCnt + '. ' + shipItem.First_Name__c + ' ' + shipItem.Last_Name__c + '<br>';
                summaryData.total++;
            } else if(shipItem.Box_Type__c == 'Lunch') {
                summaryData.lunchCnt++;
                summaryData.lunch += summaryData.lunchCnt + '. ' + shipItem.First_Name__c + ' ' + shipItem.Last_Name__c + '<br>';
                summaryData.total++;
            } else {                
                summaryData.E28Cnt++;
                summaryData.total++;
            }
            if(shipItem.Dietary_Restrictions__c != null) {
                summaryData.swapCnt++;                
                summaryData.swap += summaryData.swapCnt + '. ' + shipItem.First_Name__c + ' ' + shipItem.Last_Name__c + '(' + shipItem.Dietary_Restrictions__c + ')<br>';
            }
            if(shipItem.Is_New__c == true) {
                summaryData.isNewCnt++;                
                summaryData.isNew += summaryData.isNewCnt + '. ' + shipItem.First_Name__c + ' ' + shipItem.Last_Name__c + '<br>';
            }            
			return summaryData; 
        }
        
        for(var i=0; i<resp.lstShipmentData.length; i++) {
            var ship = resp.lstShipmentData[i];
            
            if(ship.Shipping_Type__c == 'Manhattan Sort') {
				resp.lstSummaryData[0] = setCount(ship, resp.lstSummaryData[0]);
            } else if(ship.Shipping_Type__c == 'Brooklyn Sort') {
                resp.lstSummaryData[1] = setCount(ship, resp.lstSummaryData[1]);          
            //} else {
            //    resp.lstSummaryData[2] = setCount(ship, resp.lstSummaryData[2]);                
            }   
        }
        for(var i=0; i<2; i++) {
			resp.lstSummaryData[2].E28Cnt+=resp.lstSummaryData[i].E28Cnt;
        }
        for(var i=0; i<2; i++) {
			resp.lstSummaryData[2].alacarteCnt+=resp.lstSummaryData[i].alacarteCnt;
        }
        for(var i=0; i<2; i++) {
			resp.lstSummaryData[2].momCnt+=resp.lstSummaryData[i].momCnt;
        }
        for(var i=0; i<2; i++) {
			resp.lstSummaryData[2].lunchCnt+=resp.lstSummaryData[i].lunchCnt;
        }
        for(var i=0; i<2; i++) {
			resp.lstSummaryData[2].swapCnt+=resp.lstSummaryData[i].swapCnt;
        }
        for(var i=0; i<2; i++) {
			resp.lstSummaryData[2].total+=resp.lstSummaryData[i].total;
        }
        for(var i=0; i<2; i++) {
			resp.lstSummaryData[2].isNewCnt+=resp.lstSummaryData[i].isNewCnt;
        }
        
        resp.lstSummaryData[2].isNew = resp.lstSummaryData[2].isNewCnt;
        resp.lstSummaryData[2].swap = resp.lstSummaryData[2].swapCnt;
        
        component.set('v.objClassController', resp);
    }
})