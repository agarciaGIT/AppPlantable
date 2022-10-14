trigger allRequirementsComplete on contract (after update) {
    
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ContractMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD' ){
        runTrigger = True;
    }
    
    System.debug('allRequirementsComplete::>>    '+runTrigger);
    
    
    
    if(runTrigger){
        allRequirementsCompleteTrgHandler areq = new allRequirementsCompleteTrgHandler();
        areq.allRequirementsComplete(Trigger.new,Trigger.oldMap,Trigger.oldMap);
        
    }
}