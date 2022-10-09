@isTest
public class EventDescribeRESTControllerTest {

    public static String validApiKey = 'ABC123ABC123ABC123';
   	public static String invalidApiKey = 'ABC123ABC123ABC123INVALID';
    
    public static Event__c event;
    
    private static void setup(){
        
        event = new Event__c();
        event.Name = 'TEST EVENT';
        INSERT event;
        
        INSERT new EventExecutives_Configuration__c(
            Name = 'X-API-KEY', 
            Value__c = 'ABC123ABC123ABC123'
        );
        
    }
    
    @isTest
    private static void TestGetEventRegistrationStatusesAuthorized(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/describe/registration-statuses';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventDescribeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestGetEventAttendeeTypesAuthorized(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/describe/attendee-types';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventDescribeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestGetEventParticipantTypesAuthorized(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/describe/participant-types';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventDescribeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestGetEventContributorTypesAuthorized(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/describe/contributor-types';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventDescribeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestGetEventRegistrationEntitiesMissingType(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/describe';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventDescribeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestGetEventRegistrationEntitiesInvalidRoute(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + '/describe/contributor-typess';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventDescribeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestGetEventRegistrationStatusesUnauthorized(){

        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();

        req.addHeader('X-API-KEY', invalidApiKey);
        req.requestURI = '/event/' + event.Id + '/describe/registration-statuses';
        req.httpMethod = 'GET';

        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventDescribeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
    @isTest
    private static void TestGetEventRegistrationStatusesInvalidEventId(){
        
        setup();
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        
        req.addHeader('X-API-KEY', validApiKey);
        req.requestURI = '/event/' + event.Id + 'a' + '/describe/registration-statuses';
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        
        RestContext.response = res;
        
        EventDescribeRESTController.doGet();
        
        Test.stopTest();
        
    }
    
}