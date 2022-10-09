global class EventMobiApiBatch implements Database.Batchable<EventMobiAPIFactory.EventMobiRequest>, Database.StateFul, Database.AllowsCallouts {

    @testVisible private static Boolean rethrowException = true;
    @testVisible private static Boolean disableBatch = false;

    public List<Response.Detail> exceptions = new List<Response.Detail>();
    public List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests;

    public EventMobiApiBatch(List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests){
        this.eventMobiRequests = eventMobiRequests;
    }

    /**
    @description Datamines Convention Related Event Registration that are 'Registered and Paid' or 'RSVP Accept'
    @param eventRegistrationId Id of the externalId provided by the Process Builder
    @return List<Event_Registration__c> returns a list of 'Registered and Paid' or 'RSVP Accept' Event Registrations
    */    
    private List<Event_Registration__c> getRegisteredForEventRegistrations(Id eventRegistrationId){

        Set<Id> eventIds = new Set<Id>();
        for(String eventId: Label.CurrentConventionIds.split('\n')){
            eventIds.add(eventId.trim());
        }

        // Get Contact ID
        Event_Registration__c cancelledEventRegistration = [
            SELECT Id, Contact__c
            FROM Event_Registration__c 
            WHERE Id = :eventRegistrationId
        ];

        // Get all Convention Related events that the user is registered for
        List<Event_Registration__c> registeredEventRegistrations = [
            SELECT Id 
            FROM Event_Registration__c 
            WHERE 
                Contact__c = :cancelledEventRegistration.Contact__c AND 
                (Status__c = 'Registered and Paid' OR Status__c = 'RSVP Accept') AND 
                Event__c IN :eventIds
        ];

        return registeredEventRegistrations;

    }

    /**
    @description Datamines if the record being processed should be synced and returns a boolean
    @param sObjectType the object type that is in context
    @param externalId the record id that is in context
    @return Boolean that determines if the related Event to the sObject record in context is meant to be synced
    */
    private Boolean isConventionRelated(String sObjectType, String externalId) {

        Boolean isConventionRelated = false;
        String currentConventionIds = Label.CurrentConventionIds;
        
        if(sObjectType == 'Event_Session_Track__c') {
            Event_Session_Track__c eventSessionTrack = [SELECT Id, (SELECT Id, Event__c FROM Event_Sessions__r) FROM Event_Session_Track__c WHERE Id = :externalId];
            for(Event_Sessions__c eventSession : eventSessionTrack.Event_Sessions__r) {
                if(null != eventSession.Event__c && currentConventionIds.contains(eventSession.Event__c)) {
                    isConventionRelated = true;
                    break;
                }
            }
        }else if(sObjectType == 'Event_Speaker__c') {
            Event_Speaker__c eventSpeaker = [SELECT Id, (SELECT Id, Event_Session__r.Event__c FROM Event_Speaker_Session_Tracks__r) FROM Event_Speaker__c WHERE Id = :externalId];
            for(Event_Speaker_Session_Track__c eventSessionTrack : eventSpeaker.Event_Speaker_Session_Tracks__r) {
                if(null != eventSessionTrack.Event_Session__r.Event__c && currentConventionIds.contains(eventSessionTrack.Event_Session__r.Event__c)) {
                    isConventionRelated = true;
                    break;
                }
            }                        
        }
        
        return isConventionRelated;

    }
    
    public void doActions(EventMobiAPIFactory.EventMobiRequest eventMobiRequest) {

        String action = eventMobiRequest.action.toUpperCase();
        String externalId = eventMobiRequest.externalId;
        String sObjectType = eventMobiRequest.sObjectType;
        Event_Session_Registration__c eventSessionRegistration = eventMobiRequest.eventSessionRegistration;

        // If @testSetup is running in test class, prevent callouts.
        if(disableBatch){
            return;
        }

        // Check if Session Track/Speaker is related to Convention, if not skip doActions
        if(sObjectType == 'Event_Session_Track__c' || sObjectType == 'Event_Speaker__c') {
            if(!isConventionRelated(sObjectType, externalId) && !Test.isRunningTest()) return;
        }
        
        try{
            
            EventMobiAPI EventMobiAPI = new EventMobiAPI();
            
            EventMobiAPI.ResponseEnvelope envelope = null;

            if(sObjectType == 'Event__c'){

                if(action == 'ADD'){
                    
                    envelope = EventMobiAPI.EventSessionTrack.add(externalId, false);
                    
                    if(envelope.status == 400){
                        envelope = EventMobiAPI.EventSessionTrack.add(externalId, true);
                    }                                
                    
                }else if(action == 'PUT'){
                    
                    envelope = EventMobiAPI.EventSessionTrack.put(externalId, false);
                    
                    if(envelope.status == 404){
                        envelope = EventMobiAPI.EventSessionTrack.add(externalId, false);
                        if(envelope.status == 400){
                            envelope = EventMobiAPI.EventSessionTrack.add(externalId, true);
                        }
                    }else if(envelope.status == 400){
                        envelope = EventMobiAPI.EventSessionTrack.put(externalId, true);
                    }
                    
                }    

            }else if(sObjectType == 'Event_Speaker__c'){
                
                if(action == 'ADD'){
                    
                    envelope = EventMobiAPI.EventSpeaker.add(externalId, false);
                    
                    if(envelope.status == 400){
                        envelope = EventMobiAPI.EventSpeaker.add(externalId, true);
                    }    
                    
                }else if(action == 'PUT'){
                    
                    envelope = EventMobiAPI.EventSpeaker.put(externalId, false);
                    
                    if(envelope.status == 404){
                        envelope = EventMobiAPI.EventSpeaker.add(externalId, false);
                        if(envelope.status == 400){
                            envelope = EventMobiAPI.EventSpeaker.add(externalId, true);  
                        }
                    }else if(envelope.status == 400){
                        envelope = EventMobiAPI.EventSpeaker.put(externalId, true);
                    }
                    
                }
                
            }else if(sObjectType == 'Event_Sessions__c'){
                
                if(action == 'ADD'){
                    
                    envelope = EventMobiAPI.EventSession.add(externalId, false);
                    
                    if(envelope.status == 400){
                        envelope = EventMobiAPI.EventSession.add(externalId, true);
                    }                                
                    
                }else if(action == 'PUT'){
                    
                    envelope = EventMobiAPI.EventSession.put(externalId, false);
                    
                    if(envelope.status == 404){
                        envelope = EventMobiAPI.EventSession.add(externalId, false);
                        if(envelope.status == 400 || envelope.status == 404){
                            envelope = EventMobiAPI.EventSession.add(externalId, true);
                        }
                    }else if(envelope.status == 400){
                        envelope = EventMobiAPI.EventSession.put(externalId, true);
                    }
                    
                }           
                
            }else if(sObjectType == 'Event_Session_Track__c'){
                
                if(action == 'ADD'){
                    
                    envelope = EventMobiAPI.EventSessionTrack.add(externalId, false);
                    
                    if(envelope.status == 400){
                        envelope = EventMobiAPI.EventSessionTrack.add(externalId, true);
                    }                                
                    
                }else if(action == 'PUT'){
                    
                    envelope = EventMobiAPI.EventSessionTrack.put(externalId, false);
                    
                    if(envelope.status == 404){
                        envelope = EventMobiAPI.EventSessionTrack.add(externalId, false);
                        if(envelope.status == 400){
                            envelope = EventMobiAPI.EventSessionTrack.add(externalId, true);
                        }
                    }else if(envelope.status == 400){
                        envelope = EventMobiAPI.EventSessionTrack.put(externalId, true);
                    }
                    
                }           
                
            }else if(sObjectType == 'Event_Registration__c'){
                
                if(action == 'ADD') {
                    
                    envelope = EventMobiAPI.EventRegistration.add(externalId, false);

                    if(envelope.status == 400) {
                        envelope = EventMobiAPI.EventRegistration.add(externalId, true);
                    }else if(envelope.status == 409){
                        envelope = EventMobiAPI.EventRegistration.put(externalId, false);
                    }
                    
                }else if(action == 'PUT') {
                    
                    envelope = EventMobiAPI.EventRegistration.put(externalId, false);
                                   
                    if(envelope.status == 404) {
                        envelope = EventMobiAPI.EventRegistration.add(externalId, false);
                        if(envelope.status == 400) {
                            envelope = EventMobiAPI.EventRegistration.add(externalId, true);
                        }
                    }else if(envelope.status == 400) {
                        envelope = EventMobiAPI.EventRegistration.put(externalId, true);
                    }
                    
                }else if(action == 'DEL') {

                    // Get all Convention Related events that the user is registered for
                    List<Event_Registration__c> registeredEventRegistrations = getRegisteredForEventRegistrations(externalId);
                    
                    if(registeredEventRegistrations.isEmpty()){
                        // If the user is registered for no Convention related events, remove their registration
                        envelope = EventMobiAPI.EventRegistration.del(externalId);
                    }else{
                        // If the user is registered for Convention related events, update their People Group assignments
                        envelope = EventMobiAPI.EventRegistration.put(externalId, false);
                    }

                }
                
            }else if(sObjectType == 'Event_Session_Registration__c'){

                if(action == 'ADD') {
                    envelope = EventMobiAPI.EventSessionRegistration.add(externalId, false);
                }else if(action == 'DEL' && null != eventSessionRegistration) {
                    envelope = EventMobiAPI.EventSessionRegistration.del(eventSessionRegistration);
                }

            }

            if(envelope != null && envelope.status > 207){
                Response.Detail res = new Response.Detail();
                res.data = envelope;
                res.status = envelope.status;
                res.message = 'Action: ' + action + ', sObject Type: ' + sObjectType + ', External ID: ' + externalId;
                this.exceptions.add(res);
            }
            
        }catch(Response.ResponseException e){

            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());

            Response.Detail res = new Response.Detail(
                'Action: ' + action + ', sObject Type: ' + sObjectType + ', External ID: ' + externalId,
                e.status, 
                e.errors
            );
            this.exceptions.add(res);

            if(Test.isRunningTest() && rethrowException){
                throw new EventMobiAPITest.TestException();
            }

        }catch(Exception e) {

            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());

            Response.Detail res = new Response.Detail();
            res.data = e.getStackTraceString();
            res.status = 500;
            res.message = 'Action: ' + action + ', sObject Type: ' + sObjectType + ', External ID: ' + externalId;
            this.exceptions.add(res);

            if(Test.isRunningTest() && rethrowException){
                throw new EventMobiAPITest.TestException();
            }

        }
        
    }

    global List<EventMobiAPIFactory.EventMobiRequest> start(Database.BatchableContext BC){     
        return this.eventMobiRequests;
    }

    global void execute(Database.BatchableContext BC, List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests){

        EventMobiAPIFactory.EventMobiRequest eventMobiRequest = eventMobiRequests[0];
        
        doActions(eventMobiRequest); 

        if(!EventMobiAPI.apiTransactions.isEmpty()) {
            INSERT EventMobiAPI.apiTransactions;
        }

    }
        
    global void finish(Database.BatchableContext BC){

        try {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setToAddresses(new String[] {'david.lappert@garp.com'});
            mail.setSubject('EventMobi Sync Batch Job Completed: ' + BC.getJobId());
            mail.setPlainTextBody('Exceptions: \n\n' + JSON.serializePretty(this.exceptions));
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

    }

}