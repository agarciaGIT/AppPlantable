trigger CommunityUserCreation on Contact (before update) {
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ContactMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD'){
        runTrigger = True;
    }
    
    if(runTrigger){
        if(!CommunityUtils.bIsRecusrsive){
            CommunityUtils.createCommunityUser(Trigger.New);
        }
    }
}