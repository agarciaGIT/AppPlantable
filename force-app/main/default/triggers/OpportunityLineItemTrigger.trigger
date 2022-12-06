trigger OpportunityLineItemTrigger on OpportunityLineItem (after delete, after insert, after update, before delete, before insert, before update) {
    
    system.debug('Skip_All_Trigger::>>  '+FeatureManagement.checkPermission('Skip_All_Trigger'));
    if(!FeatureManagement.checkPermission('Skip_All_Trigger')){
        TriggerFactory.createAndExecuteHandler(OpportunityLineItemTriggerHandler.class);
    }
}