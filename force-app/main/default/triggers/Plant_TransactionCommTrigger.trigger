trigger Plant_TransactionCommTrigger on Plant_Transaction__e (after insert) {

    // Fires after Order or Subscription Add / Edit
    System.debug('Trigger.new:' + Trigger.new);
    
    List<Plant_Transaction_Comm__c> lstTransComm = new List<Plant_Transaction_Comm__c>();
    
    List<Plant_Transaction__e> lstOrderEvents = new List<Plant_Transaction__e>();
    List<Plant_Transaction__e> lstSubscriptionEvents = new List<Plant_Transaction__e>();
    
    for(Plant_Transaction__e e : Trigger.new){
        
        // Insert Communication Record
        Plant_Transaction_Comm__c newTransComm = new Plant_Transaction_Comm__c(
            Plant_Type__c = e.Plant_Type__c,
            Plant_Account__c = e.Plant_AccountId__c,
            Plant_Order__c = e.Plant_OrderId__c,
            Plant_Subscription__c = e.Plant_SubscriptionId__c,
            Plant_Transaction_Date_Time__c = DateTime.Now()
        );
        lstTransComm.add(newTransComm );
    
        if(e.Plant_Type__c.toLowerCase().indexOf('order') > -1) {
            lstOrderEvents.add(e);
        }
        else if(e.Plant_Type__c.toLowerCase().indexOf('subscription') > -1) {
            lstSubscriptionEvents.add(e);
        }

        
    }
    insert lstTransComm;
    
    // Call POST Transaction Handlers
    if(!lstOrderEvents.isEmpty()) {
        Plant_Orders_BC.postTransactionOrderHandler(lstOrderEvents);
    }
    
    // Call POST Transaction Handlers
    if(!lstOrderEvents.isEmpty()) {
        Plant_Orders_BC.postTransactionOrderHandler(lstSubscriptionEvents);
    }
    
    // Send Communications
    for(Plant_Transaction_Comm__c ptc :lstTransComm) {
        Plant_TransComm_BC.sendTransComm(ptc.id);
    }

}