trigger updateDeferred on Opportunity(after update) {
    
    /**
* This is the most important trigger which drives the business logic for when 
* the Opportunity is 'Closed' and whether to upgrade or to extend the Contract (Program) 
*/ 
    
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('OpportunityMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD' ){
        runTrigger = True;
    }
    
    if(runTrigger){
        
        if(opportunityTriggerHelper.isFirstRun){
            
            for (Opportunity opp: trigger.new)  {
                if((opp.stagename == 'Closed' ||  opp.stagename == 'Recurring Intent') && Trigger.oldMap.get(opp.Id).StageName != opp.StageName){
                    opportunityTriggerHelper.opportunityTriggerHelper(trigger.new);
                }
            }
            
        }
    }
}