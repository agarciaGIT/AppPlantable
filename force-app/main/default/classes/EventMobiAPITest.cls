@isTest
public class EventMobiAPITest {
    
    public class TestException extends Exception{}

    @testSetup
    public static void makeData(){

        EventMobiApiBatch.disableBatch = true;

        Event__c event;
        Event_Speaker__c eventSpeaker;  
        Event_Sessions__c eventSession;
        Event_Registration__c eventRegistration;
        Event_Session_Track__c eventSessionTrack;  
        Event_Session_Registration__c eventSessionRegistration;
        Event_Speaker_Session_Track__c eventSpeakerSessionTrack;

        INSERT new Remote_Sites__c(
            Name = 'EventMobi', 
            Site_URL__c = 'http://test.com'
        );
        
        INSERT new EventMobi_Configuration__c(
            Name = 'X-API-KEY', 
            Value__c = 'asasdasdasd'
        );
        
        INSERT new EventMobi_Configuration__c(
            Name = 'EVENT-ID', 
            Value__c = 'test-event-id'
        );
               
    	event = new Event__c();
        event.Status__c = 'Draft';

        // Event Name must match up with what is in the mock response.
        event.Name = 'GARP Risk Convention 2020';

        event.Title__c = 'GARP Risk Convention 2020';
        INSERT event;
        
        eventSessionTrack = new Event_Session_Track__c();
        eventSessionTrack.Name = 'TEST EVENT SESSION TRACK';
        INSERT eventSessionTrack;
        
        eventSpeaker = new Event_Speaker__c();
        eventSpeaker.Address__c = '123 SAMPLE STEET';
        INSERT eventSpeaker;
        
        eventSession = new Event_Sessions__c();
        eventSession.Event_Session_Track__c = eventSessionTrack.Id;
        INSERT eventSession;
        
        eventSpeakerSessionTrack = new Event_Speaker_Session_Track__c();
        eventSpeakerSessionTrack.Event_Session__c = eventSession.Id;
        eventSpeakerSessionTrack.Event_Speaker__c = eventSpeaker.Id;
        INSERT eventSpeakerSessionTrack;
        
        Account account = new Account();
        account.Name = 'TEST ACCOUNT';
        INSERT account;
        
        Contact contact = new Contact();
        contact.FirstName = 'TEST';
        contact.LastName = 'USER';
        contact.Email = 'test.user@test.com';
        contact.AccountId = account.Id;
        INSERT contact;
        
        eventRegistration = new Event_Registration__c();
        eventRegistration.Event__c = event.Id;
        eventRegistration.Contact__c = contact.Id;
        eventRegistration.Professional_Designations__c = 'CFA;CPA;';
        eventRegistration.Status__c = 'Registered and Paid';
        INSERT eventRegistration;

        eventSessionRegistration = new Event_Session_Registration__c(
            Event_Registration__c  = eventRegistration.Id,
            Event_Session__c = eventSession.Id
        );

        INSERT eventSessionRegistration;
           
    }

    @isTest
    public static void TestAddEvent200(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));

        Event__c event = [SELECT Id FROM Event__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = event.Id;
        eventMobiRequest.sObjectType = 'Event__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};

        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEvent400(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));

        Event__c event = [SELECT Id FROM Event__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = event.Id;
        eventMobiRequest.sObjectType = 'Event__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};

        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEvent404(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));
        
        Event__c event = [SELECT Id FROM Event__c LIMIT 1];

        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = event.Id;
        eventMobiRequest.sObjectType = 'Event__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);       
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEvent200(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));

        Event__c event = [SELECT Id FROM Event__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = event.Id;
        eventMobiRequest.sObjectType = 'Event__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEvent400(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));

        Event__c event = [SELECT Id FROM Event__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = event.Id;
        eventMobiRequest.sObjectType = 'Event__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
        
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest); 
        
        Test.stopTest();

    }

    @isTest
    public static void TestPutEvent404(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));

        Event__c event = [SELECT Id FROM Event__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = event.Id;
        eventMobiRequest.sObjectType = 'Event__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest); 
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventSpeaker200(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));

        Event_Speaker__c eventSpeaker = [SELECT Id FROM Event_Speaker__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSpeaker.Id;
        eventMobiRequest.sObjectType = 'Event_Speaker__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};

        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventSpeaker400(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));

        Event_Speaker__c eventSpeaker = [SELECT Id FROM Event_Speaker__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSpeaker.Id;
        eventMobiRequest.sObjectType = 'Event_Speaker__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};

        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventSpeaker404(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));
        
        Event_Speaker__c eventSpeaker = [SELECT Id FROM Event_Speaker__c LIMIT 1];

        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSpeaker.Id;
        eventMobiRequest.sObjectType = 'Event_Speaker__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);       
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventSpeaker200(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));

        Event_Speaker__c eventSpeaker = [SELECT Id FROM Event_Speaker__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSpeaker.Id;
        eventMobiRequest.sObjectType = 'Event_Speaker__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventSpeaker400(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));

        Event_Speaker__c eventSpeaker = [SELECT Id FROM Event_Speaker__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSpeaker.Id;
        eventMobiRequest.sObjectType = 'Event_Speaker__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
        
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest); 
        
        Test.stopTest();

    }

    
    @isTest
    public static void TestPutEventSpeaker404(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));

        Event_Speaker__c eventSpeaker = [SELECT Id FROM Event_Speaker__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSpeaker.Id;
        eventMobiRequest.sObjectType = 'Event_Speaker__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest); 
        
        Test.stopTest();

    }

    
    @isTest
    public static void TestAddEventSession200(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));

        Event_Sessions__c eventSession = [SELECT Id FROM Event_Sessions__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSession.Id;
        eventMobiRequest.sObjectType = 'Event_Sessions__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                 
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest); 
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventSession400(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));

        Event_Sessions__c eventSession = [SELECT Id FROM Event_Sessions__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSession.Id;
        eventMobiRequest.sObjectType = 'Event_Sessions__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                 
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest); 
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventSession404(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));

        Event_Sessions__c eventSession = [SELECT Id FROM Event_Sessions__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSession.Id;
        eventMobiRequest.sObjectType = 'Event_Sessions__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                 
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest); 
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventSession200(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));

        Event_Sessions__c eventSession = [SELECT Id FROM Event_Sessions__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSession.Id;
        eventMobiRequest.sObjectType = 'Event_Sessions__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                    
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);  
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventSession400(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));

        Event_Sessions__c eventSession = [SELECT Id FROM Event_Sessions__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSession.Id;
        eventMobiRequest.sObjectType = 'Event_Sessions__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                    
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);  
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventSession404(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));

        Event_Sessions__c eventSession = [SELECT Id FROM Event_Sessions__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSession.Id;
        eventMobiRequest.sObjectType = 'Event_Sessions__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                    
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);  
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventSessionTrack200(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));

        Event_Session_Track__c eventSessionTrack = [SELECT Id FROM Event_Session_Track__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSessionTrack.Id;
        eventMobiRequest.sObjectType = 'Event_Session_Track__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventSessionTrack400(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));
        
        Event_Session_Track__c eventSessionTrack = [SELECT Id FROM Event_Session_Track__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSessionTrack.Id;
        eventMobiRequest.sObjectType = 'Event_Session_Track__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventSessionTrack404(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));

        Event_Session_Track__c eventSessionTrack = [SELECT Id FROM Event_Session_Track__c LIMIT 1];
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSessionTrack.Id;
        eventMobiRequest.sObjectType = 'Event_Session_Track__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventSessionTrack200(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));

        Event_Session_Track__c eventSessionTrack = [SELECT Id FROM Event_Session_Track__c LIMIT 1];
        
        Test.startTest();
                
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSessionTrack.Id;
        eventMobiRequest.sObjectType = 'Event_Session_Track__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventSessionTrack400(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));

        Event_Session_Track__c eventSessionTrack = [SELECT Id FROM Event_Session_Track__c LIMIT 1];
        
        Test.startTest();
                
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSessionTrack.Id;
        eventMobiRequest.sObjectType = 'Event_Session_Track__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventSessionTrack404(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));

        Event_Session_Track__c eventSessionTrack = [SELECT Id FROM Event_Session_Track__c LIMIT 1];
        
        Test.startTest();
                
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventSessionTrack.Id;
        eventMobiRequest.sObjectType = 'Event_Session_Track__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventRegistration200(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = [SELECT Id FROM Event_Registration__c LIMIT 1][0].Id;
        eventMobiRequest.sObjectType = 'Event_Registration__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventRegistration400(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = [SELECT Id FROM Event_Registration__c LIMIT 1][0].Id;
        eventMobiRequest.sObjectType = 'Event_Registration__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventRegistration404(){

        EventMobiApiBatch.disableBatch = false;
        
        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = [SELECT Id FROM Event_Registration__c LIMIT 1][0].Id;
        eventMobiRequest.sObjectType = 'Event_Registration__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
            
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventRegistration200(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));
        
        Test.startTest();
                
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = [SELECT Id FROM Event_Registration__c LIMIT 1][0].Id;
        eventMobiRequest.sObjectType = 'Event_Registration__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventRegistration400(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(400));
        
        Test.startTest();
                
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = [SELECT Id FROM Event_Registration__c LIMIT 1][0].Id;
        eventMobiRequest.sObjectType = 'Event_Registration__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestPutEventRegistration404(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));
        
        Test.startTest();
                
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = [SELECT Id FROM Event_Registration__c LIMIT 1][0].Id;
        eventMobiRequest.sObjectType = 'Event_Registration__c';
        eventMobiRequest.action		 = 'PUT';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }

    @isTest
    public static void TestDelEventRegistration404(){

        Event_Registration__c eventRegistration = [SELECT Id FROM Event_Registration__c LIMIT 1];

        eventRegistration.Status__c = 'Cancelled';

        UPDATE eventRegistration;

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(404));
        
        Test.startTest();
                
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = eventRegistration.Id;
        eventMobiRequest.sObjectType = 'Event_Registration__c';
        eventMobiRequest.action		 = 'DEL';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();

    }
    
    @isTest
    public static void TestAddEventSessionRegistration201() {

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(201));
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = [SELECT Id FROM Event_Session_Registration__c LIMIT 1].Id;
        eventMobiRequest.sObjectType = 'Event_Session_Registration__c';
        eventMobiRequest.action		 = 'ADD';
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();
    }

    @isTest
    public static void TestDelEventSessionRegistration200() {

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));
        
        Test.startTest();
        
        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = new EventMobiAPIFactory.EventMobiRequest();
        
        eventMobiRequest.externalId  = [SELECT Id, Event_Registration__r.Contact__c FROM Event_Session_Registration__c LIMIT 1].Id;
        eventMobiRequest.sObjectType = 'Event_Session_Registration__c';
        eventMobiRequest.action		 = 'DEL';
        eventMobiRequest.eventSessionRegistration = [SELECT Id, Event_Session__c, Event_Registration__r.Contact__c FROM Event_Session_Registration__c LIMIT 1];
           
        List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>{eventMobiRequest};
                   
        new EventMobiApiBatch(eventMobiRequests).doActions(eventMobiRequest);
        
        Test.stopTest();
    }

    @isTest
    public static void TestExtraneousClassMembers(){

        EventMobiApiBatch.disableBatch = false;

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));
        
        Test.startTest();
        
        EventMobiAPI.SessionResponse sr = new EventMobiAPI.SessionResponse();
        sr.Id 				= 'test';
        sr.event_id 		= 'test';					
        sr.name	 			= 'test';					
        sr.description 		= 'test';				
        sr.location			= 'test';		
        sr.start_datetime	= 'test';		
        sr.end_datetime		= 'test';		
        sr.track_ids		= new List<String>();	
        sr.tracks		 	= new List<EventMobiAPI.Track>();		
        sr.created_at		= 'test';			
        sr.updated_at	 	= 'test';		
        
        EventMobiAPI.PeopleResponse pr = new EventMobiAPI.PeopleResponse();
        pr.id				= 'test';			
        pr.first_name		= 'test';			
        pr.last_name		= 'test';		
        pr.email			= 'test';			
        pr.company			= 'test';		
        pr.title			= 'test';			
        pr.description		= 'test';			
        pr.created_at		= 'test';		
        pr.updated_at		= 'test';		
        pr.upload_image_url = 'test';				
        pr.group_ids		= new List<String>();			
        pr.session_roles 	= new List<EventMobiAPI.SessionRole>();
        
        EventMobiAPI eventMobiApi = new EventMobiAPI();

        eventMobiApi.EventSession.resourceType = 'sessions/resources/';

        Test.stopTest();
                    
    }
    
    @isTest
    private static void test_Utils() {

        Event_Session_Track__c eventSessionTrack = [SELECT Id, Name FROM Event_Session_Track__c LIMIT 1];
        Event_Registration__c eventRegistration = [SELECT Id, Name FROM Event_Registration__c LIMIT 1];

        EventMobiAPI.Error err = new EventMobiAPI.Error();
        err.code = 'test';
        err.message = 'test message';
        
        EventMobiAPi.PeopleGroupResponseEnvelope pgre = new EventMobiAPi.PeopleGroupResponseEnvelope();
        String type = pgre.type;
        Integer status = pgre.status;
        List<EventMobiAPI.Error> errors = pgre.errors;
        EventMobiAPi.PeopleGroup grp = pgre.data;
        
        EventMobiAPi.PeopleGroupsResponseEnvelope pgre2 = new EventMobiAPi.PeopleGroupsResponseEnvelope();
        List<EventMobiAPi.PeopleGroup> grps = pgre2.data;
        
        EventMobiAPi.SessionRoleResponseEnvelope srre = new EventMobiAPi.SessionRoleResponseEnvelope();
        EventMobiAPi.SessionRole srreData = srre.data;
        
        EventMobiAPi.SessionRolesResponseEnvelope srre2 = new EventMobiAPi.SessionRolesResponseEnvelope();
        List<EventMobiAPi.SessionRole> srre2Data = srre2.data;
        
        EventMobiAPi.PersonDetailResponseEnvelope pdre = new EventMobiAPi.PersonDetailResponseEnvelope();
        EventMobiAPi.PeopleResponse pdreData = pdre.data;
        
        EventMobiAPi.PeopleResponseEnvelope pre = new EventMobiAPi.PeopleResponseEnvelope();
        List<EventMobiAPi.PeopleResponse> preData = pre.data;
        
        EventMobiAPi.SessionDetailResponseEnvelope sdre = new EventMobiAPi.SessionDetailResponseEnvelope();
        EventMobiAPi.SessionResponse sdreData = sdre.data;
        
        EventMobiAPi.SessionsResponseEnvelope sre = new EventMobiAPi.SessionsResponseEnvelope();
        List<EventMobiAPi.SessionResponse> sreData = sre.data;
        
        EventMobiAPi.TrackDetailResponseEnvelope tdre = new EventMobiAPi.TrackDetailResponseEnvelope();
        EventMobiAPi.Track tdreData = tdre.data;
        
        EventMobiAPi.TracksResponseEnvelope tre = new EventMobiAPi.TracksResponseEnvelope();
        List<EventMobiAPi.Track> treData = tre.data;
        
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new EventMobiAPIMockHttpCallout(200));
        
        EventMobiAPI.Track trackCls = new EventMobiAPI.Track(eventSessionTrack);
        trackCls.add(eventSessionTrack.Id, false);
        trackCls.put(eventSessionTrack.Id, false);
        trackCls.del(new Event_Session_Track__c());
        trackCls.del(eventSessionTrack.Id);
        
        EventMobiAPI.PeopleGroup pgCls = new EventMobiAPI.PeopleGroup();
        String id = eventRegistration.Id;
        String name = pgCls.name;
        String pgCls_type = pgCls.type;
        String event_id = pgCls.event_id;
        List<STring> ppl_ids = pgCls.people_ids;
        
        pgCls.add(eventRegistration.Id, false);
        pgCls.put(eventRegistration.Id, false);
        pgCls.del(new Event_Session_Track__c());
        pgCls.del(eventRegistration.Id);
        
        Test.stopTest();
        
    }
   
}