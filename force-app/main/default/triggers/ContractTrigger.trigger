trigger ContractTrigger on Contract (after delete, after insert, after update, before delete, before insert, before update) {
    
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ContractMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }else if(Test.isRunningTest() && TestClassUtil.isNewTrigger == 'NEW' ){
        runTrigger = True;
    }
    
    System.debug('ContractTrigger::>>    '+runTrigger);
    
    if(runTrigger){
        system.debug('Skip_All_Trigger::>>  '+FeatureManagement.checkPermission('Skip_All_Trigger'));
        if(!FeatureManagement.checkPermission('Skip_All_Trigger')){
            TriggerFactory.createAndExecuteHandler(ContractTriggerHandler.class);
        }
    }
}