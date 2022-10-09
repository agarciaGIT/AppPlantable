global class batchContentAnalyticsBuckets implements Database.Batchable<sObject>,Database.StateFul{
    
    public String testId;  
    public String mode;  
    public Integer bucket;  

    global batchContentAnalyticsBuckets(Integer bucket, String mode, String testId){
        this.testId = testId;
        this.bucket = bucket;
        this.mode = mode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        String strId = testId;
        if(bucket == 2){
            String strBucket = 'Bucket2__c';
        } else {
            String strBucket = 'Bucket1__c';
        }
        if(strId != null) {
            return Database.getQueryLocator('select Id, Name, Bucket1__c, Bucket2__c, Trend__c  from Content_Analytic__c where Count__c > 0 and Id = :strId');
        } else {
            return Database.getQueryLocator('select Id, Name, Bucket1__c, Bucket2__c, Trend__c from Content_Analytic__c where Count__c > 0');
        }
        
    }
    
    global void execute(Database.BatchableContext BC, List<Content_Analytic__c> scope){
        
        for(Content_Analytic__c c :scope) {
                        
            if(bucket == 1){
                if(c.Bucket2__c != null && mode != 'clear') {
                    c.Trend__c = c.Bucket1__c - c.Bucket2__c;
            	}
                if(mode != 'clear')
                	c.Bucket2__c = 0;
                else c.Bucket1__c = 0;
            } else {
                if(c.Bucket1__c != null && mode != 'clear') {
                    c.Trend__c = c.Bucket2__c - c.Bucket1__c;
            	}
                if(mode != 'clear')
                	c.Bucket1__c = 0;                
                c.Bucket2__c = 0;                
            }
        }
        update scope;
        
    }
    
	global void finish(Database.BatchableContext BC){
    }    

}