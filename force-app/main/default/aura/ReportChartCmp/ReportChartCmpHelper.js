({
    createChartOverview : function (component) {
        var ready = component.get("v.ready");
        var tableData = component.get("v.tableData");        
        var filterValue = component.get("v.filterValue");
        if(filterValue == '') {
            filterValue = null;
        }
                
        if (ready === false) {
            return;
        }
        //var chartCanvas = component.find("chart").getElement();
        var reportId = component.get("v.reportId");
    debugger;
        var action = component.get("c.getreport");
        var params ={  reportId : reportId, filterStr: filterValue, getAllData: true };
    	action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var reportResultData = JSON.parse(response.getReturnValue());
                var chartData = [];
                var chartLabels = [];
                var tot = 0;
				var totBudget = 0;
                
                var d = new Date();
                var n = d.getMonth();
                if(filterValue == 'LAST MONTH') {
                    if(n == 0)
                        n=10;
                    else n--;
                } else if(filterValue == 'NEXT MONTH') {
                    if(n == 11)
                        n = 0;
                    else n++;
                }
                    
                var budgetData = this.getBudgetData();
                var days = 7;
                var date = new Date('1/1/2018');
                
                for(var i=0; i<52; i++) {
                    var budget = budgetData[i];
                    if(date.getMonth() == n) {
                        totBudget+=budget;
                    }
                    var res = date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                    date = new Date(res);
                }
                
				var rows = reportResultData.factMap['T!T'].rows;
                var totRows = 0;
                var totMeals = 0;
                var totPrice = 0;
                var totNew = 0;
                var oppIds = [];
                var acctIds = [];

                
                for(var i=0; i < rows.length; i++) {
                    var row = rows[i].dataCells;                    
                    totRows++;
                    
                    // Count Meals if Product Name is Avail
                    if(row[2].label != null && row[2].label.length > 0) {
                    	var prodName = row[2].label;
                        if(prodName == 'Just Lunch') {
                            totMeals+=10;
                        } else if(prodName == 'A-la-carte') {
                            totMeals+=11;
                        } else if(prodName == 'E 1/2') {
                            totMeals+=6;
                        } else {
                            totMeals+=12;
                        }
                    }
                    
                    var amt = 0;
                    if(row[4].label != null && row[4].label.length > 0) {
                        amt = row[4].label.substring(1);
                        //console.log(i + '~' + amt);
                    }
                    if(row[5].label != null) {
						var fndId = _.findWhere(oppIds, {id: row[5].label});
						if(fndId == null) {
							oppIds.push({id:row[5].label});
							amt = amt.replace(',','');
                            var totShipments = row[11].label;
                            var iAmt = parseFloat(amt);
                            var iShipments = parseInt(totShipments);
                            var amt = iAmt / iShipments;
							totPrice+= amt;
						}
					}

					if(row[6].label != null && row[3].value == 'New Customer') {
						var fndId = _.findWhere(acctIds, {id: row[6].label});
						if(fndId == null) {
                            acctIds.push({id:row[6].label});
                            totNew++;
						}
					}                    
                }
                component.set("v.stat1", totRows.toString());
                component.set("v.stat2", totBudget.toString());
                component.set("v.stat3", (totRows-totBudget).toString());
                component.set("v.stat4", '$' + (totPrice/oppIds.length).toFixed(2).toString());
                component.set("v.stat5", totMeals.toString());
                component.set("v.stat6", totNew.toString());
                
            }
        });
        $A.enqueueAction(action);
    },
    createChartTableDetail : function (component) {
        var ready = component.get("v.ready");
        var tableData = component.get("v.tableData");        
        var filterValue = component.get("v.filterValue");
        
        var groupByCol = component.get("v.groupByCol");
        var detailFilterCol = component.get("v.detailFilterCol");
        var detailFilterValue = component.get("v.detailFilterValue");
        var uniqueCol = component.get("v.uniqueCol");
        
        if(filterValue == '') {
            filterValue = null;
        }
                
        if (ready === false) {
            return;
        }
        //var chartCanvas = component.find("chart").getElement();
        var reportId = component.get("v.reportId");

        var action = component.get("c.getreport");
        var params ={  reportId : reportId, filterStr: filterValue, getAllData: true };
    	action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var reportResultData = JSON.parse(response.getReturnValue());
                var chartData = [];
                var chartLabels = [];
                var usedIds = [];
                var tot = 0;
                var totRows = 0;
                var rows = reportResultData.factMap['T!T'].rows;
				
                // Make 0 based
                if(detailFilterCol != null && detailFilterCol.length > 0) {
                	detailFilterCol--;
                } else {
                    detailFilterCol=null;
                }
                if(uniqueCol != null && uniqueCol.length > 0) {
                	uniqueCol--;
                } else {
                    uniqueCol=null;
                }
                groupByCol--;
                
                
                for(var i=0; i < rows.length; i++) {                    
                    var row = rows[i].dataCells;                    
                    totRows++;
                    
                    if(detailFilterCol != null && detailFilterValue != null && detailFilterValue.length > 0 && row[detailFilterCol].label != detailFilterValue) {
                        continue;
                    }

                    if(uniqueCol != null && row[uniqueCol].label != null) {
						var fndId = _.findWhere(usedIds, {id: row[uniqueCol].label});
						if(fndId == null) {
                            usedIds.push({id:row[uniqueCol].label});
                            
                            var fndGroup = _.findWhere(chartData, {col1: row[groupByCol].label});
                            if(fndGroup == null) {
                                var obj = {
                                    col1: row[groupByCol].label,
                                    col2: 1,
                                    col3: 0
                                }
                                chartData.push(obj);
                            } else {
								fndGroup.col2 = fndGroup.col2+1;                                
                            }                            
                        }
                    } else {
                        
                        var fndGroup = _.findWhere(chartData, {col1: row[groupByCol].label});
                        if(fndGroup == null) {
                            var obj = {
                                col1: row[groupByCol].label,
                                col2: 1,
                                col3: 0
                            }
                            chartData.push(obj);
                        } else {
                            fndGroup.col2 = fndGroup.col2+1;                                
                        }                            
                    }
                }
                
                for(var i=0; i < chartData.length; i++) {
                    tot+=chartData[i].col2;
                }
                var obj = {
                    col1: '',
                    col2: tot,
                    col3: null,
                };
                chartData.push(obj);
                                
                for(var i=0; i < chartData.length; i++) {
                    var cd = chartData[i];
                    var perc = '';
                    if(cd.col2 != null && cd.col3 != null) {
	                    perc = Math.trunc((cd.col2 / tot) * 100);
                        perc += "%";
                    }
                    cd.col3 = perc;
                }
                
                chartData = _.sortBy(chartData, function(obj){ 
                    var sn = obj.col3;
                    sn = sn.replace('%','');
                    return parseInt(sn*-1);
                });
                
                //Construct chart
                component.set("v.tableData", chartData);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on createReport: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },    
    createChartTable : function (component) {
        var ready = component.get("v.ready");
        var tableData = component.get("v.tableData");        
        var filterValue = component.get("v.filterValue");
        if(filterValue == '') {
            filterValue = null;
        }
                
        if (ready === false) {
            return;
        }
        //var chartCanvas = component.find("chart").getElement();
        var reportId = component.get("v.reportId");

        var action = component.get("c.getreport");
        var params ={  reportId : reportId, filterStr: filterValue };
    	action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var reportResultData = JSON.parse(response.getReturnValue());
                var chartData = [];
                var chartLabels = [];
                var tot = 0;
                
                if(this.defined(reportResultData,"groupingsDown.groupings.length")) {
                
                    for(var i=0; i < (reportResultData.groupingsDown.groupings.length); i++) {
                                            
                        //Collect all labels for Chart.js data
                        var labelTemp = reportResultData.groupingsDown.groupings[i].label;
                        var keyTemp = reportResultData.groupingsDown.groupings[i].key;
    
                        //Collect all values for Chart.js data
                        var valueTemp = reportResultData.factMap[keyTemp + '!T'].aggregates[0].value ;
    
                        var obj = {
                            col1: labelTemp,
                            col2: valueTemp,
                            col3: 0
                        }
                        tot+=valueTemp;
                        chartData.push(obj);
                    }
            	}
                
                var obj = {
                        col1: '',
                        col2: tot,
                        col3: null,
                    };
                chartData.push(obj);
                
                for(var i=0; i < chartData.length; i++) {
                    var cd = chartData[i];
                    var perc = '';
                    if(cd.col2 != null && cd.col3 != null) {
	                    perc = Math.trunc((cd.col2 / tot) * 100);
                        perc += "%";
                    }
                    cd.col3 = perc;
                }
                
                //Construct chart
                component.set("v.tableData", chartData);

                
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on createReport: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    createChartDoughnut : function (component) {
        var ready = component.get("v.ready");
        if (ready === false) {
            return;
        }
        var chartCanvas = component.find("chart").getElement();
        var reportId = component.get("v.reportId");

        var action = component.get("c.getreport");
		var params ={  reportId : reportId  };
    	action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var reportResultData = JSON.parse(response.getReturnValue());
                var chartData = [];
                var chartLabels = [];
                for(var i=0; i < (reportResultData.groupingsDown.groupings.length); i++){
                    //Collect all labels for Chart.js data
                    var labelTemp = reportResultData.groupingsDown.groupings[i].label;
                    chartLabels.push(labelTemp);

                    var keyTemp = reportResultData.groupingsDown.groupings[i].key;

                    //Collect all values for Chart.js data
                    var valueTemp = reportResultData.factMap[keyTemp + '!T'].aggregates[0].value ;
                    chartData.push(valueTemp);
                }
                //Construct chart
                var chart = new Chart(chartCanvas,{
                    type: 'doughnut',
                    data: {
                        labels: chartLabels,
                        datasets: [
                            {
                                label: "test",
                                data: chartData,
                                backgroundColor: [
                                    "#52BE80",
                                    "#76D7C4",
                                    "#1E8449",
                                    "#2ECC71",
                                    "#FFB74D",
                                    "#E67E22",
                                    "#F8C471",
                                    "#3498DB",
                                    "#00BCD4",
                                    "#D32F2F",
                                    "#82E0AA",
                                    "#AFB42B"
                                ]
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        cutoutPercentage: 75,
                        maintainAspectRatio: false,
                        legend: {
                            display: true,
                            position:'right',
                            fullWidth:false,
                            reverse:true,
                            labels: {
                                fontColor: '#000',
                                fontSize:10,
                                fontFamily:"Salesforce Sans, Arial, sans-serif SANS_SERIF"
                            },
                            layout: {
                                padding: 70,
                            }
                        }
                    }
                });
                return chart;
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on createReport: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                return null;
            }
        });
        $A.enqueueAction(action);
    },
    createChartLines : function (component) {
		var ready = component.get("v.ready");
        if (ready === false) {
            return;
        }
        var chartCanvas = component.find("chart").getElement();
        var reportId = component.get("v.reportId");
        var chartInstance = component.get("v.chartInstance");
        if(chartInstance != null && chartInstance.length > 0) {
            var chartdata = [];
            var labels = ["x"];
            
    		var LineGraph = new Chart(chartCanvas, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: chartdata
                }});
            LineGraph.destroy();
        }
        
        var action = component.get("c.getreport");
		var params ={  reportId : reportId  };
    	action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var reportResultData = JSON.parse(response.getReturnValue());
                var chartData = [];
                var chartLabels = [];
                var series = [];
                
                for(var i=0; i < (reportResultData.groupingsDown.groupings.length); i++){
                    var grp1 = reportResultData.groupingsDown.groupings[i];
                    
                    //Collect all labels for Chart.js data
                    var labelTemp = grp1.label;
                    chartLabels.push(labelTemp);
                    
                    for(var j=0; j< grp1.groupings.length; j++) {
                        var grp2 = grp1.groupings[j];
                        var lab2 = grp2.label;
                        var key2 = grp2.key;
                        var val = reportResultData.factMap[key2 + '!T'].aggregates[0].value;

                        series.push({
                            grp1: labelTemp,
                            grp2: lab2,
                            val: val
                        })                        
                    }
                }
                
                //Construct chart
                var colors = [
                    'rgba(23, 48, 91, 1)',
                    'rgba(62, 159, 222, 1)',
                    'rgba(48, 165, 154, 1)',
                    'rgba(132, 220, 214, 1)',
                    'rgba(222, 159, 0, 1)',
                    'rgba(223, 205, 114, 1)'
                ];
                
                var years = window.olympicDataService.getData();
                
                var labels = [];
                var datasets = [];
                // var countries = {};
                
                // years.forEach(function(year) {
                //     labels.push(year.year);
                //     year.countries.forEach(function(country) {
                //         var total = country.gold + country.silver + country.bronze;
                //         if (countries[country.country]) {
                //             countries[country.country].push(total);    
                //         } else {
                //             countries[country.country] = [total];   
                //         }
                //     })
                // });
                
                // var i=0;
                // for (var key in countries) {
                //     datasets.push({
                //         label: key, 
                //         data: countries[key],
                //         fill: false,
                //         borderWidth: 1.5,
                //         backgroundColor: colors[i++],
                //         borderColor: colors[i],
                //         pointBackgroundColor: "#FFFFFF",
                //         pointBorderWidth: 4,
                //         pointHoverRadius: 8,
                //         pointRadius: 6,
                //         pointHitRadius: 10,
                //     });
                // }
                
                // Setup Data
                var labels = chartLabels;
                
                for(var j=2016; j<=2018; j++) {
                    var idx = j-2016
                    var key = j.toString();
                    var vals = [];
                    for(var i=1; i<=52; i++) {
                        var grp1 = i.toString();
                        var grp2 = 'CY' + key;
                        var val = _.findWhere(series, {grp1: grp1, grp2: grp2});
                        if(val == null) {
                            vals.push(null);                        
                        } else {
	                        vals.push(val.val);
                        }
                    }                    
                    datasets.push({
                        label: key, 
                        data: vals,
                        fill: false,
                        borderWidth: 1.5,
                        backgroundColor: colors[idx],
                        borderColor: colors[idx],
                        pointBackgroundColor: "#FFFFFF",
                        pointBorderWidth: 4,
                        pointHoverRadius: 8,
                        pointRadius: 6,
                        pointHitRadius: 10,
                    });
                }
                
                var budget = this.getBudgetData();

                datasets.push({
                    label: 'Budget', 
                    data: budget,
                    fill: false,
                    borderWidth: 1.5,
                    backgroundColor: colors[idx+1],
                    borderColor: colors[idx+1],
                    pointBackgroundColor: "#FFFFFF",
                    pointBorderWidth: 4,
                    pointHoverRadius: 8,
                    pointRadius: 6,
                    pointHitRadius: 10,
                });                    
                
                var ctx = component.find("chart").getElement();
				
				Chart.controllers.lineWithReference = Chart.controllers.line.extend({
					initialize: function () {
						Chart.controllers.line.prototype.initialize.apply(this, arguments);
					},
					draw: function () {
						Chart.controllers.line.prototype.draw.apply(this, arguments);

						var scale = this.scale
						var sum = 0;
						this.getDataset().data.forEach(function(value) {
						  sum = sum + value;
						});

						var average = sum / this.getDataset().data.length;

						var averageCoord = this.calculatePointY(average);

						// draw line
						this.chart.chart.canvas.ctx = this.chart.chart.canvas.getContext('2d');
						this.chart.chart.canvas.ctx.beginPath();
						this.chart.chart.canvas.ctx.moveTo(0, averageCoord);
						this.chart.chart.canvas.ctx.strokeStyle = '#979797';
						this.chart.chart.canvas.ctx.lineTo(this.chart.chart.width, averageCoord);
						this.chart.chart.canvas.ctx.stroke();
					}
				});				
				
				
                var chart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: datasets
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio :false,
                        onClick: function(event) {
                            var elements = chart.getElementAtEvent(event);
                            console.log("elements");
                            console.log(elements);
                            if (elements.length === 1) {
                                var year = labels[elements[0]._index];
                                var country = datasets[elements[0]._datasetIndex].label;
                                var chartEvent = $A.get("e.c:ChartEvent");
                                chartEvent.setParams({
                                    data: {year: year, country: country}
                                });
                                chartEvent.fire();
                            }
                        }
                    }
                });
                
                //chartInstance
                component.set("v.chartInstance","xx");
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on createReport: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                return null;
            }
        });
        $A.enqueueAction(action);        
       
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
    },
    getBudgetData : function (component) {
		var budget = [];
		budget.push(117);
		budget.push(117);
		budget.push(117);
		budget.push(117);
		budget.push(117);
		budget.push(106);
		budget.push(106);
		budget.push(106);
		budget.push(106);
		budget.push(108);
		budget.push(108);
		budget.push(108);
		budget.push(108);
		budget.push(93);
		budget.push(93);
		budget.push(93);
		budget.push(93);
		budget.push(93);
		budget.push(120);
		budget.push(120);
		budget.push(120);
		budget.push(120);
		budget.push(122);
		budget.push(122);
		budget.push(122);
		budget.push(122);
		budget.push(99);
		budget.push(99);
		budget.push(99);
		budget.push(99);
		budget.push(99);
		budget.push(124);
		budget.push(124);
		budget.push(124);
		budget.push(124);
		budget.push(163);
		budget.push(163);
		budget.push(163);
		budget.push(163);
		budget.push(145);
		budget.push(145);
		budget.push(145);
		budget.push(145);
		budget.push(145);
		budget.push(194);
		budget.push(194);
		budget.push(194);
		budget.push(194);
		budget.push(200);
		budget.push(200);
		budget.push(200);
		budget.push(200);
		
		return budget;
	
	}

})