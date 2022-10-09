/* Usage: System.schedule('E-Book Sync Up Job', '0 30 23 * * ?', new EBookSyncBatch('TODAY', 5));
 * Scope is either 'TODAY' or an Opportunity Id
 * 07/08/2019 Xiang - Changed filter to use CloseDate is today or yesterday.
 */
public without sharing class EBookSyncBatch implements System.Schedulable, Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public String scope {get; private set;}
    public Integer size {get; private set;}
    
    public EBookSyncBatch(String scope, Integer size) {
        this.scope = String.isEmpty(scope) ? 'TODAY' : scope;
        this.size = size;
    }
    
    // Method for Scheduler
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new EBookSyncBatch(this.scope, this.size), this.size);
    }
    
    // Methods for Batch
    public Iterable<sObject> start(Database.BatchableContext BC) {
        // Use first close time from history as closed time
        String query = 'SELECT Id, Shipping_E_mail__c, Shipping_First_Name__c, Shipping_Last_Name__c, GARP_Member_ID__c,ChargentSFA__Invoice_Number__c, ';
        query += '(SELECT Id, ProductCode, Product_ID__c FROM OpportunityLineItems), (SELECT Id, Type__c FROM eBook_Keys__r), ';
        query += '(SELECT CreatedDate FROM OpportunityHistories WHERE StageName = \'Closed\' ORDER BY CreatedDate ASC LIMIT 1) FROM Opportunity ';
        
        String filterQry = '';
        if(scope == 'TODAY') {
            Date dtToday = System.today();
            filterQry = 'WHERE CloseDate IN (' + getDateStr(dtToday) + ', ' + getDateStr(dtToday.addDays(-1)) + ') AND StageName = \'Closed\'';
        } else if(scope == 'YESTERDAY') {
            Date dtToday = System.today().addDays(-1);
            filterQry = 'WHERE CloseDate IN (' + getDateStr(dtToday) + ', ' + getDateStr(dtToday.addDays(-1)) + ') AND StageName = \'Closed\'';
        }else {
            filterQry = 'WHERE Id = :scope AND StageName = \'Closed\'';
        }
        query += filterQry;
        
        System.debug(query);

        List<Opportunity> oppToday = (List<Opportunity>)Database.query(query);
        List<Opportunity> oppToSync = new List<Opportunity>();
        
        Datetime nowTime = System.now();
        
        for(Opportunity opp : oppToday) {
            Boolean[] syncChk = checkNeedSync(opp);
            
            if((syncChk[0] || syncChk[1]) && closedOverHour(opp, nowTime)) {
                oppToSync.add(opp);
            }
        }
        
        System.debug('Oppty Sync Size: ' + oppToSync.size());
        return oppToSync; 
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<API_Transaction__c> allTransLogs = new List<API_Transaction__c>();
        List<eBook_Key__c> allBookKeys = new List<eBook_Key__c>();
        List<Opportunity> oppList = (List<Opportunity>)scope;
        
        // Setup parameters for Mobius API        
        List<Integer> mobProdFRM1 = new List<Integer>();
        List<Integer> mobProdFRM2 = new List<Integer>();
        List<Integer> mobProdSCR = new List<Integer>();
        String prodIdFRM1 = '', prodIdFRM2 = '', prodIdSCR = '';
        
        Map<String, String> oppProdMap = new Map<String, String>();
        for(Opportunity opp : oppList) {
            for(OpportunityLineItem oli :opp.OpportunityLineItems) {
                oppProdMap.put(oli.ProductCode, oli.Product_ID__c);
            }
        }
        
        Map<String, Mobius_Products__c> mProds = Mobius_Products__c.getall();
        
        Mobius_Products__c mobYearObj = mProds.get('FRM Current Year');
        String mobYear = mobYearObj != null ? mobYearObj.Year__c : '2019';
        Integer accessDurationFRM;
        
        for(Mobius_Products__c mp :mProds.values()) {
            if(mp.Year__c == mobYear && mp.Exam__c == 'FRM') {
                if(mp.Part__c == 'I') {
                    mobProdFRM1.add(Integer.valueOf(mp.Product_Id__c));
                    prodIdFRM1 = oppProdMap.get(mp.Salesforce_Product_Code__c);
                } else if(mp.Part__c == 'II') {
                    mobProdFRM2.add(Integer.valueOf(mp.Product_Id__c));
                    prodIdFRM2 = oppProdMap.get(mp.Salesforce_Product_Code__c);
                }
                if(mp.Access_Duration_in_Months__c != NULL) {
                    accessDurationFRM = Integer.ValueOf(mp.Access_Duration_in_Months__c);
                }
            }
        }
        
        mobYearObj = mProds.get('SCR Current Year');
        mobYear = mobYearObj != null ? mobYearObj.Year__c : '2019';
        Integer accessDurationSCR;
        
        for(Mobius_Products__c mp :mProds.values()) {
            if(mp.Year__c == mobYear && mp.Exam__c == 'SCR') {
                prodIdSCR = oppProdMap.get(mp.Salesforce_Product_Code__c);
                if(mp.Access_Duration_in_Months__c != NULL) {
                    accessDurationSCR = Integer.ValueOf(mp.Access_Duration_in_Months__c);
                }
            }
        }        

        // Invoke Mobius API for Opportunities in the batch
        for(Opportunity opp : oppList) {
            Boolean[] syncChk = checkNeedSync(opp);
            
            System.debug('Sync FRM1: ' + syncChk[0] + ', Sync FRM2: ' + syncChk[1]+ ', Sync SCR: ' + syncChk[2]);
            
            if(syncChk[0]) {
                System.debug('*** Start FRM1 Sync Now ***');
                List<List<SObject>> resultListFRM1 = mobiusAPI.mProvisionAnEBookSync(
                    'FRM', 'I', prodIdFRM1, accessDurationFRM, mobProdFRM1, opp.Id, opp.Shipping_E_mail__c, 
                    opp.Shipping_First_Name__c, opp.Shipping_Last_Name__c, opp.GARP_Member_ID__c, true);
                
                allBookKeys.addAll((List<eBook_Key__c>)resultListFRM1.get(0));
                allTransLogs.addAll((List<API_Transaction__c>)resultListFRM1.get(1));
            }
            
            if(syncChk[1]) {
                System.debug('*** Start FRM2 Sync Now ***');
                
                List<List<SObject>> resultListFRM2 = mobiusAPI.mProvisionAnEBookSync(
                    'FRM', 'II', prodIdFRM2, accessDurationFRM, mobProdFRM2, opp.Id, opp.Shipping_E_mail__c, 
                    opp.Shipping_First_Name__c, opp.Shipping_Last_Name__c, opp.GARP_Member_ID__c, true);
                
                allBookKeys.addAll((List<eBook_Key__c>)resultListFRM2.get(0));
                allTransLogs.addAll((List<API_Transaction__c>)resultListFRM2.get(1));
            }
            
            if(syncChk[2]) {
                System.debug('*** Start SCR Sync Now ***');
                
                List<List<SObject>> resultListSCR = mobiusAPI.mProvisionAnEBookSync(
                    'SCR', NULL, prodIdSCR, accessDurationSCR, mobProdSCR, opp.Id, opp.Shipping_E_mail__c, 
                    opp.Shipping_First_Name__c, opp.Shipping_Last_Name__c, opp.GARP_Member_ID__c, true);
                
                allBookKeys.addAll((List<eBook_Key__c>)resultListSCR.get(0));
                allTransLogs.addAll((List<API_Transaction__c>)resultListSCR.get(1));
            }
        }
        
        insert allBookKeys;
        insert allTransLogs;
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
    
    // Util Methods
    public static Boolean closedOverHour(Opportunity opp, Datetime nowTime) {
        if(Test.isRunningTest()) return true;
        
        Datetime closeTime = opp.OpportunityHistories[0].CreatedDate;
        Boolean isOverHour = closeTime.addMinutes(60) < nowTime;

        return isOverHour;
    }
    
    public static Boolean[] checkNeedSync(Opportunity opp) {
        Boolean hasFRM1Prod = false, hasFRM1Book = false, hasFRM2Prod = false, hasFRM2Book = false, hasSCRProd = false, hasSCRBook = false;
        
        for(OpportunityLineItem oli : opp.OpportunityLineItems) {
            if(oli.ProductCode == 'FRM1X') {
                hasFRM1Prod = true;
            }else if(oli.ProductCode == 'FRM2X') {
                hasFRM2Prod = true;
            } else if(oli.ProductCode == 'SCRX') {
                hasSCRProd = true;
            }
        }
        
        for(eBook_Key__c eKey : opp.eBook_Keys__r) {
            if(eKey.Type__c == 'FRM Exam Part I') {
                hasFRM1Book = true;
            } else if(eKey.Type__c == 'FRM Exam Part II') {
                hasFRM2Book = true;
            }else if(eKey.Type__c == 'SCR') {
                 hasSCRBook = true;
            }
        }
        
        return new Boolean[] {hasFRM1Prod && !hasFRM1Book, hasFRM2Prod && !hasFRM2Book, hasSCRProd && !hasSCRBook};
    }
    
    public static String getDateStr(Date dt) {
        return dt.year() + '-' + String.valueOf(dt.month()).leftPad(2, '0') + '-' + String.valueOf(dt.day()).leftPad(2, '0');
    }
}