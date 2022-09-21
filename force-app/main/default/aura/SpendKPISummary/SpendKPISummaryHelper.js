({
	parseData : function(component) {
        
        var resp = component.get('v.objClassController');
        debugger;	
        
        function setData(ydData, acct) {
            ydData.payingCust++;
            ydData.totalOrders+=acct.Total_Orders__c;
            ydData.totalCustSpend+=acct.Total_Revenue__c;
            if(acct.Total_Orders__c > 1) {
                ydData.totalRepeat++;
                ydData.totalRepeatOrders+=acct.Total_Orders__c;
            	ydData.totalRepeatCustSpend+=acct.Total_Revenue__c;
            }
            	
            ydData.threeMonthSpend+=acct.X3_Month_Spend__c;
            ydData.sixMonthSpend+=acct.X6_Month_Spend__c;
            ydData.twelveMonthSpend+=acct.X12_Month_Spend__c;
			
			ydData.eighteenMonthSpend+=acct.X18_Month_Spend__c;
			ydData.twentyfourMonthSpend+=acct.X24_Month_Spend__c;
			
            
            var dt = new Date();
            if(datediff(parseDate(acct.Last_Purchase_Date__c),dt) < 92) {
                ydData.percActive3Prev++;
            }
            if(datediff(parseDate(acct.Last_Purchase_Date__c),dt) < 183) {
                ydData.percActive6Prev++;
            }

            if(datediff(parseDate(acct.First_Purchase_Date__c),dt) < 92) {
                ydData.percAcquired3Prev++;
            }
            if(datediff(parseDate(acct.First_Purchase_Date__c),dt) < 183) {
                ydData.percAcquired6Prev++;
            }
            var firstLastDiff = datediff(parseDate(acct.First_Purchase_Date__c),parseDate(acct.Last_Purchase_Date__c));
            if(firstLastDiff > 91) {
                ydData.percActive3AfterFirst++;
            }
            if(firstLastDiff > 183) {
                ydData.percActive6AfterFirst++;
            }
                        
            ydData.totalFirstSpend+= acct.Initial_Spend__c;
            
            
			return ydData;
        }
        
        function setTotals(ydData, custCnt) {
            ydData.avgOrders = (ydData.totalOrders / custCnt).toFixed(2);
                                         
            if(custCnt > 0) {
                ydData.avgCustSpend = (ydData.totalCustSpend / custCnt).toFixed(2);
                ydData.threeMonthSpend = (ydData.threeMonthSpend / custCnt).toFixed(2);
                ydData.sixMonthSpend = (ydData.sixMonthSpend / custCnt).toFixed(2);
                ydData.twelveMonthSpend = (ydData.twelveMonthSpend / custCnt).toFixed(2);
				
				ydData.eighteenMonthSpend = (ydData.eighteenMonthSpend / custCnt).toFixed(2);
				ydData.twentyfourMonthSpend = (ydData.twentyfourMonthSpend / custCnt).toFixed(2);
                
                if(ydData.totalRepeat > 0) {
                	ydData.percRepeat = Math.ceil((ydData.totalRepeat / custCnt)*100);
                    ydData.avgSpendRepeat = Math.ceil(ydData.totalRepeatCustSpend / ydData.totalRepeat).toFixed(2);
                } else {
                    ydData.percRepeat = 0; 
                    ydData.avgSpendRepeat = 0;
                } 
                
            }
            else ydData.avgCustSpend = 0;
                                                
            ydData.avgBoxes = (ydData.avgCustSpend / 150).toFixed(2);
            ydData.avgMeals = ((ydData.avgCustSpend / 150) * 12).toFixed(0);
                                        
            if(ydData.payingCust > 0) {
                ydData.percActive3Prev = Math.ceil((ydData.percActive3Prev / ydData.payingCust)*100);
                ydData.percActive6Prev = Math.ceil((ydData.percActive6Prev / ydData.payingCust)*100);
                            
                ydData.avgFirstSpend = Math.ceil(ydData.totalFirstSpend / ydData.payingCust);
                
                if(ydData.payingCust - ydData.percAcquired3Prev > 0)
                	ydData.percActive3AfterFirst = Math.ceil((ydData.percActive3AfterFirst / (ydData.payingCust - ydData.percAcquired3Prev))*100);
                else ydData.percActive3AfterFirst = 0;
                
                if(ydData.payingCust - ydData.percAcquired6Prev > 0)
                	ydData.percActive6AfterFirst = Math.ceil((ydData.percActive6AfterFirst / (ydData.payingCust - ydData.percAcquired6Prev))*100);
                else ydData.percActive6AfterFirst = 0;
            }
            return ydData;
            
        }

        function parseDate(str) {
            var mdy = str.split('-');
            return new Date(mdy[0], mdy[1]-1, mdy[2]);
        }
        
        function datediff(first, second) {
            // Take the difference between the dates and divide by milliseconds per day.
            // Round to nearest whole number to deal with DST.
            return Math.round((second-first)/(1000*60*60*24));
        }        
        
        var quartAcctDiv = resp.lstAcct.length / 4;
        var quartTop10Div = resp.lstAcct.length / 10;
        var quartCnt = 1;
        
        // Init Data
        for(var i=0; i<resp.lstYearlyData.length; i++) {
            resp.lstYearlyData[i].avgCustSpend = 0;
            resp.lstYearlyData[i].threeMonthSpend = 0;
            resp.lstYearlyData[i].sixMonthSpend = 0;
            resp.lstYearlyData[i].twelveMonthSpend = 0;
            resp.lstYearlyData[i].eighteenMonthSpend = 0;
            resp.lstYearlyData[i].twentyfourMonthSpend = 0;
            
            resp.lstYearlyData[i].totalRepeat = 0;
            resp.lstYearlyData[i].totalRepeatOrders = 0;
            resp.lstYearlyData[i].totalRepeatCustSpend = 0;
            
            resp.lstYearlyData[i].percAcquired3Prev = 0;
            resp.lstYearlyData[i].percAcquired6Prev = 0;            
            resp.lstYearlyData[i].percActive3Prev = 0;
            resp.lstYearlyData[i].percActive6Prev = 0;
            resp.lstYearlyData[i].percActive3AfterFirst = 0;
            resp.lstYearlyData[i].percActive6AfterFirst = 0;
            resp.lstYearlyData[i].totalFirstSpend = 0;
        }
        
        for(var i=0; i<resp.lstProductData.length; i++) {
            resp.lstProductData[i].avgCustSpend = 0;
            resp.lstProductData[i].threeMonthSpend = 0;
            resp.lstProductData[i].sixMonthSpend = 0;
            resp.lstProductData[i].twelveMonthSpend = 0;
            resp.lstProductData[i].eighteenMonthSpend = 0;
            resp.lstProductData[i].twentyfourMonthSpend = 0;
            
            resp.lstProductData[i].totalRepeat = 0;
            resp.lstProductData[i].totalRepeatOrders = 0;
            resp.lstProductData[i].totalRepeatCustSpend = 0;

            resp.lstProductData[i].percAcquired3Prev = 0;
            resp.lstProductData[i].percAcquired6Prev = 0;            
            resp.lstProductData[i].percActive3Prev = 0;
            resp.lstProductData[i].percActive6Prev = 0;
            resp.lstProductData[i].percActive3AfterFirst = 0;
            resp.lstProductData[i].percActive6AfterFirst = 0;
            resp.lstProductData[i].totalFirstSpend = 0;            
        }

        for(var i=0; i<resp.lstChannelData.length; i++) {
            resp.lstChannelData[i].avgCustSpend = 0;
            resp.lstChannelData[i].threeMonthSpend = 0;
            resp.lstChannelData[i].sixMonthSpend = 0;
            resp.lstChannelData[i].twelveMonthSpend = 0;
            resp.lstChannelData[i].eighteenMonthSpend = 0;
            resp.lstChannelData[i].twentyfourMonthSpend = 0;

            resp.lstChannelData[i].totalRepeat = 0;
            resp.lstChannelData[i].totalRepeatOrders = 0;
            resp.lstChannelData[i].totalRepeatCustSpend = 0;            
            
            resp.lstChannelData[i].percAcquired3Prev = 0;
            resp.lstChannelData[i].percAcquired6Prev = 0;            
            resp.lstChannelData[i].percActive3Prev = 0;
            resp.lstChannelData[i].percActive6Prev = 0;
            resp.lstChannelData[i].percActive3AfterFirst = 0;
            resp.lstChannelData[i].percActive6AfterFirst = 0;
            resp.lstChannelData[i].totalFirstSpend = 0;    
            
            resp.lstChannelData[i].payingCust = 0;
            resp.lstChannelData[i].totalCustSpend = 0;
            resp.lstChannelData[i].totalOrders = 0;
            resp.lstChannelData[i].totalRepeat = 0;
        }
        
        for(var i=0; i<resp.lstAcct.length; i++) {
            var acct = resp.lstAcct[i];
         
            resp.lstYearlyData[0] = setData(resp.lstYearlyData[0], acct);
            
            // Exclude Last 3 months
            var d = new Date();
			d.setMonth(d.getMonth() - 3);
            
            var dataDate = new Date(acct.First_Purchase_Date__c);
            
            if(dataDate < d) {
            	resp.lstYearlyData[1] = setData(resp.lstYearlyData[1], acct);    
            }
            
            
            if(acct.First_Purchase_Date__c.indexOf('2016') > -1) {
                resp.lstYearlyData[2] = setData(resp.lstYearlyData[2], acct);
            } else if(acct.First_Purchase_Date__c.indexOf('2017') > -1) {
                resp.lstYearlyData[3] = setData(resp.lstYearlyData[3], acct);
            } else if(acct.First_Purchase_Date__c.indexOf('2018') > -1) {
                resp.lstYearlyData[4] = setData(resp.lstYearlyData[4], acct);
            } else if(acct.First_Purchase_Date__c.indexOf('2019') > -1) {
                resp.lstYearlyData[5] = setData(resp.lstYearlyData[5], acct);
            }
            
            // Product Type
            if(acct.Initial_Product_Type__c != 'Program') {
                resp.lstProductData[0] = setData(resp.lstProductData[0], acct);
            } else if(acct.Initial_Product_Type__c == 'Program') {
                resp.lstProductData[1] = setData(resp.lstProductData[1], acct);
            }
            
            if(acct.Initial_Product__c == 'E28ZJ') {
            	resp.lstProductData[2] = setData(resp.lstProductData[2], acct);
            } else if(acct.Initial_Product__c == 'QSZJ') {
                resp.lstProductData[3] = setData(resp.lstProductData[3], acct);
            }
            
            
            // Channel
            // Find channel index
            var fndIdx = -1;
            for(var j=0; j<resp.lstChannelData.length; j++) {
                if(!this.defined(acct,"Main_Channel__c"))
                    acct.Main_Channel__c = 'Other';
                if(this.defined(resp.lstChannelData[j],"name") &&
                   resp.lstChannelData[j].name == acct.Main_Channel__c) {
                    fndIdx = j;
                    break;
                }
            }
            if(fndIdx == -1) {
                fndIdx = resp.lstChannelData.length;
                resp.lstChannelData.push({});
                if(this.defined(acct,"Main_Channel__c"))
	                resp.lstChannelData[fndIdx].name = acct.Main_Channel__c;
                else resp.lstChannelData[fndIdx].name = 'Other';
                resp.lstChannelData[fndIdx].avgCustSpend = 0;
                resp.lstChannelData[fndIdx].threeMonthSpend = 0;
                resp.lstChannelData[fndIdx].sixMonthSpend = 0;
                resp.lstChannelData[fndIdx].twelveMonthSpend = 0;
                resp.lstChannelData[fndIdx].eighteenMonthSpend = 0;
                resp.lstChannelData[fndIdx].twentyfourMonthSpend = 0;
                
                resp.lstChannelData[fndIdx].percAcquired3Prev = 0;
                resp.lstChannelData[fndIdx].percAcquired6Prev = 0;            
                resp.lstChannelData[fndIdx].percActive3Prev = 0;
                resp.lstChannelData[fndIdx].percActive6Prev = 0;
                resp.lstChannelData[fndIdx].percActive3AfterFirst = 0;
                resp.lstChannelData[fndIdx].percActive6AfterFirst = 0;
                resp.lstChannelData[fndIdx].totalFirstSpend = 0;                     
                
                resp.lstChannelData[fndIdx].payingCust = 0;
                resp.lstChannelData[fndIdx].totalCustSpend = 0;
                resp.lstChannelData[fndIdx].totalOrders = 0;
                resp.lstChannelData[fndIdx].totalRepeat = 0;
            }
            resp.lstChannelData[fndIdx] = setData(resp.lstChannelData[fndIdx], acct);
                         
            
            if(i > resp.lstAcct.length - quartTop10Div) {
                resp.lstQuartData[4] = setData(resp.lstQuartData[4], acct);
            }
            if(i > (quartAcctDiv * quartCnt)) {
                quartCnt++
            }
            resp.lstQuartData[quartCnt-1] = setData(resp.lstQuartData[quartCnt-1], acct);
            
            resp.allTimeData.threeMonthSpend += acct.X3_Month_Spend__c;
            resp.allTimeData.sixMonthSpend += acct.X6_Month_Spend__c;
            resp.allTimeData.twelveMonthSpend += acct.X12_Month_Spend__c;

            resp.allTimeData.eighteenMonthSpend += acct.X18_Month_Spend__c;
            resp.allTimeData.twentyfourMonthSpend += acct.X24_Month_Spend__c;			
            
            var dt = new Date();
            if(datediff(parseDate(acct.Last_Purchase_Date__c),dt) < 92) {
                resp.allTimeData.percActive3Prev++;
            }
            if(datediff(parseDate(acct.Last_Purchase_Date__c),dt) < 183) {
                resp.allTimeData.percActive6Prev++;
            }

            if(datediff(parseDate(acct.First_Purchase_Date__c),dt) < 92) {
                resp.allTimeData.percAcquired3Prev++;
            }
            if(datediff(parseDate(acct.First_Purchase_Date__c),dt) < 183) {
                resp.allTimeData.percAcquired6Prev++;
            }
            var firstLastDiff = datediff(parseDate(acct.First_Purchase_Date__c),parseDate(acct.Last_Purchase_Date__c));
            if(firstLastDiff > 91) {
                resp.allTimeData.percActive3AfterFirst++;
            }
            if(firstLastDiff > 183) {
                resp.allTimeData.percActive6AfterFirst++;
            }
                        
            resp.allTimeData.totalFirstSpend+= acct.Initial_Spend__c;
            
        }
        
        resp.allTimeData.threeMonthSpend = resp.allTimeData.threeMonthSpend / resp.lstYearlyData[0].payingCust;
        resp.allTimeData.sixMonthSpend = resp.allTimeData.sixMonthSpend / resp.lstYearlyData[0].payingCust;
        resp.allTimeData.twelveMonthSpend = resp.allTimeData.twelveMonthSpend / resp.lstYearlyData[0].payingCust;

        resp.allTimeData.eighteenMonthSpend = resp.allTimeData.eighteenMonthSpend / resp.lstYearlyData[0].payingCust;
        resp.allTimeData.twentyfourMonthSpend = resp.allTimeData.twentyfourMonthSpend / resp.lstYearlyData[0].payingCust;
		
		
        if(resp.lstYearlyData[0].payingCust > 0) {
            resp.allTimeData.percActive3Prev = Math.ceil((resp.lstYearlyData[0].percActive3Prev / resp.lstYearlyData[0].payingCust)*100);
            resp.allTimeData.percActive6Prev = Math.ceil((resp.lstYearlyData[0].percActive6Prev / resp.lstYearlyData[0].payingCust)*100);
                        
            resp.allTimeData.avgFirstSpend = Math.ceil(resp.allTimeData.totalFirstSpend / resp.lstYearlyData[0].payingCust);
            
            resp.allTimeData.percActive3AfterFirst = Math.ceil((resp.allTimeData.percActive3AfterFirst / (resp.lstYearlyData[0].payingCust - resp.allTimeData.percAcquired3Prev))*100);
            resp.allTimeData.percActive6AfterFirst = Math.ceil((resp.allTimeData.percActive6AfterFirst / (resp.lstYearlyData[0].payingCust - resp.allTimeData.percAcquired6Prev))*100);
        }        
        
        for(var i=0; i<resp.lstYearlyData.length; i++) {
            resp.lstYearlyData[i] = setTotals(resp.lstYearlyData[i], resp.lstYearlyData[i].payingCust);
        }

        for(var i=0; i<resp.lstProductData.length; i++) {
            resp.lstProductData[i] = setTotals(resp.lstProductData[i], resp.lstProductData[i].payingCust);
        }
        
        for(var i=0; i<resp.lstChannelData.length; i++) {
            resp.lstChannelData[i] = setTotals(resp.lstChannelData[i], resp.lstChannelData[i].payingCust);
        }
        
        
        for(var i=0; i<resp.lstQuartData.length; i++) {
            if(i < 4)
            	resp.lstQuartData[i] = setTotals(resp.lstQuartData[i], quartAcctDiv);
            else resp.lstQuartData[i] = setTotals(resp.lstQuartData[i], quartTop10Div);
        }
        
        
        resp.lstChannelData = _.sortBy(resp.lstChannelData, function(item) {
            return item.name;
        });
        var fndOther = _.findWhere(resp.lstChannelData, {name:'Other'});
        if(this.defined(fndOther)) {
            resp.lstChannelData = _.reject(resp.lstChannelData, function(item) {
            	return item.name == 'Other';
        	});
            resp.lstChannelData.push(fndOther);
        }
        
        component.set("v.objClassController",resp);
        
    },
    defined: function(ref, strNames) {
      var name;

      if (typeof ref === "undefined" || ref === null) {
        return false;
      }

      if (strNames !== null && typeof strNames !== "undefined") {
        var arrNames = strNames.split('.');
        while (name = arrNames.shift()) {
          if (ref[name] === null || typeof ref[name] === "undefined") return false;
          ref = ref[name];
        }
      }
      return true;        
    }
})