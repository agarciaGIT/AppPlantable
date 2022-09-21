global class batchCleanAPISessions implements Database.Batchable<sObject>{
        
    public String testID;  
    public DateTime batchLastKPI;

    global batchCleanAPISessions(DateTime inBatchLastKPI, String inTestID){
        this.batchLastKPI = inBatchLastKPI;
        this.testID = inTestID;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  

        System.debug('batchLastKPI:' + batchLastKPI);
        System.debug('testID:' + testID);
        DateTime now = DateTime.now();
        if(testID != NULL) {
            return Database.getQueryLocator('select Id, Expire_Date_Time__c from API_Session__c Where Expire_Date_Time__c < :now AND ID = :testID');
        } else {
            return Database.getQueryLocator('select Id, Expire_Date_Time__c from API_Session__c Where Expire_Date_Time__c < :now');    
        }
        
    }    
                                            
    global void execute(Database.BatchableContext BC, List<API_Session__c> scope){
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC){
    }     
    
}