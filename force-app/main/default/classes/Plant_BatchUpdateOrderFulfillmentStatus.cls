global class Plant_BatchUpdateOrderFulfillmentStatus implements Database.Batchable<sObject>{

    public String orderID;  
    public String mode;
    
    global Plant_BatchUpdateOrderFulfillmentStatus(String inOrderID, String inMode){
        this.orderID = inOrderID;
        this.mode = inMode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
        Date modStDt = Date.today();
        Date modEdDt = Date.today().addDays(1);
        System.debug('modStDt:' + modStDt);
        System.debug('modEdDt:' + modEdDt);
        
        if(mode == 'ReadyToPack') {
            if(orderID != NULL) {
                return Database.getQueryLocator('select Id, Plant_Fulfillment_Status__c, Modification_Deadline__c from Order where Id = :orderID'); 
            } else {
                return Database.getQueryLocator('select Id, Plant_Fulfillment_Status__c, Modification_Deadline__c from Order where Plant_Fulfillment_Status__c = \'New Order - Do not Pack\' AND Modification_Deadline__c > :modStDt AND Modification_Deadline__c < :modEdDt');             
            }            
        } else if(mode == 'Shipped') {
            if(orderID != NULL) {
                return Database.getQueryLocator('select Id, Plant_Fulfillment_Status__c, Plant_Shipment_Date__c from Order where Id = :orderID'); 
            } else {
                return Database.getQueryLocator('select Id, Plant_Fulfillment_Status__c, Plant_Shipment_Date__c from Order where Plant_Fulfillment_Status__c = \'Packed Order - Ready to Ship\' AND Plant_Shipment_Date__c = TODAY');             
            }            
        }
        return Database.getQueryLocator('select Id, Plant_Fulfillment_Status__c, Plant_Shipment_Date__c from Order where Id = :orderID'); 
        
    }
    
    global void execute(Database.BatchableContext BC, List<Order> scope){
        List<Order> lstUpdateOrders = new List<Order>();
        for(Order ord :scope) {
            
            if(mode == 'ReadyToPack') {
                if(ord.Modification_Deadline__c != NULL && ord.Modification_Deadline__c < DateTime.now()) {
                    ord.Plant_Fulfillment_Status__c = 'New Order - Ready to Pack';
                    lstUpdateOrders.add(ord);
                }
            } else if(mode == 'Shipped') {
                ord.Plant_Fulfillment_Status__c = 'Shipped Order';
                lstUpdateOrders.add(ord);
            }
        }
        if(!lstUpdateOrders.isEmpty()) {
            update lstUpdateOrders;
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }  
}