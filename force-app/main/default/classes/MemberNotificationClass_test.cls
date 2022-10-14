@isTest
public class MemberNotificationClass_test {

    static Member_Notification__c note ;
    static Member_Notification_Recipient__c rec ;
    static Contact con;
    
    static void testData(){ 
        note = new Member_Notification__c(Name='notify', Custom_Message__c='aaa', Status__c='Approved', Template__c='Site Closed');
        insert note;
        
        rec = new Member_Notification_Recipient__c(Name='Bob', Member_Notification__c = note.id, Email__c='abc@abc.com', GARP_ID__c='12345');
        insert rec;
        
        con = new Contact(lastname = 'Test',email='abc@abc.com');
        insert con;
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest(); 
        	MemberNotificationClass.sendNotification(note.id);
        	MemberNotificationClass.emailTracker();
        test.stopTest();
    }        
}