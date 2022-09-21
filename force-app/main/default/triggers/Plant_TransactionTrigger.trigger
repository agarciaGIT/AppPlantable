trigger Plant_TransactionTrigger on Plant_Transaction__e (after insert) {

    // Fires after Order or Subscription Add / Edit
    System.debug('Trigger.new:' + Trigger.new);
    
    List<Plant_Transaction_Comm__c> lstTransComm = new List<Plant_Transaction_Comm__c>();
    for(Plant_Transaction__e e : Trigger.new){
        Plant_Transaction_Comm__c newTransComm = new Plant_Transaction_Comm__c(
            Plant_Type__c = e.Plant_Type__c,
            Plant_Account__c = e.Plant_AccountId__c,
            Plant_Order__c = e.Plant_OrderId__c,
            Plant_Subscription__c = e.Plant_SubscriptionId__c,
            Plant_Transaction_Date_Time__c = DateTime.Now()
        );
        lstTransComm.add(newTransComm );
    }
    insert lstTransComm;
    
    for(Plant_Transaction_Comm__c ptc :lstTransComm) {
        Plant_TransComm_BC.sendTransComm(ptc.id);
    }

}