global class batchUpdateShipmentStatus implements Database.Batchable<sObject>{
     
    public DateTime dateTimeRun;  
    public String testId;
    public String mode;
    
    global batchUpdateShipmentStatus(DateTime dtRun, String modeIn, String testIdIn){
        dateTimeRun = dtRun;
        testId = testIdIn;
        mode = modeIn;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  

        if(testId != NULL) {
            return Database.getQueryLocator('select Id, Opportunity__r.Account.Email__c, Shipment_Status_Touch__c, Status__c, Scheduled_Date__c, Delivery_Date__c, Shipping_Service_Type__c, Shipment_Day_Count__c, Shipment_Day_Count_Last_Run__c, Enable_Automation__c from Shipment__c Where Status__c != \'Cancelled\' AND (Shipment_Day_Count__c = NULL OR Shipment_Day_Count__c < 30) AND Shipment_Day_Count_Last_Run__c != :dateTimeRun AND Id = :testId');
        } else {
        	return Database.getQueryLocator('select Id, Opportunity__r.Account.Email__c, Shipment_Status_Touch__c, Status__c, Scheduled_Date__c, Delivery_Date__c, Shipping_Service_Type__c, Shipment_Day_Count__c, Shipment_Day_Count_Last_Run__c, Enable_Automation__c from Shipment__c Where Status__c != \'Cancelled\' AND (Shipment_Day_Count__c = NULL OR Shipment_Day_Count__c < 30) AND Shipment_Day_Count_Last_Run__c != :dateTimeRun');    
        }
    }    
    
    global void execute(Database.BatchableContext BC, List<Shipment__c> scope){
        Date tdy = Date.today();
        for(Shipment__c ship :scope) {
            // Set Shipment Day Count
            Date dt = ship.Scheduled_Date__c;
            system.debug('dt:' + dt);
            
            Date td = Date.today();
            system.debug('td:' + td);
            
            Integer diff = dt.daysBetween(td);
            system.debug('diff:' + diff);
            
            Integer cnt = diff;

            ship.Email_Address__c = ship.Opportunity__r.Account.Email__c;
            ship.Shipment_Day_Count__c = cnt;
            ship.Enable_Automation__c = false;
            
            if(ship.Shipping_Service_Type__c == 'Manhattan Courier' || ship.Shipping_Service_Type__c == 'Brooklyn Courier') {
                ship.Delivery_Date__c = ship.Scheduled_Date__c;
            } else if(ship.Shipping_Service_Type__c == '1 Day Ground') {
                ship.Delivery_Date__c = ship.Scheduled_Date__c+1;
            } else if(ship.Shipping_Service_Type__c == '2 Day Air' || ship.Shipping_Service_Type__c == '2 Day Ground') {
                ship.Delivery_Date__c = ship.Scheduled_Date__c+2;
            }
            
            if(cnt < 0) {
                ship.Status__c = 'Pending';
            } else if(cnt < 1 && ship.Shipping_Service_Type__c == '1 Day Ground') {
                ship.Status__c = 'In Progress';
            } else if(cnt < 2 && (ship.Shipping_Service_Type__c == '2 Day Air' || ship.Shipping_Service_Type__c == '2 Day Ground')) {
                ship.Status__c = 'In Progress';                
            } else {
                ship.Status__c = 'Completed Successfully';
            }
            if(mode != null) {
                ship.Shipment_Status_Touch__c = mode;
            }
            ship.Shipment_Day_Count_Last_Run__c = dateTimeRun;
        }        
        update scope;       
    }
    
    global void finish(Database.BatchableContext BC){
    }     
    
    @InvocableMethod(label='campaignUtil' description='Euphebe Campaign Utilities.')
    public static void campaignFlow(List<List<String>> inputParams) {  
        
    }
}