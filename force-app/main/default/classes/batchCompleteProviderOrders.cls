global class batchCompleteProviderOrders implements Database.Batchable<sObject>, Database.AllowsCallouts{
        
    public String mode;  
    public DateTime batchLastKPI;

    global batchCompleteProviderOrders(DateTime inBatchLastKPI, String mode){
        this.batchLastKPI = inBatchLastKPI;
        this.mode = mode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  

        System.debug('batchLastKPI:' + batchLastKPI);
        System.debug('mode:' + mode);
        
        if(mode == 'study') {
            return Database.getQueryLocator('select Id, Account__c, Request_Type__c, Study_ID__c, Ship_Date__c from API_Request__c where Study_ID__c != NULL AND Batch__c = True');    
        } else if(mode == 'provider') {
            return Database.getQueryLocator('select Id, Account__c, Request_Type__c, Study_ID__c, Ship_Date__c from API_Request__c where Provider_Id__c != NULL AND Opportunity__c = NULL');    
        } else if(mode != NULL) {
            return Database.getQueryLocator('select Id, Account__c, Request_Type__c, Study_ID__c, Ship_Date__c from API_Request__c where ID = :mode');
        } else {
            return Database.getQueryLocator('select Id, Account__c, Request_Type__c, Study_ID__c, Ship_Date__c from API_Request__c where Batch__c = True');  
        }
        
    }    
                                            
    global void execute(Database.BatchableContext BC, List<API_Request__c> scope){
        for(API_Request__c ar :scope) {
            // Add Pine Items for Studies
            if(ar.Request_Type__c == 'Create Order' && ar.Study_ID__c != NULL) {
                API_Request_Line_Item__c arli1 = new API_Request_Line_Item__c();
                arli1.API_Request__c = ar.Id;
                arli1.Name = 'One-time Chef\'s Menu Study';
                arli1.Type__c = 'Product';
                arli1.Code__c = '3928880709750';
                arli1.Quantity__c = 1;
                arli1.Amount__c = 0;
                arli1.External_Id__c = '2903219077238';
                arli1.Ship_Date__c = ar.Ship_Date__c;
                insert arli1;
                    
                API_Request_Line_Item__c arli2 = new API_Request_Line_Item__c();
                arli2.API_Request__c = ar.Id;
                arli2.Name = 'Shipping';
                arli2.Type__c = 'Shipping';
                arli2.Code__c = 'Free Shipping';
                arli2.Amount__c = 0;
                insert arli2;

            }
            ar.Enable_Automation__c = True;
            
        }
        update scope;
        
        MAP<String,String> mapReqType = new MAP<String,String>();
        Set<String> opIDs = new Set<String>();
        List<API_Request__c> apir = [select ID, Request_Type__c, Account__c, Opportunity__c from API_Request__c where ID in :scope];
        for(API_Request__c ar :apir) {
            mapReqType.put(ar.Account__c, ar.Request_Type__c);
            //if(ar.Request_Type__c == 'Create Order') {
            //    shopifyClass.updateInventory(ar.Opportunity__c, false);    
            //}
            opIDs.add(ar.Opportunity__c);
        }
        
        List<Account> lstAcct = [Select ID, Batch__c from Account where ID in :mapReqType.keySet()];
        for(Account acct :lstAcct) {
            System.debug('acct:' + acct);
            String reqType = mapReqType.get(acct.Id);
            if(reqType != NULL && reqType == 'Customer Update') {
                acct.Batch__c = True;    
            }
        }
        update lstAcct;
        
        List<Opportunity> lstOpp = [select Id, External_Order_Number__c, External_Order_Number_Display__c from Opportunity where Id in :opIDs];
        for(Opportunity opp :lstOpp) {
            System.debug('opp:' + opp);
            if(opp.External_Order_Number__c == NULL) {
                opp.External_Order_Number__c = opp.External_Order_Number_Display__c; 
            }
        }
        update lstOpp;
        
        for(API_Request__c ar :scope) {
            ar.Enable_Automation__c = False;
        }
        update scope;        
    }
    
    global void finish(Database.BatchableContext BC){
        //Database.executebatch(new batchUpdateInventory(NULL));
    }     
    
}