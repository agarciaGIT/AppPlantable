global class MemberNotificationSendBatch implements Database.Batchable<sObject>{
    
    public String notificationId;  

    global MemberNotificationSendBatch(String notificationId){
        system.debug('Function: MemberNotificationSendBatch');
        system.debug('notificationId:' + notificationId);
        
        this.notificationId= notificationId;            
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        String query = 'select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Error_Message__c, Member_Notification__r.Template__c, Member_Notification__r.Custom_Message__c from Member_Notification_Recipient__c where Member_Notification__c = :notificationId AND Sending_Status__c != \'Sent\'';
        system.debug('query:' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Member_Notification_Recipient__c> scope){
        
        system.debug('scope:' + scope);
        list<Member_Notification__c> lstNotif = [select Id, Name, Custom_Message__c, Status__c, Template__c, Sent_Date_Time__c 
                                                 from Member_Notification__c where id = :notificationId];
        if(!lstNotif.isEmpty()) {
            lstNotif[0].Status__c = 'Sending';
        }
		update lstNotif;
        
        for(Member_Notification_Recipient__c rec: scope) {
            system.debug('sendSalesforceEmail:' + rec.Member_Notification__r.Template__c +':'+ rec.id+':'+rec.Email__c);
            MemberNotificationClass.sendSalesforceEmail(rec.Member_Notification__r.Template__c, rec.id, rec.Email__c);
        }
                
        system.debug('lstNotif:' + lstNotif);
        
        if(!lstNotif.isEmpty()) {
            lstNotif[0].Status__c = 'Sent';
            lstNotif[0].Sent_Date_Time__c = DateTime.Now();
            
        }
        update lstNotif;
    }
    
    global void finish(Database.BatchableContext BC){
        MemberNotificationClass.notifyLoggedInUsers();
    }
}