public class localCourierSummaryController {
    
    
    Public class summaryData {
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String E28 {get;set;}
        @AuraEnabled public Integer E28Cnt {get;set;}
        @AuraEnabled public String swap {get;set;}
        @AuraEnabled public Integer swapCnt {get;set;}
        @AuraEnabled public String isNew {get;set;}
        @AuraEnabled public Integer isNewCnt {get;set;}
        @AuraEnabled public String alacarte {get;set;}
        @AuraEnabled public Integer alacarteCnt {get;set;}
        @AuraEnabled public String mom {get;set;}
        @AuraEnabled public Integer momCnt {get;set;}
        @AuraEnabled public String lunch {get;set;}
        @AuraEnabled public Integer lunchCnt {get;set;}
        @AuraEnabled public String total {get;set;}
    }

    @auraEnabled public List<summaryData> lstSummaryData{get;set;}
    @auraEnabled public summaryData aSummaryData{get;set;}
    @auraEnabled public Date nextShippingDate{get;set;}
    @auraEnabled public List<Shipment__c> lstShipmentData{get;set;}
    @auraEnabled public Integer daySince{get;set;}
    @auraEnabled public date weekStart{get;set;}
    
   
    @AuraEnabled
    public static Date getNextShippingDate() {
        Date shipDate;
        Date myDate = date.today();
        Date weekStart = myDate.toStartofWeek();
        weekStart = weekStart.addDays(1);
        Integer daySince = myDate.daysBetween(weekStart);        
        if(daySince < 0)
            shipDate = weekStart.addDays(7); 
        else shipDate = weekStart; 
        
        Date altDt = Date.newInstance(2018, 5, 28);       
        if(shipDate == altDt)
            shipDate = shipDate.addDays(1);
        
        altDt = Date.newInstance(2018, 9, 3);       
        if(shipDate == altDt)
            shipDate = shipDate.addDays(1);

        altDt = Date.newInstance(2018, 10, 8);       
        if(shipDate == altDt)
            shipDate = shipDate.addDays(1);

        altDt = Date.newInstance(2018, 11, 12);       
        if(shipDate == altDt)
            shipDate = shipDate.addDays(1);
        
        return shipDate;
    }
    
    @AuraEnabled
    public static localCourierSummaryController initClass(String inDate){
        
        localCourierSummaryController obj = new localCourierSummaryController();
        
        Date shipDate;
        date myDate = date.today();
        obj.weekStart = myDate.toStartofWeek();
        obj.weekStart = obj.weekStart.addDays(1);
        obj.daySince = myDate.daysBetween(obj.weekStart);        
        //if(obj.daySince == -1)
        //    obj.nextShippingDate = obj.weekStart.addDays(7); 
        //else obj.nextShippingDate = obj.weekStart; 
        
        if(inDate != null) {
            String[] arrText = inDate.split('-'); 
            System.debug('arrText:' + arrText);
            obj.nextShippingDate = Date.newInstance(Integer.valueOf(arrText[0]), Integer.valueOf(arrText[1]), Integer.valueOf(arrText[2]));
        } else {
            obj.nextShippingDate = getNextShippingDate();    
        }
        
        obj.lstShipmentData = [SELECT Id, First_Name__c, Last_Name__c, Product_Code__c, Product_Name__c, Order_Number__c, Box_Type__c, Coolant_Type__c, Dietary_Restrictions__c, Shipping_Service_Type__c, Is_New__c, Shipping_Type__c FROM Shipment__c WHERE (Shipping_Service_Type__c = 'Manhattan Courier' OR Shipping_Service_Type__c = 'Brooklyn Courier') AND Scheduled_Date__c = :obj.nextShippingDate AND Is_Test__c = FALSE AND Status__c != 'Cancelled'];

        obj.lstSummaryData = new List<summaryData>();

		summaryData sd1 = new summaryData();
        sd1.name = 'Manhattan Sort';
        obj.lstSummaryData.add(sd1);
        
        summaryData sd2 = new summaryData();
        sd2.name = 'Brooklyn Sort';
        obj.lstSummaryData.add(sd2);

        //summaryData sd3 = new summaryData();
        //sd3.name = 'Other';
        //obj.lstSummaryData.add(sd3);
        
        summaryData sdTotals = new summaryData();
        sdTotals.name = 'Total';
        obj.lstSummaryData.add(sdTotals);
        
        system.debug('!obj.lstSummaryData:' + obj.lstSummaryData);
        return obj;
    }    
}