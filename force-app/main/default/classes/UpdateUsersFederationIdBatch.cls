global class UpdateUsersFederationIdBatch implements Database.Batchable<sObject>{
    Id ProfileId = '00e400000017dA8';
    @TestVisible String query = 'Select Id,FederationIdentifier,Contact.GARP_Member_ID__c,Contact.RecordTypeId from User where ContactId != null AND IsActive = True AND FederationIdentifier = null AND Contact.GARP_Member_ID__c != null AND ProfileId =\''+ProfileId+'\'';
	global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, List<User> scope){
        List<User> userListToUpdate = new List<User>();
        for(User u : scope){
            Id memberRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Member').getRecordTypeId();
            if(u.Contact.RecordTypeId == memberRecordTypeId && (String.isblank(u.FederationIdentifier) || u.FederationIdentifier != u.Contact.GARP_Member_ID__c)){
                u.FederationIdentifier = u.Contact.GARP_Member_ID__c;
                userListToUpdate.add(u);
            }
        }
        if(!userListToUpdate.isEmpty()){
            update userListToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}