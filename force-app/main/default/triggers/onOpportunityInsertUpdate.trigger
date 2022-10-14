trigger onOpportunityInsertUpdate on Opportunity (before update, before insert) {
    
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('OpportunityMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }
    
    
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD' ){
        runTrigger = True;
    }
    
    //if(TestClassUtil.isFirstTime){
      //  TestClassUtil.isFirstTime = false;
    
    if(runTrigger){
        if(trigger.isupdate){
            List<Opportunity> lstOpps = new List<Opportunity>();
            for(Opportunity o : trigger.new)
            {
                if(o.company_check__c > 0 && (o.company_check__c != trigger.oldMap.get(o.Id).company_check__c ))
                    lstOpps.add(o);
            }
            
            //if(lstOpps.isEmpty()) return;
            Map<String,updateids__c> mapSettings = updateids__c.getAll();
            if(trigger.isUpdate && trigger.isBefore)
            {
                for(Opportunity op : lstOpps)
                {
                    op.ChargentSFA__Gateway__c = mapSettings.get('GRA').Record_id__c;
                }
            }
            else if(trigger.isUpdate && trigger.isAfter)
            {
                List<Opportunity> lstUpdateOpps = new List<Opportunity>();
                
                for(Opportunity opp : [select id,ChargentSFA__Gateway__c from Opportunity  where id in: lstOpps])
                {
                    opp.ChargentSFA__Gateway__c = mapSettings.get('GRA').Record_id__c;
                    lstUpdateOpps .add(opp );
                }
                
                update lstUpdateOpps;
            }
        }
        
        if(!OppTriggerUtil.bIsRecusrive)
            OppTriggerUtil.OppTriggerLogic(Trigger.new);
        
        
    }
}