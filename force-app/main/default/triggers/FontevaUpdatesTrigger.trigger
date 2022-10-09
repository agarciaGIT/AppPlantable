trigger FontevaUpdatesTrigger on Fonteva_Updates__e (after Insert) {
    Set<String> accountIds = new Set<String>();
    for(Fonteva_Updates__e evt : Trigger.new){
        if(String.isNotBlank(evt.Account_Id__c)){
            accountIds.add(evt.Account_Id__c);
        }
    }
    
    if(!accountIds.isEmpty() && !test.isRunningTest()){
        FontevaClass.contractStatusChange(accountIds);
    }
}