/*  Apex Class holding Event Mobi Integration Logics for Event_Registration__c, Event_Sessions__c, Event_Session_Track__c and Event_Speaker__c
 *  01/10/2019 Xiang: US-17044. Updated PersonRequest Constructor for Event_Speaker__c so that Event_Speaker__c is in Speaker group only,
 *  Updated class EventRegistration to exclude Registrations related to Speaker to prevent duplicate records.
 */
public class EventMobiAPI {
    
    public static List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>();

    public Model EventSession 		{ get; set; }
    public Model EventSpeaker 		{ get; set; }
    public Model EventSessionTrack 	{ get; set; } 
    public Model EventRegistration 	{ get; set; } 
    public Model EventSessionRegistration { get; set; }
        
    public EventMobiAPI() {
        this.EventSession 		= new EventSession();
        this.EventSpeaker 		= new EventSpeaker();
        this.EventSessionTrack 	= new EventSessionTrack();
        this.EventRegistration 	= new EventRegistration();
        this.EventSessionRegistration = new EventSessionRegistration();
    }
    
    public abstract class Model{
        
        /*
         * Set Class properties as transient so they are not included 
         * in JSON serialization.
         */ 
        
        public transient String resourceType 				{ get; set; }
        public transient String apiKey   					{ get; set; }
        public transient String baseUrl						{ get; set; }
        public transient String eventId 					{ get; set; }
        public transient Map<String, String> idByNameMap 	{ get; set; }

        public abstract ResponseEnvelope add(Id external_id, Boolean removeDependencies);
        public abstract ResponseEnvelope put(Id external_id, Boolean removeDependencies);
        public abstract ResponseEnvelope del(Id external_id);
        public abstract ResponseEnvelope del(SObject del_record);
        
        public String HttpPost(Object requestBody, Id apiTransactionSobjectId){

            String sObjectType = apiTransactionSobjectId.getSObjectType().getDescribe().getName();
            
            String jsonString = JSON.serialize(requestBody);

            if(jsonString != null){
                
                HttpRequest req = new HttpRequest();

                String endpoint = baseUrl + '/v2/events/' + this.eventId + '/' + this.resourceType;

                System.debug('HttpPost: ' + endpoint);
                
                req.setEndPoint(endpoint);
                req.setTimeout(120000);
                req.setMethod('POST');
                req.setHeader('X-API-Key', apiKey);
                req.setHeader('Content-Type', 'application/json');
                req.setBody(jsonString);
                
                Http http = new Http();
                
                HttpResponse res = http.send(req);
                
                String result = res.getBody();

                API_Transaction__c apiTransaction = new API_Transaction__c();

                // Re-write related object reference
                sObjectType = (sObjectType == 'Event_Sessions__c') ? 'Event_Session__c' : sObjectType;

                apiTransaction.put(sObjectType, apiTransactionSobjectId);
                apiTransaction.Request_URL_Long_Text__c = endpoint;
                apiTransaction.Request_Body__c = jsonString;
                apiTransaction.Response_Body__c = result;
                apiTransaction.Response_Code__c = String.valueOf(((GenericEnvelope)JSON.deserialize(result, GenericEnvelope.class)).status);
                apiTransactions.add(apiTransaction);

                return result;
                
            }else{
                
                return null;
                
            }
            
        }
        
        public String HttpGet(){
            
            HttpRequest req = new HttpRequest();

            String endpoint = baseUrl + '/v2/events/' + this.eventId + '/' + this.resourceType;

            System.debug('HttpGet: ' + endpoint);

            req.setEndPoint(endpoint);
            req.setTimeout(120000);
            req.setMethod('GET');
            req.setHeader('X-API-Key', apiKey);
            req.setHeader('Content-Type', 'application/json');
            
            Http http = new Http();
            
            HttpResponse res = http.send(req);

            System.debug('Get Collection: ' + res.getBody());
            
            return res.getBody();
            
        }
        
        public String HttpGet(String externalId, Id apiTransactionSobjectId){

            String sObjectType = apiTransactionSobjectId.getSObjectType().getDescribe().getName();
            
            HttpRequest req = new HttpRequest();

            String endpoint = baseUrl + '/v2/events/' + this.eventId + '/' + this.resourceType + externalId;

            System.debug('HttpGet: ' + endpoint);
            
            req.setEndPoint(endpoint);
            req.setTimeout(120000);
            req.setMethod('GET');
            req.setHeader('X-API-Key', apiKey);
            req.setHeader('Content-Type', 'application/json');
            
            Http http = new Http();
            
            HttpResponse res = http.send(req);
            
            String result = res.getBody();
            
            API_Transaction__c apiTransaction = new API_Transaction__c();

            // Re-write related object reference
            sObjectType = (sObjectType == 'Event_Sessions__c') ? 'Event_Session__c' : sObjectType;

            apiTransaction.put(sObjectType, apiTransactionSobjectId);
            apiTransaction.Request_URL_Long_Text__c = endpoint;
            apiTransaction.Response_Body__c = result;
            apiTransaction.Response_Code__c = String.valueOf(((GenericEnvelope)JSON.deserialize(result, GenericEnvelope.class)).status);
            apiTransactions.add(apiTransaction);

            return result;
            
        }
        
        public String HttpPut(String externalId, Object requestBody, Id apiTransactionSobjectId){
            
            String sObjectType = apiTransactionSobjectId.getSObjectType().getDescribe().getName();

            String jsonString = JSON.serialize(requestBody);
  
            if(jsonString != null){
                
                HttpRequest req = new HttpRequest();

                String endpoint = baseUrl + '/v2/events/' + this.eventId + '/' + this.resourceType + externalId;

                System.debug('HttpPut: ' + endpoint);
                
                req.setEndPoint(endpoint);
                req.setTimeout(120000);
                req.setMethod('PUT');
                req.setHeader('X-API-Key', apiKey);
                req.setHeader('Content-Type', 'application/json');
                req.setBody(jsonString);
                
                Http http = new Http();
                
                HttpResponse res = http.send(req);
                
                String result = res.getBody();

                API_Transaction__c apiTransaction = new API_Transaction__c();

                // Re-write related object reference
                sObjectType = (sObjectType == 'Event_Sessions__c') ? 'Event_Session__c' : sObjectType;

                apiTransaction.put(sObjectType, apiTransactionSobjectId);
                apiTransaction.Request_URL_Long_Text__c = endpoint;
                apiTransaction.Request_Body__c = jsonString;
                apiTransaction.Response_Body__c = result;
                apiTransaction.Response_Code__c = String.valueOf(((GenericEnvelope)JSON.deserialize(result, GenericEnvelope.class)).status);
                apiTransactions.add(apiTransaction);

                return result;
                
            }else{
                
                return null;
                
            }
            
        }
                        
        public String HttpDelete(String externalId, Id apiTransactionSobjectId){

            HttpRequest req = new HttpRequest();

            String endpoint = baseUrl + '/v2/events/' + this.eventId + '/' + this.resourceType + externalId;

            System.debug('HttpDelete: ' + endpoint);
            
            req.setEndPoint(endpoint);
            req.setTimeout(120000);
            req.setMethod('DELETE');
            req.setHeader('X-API-Key', apiKey);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('DELETE_CONFIRMATION', 'TRUE');
            
            Http http = new Http();
            
            HttpResponse res = http.send(req);

            String result = res.getBody();

            String sObjectType = apiTransactionSobjectId.getSObjectType().getDescribe().getName();

            API_Transaction__c apiTransaction = new API_Transaction__c();

            // Re-write related object reference
            sObjectType = (sObjectType == 'Event_Sessions__c') ? 'Event_Session__c' : sObjectType;
            
            apiTransaction.put(sObjectType, apiTransactionSobjectId);
            apiTransaction.Request_URL_Long_Text__c = endpoint;
            apiTransaction.Response_Body__c = result;
            apiTransaction.Response_Code__c = String.valueOf(((GenericEnvelope)JSON.deserialize(result, GenericEnvelope.class)).status);
            apiTransactions.add(apiTransaction);

            return result;
            
        }
        
        public Model(){

            this.baseUrl 	= Remote_Sites__c.getAll().get('EventMobi').Site_URL__c;
            this.apiKey 	= EventMobi_Configuration__c.getAll().get('X-API-KEY').Value__c;
            this.eventId 	= EventMobi_Configuration__c.getAll().get('EVENT-ID').Value__c;
            
        }
                
    }
    
    public class Error{
        public String code 		{ get; set; }
        public String message 	{ get; set; }
    }
    
    public abstract class ResponseEnvelope{
        public String type 			{ get; set; }		
        public Integer status 		{ get; set; }
        public List<Error> errors 	{ get; set; }
    }

    public class GenericEnvelope extends ResponseEnvelope{}

    public class PeopleGroupResponseEnvelope extends ResponseEnvelope{
        public PeopleGroup data 		{ get; set; }
    }
    
    public class PeopleGroupsResponseEnvelope extends ResponseEnvelope{
        public List<PeopleGroup> data 		{ get; set; }
    }
 
    public class SessionRoleResponseEnvelope extends ResponseEnvelope{       
        public SessionRole data 	{ get; set; }         
    } 
    
    public class SessionRolesResponseEnvelope extends ResponseEnvelope{       
        public List<SessionRole> data 	{ get; set; }         
    }    
    
    public class PersonDetailResponseEnvelope extends ResponseEnvelope{
        public PeopleResponse data 	{ get; set; }
    }

    public class PeopleResponseEnvelope extends ResponseEnvelope{
        public List<PeopleResponse> data 	{ get; set; }
    }

    public class SessionDetailResponseEnvelope extends ResponseEnvelope{       
        public SessionResponse data { get; set; }         
    }
    
    public class SessionsResponseEnvelope extends ResponseEnvelope{       
        public List<SessionResponse> data { get; set; }         
    }
    
    public class TrackDetailResponseEnvelope extends ResponseEnvelope{       
        public Track data { get; set; }         
    }
    
    public class TracksResponseEnvelope extends ResponseEnvelope{       
        public List<Track> data { get; set; }         
    }
            
    public class Track extends Model{
        
        public String id 		{ get; set; }
        public String name 		{ get; set; }
        public String color 	{ get; set; }
        public String event_id 	{ get; set; }
        
        public Track(Event_Session_Track__c eventSessionTrack){
            this.id = eventSessionTrack.Id;
            this.name = (eventSessionTrack.Name != null && eventSessionTrack.Name.length() > 64) ? eventSessionTrack.Name.substring(0, 64) : eventSessionTrack.Name;
            this.color = '007EAC';
            this.event_id = this.eventId;
        }

        public Track(Event__c event){
            this.id = event.Id;
            this.name = (event.Title__c != null && event.Title__c.length() > 64) ? event.Title__c.substring(0, 64) : event.Title__c;
            this.color = 'F4B519';
            this.event_id = this.eventId;
        }
        
        public override ResponseEnvelope add(Id external_id, Boolean removeDependencies){ return null; }
        public override ResponseEnvelope put(Id external_id, Boolean removeDependencies){ return null; }
        public override ResponseEnvelope del(SObject del_record){ return null; }
        public override ResponseEnvelope del(Id del_record){ return null; }
        
    }
    
    public class PeopleGroup extends Model{
        
        public String id 				 	{ get; set; }
        public String name 				 	{ get; set; }
        public String type					{ get; set; }
        public String event_id				{ get; set; }
        public List<String> people_ids   	{ get; set; }
        
        public PeopleGroup(){
            
            this.resourceType = 'people/groups/';
            
            PeopleGroupsResponseEnvelope envelope = (PeopleGroupsResponseEnvelope)this.getCollection();
            
            this.idByNameMap = new Map<String, String>();
            for(PeopleGroup peopleGroup: envelope.data){
                this.idByNameMap.put(peopleGroup.name, peopleGroup.id);
            }
            
        }
        
        public ResponseEnvelope getCollection(){
            
            String jsonString = super.HttpGet();
            
            return (PeopleGroupsResponseEnvelope)JSON.deserialize(jsonString, PeopleGroupsResponseEnvelope.class);    
            
        }
        
        public override ResponseEnvelope add(Id external_id, Boolean removeDependencies){ return null; }                   
        public override ResponseEnvelope put(Id external_id, Boolean removeDependencies){ return null; }            
        public override ResponseEnvelope del(SObject del_record){ return null; } 
        public override ResponseEnvelope del(Id del_record){ return null; }   
        
    }
    
    public class SessionRole extends Model{
        
        public String id 				 	{ get; set; }
        public String name 				 	{ get; set; }
        public String type					{ get; set; }
        public String event_id				{ get; set; }
        
        //To be in used in context of the PeopleRequest object session_roles property
        public List<String> session_ids   	{ get; set; }
        
        //To be in used in context of the SessionRequest object roles property
        public List<String> people_ids   	{ get; set; }
        
        public SessionRole(){
            
            this.resourceType = 'sessions/roles/';
            
            SessionRolesResponseEnvelope envelope = (SessionRolesResponseEnvelope)this.getCollection();
            
            this.idByNameMap = new Map<String, String>();
            for(SessionRole sessionRole: envelope.data){
                this.idByNameMap.put(sessionRole.name, sessionRole.id);
            }
            
        }
        
        public ResponseEnvelope getCollection(){
            
            String jsonString = super.HttpGet();
            
            return (SessionRolesResponseEnvelope)JSON.deserialize(jsonString, SessionRolesResponseEnvelope.class);    
            
        }
        
        public override ResponseEnvelope add(Id external_id, Boolean removeDependencies){ return null; }                   
        public override ResponseEnvelope put(Id external_id, Boolean removeDependencies){ return null; }            
        public override ResponseEnvelope del(SObject del_record){ return null; }  
        public override ResponseEnvelope del(Id del_record){ return null; }
        
    }
            
    public class PersonRequest{
        
        public String id 							{ get; set; }
        public String first_name 					{ get; set; }
        public String last_name 					{ get; set; }
        public String email 						{ get; set; }
        public String company 						{ get; set; }
        public String title							{ get; set; }
        public String about 						{ get; set; }              
        public String upload_image_url 				{ get; set; }
        public Map<String, String> custom_fields	{ get; set; }
        public List<String> group_ids 				{ get; set; } 
        public List<SessionRole> session_roles  	{ get; set; }  
        
        public PersonRequest(Event_Speaker__c eventSessionSpeaker){
            
            this.id 			    = eventSessionSpeaker.Id;
            this.first_name 	    = eventSessionSpeaker.First_Name__c;	
            this.last_name 		    = eventSessionSpeaker.Last_Name__c;

            // Append '.speaker' to email address to prevent duplicate emails for speakers
            this.email 			    = eventSessionSpeaker.Email__c + '.speaker';
            
            this.company 		    = eventSessionSpeaker.Organization__c;
            this.about 			    = eventSessionSpeaker.Bio__c; 
            this.title			    = eventSessionSpeaker.Title__c;
            this.upload_image_url   = eventSessionSpeaker.Photo__c;

            this.custom_fields	    = new Map<String, String>();
            this.group_ids		    = new List<String>();
            this.session_roles 	    = new List<SessionRole>();

            PeopleGroup peopleGroup = new PeopleGroup();
            
            // Get Grenadine Group (Speakers) Id 
            String peopleGroupSpeakersId = peopleGroup.idByNameMap.get('Speakers');

            // Add People Group to People assignment
            this.group_ids.add(peopleGroupSpeakersId);
            
            // Create SessionRole definition 
            SessionRole speaker = new SessionRole();
			speaker.id = speaker.idByNameMap.get('Speaker'); 
            speaker.name = 'Speaker';
            speaker.type = 'speaker';
            speaker.event_id = speaker.eventId;
            speaker.session_ids = new List<String>();
            speaker.people_ids = new List<String>();
            for(Event_Speaker_Session_Track__c esst: eventSessionSpeaker.Event_Speaker_Session_Tracks__r){
                if(esst.Event_Session__c != null){
                	speaker.session_ids.add(esst.Event_Session__c);
                }
            }

            // Add session assignments
            this.session_roles.add(speaker);    

        }
        
        public PersonRequest(Event_Registration__c eventRegistration){
            
            this.id 			= eventRegistration.Contact__c;
            this.company 		= eventRegistration.RPT_Company__c;
            this.about 			= eventRegistration.Professional_Designations__c;
            this.first_name 	= eventRegistration.Contact__r.FirstName;	
            this.last_name 		= eventRegistration.Contact__r.LastName;	
            this.email 			= eventRegistration.Contact__r.Email;	
            this.title			= eventRegistration.Contact__r.Title;                 
            
            this.custom_fields	= new Map<String, String>();
            this.group_ids		= new List<String>();
            this.session_roles 	= new List<SessionRole>();

            PeopleGroup peopleGroup = new PeopleGroup();
            
            // Get Grenadine Group (Attendee) Id 
            String peopleGroupAttendeesGroupId = peopleGroup.idByNameMap.get('Attendees');

            // Put attendees in Grenadine Groups
            this.group_ids.add(peopleGroupAttendeesGroupId);

            // Get Convention Event Ids
            Set<Id> eventIds = new Set<Id>();
            for(String eventId: Label.CurrentConventionIds.split('\n')){
                eventIds.add(eventId.trim());
            }
        
            // Add Event Id
            eventIds.add(eventRegistration.Event__c);

            // Get all registered for events attendee to Grenadine Groups
            for(Event_Registration__c er: [
                SELECT Id, Event__r.Title__c, Contact__c 
                FROM Event_Registration__c 
                WHERE 
                    Contact__c = :eventRegistration.Contact__c AND 
                    (Status__c = 'Registered and Paid' OR Status__c = 'RSVP Accept') AND 
                    Event__c IN :eventIds
            ]){
                // Grenadine Groupname is the Title of the Event
                String peopleGroupEventGroupId = peopleGroup.idByNameMap.get(er.Event__r.Title__c);

                // Throw exception if the Event Grouping People Group hasn't been configured in EventMobi
                if(peopleGroupEventGroupId == null){
                    throw new Response.ResponseException(
                        null, 404,
                        new List<String>{
                            'People Group \'' + er.Event__r.Title__c + '\' not found.',
                            'Create People Group \'' + er.Event__r.Title__c + '\''
                        }
                    );
                }

                // Add People Group to People assignment
                this.group_ids.add(peopleGroupEventGroupId);
            }

            // Put Contributors in a the corresponding group
            if(eventRegistration.Attendee_Type__c == 'Contributor' && eventRegistration.Registration_Type__c != null){
                
                String contributorType = eventRegistration.Registration_Type__c;

                // Get Grenadine Group (Registration_Type__c) Id 
                String peopleGroupContributorTypeGroupId = peopleGroup.idByNameMap.get(contributorType); 

                // Throw exception if the Contributor People Group hasn't been configured in EventMobi
                if(peopleGroupContributorTypeGroupId == null){
                    throw new Response.ResponseException(
                        null, 404,
                        new List<String>{
                            'People Group \'' + contributorType + '\' not found.',
                            'Create People Group \'' + contributorType + '\''
                        }
                    );
                }   

                // Add People Group to People assignment
                this.group_ids.add(peopleGroupContributorTypeGroupId);

            }
            
            // Put certified attendees in the corresponding group
            if(eventRegistration.Contact__r.KPI_ERP_Certified__c || eventRegistration.Contact__r.KPI_FRM_Certified__c){

                // Get Grenadine Group (FRM/ERP Certified) Id 
                String peopleGroupCertifiedGroupId = peopleGroup.idByNameMap.get('FRM/ERP Certified');    

                // Add People Group to People assignment
                this.group_ids.add(peopleGroupCertifiedGroupId);

            }

            // Create session assignments
            SessionRole attendee = new SessionRole();

            // Get Grenadine Group (Attendee) Id 
			attendee.id = attendee.idByNameMap.get('Attendee'); 
            attendee.name = 'Attendee';
            attendee.type = 'attendee';
            attendee.event_id = attendee.eventId;
            attendee.session_ids = new List<String>();
            attendee.people_ids = new List<String>();
            for(Event_Session_Registration__c esr: eventRegistration.Event_Session_Registrations__r){
                attendee.session_ids.add(esr.Event_Session__c);
            }

            // Add session assignments
            this.session_roles.add(attendee); 
                    
        }
        
    } 
        
    public class PeopleResponse{
        public String id							{ get; set; }//the unique ID of person in people
        public String first_name					{ get; set; }	
        public String last_name						{ get; set; }	
        public String email							{ get; set; }	
        public String company						{ get; set; }	
        public String title							{ get; set; }	
        public String description					{ get; set; }	
        public String created_at					{ get; set; }//The timestamp of record creation in ISO format. (Details)
        public String updated_at					{ get; set; }//The timestamp of last update in ISO format. (Details).
        public String upload_image_url 				{ get; set; }//the full URL of uploaded image. Used as person profile photo. This is read-only and will not update in POST/PATCH.   
        public List<String> group_ids				{ get; set; }//the array of group IDs
        public List<SessionRole> session_roles 		{ get; set; }//the roles for each event
    }
    
    public class SessionRequest{
        
        public String id						{ get; set; }
        public String name						{ get; set; }
        public String start_datetime 			{ get; set; }//ISO Date, “YYYY-MM-DDTHH:MM”. Seconds and timezone can be omitted. System will use event timezone defaultly.
        public String end_datetime				{ get; set; }//ISO Date, “YYYY-MM-DDTHH:MM”. Seconds and timezone can be omitted. System will use event timezone defaultly.
        public String description				{ get; set; }//the html encoded string.
        public String location					{ get; set; }
        public List<String> track_ids 			{ get; set; }//the ID of tracks this session belongs to
        public List<SessionRole> roles			{ get; set; }
        
        //Add additional constructors to map other sObjectTypes if needed
        public SessionRequest(Event_Sessions__c eventSession){
            
            this.id 			= eventSession.Id;
            this.name 			= eventSession.Title__c;    // Per Event team, Title is for display, Name is for backend
            this.start_datetime = (eventSession.Start_Date_Time__c != null) ? eventSession.Start_Date_Time__c.format('YYYY-MM-dd\'T\'HH:mm') : null;
            this.end_datetime 	= (eventSession.End_Date_Time__c != null) ? eventSession.End_Date_Time__c.format('YYYY-MM-dd\'T\'HH:mm') : null;
            this.description 	= eventSession.Description__c;
            this.location 		= eventSession.Location__c;

            // By default add Sessions to the Event Container Tracks
            if(eventSession.Event_Session_Track__c != null){
                this.track_ids = new List<String>{eventSession.Event_Session_Track__c, eventSession.Event__c};
            }else{
                this.track_ids = new List<String>{eventSession.Event__c};
            }

            this.roles 			= new List<SessionRole>();
                   
            // Add all speakers
            SessionRole speaker = new SessionRole();
			speaker.id = speaker.idByNameMap.get('Speaker'); 
            speaker.type = 'speaker';
            speaker.name = 'Speaker';
            speaker.event_id = speaker.eventId;
            speaker.people_ids = new List<String>();
            for(Event_Speaker_Session_Track__c esst: eventSession.Event_Speaker_Session_Tracks__r){
                if(esst.Event_Speaker__c != null){
                	speaker.people_ids.add(esst.Event_Speaker__c);
                }
            }
            this.roles.add(speaker);    
            
            // Add all attendees
            SessionRole attendee = new SessionRole();
			attendee.id = attendee.idByNameMap.get('Attendee'); 
            attendee.type = 'attendee';
            attendee.name = 'Attendee';
            attendee.event_id = attendee.eventId;
            attendee.people_ids = new List<String>();
            
            for(Event_Session_Registration__c esr: eventSession.Event_Session_Registrations__r){
             	attendee.people_ids.add(esr.Event_Registration__r.Contact__c);
            }
            this.roles.add(attendee);
            
        }
        
    }
        
    public class SessionResponse{      
        public String id						{ get; set; }//the unique session id. External ID can be used.
        public String event_id					{ get; set; }
        public String name						{ get; set; }	
        public String description				{ get; set; }
        public String location					{ get; set; }
        public String start_datetime			{ get; set; }//the ISO format of “YYYY-MM-DDTHH:MM:SS±hh:mm”
        public String end_datetime				{ get; set; }//same as start_datetime
        public List<String> track_ids			{ get; set; }//the ID of tracks this session belongs to
        public List<Track> tracks				{ get; set; }//the track Id and names (read-only)
        public String created_at				{ get; set; }//The timestamp of record creation in ISO format. (Details)
        public String updated_at				{ get; set; }//The timestamp of last update in ISO format. (Details)        
    }
    
    // Starting Implementations 
    public class EventSessionTrack extends Model{
        
        public EventSessionTrack(){
        	this.resourceType = 'sessions/tracks/';
        }
       
        public override ResponseEnvelope add(Id external_id, Boolean removeDependencies){
            
            String sObjectType = external_id.getSObjectType().getDescribe().getName();

            Event__c event = null;
            Event_Session_Track__c eventSessionTrack = null;

            if(sObjectType == 'Event__c'){
                event = getEventRecord(external_id);
            }else if(sObjectType == 'Event_Session_Track__c'){
                eventSessionTrack = (Event_Session_Track__c)getRecord(external_id);
            }

            if(event != null){
            
                Track track = new Track(event);
                                
                String jsonString = super.HttpPost(track, external_id);
                          
                return (TrackDetailResponseEnvelope)JSON.deserialize(jsonString, TrackDetailResponseEnvelope.class);
            
            }else if(eventSessionTrack != null){
            
                Track track = new Track(eventSessionTrack);
                                
                String jsonString = super.HttpPost(track, external_id);
                          
                return (TrackDetailResponseEnvelope)JSON.deserialize(jsonString, TrackDetailResponseEnvelope.class);
            
            }
            
            return null;
            
        }
           
        public override ResponseEnvelope put(Id external_id, Boolean removeDependencies){

            String sObjectType = external_id.getSObjectType().getDescribe().getName();

            Event__c event = null;
            Event_Session_Track__c eventSessionTrack = null;

            if(sObjectType == 'Event__c'){
                event = getEventRecord(external_id);
            }else if(sObjectType == 'Event_Session_Track__c'){
                eventSessionTrack = (Event_Session_Track__c)getRecord(external_id);
            }

            if(event != null){
            
                Track track = new Track(event);
                                
                String jsonString = super.HttpPut(external_id, track, external_id);
                          
                return (TrackDetailResponseEnvelope)JSON.deserialize(jsonString, TrackDetailResponseEnvelope.class);
            
            }else if(eventSessionTrack != null){
            
                Track track = new Track(eventSessionTrack);
                
                String jsonString = super.HttpPut(external_id, track, external_id);
                          
				return (TrackDetailResponseEnvelope)JSON.deserialize(jsonString, TrackDetailResponseEnvelope.class);
                
            }
            
            return null;
            
        }
        
        public override ResponseEnvelope del(SObject del_record){ return null; } 
        public override ResponseEnvelope del(Id del_record){ return null; } 
     
        public sObject getRecord(String external_id){
            
            return [
                SELECT Id, Name
                FROM Event_Session_Track__c
                WHERE Id = :external_id
            ];

        }  

        public Event__c getEventRecord(String external_id){
            
            return [
                SELECT Id, Name, Title__c
                FROM Event__c
                WHERE Id = :external_id
            ];

        }  
        
    }
    
    public class EventSpeaker extends Model{
        
        public EventSpeaker(){
            this.resourceType = 'people/resources/';
        }
        
        public override ResponseEnvelope add(Id external_id, Boolean removeDependencies){
            
            Event_Speaker__c eventSpeaker = (Event_Speaker__c)getRecord(external_id);

            if(eventSpeaker != null){
                
                // 01/11/2019 Xiang - PersonRequest for Event_Speaker__c doesn't setup FRM/ERP group as currently no Lookup to Contact
                PersonRequest peopleRequest = new PersonRequest(eventSpeaker);
                
                if(removeDependencies){
                    peopleRequest.session_roles = new List<SessionRole>();
                }
                
                String jsonString = super.HttpPost(peopleRequest, external_id);
                          
                return (PersonDetailResponseEnvelope)JSON.deserialize(jsonString, PersonDetailResponseEnvelope.class);
            
            }
            
            return null;
            
        }
                   
        public override ResponseEnvelope put(Id external_id, Boolean removeDependencies){
            
            Event_Speaker__c eventSpeaker = (Event_Speaker__c)getRecord(external_id);

            if(eventSpeaker != null){
            
                PersonRequest peopleRequest = new PersonRequest(eventSpeaker);
                
                if(removeDependencies){
                    peopleRequest.session_roles = new List<SessionRole>();
                }
                
                String jsonString = super.HttpPut(eventSpeaker.Id, peopleRequest, eventSpeaker.Id);
                
				return (PersonDetailResponseEnvelope)JSON.deserialize(jsonString, PersonDetailResponseEnvelope.class);
                
            }
            
            return null;
            
        }
        
        public override ResponseEnvelope del(SObject del_record){ return null; }  
        public override ResponseEnvelope del(Id del_record){ return null; }
                    
        public sObject getRecord(String external_id){
            
            return [
                SELECT 
                Id,
                First_Name__c,
                Last_Name__c,
                Email__c,
                Organization__c,
                Bio__c,
                Title__c,
                Photo__c,
                (
                    SELECT 
                    Id, 
                    Name,
                    Event_Session_Track__c,
                    Event_Session__c
                    FROM Event_Speaker_Session_Tracks__r
                )
                FROM Event_Speaker__c
                WHERE Id = :external_id
            ];

        }
                
    }
    
    public class EventRegistration extends Model{
        
        public EventRegistration(){
            this.resourceType = 'people/resources/';
        }
        
        public override ResponseEnvelope add(Id external_id, Boolean removeDependencies){
            
            Event_Registration__c eventRegistration = (Event_Registration__c)getRecord(external_id);
            
            PersonRequest peopleRequest = new PersonRequest(eventRegistration);
            
            if(removeDependencies){
                peopleRequest.session_roles = new List<SessionRole>();
            }
            
            String jsonString = super.HttpPost(peopleRequest, external_id);
                        
            return (PersonDetailResponseEnvelope)JSON.deserialize(jsonString, PersonDetailResponseEnvelope.class);
            
        }
                   
        public override ResponseEnvelope put(Id external_id, Boolean removeDependencies){
            
            Event_Registration__c eventRegistration = (Event_Registration__c)getRecord(external_id);
            
            PersonRequest peopleRequest = new PersonRequest(eventRegistration);
            
            if(removeDependencies){
                peopleRequest.session_roles = new List<SessionRole>();
            }
            
            String jsonString = super.HttpPut(eventRegistration.Contact__c, peopleRequest, eventRegistration.Id);
            
            return (PersonDetailResponseEnvelope)JSON.deserialize(jsonString, PersonDetailResponseEnvelope.class);
            
        }
        
        public override ResponseEnvelope del(SObject del_record){ return null; }
        
        // For deleting User Registration when Registration status no longer Registered and Paid
        public override ResponseEnvelope del(Id external_id) {
            Event_Registration__c eventRegistration = (Event_Registration__c)getRecord(external_id);
            
            if(eventRegistration != null && eventRegistration.Registration_Type__c != 'Speaker') {
                String jsonString = super.HttpDelete(eventRegistration.Contact__c, eventRegistration.Id);
                
				return (PersonDetailResponseEnvelope)JSON.deserialize(jsonString, PersonDetailResponseEnvelope.class);
            }
            
            return null;
        } 
                    
        public sObject getRecord(String external_id){

            return [
                SELECT 
                Id,
                User__r.FirstName,
                User__r.LastName,
                User__r.Email,
                User__r.Title,
                Contact__r.FirstName,
                Contact__r.LastName,
                Contact__r.Email,
                Contact__r.Title,
                Contact__r.KPI_ERP_Certified__c,
                Contact__r.KPI_FRM_Certified__c,
                RPT_Company__c,
                Professional_Designations__c,
                Attendee_Type__c,
                Registration_Type__c, //Contributor Type
                Event__c,
                (SELECT Id, Event_Session__c, Event_Registration__c, Event_Registration__r.Contact__c FROM Event_Session_Registrations__r)
                FROM Event_Registration__c
                WHERE Id = :external_id
            ];

        }
                
    }
    
    public class EventSession extends Model{
        
        public EventSession(){
            this.resourceType = 'sessions/resources/';
        }
        
        public override ResponseEnvelope add(Id external_id, Boolean removeDependencies){
            
            Event_Sessions__c eventSession = (Event_Sessions__c)getRecord(external_id);

            if(eventSession != null){
            
                SessionRequest sessionRequest = new SessionRequest(eventSession);
                
                if(removeDependencies){
                    sessionRequest.track_ids = new List<String>();
                    sessionRequest.roles = new List<SessionRole>();
                }
                
                String jsonString = super.HttpPost(sessionRequest, external_id);
                          
                return (SessionDetailResponseEnvelope)JSON.deserialize(jsonString, SessionDetailResponseEnvelope.class);
            
            }
            
            return null;
            
        }
            
        public override ResponseEnvelope put(Id external_id, Boolean removeDependencies){
            
            Event_Sessions__c eventSession = (Event_Sessions__c)getRecord(external_id);

            if(eventSession != null){
            
                SessionRequest sessionRequest = new SessionRequest(eventSession);
                
                if(removeDependencies){
                    sessionRequest.track_ids = new List<String>();
                    sessionRequest.roles = new List<SessionRole>();
                }
                
                String jsonString = super.HttpPut(eventSession.Id, sessionRequest, eventSession.Id);
                
				return (SessionDetailResponseEnvelope)JSON.deserialize(jsonString, SessionDetailResponseEnvelope.class);
            
            }
            
            return null;
            
        }
        
        public override ResponseEnvelope del(SObject del_record){ return null; }  
        public override ResponseEnvelope del(Id external_id){ return null; }

        public sObject getRecord(String external_id){
            
            return [
                SELECT 
                Id, 
                Name, 
                Title__c,
                Event_Session_Track__c, 
                Availability__c,
                Certified_Only__c,
                Description__c,
                End_Date_Time__c,
                Event__c,
                Event__r.Name,
                Group_Name__c,
                Last_Updated_Date__c,
                Location__c,
                Published_Date__c,
                Session_Type__c,
                Show_On_Summary_Schedule__c,
                Start_Date_Time__c,
                Status__c,
                Subtitle__c,
                Type__c,
				(
                    SELECT 
                    Id,
					Event_Registration__c,
                    Event_Registration__r.Contact__c
                    FROM Event_Session_Registrations__r
                    WHERE 
                        (
                            Event_Registration__r.Status__c = 'RSVP Accept' OR 
                            Event_Registration__r.Status__c = 'Registered and Paid'
                        ) AND 
                        Event_Registration__r.Registration_Type__c != 'Speaker'
                ),
                (
                    SELECT 
                    Id, 
                    Name,
                    Event_Session_Track__c,
                    Event_Speaker__c
                    FROM Event_Speaker_Session_Tracks__r
                )
                FROM Event_Sessions__c
                WHERE Id = :external_id
                LIMIT 1
            ];
            
        }
                
    }
    
    // US-17044. For adding / removing attendee Person from Event Session.
    public class PersonToSessionReq {

        public List<String> people_ids { get; set; }
        
        public PersonToSessionReq(Event_Session_Registration__c eventSessionRegistration) {
            List<String> peopleIds = new List<String>();
            peopleIds.add(eventSessionRegistration.Event_Registration__r.Contact__c);
            this.people_ids = peopleIds;
        }

    }
    
    public class PersonToSessionResp extends ResponseEnvelope {
        public PersonToSessionData data { get; set; }
    }
    
    public class PersonToSessionData {
        public String event_id { get; set; }
        public String session_id { get; set; }
        public String role_id { get; set; }
        public List<String> people_ids { get; set; }
    }
    
    // US-17044. Use Event_Session_Registration__c to handle attendees only.
    public class EventSessionRegistration extends Model {
        
        public EventSessionRegistration() {
            this.resourceType = 'sessions/resources/';
        }

        public String getPersonSessionEndpoint(Event_Session_Registration__c eventSessionRegistration) {

            Id eventSessionId = eventSessionRegistration.Event_Session__c;
            
            SessionRole attendeeSessionRole = new SessionRole();

			String attendeeSessionRoleId = attendeeSessionRole.idByNameMap.get('Attendee');
            
            String endpoint = eventSessionId + '/roles/' + attendeeSessionRoleId + '/people/';

            return endpoint;

        }
        
        // Entry Point: EventSessionRegistration trigger upon insert
        public override ResponseEnvelope add(Id external_id, Boolean removeDependencies) {

            Event_Session_Registration__c eventSessionRegistration = (Event_Session_Registration__c)getRecord(external_id);

            if(eventSessionRegistration != null) {

                String endpoint = getPersonSessionEndpoint(eventSessionRegistration);

                this.resourceType += endpoint;
                
                PersonToSessionReq personSessReq = new PersonToSessionReq(eventSessionRegistration);
                
                // API Transaction is Associated with the parent Event Registration
                String jsonString = super.HttpPost(personSessReq, eventSessionRegistration.Event_Registration__c);
                          
                return (PersonToSessionResp)JSON.deserialize(jsonString, PersonToSessionResp.class);
            }
            
            return null;
        }
        
        public override ResponseEnvelope del(sObject eventSessionRegistrationSobject) {

            if(eventSessionRegistrationSobject != null) {

                Event_Session_Registration__c eventSessionRegistration = (Event_Session_Registration__c)eventSessionRegistrationSobject;
                
                String endpoint = getPersonSessionEndpoint((Event_Session_Registration__c)eventSessionRegistration);

                this.resourceType = 'sessions/resources/' + endpoint;
                
                // API Transaction is Associated with the parent Event Registration
                String jsonString = super.HttpDelete(eventSessionRegistration.Event_Registration__r.Contact__c, eventSessionRegistration.Event_Registration__c);

				return (PersonToSessionResp)JSON.deserialize(jsonString, PersonToSessionResp.class);

            }
            
            return null;

        }

        public override ResponseEnvelope put(Id external_id, Boolean removeDependencies) { return null; }
        public override ResponseEnvelope del(Id external_id) { return null; }
        
        public sObject getRecord(String external_id) {
            List<Event_Session_Registration__c> eventSessionRegistrations = [
                SELECT Id, Event_Session__c, Event_Registration__c, Event_Registration__r.Contact__c
                FROM Event_Session_Registration__c 
                WHERE Id = :external_id AND (Event_Registration__r.Status__c = 'Registered and Paid' OR Event_Registration__r.Status__c = 'RSVP Accept')
            ];
            if(!eventSessionRegistrations.isEmpty()){
                return eventSessionRegistrations[0];
            }else{
                return null;
            }
        }
    }
    
}