global class batchUpdateBitlyLinks implements Database.Batchable<sObject>, Database.AllowsCallouts{
        
    public String mode;  

    global batchUpdateBitlyLinks(String mode){
        this.mode = mode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  

        System.debug('mode:' + mode);
        
        if(mode != NULL) {
            return Database.getQueryLocator('select ID, Account__c, Batch__c, Request_Type__c from API_Request__c where Study_ID__c != NULL AND Batch__c = True AND ID = :mode');    
        } else {
            return Database.getQueryLocator('select ID, Account__c, Batch__c, Request_Type__c from API_Request__c where Study_ID__c != NULL AND Batch__c = True');    
        }
        
    }    
                                            
    global void execute(Database.BatchableContext BC, List<API_Request__c> scope){

        Set<String> acctIDs = new Set<String>();
        for(API_Request__c ar :scope) {
            if(ar.Request_Type__c == 'Customer Update') {
            	acctIDs.add(ar.Account__c);    
            }
        }
        
        List<Account> lstAcctUpdate = new List<Account>();
        List<Account> lstAcct = [select Id, Batch__C, Finisher_Survey_Quickstart_Short_URL__c from Account where ID in :acctIDs AND Batch__C = True];
        if(lstAcct.size() > 0) {
            for(Account acct :lstAcct) {
                System.debug('Acct:' + acct.ID);
                
                //if(acct.Finisher_Survey_Quickstart_Short_URL__c == NULL) {
                    List<Account> lstAcctRet = mailChimpClass.setAccountSurveyLinksInternal(acct.ID);
                    System.debug('lstAcctRet:' + lstAcctRet);
                    if(lstAcctRet != NULL && lstAcctRet.size() > 0) {
                        lstAcctRet[0].Batch__c = False;
                        lstAcctUpdate.add(lstAcctRet[0]);            
                    }
                //}
            }        
        }
        
        //List<API_Request__c> apir = [select ID, Batch__c from API_Request__c where Study_ID__c != NULL AND Batch__c = True];
        for(API_Request__c ar :scope) {
            ar.Batch__c = False;
        }
        if(lstAcctUpdate.size() > 0) {
        	update lstAcctUpdate;    
        }
        update scope;
        
    }
    
    global void finish(Database.BatchableContext BC){
    }     
    
}