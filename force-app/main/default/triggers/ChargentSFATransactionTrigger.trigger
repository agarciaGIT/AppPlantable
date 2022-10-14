trigger ChargentSFATransactionTrigger on ChargentSFA__Transaction__c ( after insert, after update,  before insert) {
    
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ChargentSFATransactionMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && metadataSwitch.isActive__c  && !Test.isRunningTest() ){
        runTrigger = True;
    }else if(Test.isRunningTest() && TestClassUtil.isNewTrigger == 'NEW' ){
        runTrigger = True;
    }
    
    if(runTrigger){
        system.debug('Skip_All_Trigger::>>  '+FeatureManagement.checkPermission('Skip_All_Trigger'));
        if(!FeatureManagement.checkPermission('Skip_All_Trigger')){
            TriggerFactory.createAndExecuteHandler(ChargentSFATransactionTriggerHandler.class);
        }
    }
}