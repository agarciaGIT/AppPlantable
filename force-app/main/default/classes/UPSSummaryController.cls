public class UPSSummaryController {
    
    
    Public class summaryData {
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public Integer ice2 {get;set;}
        @AuraEnabled public Integer ice3 {get;set;}
        @AuraEnabled public Integer iceTotal {get;set;}
        @AuraEnabled public Boolean isNames {get;set;}        
        @AuraEnabled public String ice2Names {get;set;}
        @AuraEnabled public String ice3Names {get;set;}
    }

    @auraEnabled public Date nextShippingDate{get;set;}    
    @auraEnabled public List<Shipment__c> lstShipments{get;set;}
    @auraEnabled public List<summaryData> lstSummaryData{get;set;}    
       
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
        
        //shipDate = Date.newInstance(2020, 3, 30);
        return shipDate;
    }
    
    @AuraEnabled
    public static UPSSummaryController initClass(String inDate){
        
        UPSSummaryController obj = new UPSSummaryController();
        obj.lstSummaryData = new List<summaryData>();
        summaryData sd = new summaryData();
        sd.name = 'Quickstarts';
        sd.ice2 = 0;
        sd.ice3 = 0;
        sd.ice2Names = '';
        sd.ice3Names = '';
        obj.lstSummaryData.add(sd);
        
        if(inDate != null) {
            String[] arrText = inDate.split('-'); 
            System.debug('arrText:' + arrText);
            obj.nextShippingDate = Date.newInstance(Integer.valueOf(arrText[0]), Integer.valueOf(arrText[1]), Integer.valueOf(arrText[2]));
        } else {
            obj.nextShippingDate = getNextShippingDate();    
        }
        
        obj.lstShipments = [SELECT Id, First_Name__c, Last_Name__c, Product_Code__c, Is_First_Shipment__c, Product_Name__c, Order_Number__c, Box_Type__c, Coolant_Type__c, Dietary_Restrictions__c, Shipping_Service_Type__c, Is_New__c, Shipping_Type__c FROM Shipment__c WHERE Scheduled_Date__c = :obj.nextShippingDate AND Is_Test__c = FALSE AND Status__c != 'Cancelled'];

        return obj;
    }    
}