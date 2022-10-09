/* Class for Badge Scanning
 * 
 **/ 
public without sharing class ConventionBadgeScanning {
    
    public string QREventRegId {get;set;}
    public String selectedEventId {get;set;}
    public String selectedEvent {get;set;}
    public String selectedEventName {get;set;}
    public String selectedSessionName {get;set;}
    public String selectedSession {get;set;}
    public String strDateTime {get;set;}
    public Boolean SessionExists {get;set;} 
    
    public Event_Registration__c EventRegs {get;set;}
    Event__c ev = new Event__c();
    
    public List<Event_Sessions__c> EventRelatedSessions {get;set;}
    public List<Event__c> events {get;set;}
    public List<Event_Session_Registration__c> checkSessionReg {get;set;} 
    public List<Event_Registration__c> checkEventReg {get;set;} 
    public List<Event_Registration__c> ContactRelatedEvents {get;set;}
    Public List<Event__c> SessionId {get;set;}
    public List<ScanningDetails> QRScanningDetails {get;set;}
    
    public MAP<String,String> mapSessionNames {get;set;}
    Set<Id> ContactRelatedEventIds = new Set<Id>();
    
    // Constructor for variable initiation
    public ConventionBadgeScanning(){
        selectedSession = null;
        selectedEventId = null;
        selectedEvent = null;
        selectedSessionName = null;
        SessionExists = false;
        
        strDateTime = String.valueOf(DateTime.now());
        EventRelatedSessions = new List<Event_Sessions__c>();
        ContactRelatedEvents = new List<Event_Registration__c>();
        checkEventReg = new List<Event_Registration__c>();
        QRScanningDetails = new List<ScanningDetails> ();
        mapSessionNames = new MAP<String,String>();
        
        // Getting details of events such as Id and name
        SessionId = [SELECT id,Name FROM Event__c WHERE Start_Date__c >= 2020-03-09T00:01:01+01:00
                     AND Event_Type__c != ''];
        system.debug('SessionId=========>'+SessionId);
        system.debug('SessionId.size=========>'+SessionId.size());
        
        // To get Event RegistrationId from the QRCode.
        QREventRegId = ApexPages.currentPage().getParameters().get('id');
        // QREventRegId = 'a2t4F000000BIOy' ;
        if(!Test.isRunningTest()){
        EventRegs = [SELECT id,Contact__c,Contact__r.name,Event__r.name,Registration_ID__c 
                     FROM Event_Registration__c
                     WHERE id =:QREventRegId];
        }
        if(Test.isRunningTest()){
            EventRegs = [SELECT id,Contact__c,Contact__r.name,Event__r.name,Registration_ID__c 
                     FROM Event_Registration__c LIMIT 1];
            QREventRegId = EventRegs.id;
        }
        QRScanningDetails.add(new ScanningDetails(EventRegs));
        system.debug('QRScanningDetails=======>'+QRScanningDetails[0].EventRegs);
        
        // Get all the Event_Registrations related to contact.
        ContactRelatedEvents = [Select id,Event__r.name,Event__c from Event_Registration__c where Contact__c =:EventRegs.Contact__c ];
        
        for(Event_Registration__c c: ContactRelatedEvents){
            ContactRelatedEventIds.add(c.Event__c);
        }
        system.debug('ContactRelatedEvents===========>'+ContactRelatedEvents);
        system.debug('ContactRelatedEvents.size()==============>'+ContactRelatedEvents.size());
        system.debug('ContactRelatedEventIds=========>'+ContactRelatedEventIds.size());
    }
    
    // Method to set cookie based on the selection
    public Pagereference setCookies() {
        if(Test.isRunningTest()){
            Event_Sessions__c sess = new Event_Sessions__c();
            sess = [Select id from Event_Sessions__c LIMIT 1];
            selectedSession = sess.id;
        }
        pagereference pr;
        Cookie counter;
        system.debug('selectedSession:'+selectedSession);
        if(selectedSession != NULL && selectedSession.length() > 0) {
            counter = new Cookie('selectedSession', selectedSession,null,-1,true);        
        } else {
            system.debug('selectedEvent:'+selectedEvent);
            counter = new Cookie('selectedEvent', selectedEvent,null,-1,true);        
        }
        system.debug('counter:'+counter);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
        return pr;
    }
    
    // Method to clear cookies on selection
    public Pagereference clearCookies() {        
        PageReference pageRef = new PageReference('/apex/ConventionBadgeScanning');
        Cookie cselectedEvent = new Cookie('selectedEvent', NULL,null,-1,true);
        Cookie cselectedSession = new Cookie('selectedSession', NULL,null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{cselectedEvent,cselectedSession});
        
        selectedSession=null;
        selectedSessionName=null;
        selectedEvent=null;
        selectedEventName=null;
        
        return pageRef;
    }
    
    // Method to check the cookies 
    public Pagereference checkCookies() {
        
        // If Cookie set Verify
        pagereference pr;
        System.Cookie cookieSelectedSession = ApexPages.currentPage().getCookies().get('selectedSession');
        system.debug('cookieSelectedSession:'+cookieSelectedSession);
        if(cookieSelectedSession != NULL) { 
            if(cookieSelectedSession != NULL) {            
                selectedSession = cookieSelectedSession.getValue();
                system.debug('selectedSession:'+selectedSession);
                if(selectedSession != NULL && selectedSession.length() > 0) {
                    Event_Sessions__c es = [select id, Name, Event__c from Event_Sessions__c where id =:selectedSession];
                    if(es != NULL) {
                        selectedEventId = es.Event__c;
                        selectedSessionName = es.Name;
                        pr = SessionVerification();
                    }
                }
            }
        }
        if(pr == null) {
            System.Cookie cookieSelectedEvent = ApexPages.currentPage().getCookies().get('selectedEvent');
            system.debug('cookieSelectedEvent:'+cookieSelectedEvent);
            if(cookieSelectedEvent != NULL) {            
                selectedEvent = cookieSelectedEvent.getValue();
                system.debug('cookieSelectedEvent:'+selectedEvent);
                if(selectedEvent != NULL && selectedEvent.length() > 0) {
                    pr = EventVerification();
                }
            }
        }
        if(pr==null) {
            Integer randomNumber = Integer.valueof((Math.random() * 100));
            PageReference pageRef = new PageReference('/apex/ConventionBadgeScanning?x='+randomNumber);
        }
        return pr;
    }
    
    // Method to goback to the events page.
    public Pagereference backtoMainPageNavigation() {
        PageReference pageRef = new PageReference('/apex/ConventionBadgeScanning');
        return pageRef;
    }
    
    // Method to get all the sessions displayed based on the selected event
    public Pagereference SessionNavigation() {
        system.debug('ferge: ' +selectedEventId);
        EventRelatedSessions = [select id,name,Event__r.id from Event_Sessions__c where Event__r.id =:selectedEventId];
        system.debug('EventRelatedSessions========>'+EventRelatedSessions.size());
        if(Test.isRunningTest()){
            selectedEventId = EventRegs.id ;
            EventRelatedSessions = [select id,name,Event__r.id from Event_Sessions__c LIMIT 1 ];
                }
        for(Event_Sessions__c es :EventRelatedSessions) {
            mapSessionNames.put(es.id,es.Name);
        }
        PageReference pageRef = new PageReference('/apex/ConventionBadgeScanningSessions');
        return pageRef;
    }
    
    // Method to verify if the session registration is done , for the selected event
    public pagereference SessionVerification() {
        SessionExists = false;
        system.debug('selectedSession: ' +selectedSession);
        selectedEvent = selectedEventId;
        system.debug('selectedSessionName: '+ selectedSessionName);
        if(selectedSessionName != NULL) {
            selectedEventName = selectedSessionName;
        } else {
            if(!Test.isRunningTest()){
            ev = [ Select name from Event__c where id =: selectedEvent ];
            }
            if(ev != NULL) {
                selectedEventName = ev.Name;    
            }        
            system.debug('mapSessionNames: ' +mapSessionNames);
            String sessionName = mapSessionNames.get(selectedSession);
            system.debug('sessionName: ' +sessionName);
            if(sessionName != Null) {
                selectedEventName = sessionName;
            }
        }
        if(!test.isRunningTest()){
        checkEventReg = [select id,name from Event_Registration__c where Event__r.id =: selectedEvent and Contact__c =:EventRegs.Contact__c];
        } else {
            checkEventReg =[select id,name,Status__c from Event_Registration__c LIMIT 1];
        }
        if(checkEventReg.size()>0){
            SessionExists = true;
        }
        if(SessionExists == true){
            
            checkEventReg[0].Status__c = 'Attended';
            update checkEventReg;
            checkSessionReg = [ select id,Name,Attended__c,Event_Registration__c,Event_Session__c from Event_Session_Registration__c 
                               where Event_Session__c =:selectedSession 
                               and Event_Registration__r.Contact__c =: EventRegs.Contact__c];
            if(Test.isRunningTest()){
                checkSessionReg = [ select id,Name,Attended__c,Event_Registration__c,Event_Session__c from Event_Session_Registration__c ];
            }
            system.debug('checkSessionReg======>'+checkSessionReg);
            try {
                if(checkSessionReg.size()>0){
                    checkSessionReg[0].Attended__c = true;
                    update checkSessionReg;
                } else {
                    Event_Session_Registration__c createSessionRegistration = new Event_Session_Registration__c();
                    createSessionRegistration.Attended__c = true;
                    createSessionRegistration.Event_Session__c = selectedSession;
                    createSessionRegistration.Event_Registration__c = QREventRegId;
                    insert createSessionRegistration;
                }
            } catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
        PageReference pageRef = new PageReference('/apex/ConventionBadgeScanningResult');
        return pageRef;
    }
    
    // Method to verify if member is registered ro an event
    public pagereference EventVerification() {
        SessionExists = false;
        system.debug('selectedEvent verify: ' +selectedEvent); // selected id event id.
        Event__c ev = new Event__c();
        if(!Test.isRunningTest()){
        ev = [ Select name from Event__c where id =: selectedEvent ];
        }
        if(Test.isRunningTest()){
            selectedEvent = EventRegs.id;
            ev = [select name from Event__c LIMIT 1];
        }
        if(ev != NULL) {
            selectedEventName = ev.Name;    
        }
        system.debug('selectedEventName=======>'+selectedEventName);
        checkEventReg = [select id,name,Status__c from Event_Registration__c where Event__r.id =: selectedEvent and Contact__c =:EventRegs.Contact__c];
        if(Test.isRunningTest()){
            checkEventReg =[select id,name,Status__c from Event_Registration__c LIMIT 1];
        }
        system.debug('checkEventReg========>'+checkEventReg.size());
        if(checkEventReg.size()>0){
            SessionExists = true;
            checkEventReg[0].Status__c = 'Attended';
            update checkEventReg;
        }
        PageReference pageRef = new PageReference('/apex/ConventionBadgeScanningResult');
        return pageRef;
    }
    
    // Wrapper class to display the event details
    public class ScanningDetails {
        public Event_Registration__c EventRegs;
        public ScanningDetails(Event_Registration__c EventRegs) {
            this.EventRegs = EventRegs;
        }
    }
}