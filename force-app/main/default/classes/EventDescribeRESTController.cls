@RestResource(urlMapping='/event/*/describe/*')
global class EventDescribeRESTController extends EventRESTService{
	
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
        
        String registrationPicklistType = EventRESTService.params.get('describe');
        if(!EventRESTService.registrationEndpointIsValid(registrationPicklistType)){
            return EventRESTService.error;       
        }
        
        if(registrationPicklistType == 'registration-statuses'){
       		return EventRESTService.getRegistrationStatuses();
        }else if(registrationPicklistType == 'contributor-types'){
            return EventRESTService.getContributorTypes();
        }else if(registrationPicklistType == 'participant-types'){
            return EventRESTService.getParticipantTypes();
        }else if(registrationPicklistType == 'attendee-types'){
            return EventRESTService.getAttendeeTypes();
        }
        
        return EventRESTService.getInvalidRoute(); 
        
    }
    
}