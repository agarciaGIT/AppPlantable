trigger onTransaction on ChargentSFA__Transaction__c (before insert) {
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ChargentSFATransactionMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest() ){
        runTrigger = True;
    }
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD'){
        runTrigger = True;
    }
    
    if(runTrigger){
        List<Transaction_Event__e> eventList = new List<Transaction_Event__e>();
        for(ChargentSFA__Transaction__c t : trigger.new) {
            
            if(t.ChargentSFA__Response_Status__c == 'Approved' && t.ChargentSFA__Type__c == 'Charge' && t.ChargentSFA__Amount__c > 0 && !t.ChargentSFA__Recurring__c && t.ChargentSFA__Payment_Method__c == 'Credit Card') {          
                Transaction_Event__e evt = new Transaction_Event__e();
                evt.Amount__c = t.ChargentSFA__Amount__c;
                evt.Authorization__c = t.ChargentSFA__Authorization__c;
                evt.Card_Last_4__c = t.ChargentSFA__Card_Last_4__c;
                evt.Chargent_Token__c = t.ChargentSFA__Tokenization__c;
                evt.Gateway_Date__c = t.ChargentSFA__Gateway_Date__c;
                evt.Gateway_ID__c = t.ChargentSFA__Gateway_ID__c;
                evt.Gateway_Response__c = t.ChargentSFA__Gateway_Response__c;
                evt.Opportunity_ID__c = t.ChargentSFA__Opportunity__c;
                evt.Response_Status__c = t.ChargentSFA__Response_Status__c;
                eventList.add(evt);
                System.debug('~~~onTransaction:' + t.ChargentSFA__Tokenization__c);
            }
        }
        if(!eventList.isEmpty()){
            EventBus.Publish(eventList);
        }
    }
}