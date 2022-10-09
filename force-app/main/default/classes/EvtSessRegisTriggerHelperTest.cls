@isTest
private class EvtSessRegisTriggerHelperTest {
    
    @isTest
    private static void testInsertAndDelete() {
        
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
        
        DELETE eventSessionRegistration;
        
    }

}