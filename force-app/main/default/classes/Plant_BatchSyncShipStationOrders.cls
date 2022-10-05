global class Plant_BatchSyncShipStationOrders implements Database.Batchable<sObject>, Database.AllowsCallouts {
     
    public String testId;
    public String mode;
    public String shipDate;    
    
    global Plant_BatchSyncShipStationOrders(String modeIn, String shipDateIn, String testIdIn){
        testId = testIdIn;
        mode = modeIn;
        shipDate = shipDateIn;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        
        Date sDate;
        if(shipDate != NULL) {
            sDate = Date.valueOf(shipDate);    
        }
        
        System.debug('mode:' + mode);
        System.debug('testId:' + testId);
        System.debug('sDate:' + sDate);
        
        if(testId != NULL) {
            return Database.getQueryLocator('select Id from Order Where Id = :testId');
        } else if(mode == 'customzip') {
            return Database.getQueryLocator('select Id from Order Where Status = \'Activated\' AND Plant_Fulfillment_Status__c = \'New Order - Ready to Pack\' AND Plant_Is_Test__c = False AND Plant_Shipment_Date__c != NULL AND Plant_Shipment_Date__c >= TODAY AND Plant_Shipment_Date__c = :sDate AND (Meal_Selection_Status__c = \'Custom\' OR Plant_Provider__c != \'Study\' OR Plant_Provider__c != \'Zipongo\')');
        } else if(mode == 'all') {
            return Database.getQueryLocator('select Id from Order Where Status = \'Activated\' AND Plant_Fulfillment_Status__c = \'New Order - Ready to Pack\' AND Plant_Is_Test__c = False AND Plant_Shipment_Date__c != NULL AND Plant_Shipment_Date__c >= TODAY AND Plant_Shipment_Date__c = :sDate');
            //return Database.getQueryLocator('select Id from Order Where Status = \'Activated\'');
        } else {
            return Database.getQueryLocator('select Id from Order Where Plant_Fulfillment_Status__c in (\'Awaiting Shipment\',\'Cancel Shipment\')');
        }
    }    
    
    global void execute(Database.BatchableContext BC, List<Order> scope){
        for(Order ord :scope) {
            Plant_ShipStation_BC.setOrderToShip(ord.Id);
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
    }         
}