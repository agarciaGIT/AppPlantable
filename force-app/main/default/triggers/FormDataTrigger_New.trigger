trigger FormDataTrigger_New on Form_Data__c (after delete, after insert, after update, before delete, before insert, before update) {
    if(!FeatureManagement.checkPermission('Skip_All_Trigger')){
        TriggerFactory.createAndExecuteHandler(FormDataTrigger_NewHandler.class);
    }
}