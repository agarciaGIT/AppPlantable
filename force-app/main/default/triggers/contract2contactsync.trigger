trigger contract2contactsync on Contract (after update, after insert) {
    
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ContractMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD' ){
        runTrigger = True;
    }
    
    System.debug('contract2contactsync::>>    '+runTrigger);
    
    
    
    if(runTrigger){
        
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract>();
        List<id> lstIds = new List<id>();
        if(!contractSyncUtil.skipSyncTrigger){
            for(Contract obj : trigger.New)
            {   
                if(obj.Status != 'Draft')
                    mapAccountIds.put(obj.accountId,obj);
            }
            
            if(mapAccountIds.size() <= 0) return;
            
            if(!contractSyncUtil.bRecursive) {
                for(ID c :mapAccountIds.keySet()) {
                    lstIds.add(c);
                }
                contractSyncUtil.updateContracts(lstIds);
            }
            
            
            if(Trigger.isAfter && Trigger.isUpdate && ScrContractTriggerHelper.isFirstRun ){
                ScrContractTriggerHelper.createPearsonVueData(trigger.New,Trigger.OldMap);
            }
            
            if(Trigger.isAfter && Trigger.isUpdate ) {
                if(!system.isBatch()){
                    RiskDotNetMemberShip.CallRiskDotNet(trigger.new, trigger.oldMap);
                } 
                //on24API.manageAccessOnContract(trigger.new, trigger.oldMap);
            }
        }
        
        if(Trigger.isAfter && Trigger.isUpdate) {
            Set<String> accountIds = new Set<String>();
            string memberRecTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Membership').getRecordTypeId();
            string frmRecTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('FRM_Program').getRecordTypeId();
            string erpRecTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('ERP_Program').getRecordTypeId();
            for(Contract newContract : trigger.New) {
                
                System.debug('newContract.Status:' + newContract.Status);
                
                Contract oldContract = trigger.oldMap.get(newContract.Id);
                
                System.debug('oldContract.Status:' + oldContract.Status);
                
                // AG Store newly Activated and Expired Contracts
                if(oldContract.Status != newContract.Status && newContract.Status.indexOf('Activ') > -1 && newContract.RecordTypeId == memberRecTypeId && (newContract.Membership_Type__c == 'Individual' || newContract.Membership_Type__c == 'Affiliate')) {
                    accountIds.add(newContract.AccountId);
                }
                if(oldContract.Status != newContract.Status && newContract.Status == 'Expired' && newContract.RecordTypeId == memberRecTypeId && newContract.Membership_Type__c == 'Individual') {
                    accountIds.add(newContract.AccountId);
                }
                if(oldContract.All_Requirements_Completed__c != newContract.All_Requirements_Completed__c && newContract.All_Requirements_Completed__c == True && newContract.RecordTypeId == frmRecTypeId) {
                    accountIds.add(newContract.AccountId);
                }
                if(oldContract.Status != newContract.Status && newContract.Status == 'Canceled' && 
                   ((newContract.RecordTypeId == memberRecTypeId && newContract.Membership_Type__c == 'Individual')
                    || newContract.RecordTypeId == frmRecTypeId
                    || newContract.RecordTypeId == erpRecTypeId)) {
                        accountIds.add(newContract.AccountId);
                    }
            }
            
            System.debug('accountIds:' + accountIds);
            
            List<Fonteva_Updates__e> updates = new List<Fonteva_Updates__e>();
            if(!accountIds.isEmpty()){
                for(String accId : accountIds){
                    Fonteva_Updates__e fontUpd = new Fonteva_Updates__e();
                    fontUpd.Account_Id__c = accId;
                    updates.add(fontUpd);
                }
            }
            if(!updates.isEmpty()) {
                EventBus.publish(updates);
            }
        }
        
    }
}