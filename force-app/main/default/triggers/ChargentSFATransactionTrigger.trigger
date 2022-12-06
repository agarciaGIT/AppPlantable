trigger ChargentSFATransactionTrigger on ChargentSFA__Transaction__c ( after insert, after update,  before insert) {
    
    system.debug('Skip_All_Trigger::>>  '+FeatureManagement.checkPermission('Skip_All_Trigger'));
    if(!FeatureManagement.checkPermission('Skip_All_Trigger')){
        TriggerFactory.createAndExecuteHandler(ChargentSFATransactionTriggerHandler.class);
    }
}