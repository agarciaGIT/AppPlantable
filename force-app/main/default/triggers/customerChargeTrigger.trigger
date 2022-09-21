trigger customerChargeTrigger on CustomerChargeEvent__e (after insert) {
    for (CustomerChargeEvent__e event : Trigger.New) {
        System.enqueueJob(new Plant_ProcessTransaction_Queueable(event.RecordID__c));
        //System.enqueueJob(new Plant_ProcessTransaction_Queueable(siteBody));
    }
    
    //API_Request__c apir = new API_Request__c(
    //    Name = 'customerChargeTrigger '
    //);
    //insert apir;
}