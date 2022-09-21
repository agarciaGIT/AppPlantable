public class SpendKPISummary {

    Public class purchaseData {
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public Integer payingCust {get;set;}
        @AuraEnabled public Integer totalOrders {get;set;}
        @AuraEnabled public Integer avgBoxes {get;set;}
        @AuraEnabled public Integer avgOrders {get;set;}
        @AuraEnabled public Integer totalMeals {get;set;}
        @AuraEnabled public Integer avgMeals {get;set;}
        @AuraEnabled public Integer totalRepeat {get;set;}
        @AuraEnabled public Integer percRepeat {get;set;}
        @AuraEnabled public Integer totalCustSpend {get;set;}
        @AuraEnabled public Integer avgCustSpend {get;set;}
        @AuraEnabled public Integer threeMonthSpend {get;set;}
        @AuraEnabled public Integer sixMonthSpend {get;set;}
        @AuraEnabled public Integer twelveMonthSpend {get;set;}
        @AuraEnabled public Integer eighteenMonthSpend {get;set;}
        @AuraEnabled public Integer twentyfourMonthSpend {get;set;}
    }
    
    Public class allTimeData {
        @AuraEnabled public Integer threeMonthSpend {get;set;}
        @AuraEnabled public Integer sixMonthSpend {get;set;}
        @AuraEnabled public Integer twelveMonthSpend {get;set;}
        @AuraEnabled public Integer eighteenMonthSpend {get;set;}
        @AuraEnabled public Integer twentyfourMonthSpend {get;set;}
        @AuraEnabled public Integer percActive3Prev {get;set;}
        @AuraEnabled public Integer percActive6Prev {get;set;}
        @AuraEnabled public Integer percAcquired3Prev {get;set;}
        @AuraEnabled public Integer percAcquired6Prev {get;set;}
        @AuraEnabled public Integer percActive3AfterFirst {get;set;}
        @AuraEnabled public Integer percActive6AfterFirst {get;set;}
        @AuraEnabled public Integer totalFirstSpend {get;set;}
        @AuraEnabled public Integer avgFirstSpend {get;set;}
    }
    
    @auraEnabled public List<purchaseData> lstYearlyData{get;set;}
    @auraEnabled public List<purchaseData> lstProductData{get;set;}
    @auraEnabled public List<purchaseData> lstChannelData{get;set;}
    @auraEnabled public List<purchaseData> lstQuartData{get;set;}
    
    @auraEnabled public allTimeData allTimeData{get;set;}
    @auraEnabled public List<Account> lstAcct{get;set;}
    
    @AuraEnabled
    public static SpendKPISummary initClass(String inDate){
        
        SpendKPISummary obj = new SpendKPISummary();
        obj.lstYearlyData = new List<purchaseData>();
        
        purchaseData yd1 = new purchaseData();
        yd1.name = 'All Time (since 2015)';
		obj.lstYearlyData.add(yd1);
        
		purchaseData yd1A = new purchaseData();
        yd1A.name = 'All Time (exclude last 3 months)';
		obj.lstYearlyData.add(yd1A);
        
        purchaseData yd2 = new purchaseData();
        yd2.name = '2016';
		obj.lstYearlyData.add(yd2);
        
        purchaseData yd3 = new purchaseData();
        yd3.name = '2017';
		obj.lstYearlyData.add(yd3);

        purchaseData yd4 = new purchaseData();
        yd4.name = '2018';
        obj.lstYearlyData.add(yd4);

        purchaseData yd5 = new purchaseData();
        yd5.name = '2019';
        obj.lstYearlyData.add(yd5);
        
        for(purchaseData yd :obj.lstYearlyData) {
            yd.payingCust = 0;
            yd.totalOrders = 0;
            yd.avgBoxes = 0;
            yd.avgOrders = 0;
            yd.totalMeals = 0;
            yd.avgMeals = 0;
            yd.totalRepeat = 0;
            yd.percRepeat = 0;
            yd.avgCustSpend = 0;
            yd.totalCustSpend = 0;
        }
        

        obj.lstProductData = new List<purchaseData>();
        purchaseData pd1 = new purchaseData();
        pd1.name = 'Meals Only';
		obj.lstProductData.add(pd1);
        
        purchaseData pd2 = new purchaseData();
        pd2.name = 'Program';
		obj.lstProductData.add(pd2);

        purchaseData pd3 = new purchaseData();
        pd3.name = 'E28ZJ';
		obj.lstProductData.add(pd3);
        
        purchaseData pd4 = new purchaseData();
        pd4.name = 'QSZJ';
		obj.lstProductData.add(pd4);
        
        for(purchaseData yd :obj.lstProductData) {
            yd.payingCust = 0;
            yd.totalOrders = 0;
            yd.avgBoxes = 0;
            yd.avgOrders = 0;
            yd.totalMeals = 0;
            yd.avgMeals = 0;
            yd.totalRepeat = 0;
            yd.percRepeat = 0;
            yd.avgCustSpend = 0;
            yd.totalCustSpend = 0;
        }
                
        // Channel
		obj.lstChannelData = new List<purchaseData>();
        
        purchaseData ch1 = new purchaseData();
        ch1.name = 'Fitness Partnership';
		obj.lstChannelData.add(ch1);
        
        purchaseData ch2 = new purchaseData();
        ch2.name = 'Marketing';
		obj.lstChannelData.add(ch2);

        purchaseData ch3 = new purchaseData();
        ch3.name = 'Medical/MD Partnership';
		obj.lstChannelData.add(ch3);
        
        purchaseData ch4 = new purchaseData();
        ch4.name = 'Nutritionist/RD Partnership';
		obj.lstChannelData.add(ch4);

        purchaseData ch5 = new purchaseData();
        ch5.name = 'Social Media';
		obj.lstChannelData.add(ch5);
        
        purchaseData ch6 = new purchaseData();
        ch6.name = 'WOM Referral';
		obj.lstChannelData.add(ch6);

        purchaseData ch7 = new purchaseData();
        ch7.name = 'Other';
		obj.lstChannelData.add(ch7);
        
        for(purchaseData yd :obj.lstChannelData) {
            yd.payingCust = 0;
            yd.totalOrders = 0;
            yd.avgBoxes = 0;
            yd.avgOrders = 0;
            yd.totalMeals = 0;
            yd.avgMeals = 0;
            yd.totalRepeat = 0;
            yd.percRepeat = 0;
            yd.avgCustSpend = 0;
            yd.totalCustSpend = 0;
        }            
            
        obj.lstQuartData = new List<purchaseData>();
        
        purchaseData qd1 = new purchaseData();
        qd1.name = '1st Quartile';
		obj.lstQuartData.add(qd1);
        
        purchaseData qd2 = new purchaseData();
        qd2.name = '2nd Quartile';
		obj.lstQuartData.add(qd2);

        purchaseData qd3 = new purchaseData();
        qd3.name = '3rd Quartile';
		obj.lstQuartData.add(qd3);

        purchaseData qd4 = new purchaseData();
        qd4.name = '4th Quartile';
		obj.lstQuartData.add(qd4);

        purchaseData topQ = new purchaseData();
        topQ.name = 'top 10%';
		obj.lstQuartData.add(topQ);
        
		for(purchaseData yd :obj.lstQuartData) {
            yd.payingCust = 0;
            yd.totalOrders = 0;
            yd.avgBoxes = 0;
            yd.avgOrders = 0;
            yd.totalMeals = 0;
            yd.avgMeals = 0;
            yd.totalRepeat = 0;
            yd.percRepeat = 0;
            yd.avgCustSpend = 0;
            yd.totalCustSpend = 0;

            yd.threeMonthSpend = 0;
            yd.sixMonthSpend = 0;
            yd.twelveMonthSpend = 0;
            yd.eighteenMonthSpend = 0;
            yd.twentyfourMonthSpend = 0;

        }        
        
        obj.allTimeData = new allTimeData();
        obj.allTimeData.threeMonthSpend=0;
        obj.allTimeData.sixMonthSpend=0;
        obj.allTimeData.twelveMonthSpend=0;
        obj.allTimeData.eighteenMonthSpend=0;
        obj.allTimeData.twentyfourMonthSpend=0;
        
        obj.allTimeData.percActive3Prev=0;
        obj.allTimeData.percActive6Prev=0;
        obj.allTimeData.percAcquired3Prev=0;
        obj.allTimeData.percAcquired6Prev=0;
        obj.allTimeData.percActive3AfterFirst=0;
        obj.allTimeData.percActive6AfterFirst=0;
        obj.allTimeData.totalFirstSpend=0;
        obj.allTimeData.avgFirstSpend=0;
        
            
        obj.lstAcct = [select Id, Name, First_Purchase_Date__c, Last_Purchase_Date__c, Total_Orders__c, X3_Month_Spend__c, X6_Month_Spend__c, X12_Month_Spend__c, X18_Month_Spend__c, X24_Month_Spend__c, Total_Revenue__c, Total_Shipment__c, Total_Spend_YTD__c, Initial_Product__c, Initial_Product_Type__c, Main_Channel__c, Initial_Spend__c from Account where Total_Revenue__c > 0 AND Is_Test__c = False Order By Total_Revenue__c ASC];

        return obj;
    }
    
}