global class chargemodificationsonopp implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
       Set<String> setStatus = new Set<String>{'Recurring'};
      

       
       return Database.getQueryLocator('select id,accountId,ChargentSFA__Payment_Status__c ,ChargentSFA__Tokenization__c,ChargentSFA__Payment_Count__c,ChargentSFA__Charge_Amount__c,ChargentSFA__Manual_Charge__c,ChargentSFA__Next_Transaction_Date__c,ChargentSFA__Payment_Start_Date__c ,ChargentSFA__Payment_End_Date__c ,ChargentSFA__Payment_Stop__c ,ChargentSFA__Charge_Date__c ,ChargentSFA__Payment_Frequency__c from Opportunity where ChargentSFA__Payment_Status__c in : setStatus');
      
     }
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
    
        List<Opportunity> lstOpportunities = new List<Opportunity>();
        Map<Id,Contract> memContractsMap = new Map<Id,Contract>();
        id memRecTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'Membership');
        Set<Id> setAccIds = new Set<Id>();
        for(Opportunity obj : scope)
        {
            setAccIds.add(obj.accountId);
            
        }
        
        AggregateResult[] groupedResults = [select SUM(ContractTerm) term,accountId from Contract where accountId in : setAccIds and recordTypeId = : memRecTypeId and Membership_Type__c = 'Student' group by accountId];
        
        Map<Id,boolean> mapContacts = new Map<Id,boolean>();
        
        
        Id frmRecType = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','FRM_Program');
        Id erpRecType = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','ERP_Program');
        
        for(Contract ct : [select id,name,accountId,Status,EndDate,recordTypeId from contract where accountId =: setAccIds and (recordTypeId =: memRecTypeId or recordTypeId =: frmRecType or recordTypeId =: erpRecType)])
        {
            if((ct.recordTypeId == frmRecType || ct.recordTypeId == erpRecType) && ct.Status == 'Completed'){
                mapContacts.put(ct.accountID,true);
            }else if(ct.recordTypeId == memRecTypeId && ct.Status == 'Activated ( Auto-Renew )'){
                memContractsMap.put(ct.accountID, ct);
            }
        }
        
        
        
        Map<Id,Decimal> mapAccountTerm = new Map<Id,Decimal>();
        for (AggregateResult Result: groupedResults)
        {
            mapAccountTerm.put((Id)Result.get('accountId'),(Decimal) Result.get('term'));
            
        }
        
        List<Opportunity> lstUpdateOpps = new List<Opportunity>();
        for(Opportunity objUpdate : scope)
        {
            if(mapContacts.get(objUpdate.accountID) != null && objUpdate.ChargentSFA__Charge_Amount__c != 150)
            {
                if(memContractsMap.containsKey(objUpdate.accountID)){
                	objUpdate.ChargentSFA__Payment_Start_Date__c = memContractsMap.get(objUpdate.accountID).EndDate;
                }
                objUpdate.ChargentSFA__Charge_Amount__c = 150;
                objUpdate.Do_Not_change_amount__c = true;
                lstUpdateOpps.add(objUpdate);
            }
            else if(mapAccountTerm.get(objUpdate.accountId) >= 24 && objUpdate.ChargentSFA__Charge_Amount__c != 95)
            {
                if(memContractsMap.containsKey(objUpdate.accountID)){
                	objUpdate.ChargentSFA__Payment_Start_Date__c = memContractsMap.get(objUpdate.accountID).EndDate;
                }
                objUpdate.ChargentSFA__Charge_Amount__c = 195;
                lstUpdateOpps.add(objUpdate);
            }
            else if(objUpdate.ChargentSFA__Charge_Amount__c != 195 && objUpdate.ChargentSFA__Charge_Amount__c != 150)
            {
                if(memContractsMap.containsKey(objUpdate.accountID)){
                	objUpdate.ChargentSFA__Payment_Start_Date__c = memContractsMap.get(objUpdate.accountID).EndDate;
                }
                objUpdate.ChargentSFA__Charge_Amount__c = 195;
                lstUpdateOpps.add(objUpdate);
            }
            
            
        }
        
        
        
        try{
            
            update lstUpdateOpps;
            
        }catch(Exception ex){}
        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}