@isTest
public class MemberNotificationClass_test {

    static Member_Notification__c note ;
    static Member_Notification_Recipient__c rec ;
    static Contact con;
    
    static void testData(){ 
        note = new Member_Notification__c(Name='notify', Custom_Message__c='aaa', Status__c='Approved', Template__c='Site Closed');
        insert note;
        
        rec = new Member_Notification_Recipient__c(Name='Bob', Member_Notification__c = note.id, Email__c='abc@abc.com', GARP_ID__c='12345',
                                                   Sent_Date_Time__c= DateTime.newInstanceGmt(2022, 4, 22, 8, 0, 0));
        insert rec;
        
        con = new Contact(lastname = 'Test',email='abc@abc.com');
        insert con;
        
        Member_Notification_Email_Log_Entry__c nml = new Member_Notification_Email_Log_Entry__c(Name='l1', Email_Address__c='abc@abc.com',
                                                                                                Message__c='Error', 
                                                                                                Log_Action__c='P',
                                                         Log_Date_Time__c = DateTime.newInstanceGmt(2022, 4, 22, 8, 0, 0));
        insert nml;        
    }
    
    static testMethod void unitTest_2(){
        testData();
        test.startTest(); 
        MemberNotificationClass.updateSendingStatus(note.id);
        test.stopTest();
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest(); 
            MemberNotificationClass.sendNotificationButton(note.id);
            MemberNotificationClass.sendNotificationButtonAura(note.id);
            MemberNotificationClass.sendNotificationTestButton(note.id, 'abc@abc.com');
            MemberNotificationClass.emailTracker();

        MemberNotificationClass.setMemberNotificationAsViewed(rec.id);
        
        List<String> params = new List<String>();
        params.add('sendNotificationTest');
        params.add(note.id);
        params.add('abc@abc.com');
        List<List<String>> inputParams = new List<List<String>>();
        inputParams.add(params);
        
        MemberNotificationClass.MemberNotificationInvocable(inputParams);        
        
        note.Status__c='Sent';
        update note;
        
            MemberNotificationClass.resendNotificationButton(note.id, rec.id);
            MemberNotificationClass.resendNotificationButtonAura(note.id);
            MemberNotificationClass.resendNotificationRecipientButtonAura(rec.id);
        
        
            MemberNotificationClass.getMemberNotifications(null);
            
            MemberNotificationClass.updateSendingStatus(note.id);
        test.stopTest();
    }        
}