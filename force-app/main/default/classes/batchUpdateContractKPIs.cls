global class batchUpdateContractKPIs implements Database.Batchable<sObject>{

    public String mode;  

    global batchUpdateContractKPIs(String modeIn){
        system.debug('Function: batchUpdateContractKPIs');
        system.debug('mode:' + modeIn);
        
        this.mode= modeIn;            
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
    
        string query;
        if(mode == 'inc') {
            query = 'select Id, AccountId, ContractTerm From Contract where RecordType.Name = \'Membership\' AND Membership_Type__c in (\'Individual\',\'Student\') AND status NOT in (\'Draft\',\'Canceled\') AND (LastModifiedDate > YESTERDAY OR KPI_Last_Updated__c = null)';
        } else if(mode == 'all') {
            query = 'select Id, AccountId, ContractTerm from Contract where RecordType.Name = \'Membership\' AND Membership_Type__c in (\'Individual\',\'Student\') AND status NOT in (\'Draft\',\'Canceled\')';
        } else {
            query = 'select Id, AccountId, ContractTerm from Contract where RecordType.Name = \'Membership\' AND Membership_Type__c in (\'Individual\',\'Student\') ID = :mode';
        }
        
        system.debug('***batchUpdateContractKPIs: ' + query );
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contract> scope){
    
        MAP<String,Integer> mapCnt = new MAP<String,Integer>();
    
        
        Set<String> accountIDs = new Set<String>();
        for(Contract c :scope) {
            accountIDs.add(c.AccountId);
        }
        
        system.debug('***batchUpdateContractKPIs: ' + accountIDs);

        
         List < Contract > updateContracts = new List < Contract >();
         List < Contract > lstContract = [select Id, AccountId, ContractTerm, Status, KPI_Last_Updated__c, KPI_Months_of_Membership__c, All_Requirements_Completed_Date__c, All_Requirements_Completed__c, Membership_Type__c, StartDate, EndDate, ActivatedDate, Opportunity__c, Opportunity__r.Program_Abbrev__c, recordTypeId 
                                             from Contract where 
                                             RecordType.Name = 'Membership' AND
                                             Membership_Type__c in ('Individual','Student') AND
                                             status in ('Activated','Activated ( Auto-Renew )','Expired','Completed') AND
                                             accountId in : accountIDs Order By StartDate];
        
         //System.assert(false, 'BOOM!!!!' + lstContract); 

        system.debug('***batchUpdateContractKPIs: ' + lstContract);
    
        
        for(Contract con :lstContract) {

            system.debug('***batchUpdateContractKPIs: ' + con);
            
            
            Integer cnt = mapCnt.get(con.AccountId);
            
            if(cnt == NULL) {
                cnt = 0;
                mapCnt.put(con.AccountId, cnt);
            }
            system.debug('***batchUpdateContractKPIs: ' + cnt);
             
            
            con.KPI_Months_of_Membership__c = cnt;
            con.KPI_Last_Updated__c = DateTime.now();
            updateContracts.add(con);
             
            cnt += con.ContractTerm;
            mapCnt.put(con.AccountID, cnt);

            system.debug('***batchUpdateContractKPIs: ' + cnt);
             
    
         }
        
        update(updateContracts);
                
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}