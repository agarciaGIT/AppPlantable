@isTest
public class EventControllerTest {

    @testSetup
    public static void setup(){

        EventMobiApiBatch.disableBatch = true;
        
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

        String recordTypeEventConvention    = RecordTypeHelper.GetRecordTypeId('Event__c', 'Convention');
        String recordTypeEventNonConvention = RecordTypeHelper.GetRecordTypeId('Event__c', 'Non-Convention');
        
        Event__c parentEvent = new Event__c();
        parentEvent.RecordTypeId    = recordTypeEventConvention;
        parentEvent.Start_Date__c   = Date.today().addDays(58);
        parentEvent.End_Date__c     = Date.today().addDays(60);
        parentEvent.Name            = 'PARENT EVENT';
        INSERT parentEvent;
        
        Event_Sessions__c eventSessions = new Event_Sessions__c();
        eventSessions.Name = 'TEST EVENT SESSION';
        eventSessions.Event__c = parentEvent.Id;
        INSERT eventSessions;
        
        Event__c childEvent1 = new Event__c();
        childEvent1.Start_Date__c   = Date.today().addDays(58);
        childEvent1.End_Date__c     = Date.today().addDays(60);
        childEvent1.Name            = 'CHILD EVENT 1';
        childEvent1.Parent_Event__c = parentEvent.Id;
        INSERT childEvent1;
        
        Event__c childEvent2 = new Event__c();
        childEvent2.Start_Date__c   = Date.today().addDays(58);
        childEvent2.End_Date__c     = Date.today().addDays(60);
        childEvent2.Name            = 'CHILD EVENT 2';
        childEvent2.Parent_Event__c = parentEvent.Id;
        INSERT childEvent2;
        
        Event_Rate__c parentEventRate = new Event_Rate__c();
        parentEventRate.Start_Date__c   = Date.today().addDays(-10);
        parentEventRate.End_Date__c     = Date.today().addDays(10);
        parentEventRate.Event__c        = parentEvent.Id;
        INSERT parentEventRate;
        
        Event_Rate__c child1EventRate = new Event_Rate__c();
        child1EventRate.Start_Date__c   = Date.today().addDays(-10);
        child1EventRate.End_Date__c     = Date.today().addDays(10);
        child1EventRate.Event__c        = childEvent1.Id;
        INSERT child1EventRate; 
        
        Event_Rate__c child2EventRate = new Event_Rate__c();
        child2EventRate.Start_Date__c   = Date.today().addDays(-10);
        child2EventRate.End_Date__c     = Date.today().addDays(10);
        child2EventRate.Event__c        = childEvent2.Id;
        INSERT child2EventRate;     
        
        Account account = new Account();
        account.Name = 'TEST ACCOUNT';
        INSERT account;
        
        Contact contact = new Contact();
        contact.AccountId = account.Id;
        contact.FirstName = 'TEST FIRST NAME';
        contact.LastName = 'TEST LAST NAME';
        contact.Email ='test@test.com';
        INSERT contact;
        
        Event_Registration__c eventRegistrationForParentEvent = new Event_Registration__c();
        eventRegistrationForParentEvent.Contact__c = contact.Id;
        eventRegistrationForParentEvent.Event__c = parentEvent.Id;
        INSERT eventRegistrationForParentEvent;
        
        Event_Session_Registration__c eventSessionRegistration = new Event_Session_Registration__c();
        eventSessionRegistration.Event_Session__c = eventSessions.Id;
        eventSessionRegistration.Event_Registration__c = eventRegistrationForParentEvent.Id;
        INSERT eventSessionRegistration;
        
        Event_Registration__c eventRegistrationForChildEvent = new Event_Registration__c();
        eventRegistrationForChildEvent.Contact__c = contact.Id;
        eventRegistrationForChildEvent.Event__c = childEvent1.Id;
        INSERT eventRegistrationForChildEvent;
        
        Webcast__c webcast = new Webcast__c();
        webcast.Name = 'TESTWEBCAST';
        webcast.Start_Date__c = Datetime.now().addDays(10);
        webcast.End_Date__c = Datetime.now().addDays(11);
        INSERT webcast;
        
        Webcast_Registration__c wr = new Webcast_Registration__c();
        wr.Contact__c = contact.Id;
        wr.Webcast__c = webcast.Id;
        INSERT wr;
        
        Chapter_Meeting__c chapterMeeting = new Chapter_Meeting__c();
        chapterMeeting.Name = 'TESTCHAPTERMEETING';
        chapterMeeting.Start__c = Datetime.now().addDays(10);
        chapterMeeting.End__c = Datetime.now().addDays(11);
        INSERT chapterMeeting;
        
        Chapter_Meeting_Registration__c cmr = new Chapter_Meeting_Registration__c();
        cmr.Chapter_Meeting__c = chapterMeeting.Id;
        cmr.Contact__c = contact.Id;
        INSERT cmr;

    }

    @isTest
    public static void testGetEventsByContactId(){
        
        Id contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        EventController.getEventsByContactId(contactId);
        
    }
    
    @isTest 
    public static void testUpdateChapterMeetingRegistrationStatus(){
        
        Id chapterMeetingRegistrationId = [SELECT Id FROM Chapter_Meeting_Registration__c LIMIT 1].Id;
        EventController.updateChapterMeetingRegistrationStatus(chapterMeetingRegistrationId, 'Cancelled');
        
    }
    
}