global class updateRapidCourseBatch implements Database.Batchable<sObject>, Database.Stateful {
    public static string programRecType = System.Label.ProgramRTforRapidCourseUpdate;
	
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> StatusList = new List<String>();
        StatusList.add('Activated');
        StatusList.add('Activated ( Auto-Renew )');
        return Database.getQueryLocator([SELECT Id,AccountId FROM Contract WHERE recordType.DeveloperName=:System.Label.ProgramRTforRapidCourseUpdate AND Opportunity__c != null AND Status IN:StatusList]);
    }
    
    global void execute(Database.BatchableContext BC, List<Contract> scope) {
        Set<Id> accountIds = new Set<Id>();
        List<User> usersToUpdate = new List<User>();
        Map<Id,User> accIdToUserMap = new Map<Id,User>();
        
        WKT_Settings__mdt wkt = WKT_Settings__mdt.getInstance(programRecType);
        integer newCourseId = Integer.valueOf(wkt.Value__c);
        
        for(Contract Cont : scope){
            accountIds.add(cont.AccountId);
        }
        
        List<User> currentUserList = [SELECT Id,Rapid_Courses__c,Contact.AccountId FROM User WHERE Contact.AccountId IN: accountIds];
        
        for(user u : currentUserList){
            usersToUpdate.add(WKTRapidCourseJSONBuilder.updateUser(u,newCourseId));
        }
        
        if(!usersToUpdate.isEmpty() && !test.isRunningTest()){
            try {
                update usersToUpdate;
            } catch(Exception e) {
                System.debug(e);
            }
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}