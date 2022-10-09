global class updateMilestonesDays_Batch implements Database.Batchable<sObject>, Database.Stateful {
	global Database.QueryLocator start(Database.BatchableContext BC){
        string query;
        Set<String> statusSet = new Set<String>{'Active'};
        if(test.isRunningTest()){
            query = 'SELECT Id,Due_Date__c,Days_Left__c FROM Milestone__c LIMIT 100';
        } else {
            query = 'SELECT Id,Due_Date__c,Days_Left__c FROM Milestone__c where Status__c IN: statusSet';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Milestone__c> scope){
        date today = system.today();
        List<Milestone__c> milestonesToUpdate = new List<Milestone__c>();
        for(Milestone__c milestone : scope){
            if(milestone.Due_Date__c >= today){
                milestone.Days_Left__c = today.daysBetween(milestone.Due_Date__c);
                milestonesToUpdate.add(milestone);
            }else if(milestone.Due_Date__c < today){
                milestone.Status__c = 'Completed';
                milestonesToUpdate.add(milestone);
            }
        }
        
        if(!milestonesToUpdate.isEmpty()){
            update milestonesToUpdate;
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}