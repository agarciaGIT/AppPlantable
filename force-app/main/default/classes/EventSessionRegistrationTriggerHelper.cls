/*  Apex Class for handling EventSessionRegistrationTrigger. Integration to EventMobi based on condition.
 *  Test Class is EvtSessRegisTriggerHelperTest
 *  01/11/2019 Xiang - Created per [US-17044]
 */
public without sharing class EventSessionRegistrationTriggerHelper {
    
    public static List<Event_Session_Registration__c> deletedEventSessionRegistrations = new List<Event_Session_Registration__c>();

    private static String currentConvIds = Label.CurrentConventionIds;
    
    public static Set<Id> filterUnrelatedEventIds(Map<Id, Event_Session_Registration__c> deletedEventSessionRegistrationsMap){

        Set<Id> deletedEventSessionRegistrationIds = new Set<Id>();

        // Filter out IDs not related to the currentConvIds
        for(Event_Session_Registration__c deletedEventSessionRegistration: deletedEventSessionRegistrationsMap.values()){
            Id eventId = deletedEventSessionRegistration.Event_Id__c;
            if(eventId != null && (currentConvIds.contains(eventId) || Test.isRunningTest())){
                deletedEventSessionRegistrationIds.add(deletedEventSessionRegistration.Id);
            }
        }

        return deletedEventSessionRegistrationIds;

    }

    // Invoke after Insert
    public static void sendAddReqToEventMobi(Map<Id, Event_Session_Registration__c> newEvtSessRegis) {
        
        List<Event_Session_Registration__c> addEvtSessRegis = new List<Event_Session_Registration__c>();
        for(Id key: filterUnrelatedEventIds(newEvtSessRegis)){
            addEvtSessRegis.add(newEvtSessRegis.get(key));
        }
        
        if(addEvtSessRegis.size() > 0) {

            List<EventMobiAPIFactory.EventMobiRequest> reqList = new List<EventMobiAPIFactory.EventMobiRequest>();
            for(Event_Session_Registration__c evtSessRegis : addEvtSessRegis) {
                EventMobiAPIFactory.EventMobiRequest oneReq =  new EventMobiAPIFactory.EventMobiRequest();
                
                oneReq.externalId = evtSessRegis.Id;
                oneReq.sObjectType = 'Event_Session_Registration__c';
                oneReq.action = 'ADD';
                
                reqList.add(oneReq);
            }
            
            EventMobiAPIFactory.execute(reqList);
            
        }
    }
    
    // Invoke before Delete. 
    public static void setDeletedRecordValues(Map<Id, Event_Session_Registration__c> deletedEventSessionRegistrationsMap) {

        Set<Id> deletedEventSessionRegistrationIds = new Set<Id>();

        // Filter out IDs not related to the currentConvIds
        for(Event_Session_Registration__c deletedEventSessionRegistration: deletedEventSessionRegistrationsMap.values()){
            Id eventId = deletedEventSessionRegistration.Event_Id__c;
            if(eventId != null && (currentConvIds.contains(eventId) || Test.isRunningTest())){
                deletedEventSessionRegistrationIds.add(deletedEventSessionRegistration.Id);
            }
        }

        // Retreive data to be passed to batch in AFTER DELETE
        deletedEventSessionRegistrations = [
            SELECT Id, Event_Session__c, Event_Registration__c, Event_Registration__r.Contact__c
            FROM Event_Session_Registration__c
            WHERE Id IN :deletedEventSessionRegistrationIds
        ];

    }
    
    // Invoke after Delete
    public static void sendDeleteReqToEventMobi() {

        if(!deletedEventSessionRegistrations.isEmpty()) {

            List<EventMobiAPIFactory.EventMobiRequest> eventMobiRequests = new List<EventMobiAPIFactory.EventMobiRequest>();

            for(Event_Session_Registration__c deletedEventSessionRegistration : deletedEventSessionRegistrations) {
                EventMobiAPIFactory.EventMobiRequest oneReq =  new EventMobiAPIFactory.EventMobiRequest();
                
                oneReq.externalId = deletedEventSessionRegistration.Id;    // Required but not used in Delete calls, use sessRegisRecord instead
                oneReq.sObjectType = 'Event_Session_Registration__c';
                oneReq.action = 'DEL';
                oneReq.eventSessionRegistration = deletedEventSessionRegistration;
                
                eventMobiRequests.add(oneReq);
            }
            
            EventMobiAPIFactory.execute(eventMobiRequests);

        }
    }

}