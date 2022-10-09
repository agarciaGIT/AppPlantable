public class GARP_MS_MemberNotifications {

    // GARP Member Service - Member Notifications - Exam Alerts componenet
    // AG 3/30/2022 - Created
    
    public static List<Member_Notification_Recipient__c> getExamAlerts(){
        String userId = UserInfo.getUserId();
        System.debug('userId:' + userId);
        
        List<User> users = [SELECT Id, ContactId, Email FROM User WHERE Id = :userId];
        System.debug('userId:' + userId);
        
        if(!users.isEmpty()) {         
            return MemberNotificationClass.getMemberNotificationsExamAlerts(users[0].ContactId);
        }
        return null;
    }
    
    public static Boolean setMemberNotificationAsViewed(string recNotId){
        return MemberNotificationClass.setMemberNotificationAsViewed(recNotId);
    }
}