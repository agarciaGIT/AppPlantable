global class batchFixReopenCases implements Database.Batchable<sObject>{
        
    public String testID;  
    public DateTime batchLastKPI;

    global batchFixReopenCases(DateTime inBatchLastKPI, String inTestID){
        this.batchLastKPI = inBatchLastKPI;
        this.testID = inTestID;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  

        System.debug('batchLastKPI:' + batchLastKPI);
        System.debug('testID:' + testID);
        
        if(testID != NULL) {
            return Database.getQueryLocator('select Id, Status, Last_Email_Date_Sent__c, Last_Email_Date_Received__c, Reply__c, ClosedDate, Do_No_Fire__c from Case Where Status = \'Closed\' AND Last_Email_Date_Received__c > YESTERDAY AND ID = :testID');
        } else {
            return Database.getQueryLocator('select Id, Status, Last_Email_Date_Sent__c, Last_Email_Date_Received__c, Reply__c, ClosedDate, Do_No_Fire__c from Case Where Status = \'Closed\' AND Last_Email_Date_Received__c > YESTERDAY');    
        }
        
    }    
                                            
    global void execute(Database.BatchableContext BC, List<Case> scope){
        List<Case> updateCases = new List<Case>();
        for(Case c :scope) {
            if(c.Last_Email_Date_Received__c > c.ClosedDate &&
               (c.Last_Email_Date_Sent__c == NULL || c.Last_Email_Date_Received__c > c.Last_Email_Date_Sent__c)) {
                c.status = 'In Progress';
                c.Reply__c = True;
                c.Do_No_Fire__c = True;
                updateCases.add(c);
            }
        }
        update updateCases;
    }
    
    global void finish(Database.BatchableContext BC){
    }     
    
}