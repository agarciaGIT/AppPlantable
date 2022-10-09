@isTest
public class EventAttendeeRESTControllerTest {

    public static String validApiKey = 'ABC123ABC123ABC123';
   	public static String invalidApiKey = 'ABC123ABC123ABC123INVALID';
    
    public static Contact contact;
    public static Account account;
    public static Event__c event;
    public static Event_Registration__c eventRegistrationUser;
    public static Event_Registration__c eventRegistrationContact;
    
    @testSetup
    private static void creatUser(){
        
        Profile profile = [SELECT Id, Name FROM Profile WHERE Name = 'Accounting' LIMIT 1];
        
        User user = new User(
            ProfileId = profile.Id,
            Department_Head__c = false,
            Division_Head__c = false,
            CEO__c = false,
            CFO__c = false,
            Username = 'suPWoBwydolrOIUvRUHk@TEST.com', 
            LastName = 'TEST', 
            Email = 'suPWoBwydolrOIUvRUHk@TEST.com', 
            Alias = 'TEST', 
            CommunityNickname = 'suPWoBwydolrOIUvRUHk', 
            LocaleSidKey='en_US',
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey='en_US',
            TimezoneSidKey = 'America/New_York',
            IsActive = TRUE
        );
        
        INSERT user;    
        
    }
    
    private static void setup(){
        
        User user = [SELECT Id, Email FROM User WHERE Email = 'suPWoBwydolrOIUvRUHk@TEST.com'];
        
        event = new Event__c();
        event.Name = 'TEST EVENT';
        INSERT event;
        
        account = new Account();
        account.Name = 'TEST CO';
        INSERT account;
        
        contact = new Contact();
        contact.Email = 'TEST@TEST.com';
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.AccountId = account.Id;
        contact.GARP_Member_ID__c = '0123456';
        INSERT contact;
        
        eventRegistrationContact = new Event_Registration__c();
        eventRegistrationContact.Event__c = event.Id;
        eventRegistrationContact.Contact__c = contact.Id;
        eventRegistrationContact.Special_Requirements__c = 'these are some special requirements';
        eventRegistrationContact.Professional_Designations__c = 'CPA;CFA;';
        eventRegistrationContact.Dietary_Restriction__c = true;
        eventRegistrationContact.Dietary_Restriction_Description__c = 'TEST DESCRIPTION';
        eventRegistrationContact.Dietary_Restriction_Types__c = 'Vegan;Kosher;';
		INSERT eventRegistrationContact;
        
        eventRegistrationUser = new Event_Registration__c();
        eventRegistrationUser.Event__c = event.Id;
        eventRegistrationContact.Contact__c = null;
        eventRegistrationUser.User__c = user.Id;
        eventRegistrationUser.Special_Requirements__c = 'these are some special requirements';
        eventRegistrationUser.Professional_Designations__c = 'CPA;CFA;';
        eventRegistrationUser.Dietary_Restriction__c = true;
        eventRegistrationUser.Dietary_Restriction_Description__c = 'TEST DESCRIPTION';
        eventRegistrationUser.Dietary_Restriction_Types__c = 'Vegan;Kosher;';
		INSERT eventRegistrationUser;
        
        INSERT new EventExecutives_Configuration__c(
            Name = 'X-API-KEY', 
            Value__c = 'ABC123ABC123ABC123'
        );
        
    }
    
    @isTest
    private static void TestDoGetUnauthorized(){

        setup();
        
        Test.startTest();
	
        String registrationId = [SELECT Id, Registration_ID__c FROM Event_Registration__c WHERE Id = :eventRegistrationContact.Id LIMIT 1].Registration_ID__c;
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', invalidApiKey);
        req.requestURI = '/event/' + event.Id + '/attendee/' + registrationId;
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
               
        EventAttendeeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestDoGetInvalidEventId(){

        setup();
        
        Test.startTest();
        
        String registrationId = [SELECT Id, Registration_ID__c FROM Event_Registration__c WHERE Id = :eventRegistrationContact.Id LIMIT 1].Registration_ID__c;
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '-INVALID' + '/attendee/' + registrationId;
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
               
        EventAttendeeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestDoPutUnauthorized(){

        setup();
        
        Test.startTest();
        
        String registrationId = [SELECT Id, Registration_ID__c FROM Event_Registration__c WHERE Id = :eventRegistrationContact.Id LIMIT 1].Registration_ID__c;
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', invalidApiKey);
        req.requestURI = '/event/' + event.Id + '/attendee/' + registrationId;
        req.httpMethod = 'PUT';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
               
        EventAttendeeRESTController.doPut();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestDoPutInvalidEventId(){

        setup();
        
        Test.startTest();
        
        String registrationId = [SELECT Id, Registration_ID__c FROM Event_Registration__c WHERE Id = :eventRegistrationContact.Id LIMIT 1].Registration_ID__c;
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + 'INVALID' + '/attendee/' + registrationId;
        req.httpMethod = 'PUT';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
               
        EventAttendeeRESTController.doPut();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestDoPutInvalidAttendeeId(){

        setup();
        
        Test.startTest();
        
        String registrationId = [SELECT Id, Registration_ID__c FROM Event_Registration__c WHERE Id = :eventRegistrationContact.Id LIMIT 1].Registration_ID__c;
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.addParameter('attended', 'true');
        req.requestURI = '/event/' + event.Id + '/attendee/' + registrationId + '-INVALID';
        req.httpMethod = 'PUT';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventAttendeeRESTController.doPut();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestToggleAttendance(){

        setup();
        
        Test.startTest();
        
        String registrationId = [SELECT Id, Registration_ID__c FROM Event_Registration__c WHERE Id = :eventRegistrationContact.Id LIMIT 1].Registration_ID__c;
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.addParameter('attended', 'true');
        req.requestURI = '/event/' + event.Id + '/attendee/' + registrationId;
        req.httpMethod = 'PUT';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventAttendeeRESTController.doPut();
        
        req.addParameter('attended', 'false');
        
        EventAttendeeRESTController.doPut();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void GetAttendeeByContact(){

        setup();
        
        Test.startTest();
        
        String registrationId = [SELECT Id, Registration_ID__c FROM Event_Registration__c WHERE Id = :eventRegistrationContact.Id LIMIT 1].Registration_ID__c;
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/attendee/' + registrationId;
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventAttendeeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void GetAttendeeByUser(){

        setup();
        
        Test.startTest();
        
        String registrationId = [SELECT Id, Registration_ID__c FROM Event_Registration__c WHERE Id = :eventRegistrationUser.Id LIMIT 1].Registration_ID__c;
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/attendee/' + registrationId;
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventAttendeeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void GetAttendeeByInvalidGARPMemberId(){

        setup();
        
        Test.startTest();
        
        String registrationId = [SELECT Id, Registration_ID__c FROM Event_Registration__c WHERE Id = :eventRegistrationContact.Id LIMIT 1].Registration_ID__c;
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/attendee/' + registrationId + '-INVALID';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventAttendeeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void GetAttendees(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/attendee';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventAttendeeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void GetAttendeesAfterLastModifiedDate(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.addParameter('last_modified_date_time', '2017-11-01T00:00:00');
        req.requestURI = '/event/' + event.Id + '/attendee';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventAttendeeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void GetAttendeeByEmail(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.addParameter('email', 'TEST@TEST.COM');
        req.requestURI = '/event/' + event.Id + '/attendee';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventAttendeeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void GetAttendeesDetail(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.addParameter('details', 'true');
        req.requestURI = '/event/' + event.Id + '/attendee';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventAttendeeRESTController.doGet();
        
        Test.stopTest();
        
    }

}