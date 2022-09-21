@isTest 
public class IntercomClass_test {

    Static Account acct;
    Static Contact cont;
    
    Static Account acct1;
    Static Contact cont1;


    Static Case cs;
    Static Health_Survey__c hs;
    
    public static void setup(){
        acct = new Account(Name='Account', Email__c='joe@bob.com', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C');
        insert acct;
        
        cont = new Contact(Email='joe@bob.com', AccountId=acct.Id, LastName = 'last');
        insert cont;
        
        Case cs1 = new Case(Status='New', ContactID = cont.Id, Origin = 'Email', Intercom_Conversation_ID__c='123', Last_Email_Date_Sent__c=DateTime.newInstance(2019, 1, 1, 1, 0, 0), Last_Email_Date_Received__c=DateTime.now(), Reply__c=False);
        insert cs1;
        System.debug('cs1:' + cs1);
        
        hs = new Health_Survey__c(Account__c = acct.id, Is_App__c = True);
        insert hs;

        acct1 = new Account(Name='Account', Email__c='joe1@bob.com', Batch_Last_KPI__c=null, BillingStreet='25 Jackson\n\rApt 1C');
        insert acct1;
        
        cont1 = new Contact(Email='joe1@bob.com', AccountId=acct1.Id, LastName = 'last');
        insert cont1;
        
    }
    
    @isTest
    private static void test1(){
    	setup();
        Test.startTest();    
        
		RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestUri ='https://parcopy-euphebe.cs95.force.com/services/apexrest/meals/agarcia@a.com';
        request.httpMethod = 'GET';
		//request.requestBody = Blob.valueof(jsonReq);
        
        RestContext.request = request;
        RestContext.response = response;   
        
        // Intercom Admin MSG - Reply Send SMS 
        RESTIntercomController.processPOSTRequest(request, response,'{"type":"notification_event","app_id":"mzgbihsm","data":{"type":"notification_event_data","item":{"type":"conversation","id":"181","created_at":1621416850,"updated_at":1621417312,"user":{"type":"user","id":"605a1845c51c55f5b7429dd5","user_id":null,"name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com","do_not_track":null},"assignee":{"type":"admin","id":"4672167","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"admin_assignee_id":4672167,"team_assignee_id":null,"conversation_message":{"type":"conversation_message","id":"849195454","url":null,"subject":"","body":"<p>Hello new case</p>","author":{"type":"user","id":"605a1845c51c55f5b7429dd5"},"attachments":[]},"conversation_parts":{"type":"conversation_part.list","conversation_parts":[{"type":"conversation_part","id":"9185329066","part_type":"comment","body":"aaaaaa","created_at":1621417312,"updated_at":1621417312,"notified_at":1621417312,"assigned_to":null,"author":{"type":"admin","id":"4672167","name":"Alberto Garcia"},"attachments":[],"external_id":null}],"total_count":1},"conversation_rating":{},"open":true,"state":"open","snoozed_until":null,"read":false,"metadata":{},"tags":{"type":"tag.list","tags":[]},"tags_added":{"type":"tag.list","tags":[]},"custom_attributes":{},"links":{"conversation_web":"https://app.intercom.com/a/apps/mzgbihsm/conversations/181"}}},"links":{},"id":"notif_b036dea6-695f-45a6-aa86-f980eb3eec8b","topic":"conversation.admin.replied","delivery_status":"pending","delivery_attempts":1,"delivered_at":0,"first_sent_at":1621417318,"created_at":1621417318,"self":null}');

        // CloseConversation
        RESTIntercomController.processPOSTRequest(request, response,'{"type":"notification_event","app_id":"mzgbihsm","data":{"type":"notification_event_data","item":{"type":"conversation","id":"181","created_at":1621416850,"updated_at":1621417499,"user":{"type":"user","id":"605a1845c51c55f5b7429dd5","user_id":null,"name":"Al Garcia","email":"garcia.alberto.crespo@gmail.com","do_not_track":null},"assignee":{"type":"admin","id":"4672167","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"admin_assignee_id":4672167,"team_assignee_id":null,"conversation_message":{"type":"conversation_message","id":"849195454","url":null,"subject":"","body":"<p>Hello new case</p>","author":{"type":"user","id":"605a1845c51c55f5b7429dd5"},"attachments":[]},"conversation_parts":{"type":"conversation_part.list","conversation_parts":[{"type":"conversation_part","id":"9185369405","part_type":"close","body":null,"created_at":1621417499,"updated_at":1621417499,"notified_at":1621417499,"assigned_to":null,"author":{"type":"admin","id":"4672167","name":"Alberto Garcia"},"attachments":[],"external_id":null}],"total_count":1},"conversation_rating":{},"open":false,"state":"closed","snoozed_until":null,"read":false,"metadata":{},"tags":{"type":"tag.list","tags":[]},"tags_added":{"type":"tag.list","tags":[]},"custom_attributes":{},"links":{"conversation_web":"https://app.intercom.com/a/apps/mzgbihsm/conversations/181"}}},"links":{},"id":"notif_ca4babe1-90e8-4c5c-8be3-69e9f6e08d62","topic":"conversation.admin.closed","delivery_status":"pending","delivery_attempts":1,"delivered_at":0,"first_sent_at":1621417503,"created_at":1621417503,"self":null}');

        // In-App Client Msg
        RESTIntercomController.processPOSTRequest(request, response,'{"type":"notification_event","app_id":"mzgbihsm","data":{"type":"notification_event_data","item":{"type":"conversation","id":"182","created_at":1621417659,"updated_at":1621417666,"user":{"type":"user","id":"609c0c464a426b430ff75f10","user_id":"3B3CDB50-C826-457B-813C-0059DE72A2FC","name":"Lynn Lewis","email":"lynn.lewis@umww.com","do_not_track":null},"assignee":{"type":"admin","id":"4417246","name":"Plantable Coach","email":"operator+mzgbihsm@intercom.io"},"admin_assignee_id":4417246,"team_assignee_id":null,"conversation_message":{"type":"conversation_message","id":"849207358","url":null,"subject":"","body":"Yes, Im ready!","author":{"type":"user","id":"609c0c464a426b430ff75f10"},"attachments":[]},"conversation_parts":{"type":"conversation_part.list","conversation_parts":[],"total_count":0},"conversation_rating":{},"open":true,"state":"open","snoozed_until":null,"read":false,"metadata":{},"tags":{"type":"tag.list","tags":[]},"tags_added":{"type":"tag.list","tags":[]},"custom_attributes":{},"links":{"conversation_web":"https://app.intercom.com/a/apps/mzgbihsm/conversations/182"}}},"links":{},"id":"notif_d7207814-76cd-4b27-90e2-f7ea1745272f","topic":"conversation.user.created","delivery_status":"pending","delivery_attempts":1,"delivered_at":0,"first_sent_at":1621417667,"created_at":1621417667,"self":null}');

        // Admin Reply
		RESTIntercomController.processPOSTRequest(request, response,'{"type":"notification_event","app_id":"mzgbihsm","data":{"type":"notification_event_data","item":{"type":"conversation","id":"182","created_at":1621417659,"updated_at":1621417871,"user":{"type":"user","id":"609c0c464a426b430ff75f10","user_id":"3B3CDB50-C826-457B-813C-0059DE72A2FC","name":"Lynn Lewis","email":"lynn.lewis@umww.com","do_not_track":null},"assignee":{"type":"admin","id":"4672167","name":"Alberto Garcia","email":"garcia.alberto.crespo@gmail.com"},"admin_assignee_id":4672167,"team_assignee_id":null,"conversation_message":{"type":"conversation_message","id":"849207358","url":null,"subject":"","body":"Yes, Im ready!","author":{"type":"user","id":"609c0c464a426b430ff75f10"},"attachments":[]},"conversation_parts":{"type":"conversation_part.list","conversation_parts":[{"type":"conversation_part","id":"9185448193","part_type":"assignment","body":"Admin Reply","created_at":1621417869,"updated_at":1621417869,"notified_at":1621417869,"assigned_to":{"type":"admin","id":"4672167","name":"Alberto Garcia"},"author":{"type":"admin","id":"4672167","name":"Alberto Garcia"},"attachments":[],"external_id":null}],"total_count":1},"conversation_rating":{},"open":true,"state":"open","snoozed_until":null,"read":true,"metadata":{},"tags":{"type":"tag.list","tags":[]},"tags_added":{"type":"tag.list","tags":[]},"custom_attributes":{},"links":{"conversation_web":"https://app.intercom.com/a/apps/mzgbihsm/conversations/182"}}},"links":{},"id":"notif_297a49ac-6426-473e-b400-df16c6d78111","topic":"conversation.admin.replied","delivery_status":"pending","delivery_attempts":1,"delivered_at":0,"first_sent_at":1621417872,"created_at":1621417871,"self":null}');        
        
        Case cs2 = new Case(Status='New', ContactID = cont.Id, Origin = 'SMS', Intercom_Conversation_ID__c='123', Last_Email_Date_Sent__c=DateTime.newInstance(2019, 1, 1, 1, 0, 0), Last_Email_Date_Received__c=DateTime.now(), Reply__c=False);
        insert cs2;
        System.debug('cs2:' + cs2);
        
        
        //IntercomClass.SMStoIntercomCustomerMsg('joe@bob.com', 'Hello!', cs2.id, 'true');
        IntercomClass.createMessage('123', 'Hello!');
        IntercomClass.replyConversation('123', 'joe@bob.com', 'Hello!');
        IntercomClass.IntercomAdminMsg(cont.Id, 'joe@bob.com', 'Hello!', '123', NULL);
        IntercomClass.IntercomCustomerMsg(cont.Id, 'joe@bob.com', 'Hello!', '123','');
        IntercomClass.IntercomCustomerMsg(cont.Id, 'joe1@bob.com', 'Hello!', '456','');
        IntercomClass.createCustomer('2342424324','planttestappXX10@mailinator.com','Intercom Test Add Contact');
        
        IntercomClass.sendCampaignMsg('planttestappXX10@mailinator.com', 'hi', True);
        
        IntercomClass.openConversation('123');
        IntercomClass.closeConversation('123');
        
        IntercomClass.IntercomUpdateUserActivity('planttestappXX10@mailinator.com'); 
        
        
		List<String> params1 = new List<String>();
        params1.add('SMStoIntercomCustomerMsg');
        params1.add('joe@bob.com');
        params1.add('Hello!');
        params1.add(cs2.id);
        params1.add('true');
        List<List<String>> inputParams1 = new List<List<String>>();
        inputParams1.add(params1);
        
        IntercomClass.IntercomMethods(inputParams1);        
        
        Test.stopTest();        
    }        
}