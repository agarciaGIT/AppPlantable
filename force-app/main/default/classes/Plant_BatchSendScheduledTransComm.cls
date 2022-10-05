global class Plant_BatchSendScheduledTransComm implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    public String mode;  
    public DateTime startDateTime;
    
    //DateTime dt = DateTime.newInstance(2022, 9, 23, 8, 0, 0);
    //Database.executeBatch(new Plant_BatchSendScheduledTransComm(dt,'a1Z3J0000011pol'), 1);

    global Plant_BatchSendScheduledTransComm(DateTime inStartDateTime, String inMode){
        startDateTime = inStartDateTime.addMinutes(-5);
        mode = inMode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        
        DateTime endDateTime = startDateTime.addMinutes(10);
        
        System.debug('mode:' + mode);
        System.debug('startDateTime:' + startDateTime);
        System.debug('endDateTime:' + endDateTime);
        
        String query = 'select id from Plant_Transaction_Comm__c where Plant_Schedule_Date_Time__c > :startDateTime AND Plant_Schedule_Date_Time__c < :endDateTime AND Plant_Status__c = \'Scheduled\' AND Plant_Account__c != NULL AND (Plant_Order__c != NULL OR Plant_Subscription__c != NULL)';
        if(Test.isRunningTest()) {
            query = 'select id from Plant_Transaction_Comm__c';
        } else if(mode!='') {
            query = 'select id from Plant_Transaction_Comm__c where Plant_Schedule_Date_Time__c > :startDateTime AND Plant_Schedule_Date_Time__c < :endDateTime AND Plant_Status__c = \'Scheduled\' AND Plant_Account__c != NULL AND (Plant_Order__c != NULL OR Plant_Subscription__c != NULL) AND ID = :mode';
        }
        //query = 'select id from Plant_Transaction_Comm__c where id =:mode';
        System.debug('query:' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Plant_Transaction_Comm__c> scope){
        
        System.debug('execute:' + scope);
        
        for(Plant_Transaction_Comm__c psc :scope) {
            
            System.debug('psc:' + psc);
            
            Plant_TransComm_BC.sendTransComm(psc.Id);
        }
    }

    global void finish(Database.BatchableContext BC){
    }
}