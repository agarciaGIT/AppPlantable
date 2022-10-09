/*  Controller for multiJoin LWC
 *  07/29/2019 Xiang - Created.
 */
public without sharing class MultiJoinCtrl {

    // Global Describe
    private static Map<String, Schema.SObjectType> gd {
        get {
            if(null == gd) {
                gd = Schema.getGlobalDescribe();
            }
            return gd;
        }
        set;
    }

    // Whether to use save feature based on Recent_Query__c exists or not
    @AuraEnabled
    public static Boolean loadUseSaveFeature() {
        Boolean useSaveFeature = gd.get('Recent_Query__c') != null;
        
        return useSaveFeature;
    }

    @AuraEnabled
    public static List<sObject> loadRecentQuery() {
        Id userId = UserInfo.getUserId();

        String qryStr = 'SELECT Id, Name, Query__c, (SELECT Id, Query__c, Sub_Query_Lookup__c FROM Sub_Queries__r) FROM Recent_Query__c ';
        qryStr += 'WHERE Main_Query__c = NULL AND OwnerId = :userId ORDER BY LastModifiedDate DESC LIMIT 5';

        List<sObject> rq = Database.query(qryStr);

        return rq;
    }

    // Based on input query, load: 1. records 2. sObject name 3. sObject fields. saveQry should have feature check.
    @AuraEnabled
    public static QueryResult loadObjectList(String inptQry, Boolean saveQry) {
        QueryResult qr = new QueryResult();

        // Load Records
        List<sObject> queryList = new List<sObject>();
        if(String.isNotEmpty(inptQry)) {
            System.debug(inptQry);
            queryList = Database.query(inptQry);
        }
        qr.records = queryList;

        // Load Metadata
        Pattern p = Pattern.compile('(?i)(?<=\\bFrom\\s)(\\w+)');
        Matcher pm = p.matcher(inptQry);
        if(pm.find()) {
            qr.objectName = pm.group();

            String lowQry = inptQry.toLowerCase();
            Integer fldStart = lowQry.indexOf('select') + 6;
            Integer fldEnd = lowQry.indexOf('from');
            String fieldsStr = inptQry.substring(fldStart, fldEnd);

            List<String> names = new List<String>();
            List<String> labels = new List<String>();
            
            Map<String, Schema.SObjectField> sfMap = gd.get(qr.objectName).getDescribe().fields.getMap();
            for(String aFld : fieldsStr.split(',')) {
                String fld = aFld.trim();
                
                if(fld.contains('.')) {
                    names.add(fld);
                    labels.add(fld);
                }else {
                    Schema.DescribeFieldResult dfr = sfMap.get(fld).getDescribe();
                    names.add(dfr.getName());
                    labels.add(dfr.getLabel());
                }
            }
            qr.fieldNames = names;
            qr.fieldLabels = labels;

            if(saveQry) {
                saveQuery(inptQry);
            }
        }

        return qr;
    }

    // For saving main query. 5 main queries per user and doesn't save if main query unchanged.
    private static void saveQuery(String inptQry) {
        // Upon successful query, save for quick access
        List<sObject> rqList = loadRecentQuery();

        Boolean shouldSave = true;
        /* if(rqList.size() > 0 && (String)rqList.get(0).get('Query__c') == inptQry) {
            shouldSave = false;
        }

        if(shouldSave) {
            sObject rqSave;
            if(rqList.size() >= 5) {
                rqSave = rqList.get(rqList.size() - 1);
            }else {
                rqSave = gd.get('Recent_Query__c').newSObject();
                rqSave.put('OwnerId', UserInfo.getUserId());
            }
            rqSave.put('Query__c', inptQry);
            upsert rqSave;
        } */
    }

    // For saving main query with all sub queries. Action triggered by user click.
    @AuraEnabled
    public static Boolean saveAllQueries(String mainQry, List<SubQuery> subQryList) {
        Boolean result = false;

        /* try {
            List<sObject> rqList = loadRecentQuery();

            sObject rqSave;
            if(rqList.size() > 0) {
                rqSave = rqList.get(0);
            }else{
                rqSave = gd.get('Recent_Query__c').newSObject();
            }
            System.debug('mainQry: ' + mainQry);
            rqSave.put('Query__c', mainQry);
            upsert rqSave;

            // Clear out all previous sub queries
            List<sObject> subRqDel = Database.query('SELECT Id FROM Recent_Query__c WHERE Main_Query__c =\'' + (String)rqSave.get('Id') + '\'');
            delete subRqDel;

            List<sObject> subRqList = new List<sObject>();
            for(SubQuery sq : subQryList) {
                sObject subRq = gd.get('Recent_Query__c').newSObject();
                subRq.put('Query__c', sq.qry);
                subRq.put('Sub_Query_Lookup__c', sq.lookup);
                subRq.put('Main_Query__c', rqSave.Id);
                subRqList.add(subRq);

                System.debug(subRq);
            }
            insert subRqList;

            result = true;
        }catch(Exception e) {
            System.debug(e);
        }*/

        return result;
    }

    // Query all sub queries within one transaction.
    @AuraEnabled
    public static List<QueryResult> loadSubQueries(List<SubQuery> subQryList, List<Id> mainIds) {
        List<QueryResult> qrList = new List<QueryResult>();

        for(SubQuery subQry : subQryList) {
            String subQryStr = subQry.qry;
            String lookupFld = subQry.lookup;

            if(!subQryStr.contains(lookupFld)) {
                subQryStr = subQryStr.replace('SELECT ', 'SELECT ' + lookupFld + ', ');
            }

            String filterStr = lookupFld + ' IN (\'' + String.join(mainIds, '\',\'') + '\')';

            subQryStr += subQryStr.contains('WHERE') ? (' AND ' + filterStr) : (' WHERE ' + filterStr);

            QueryResult qr = loadObjectList(subQryStr, false);
            qr.subQueryIndex = subQry.index;
            qr.lookupField = subQry.lookup;
            qrList.add(qr);
        }

        return qrList;
    }

    // For query result return
    public class QueryResult {
        @AuraEnabled public String objectName {get;set;}
        @AuraEnabled public List<String> fieldNames {get;set;}
        @AuraEnabled public List<String> fieldLabels {get;set;}
        @AuraEnabled public List<sObject> records {get;set;}

        // For Sub Query Only
        @AuraEnabled public String subQueryIndex {get;set;}
        @AuraEnabled public String lookupField {get;set;}
    }

    // For sub query input
    public class SubQuery {
        @AuraEnabled public String index {get;set;}
        @AuraEnabled public String qry {get;set;}
        @AuraEnabled public String lookup {get;set;}
    }

    // [Not in use] sObject label and API pair.
    /* @AuraEnabled
    public static List<KeyValuePair> loadObjectNames() {
        List<KeyValuePair> kvpList = new List<KeyValuePair>();

        for(String key : gd.keySet()) {
            Schema.DescribeSObjectResult dsr = gd.get(key).getDescribe();

            kvpList.add(new KeyValuePair(dsr.getLabel(), dsr.getName()));
        }

        return kvpList;
    } */
    
    // [Not in use] Generic key/value pair for return
    /* public class KeyValuePair {
        @AuraEnabled public String key {get;set;}
        @AuraEnabled public String value {get;set;}

        public KeyValuePair(String key, String value) {
            this.key = key;
            this.value = value;
        }
    } */
}