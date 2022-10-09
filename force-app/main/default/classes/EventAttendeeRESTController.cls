@RestResource(urlMapping='/event/*/attendee/*')
global class EventAttendeeRESTController extends EventRESTService{

    @HttpPut
    global static Envelope doPut(){
        
        EventRESTService.req = RestContext.request;
        EventRESTService.res = RestContext.response;

        if(!EventRESTService.isAuthenticated(EventRESTService.req.headers)){
            return EventRESTService.error;
        }

        EventRESTService.params = EventRESTService.parameterMap(EventRESTService.req.requestURI);
        String eventId = EventRESTService.params.get('event');
        if(!EventRESTService.eventIdIsValid(eventId)){
            return EventRESTService.error;   
        }
        
        String attendeeId = EventRESTService.params.get('attendee');
        if(!EventRESTService.attendeeIdIsValid(attendeeId, eventId)){
            System.debug(EventRESTService.error);
            return EventRESTService.error;       
        }
        
        String attended	= EventRESTService.req.params.get('attended');
        if(EventRESTService.attendedParameterIsValid(attended)){
            EventRESTService.params.put('attended', attended);
        }else{
			return EventRESTService.error;               
        }
        
        return EventRESTService.setRegistrationStatus(eventId, attendeeId, Boolean.valueOf(attended));
        
    }
    
    @HttpGet
    global static Envelope doGet(){
        
        EventRESTService.req = RestContext.request;
        EventRESTService.res = RestContext.response;
        
        if(!EventRESTService.isAuthenticated(EventRESTService.req.headers)){
            return EventRESTService.error;
        }
        
        EventRESTService.params = EventRESTService.parameterMap(EventRESTService.req.requestURI);
        
        String eventId = EventRESTService.params.get('event');
        if(!EventRESTService.eventIdIsValid(eventId)){
            return EventRESTService.error;   
        }
        
        String attendeeId = EventRESTService.params.get('attendee');
        if(attendeeId != null && !EventRESTService.attendeeIdIsValid(attendeeId, eventId)){
            return EventRESTService.error;       
        }

        String email = EventRESTService.req.params.get('email');
        if(email != null){
            EventRESTService.params.put('email', email); 
        }
        
        String modifiedAfterDatetimeString = EventRESTService.req.params.get('last_modified_date_time');
        if(modifiedAfterDatetimeString != null){
            EventRESTService.params.put('last_modified_date_time', modifiedAfterDatetimeString); 
        }
        
        String details = EventRESTService.req.params.get('details');
        if(details != null){
            EventRESTService.params.put('details', details); 
        }

        if(attendeeId == null && email != null){
            return EventRESTService.getAttendeeByEmail(eventId, email);
        }
        
        if(attendeeId == null && modifiedAfterDatetimeString != null){
			return EventRESTService.getAttendeesModifiedAfterDateTime(eventId, modifiedAfterDatetimeString);
        }
        
        if(attendeeId == null && details != null && Boolean.valueOf(details) == TRUE){
            return EventRESTService.getAttendeesDetail(eventId);
        } 
        
        if(attendeeId != null && email == null){
            return EventRESTService.getAttendeeByGarpId(eventId, attendeeId);
        }
        
        return EventRESTService.getAttendees(eventId);
        
    }
       
}