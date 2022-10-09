global virtual class EventRESTService {
    
    public static RestRequest req;
    public static RestResponse res;
    public static ErrorEnvelope error;
    public static Map<String, String> params;
    
    public EventRESTService(){
        res.addHeader('Content-Type', 'application/json');
    }
    
    global abstract class Envelope{
        public String url 						{ get; set; }
        public Integer status 					{ get; set; }
        public Map<String, String> parameters	{ get; set; }
    }
    
    public class PicklistEntryEnvelope extends Envelope{
        public Integer count					{ get; set; }
        public List<Schema.PicklistEntry> data  { get; set; }
    }
    
    public class ErrorEnvelope extends Envelope{
        public List<String> errors 				{ get; set; }
    }
    
    public class AttendeeDetailEnvelope extends Envelope{
        public AttendeeDetail data 				{ get; set; }     
    }
    
    public class AttendeeCollectionEnvelope extends Envelope{
        public Integer count 					{ get; set; }
        public List<AttendeeCollection> data 	{ get; set; }
    }
    
    public class AttendeeDetailCollectionEnvelope extends Envelope{
        public Integer count					{ get; set; }
        public List<AttendeeDetail> data 		{ get; set; }
    }
    
    public class AttendeeCollection{
        
        public String event_id					{ get; set; }
        public String event_name				{ get; set; }        
        public String event_registration_id 	{ get; set; }
        
        public String attendee_id				{ get; set; }
        public String contact_id				{ get; set; }
        public String email						{ get; set; }
        public String url						{ get; set; }
        
        public String created_date_time			{ get; set; }
        public String last_modified_date_time	{ get; set; }
        
        public AttendeeCollection(Event_Registration__c eventRegistration){
            
            this.event_id				= eventRegistration.Event__c;
            this.event_name				= eventRegistration.Event__r.Name;
            this.event_registration_id  = eventRegistration.Id;
            this.attendee_id 			= eventRegistration.Registration_ID__c;
            
            if(eventRegistration.User__c != null && eventRegistration.Contact__c == null){
                this.email			= eventRegistration.User__r.Email;
                this.contact_id		= eventRegistration.User__c;            
            }else{
                this.email			= eventRegistration.Contact__r.Email;
                this.contact_id		= eventRegistration.Contact__c;                
            }
            
            this.url 					= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + '/services/apexrest/event/' + event_id + '/attendee/' + attendee_id;
                       
            this.created_date_time		 	= eventRegistration.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss');
            this.last_modified_date_time 	= eventRegistration.LastModifiedDate.format('yyyy-MM-dd\'T\'HH:mm:ss');
            
        }
        
    }
    
    public class AttendeeDetail{
        
        public String event_id							{ get; set; }
        public String event_name						{ get; set; }      
        public String event_registration_id 			{ get; set; }
        
        public String attendee_id						{ get; set; }
        public String contact_id						{ get; set; }
        
        public Boolean monday_attendee                  { get; set; }
        public Boolean frm_certified					{ get; set; }
        public Boolean erp_certified					{ get; set; }
        public Boolean chapter_director					{ get; set; }
        public Boolean garp_committee_member			{ get; set; }
        public Boolean garp_board_member				{ get; set; }
        
        public String address							{ get; set; }
        public String city								{ get; set; }
        public String state								{ get; set; }
        public String country							{ get; set; }
        public String postal_code						{ get; set; }
        public String phone								{ get; set; }
        public String email								{ get; set; }
        public String company							{ get; set; }
        public String title								{ get; set; }
        public String first_name						{ get; set; }
        public String last_name							{ get; set; }
        public String registration_status 				{ get; set; }
        public String registration_type					{ get; set; }  
        public String contributor_type					{ get; set; }
        public String attendee_type						{ get; set; }
        public String participant_type					{ get; set; }
        public String membership_type					{ get; set; }
        public String dietary_restriction_description 	{ get; set; }  
        public String special_requirements				{ get; set; }
        public String comp_type							{ get; set; }
        public String comped_guest_type					{ get; set; }
        public String additional_contributor_type		{ get; set; }
        
        public Boolean paid								{ get; set; }
        public Boolean convention_alumni				{ get; set; }
        public Boolean checked_in						{ get; set; }
        public Boolean dietary_restriction				{ get; set; }
        
        public String created_date_time					{ get; set; }
        public String last_modified_date_time			{ get; set; }
        
        public List<String> dietary_restrictions 		{ get; set; }
        public List<String> designations 				{ get; set; }
        
        public AttendeeDetail(Event_Registration__c eventRegistration){
            
            this.event_id							= eventRegistration.Event__c;
            this.event_name							= eventRegistration.Event__r.Name;
            this.event_registration_id  			= eventRegistration.Id;
            this.attendee_id 						= eventRegistration.Registration_ID__c;
            this.monday_attendee                    = eventRegistration.Monday_Attendee__c;
            
            if(eventRegistration.User__c != null && eventRegistration.Contact__c == null){
              
                this.contact_id							= eventRegistration.User__c;    
                this.address							= eventRegistration.User__r.Street;	
                this.city								= eventRegistration.User__r.City;		
                this.state								= eventRegistration.User__r.State;
                this.country							= eventRegistration.User__r.Country;
                this.postal_code                        = eventRegistration.User__r.PostalCode;
                this.phone                              = eventRegistration.User__r.Phone;
                this.email								= eventRegistration.User__r.Email;			
                this.company							= eventRegistration.User__r.CompanyName;		 
                this.title								= eventRegistration.User__r.Title;			
                this.first_name							= eventRegistration.User__r.FirstName;	
                this.last_name							= eventRegistration.User__r.LastName;
                this.membership_type					= null;
                this.frm_certified						= false;
                this.erp_certified						= false;
                this.chapter_director 					= false;
                this.garp_committee_member 				= false;
                this.garp_board_member 					= false;              
                
            }else{
            
                this.contact_id							= eventRegistration.Contact__c;       
                this.address							= eventRegistration.Contact__r.MailingStreet;	
                this.city								= eventRegistration.Contact__r.MailingCity;		
                this.state								= eventRegistration.Contact__r.MailingState;
                this.country							= eventRegistration.Contact__r.MailingCountry;
                this.postal_code                        = eventRegistration.Contact__r.MailingPostalCode;
                
                if(eventRegistration.Contact__r.Phone != null) this.phone = eventRegistration.Contact__r.Phone;
                if(eventRegistration.Contact__r.HomePhone != null) this.phone = eventRegistration.Contact__r.HomePhone;
                if(eventRegistration.Contact__r.MobilePhone != null) this.phone = eventRegistration.Contact__r.MobilePhone;

                this.email								= eventRegistration.Contact__r.Email;			
                this.company							= eventRegistration.Contact__r.Company__c;		 
                this.title								= eventRegistration.Contact__r.Title;			
                this.first_name							= eventRegistration.Contact__r.FirstName;	
                this.last_name							= eventRegistration.Contact__r.LastName;
                this.membership_type					= eventRegistration.Contact__r.Membership_Type__c;
                this.frm_certified						= eventRegistration.Contact__r.KPI_FRM_Certified__c;
                this.erp_certified						= eventRegistration.Contact__r.KPI_ERP_Certified__c;
                this.chapter_director 					= eventRegistration.Contact__r.KPI_Chapter_Director__c;
                this.garp_committee_member 				= eventRegistration.Contact__r.KPI_GARP_Committee_Member__c;
                this.garp_board_member 					= eventRegistration.Contact__r.KPI_GARP_Board_Member__c;
                
            }
            
            if(eventRegistration.Opportunity__r != null){
            	this.convention_alumni					= eventRegistration.Opportunity__r.Convention_Alumni__c;
            }
            
            this.comp_type							= eventRegistration.Comp_Type__c;
            this.comped_guest_type					= eventRegistration.Comped_Guest_Type__c;
            this.additional_contributor_type		= eventRegistration.Additional_Contributor_Type__c;
            
            this.attendee_type	 					= eventRegistration.Attendee_Type__c;
            this.contributor_type					= eventRegistration.Registration_Type__c;	
            this.participant_type  					= eventRegistration.Participants__c;
            
            if(this.attendee_type == 'Participant'){
            	this.registration_type = this.attendee_type + ' - ' + this.participant_type;
            }else if(this.attendee_type == 'Contributor'){
                this.registration_type = this.attendee_type + ' - ' + this.contributor_type;
            }
            
            this.checked_in							= (eventRegistration.Status__c == 'Attended') ? true : false;
            this.paid								= (eventRegistration.Status__c == 'Registered and Paid' || eventRegistration.Status__c == 'Attended') ? true : false;
            this.registration_status				= eventRegistration.Status__c; 		
            
            this.designations						= new List<String>();

			this.special_requirements				= eventRegistration.Special_Requirements__c;           
            this.dietary_restriction				= eventRegistration.Dietary_Restriction__c;
            this.dietary_restrictions				= new List<String>();
            this.dietary_restriction_description 	= eventRegistration.Dietary_Restriction_Description__c;
            
            this.created_date_time					= eventRegistration.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss');
            this.last_modified_date_time			= eventRegistration.LastModifiedDate.format('yyyy-MM-dd\'T\'HH:mm:ss');     
            
            if(eventRegistration.Dietary_Restriction_Types__c != null){
                List<String> dietaryRestrictions = eventRegistration.Dietary_Restriction_Types__c.split(';');
                this.dietary_restrictions.addAll(dietaryRestrictions);
            }
            
            if(eventRegistration.Professional_Designations__c != null){
                List<String> professionalDesignations = eventRegistration.Professional_Designations__c.split(';');
                this.designations.addAll(professionalDesignations);
            }        
            
        }
        
    }
    
    public static String getDetailQueryFieldsString(){
        
        List<String> fields =  new List<String>{
            'Id',
            'Status__c',
            'Monday_Attendee__c',
            'Professional_Designations__c',
            'Registration_Type__c',
        	'Attendee_Type__c',
        	'Participants__c',
            'Dietary_Restriction__c',
            'Dietary_Restriction_Types__c',
            'Dietary_Restriction_Description__c',
            'CreatedDate',
            'LastModifiedDate',
        	'Special_Requirements__c',
            'Event__c',
            'Event__r.Name',
        	'Registration_ID__c',
        	'Registration_Auto_ID__c',
            'Comp_Type__c',
            'Comped_Guest_Type__c',
            'Additional_Contributor_Type__c',
        	'User__c',
        	'User__r.FirstName',
        	'User__r.LastName',
        	'User__r.Email',
        	'User__r.Phone',
            'User__r.Title',
            'User__r.CompanyName',
            'User__r.Street',
            'User__r.City',
           	'User__r.State',
        	'User__r.Country',
        	'User__r.PostalCode',
            'Contact__c',
        	'Contact__r.KPI_Chapter_Director__c',
        	'Contact__r.KPI_GARP_Committee_Member__c',
        	'Contact__r.KPI_GARP_Board_Member__c',
            'Contact__r.GARP_Member_ID__c',
            'Contact__r.FirstName',
            'Contact__r.LastName',
            'Contact__r.KPI_FRM_Certified__c',
            'Contact__r.KPI_ERP_Certified__c',
            'Contact__r.Title',
            'Contact__r.Company__c',
            'Contact__r.Email',
            'Contact__r.Phone',
            'Contact__r.HomePhone',
            'Contact__r.MobilePhone',
            'Contact__r.OtherPhone',
            'Contact__r.MailingStreet',
            'Contact__r.MailingCity',
            'Contact__r.MailingState',
        	'Contact__r.MailingCountry',
        	'Contact__r.MailingPostalCode',
        	'Contact__r.Membership_Type__c',
        	'Opportunity__r.Convention_Alumni__c'
        };
        
        return String.join(fields,',');
        
    }
    
    public static String getCollectionQueryFieldsString(){
        
        List<String> fields =  new List<String>{
            'CreatedDate',
            'LastModifiedDate',
            'Event__c',
            'Event__r.Name',
            'Contact__c',
            'Contact__r.GARP_Member_ID__c',
            'Contact__r.Email',
        	'Registration_ID__c',
        	'Registration_Auto_ID__c',
        	'User__c',
        	'User__r.Email'
        };
        
        return String.join(fields,',');
        
    }

    public static Datetime convertStringToDatetime(String datetimeString){
        
        System.debug(datetimeString);
         
        List<String> dateTimeArray = datetimeString.split('T');
        
        List<String> dateArray = dateTimeArray[0].split('-');
        
        List<String> timeArray = dateTimeArray[1].split(':');
        
        timeArray[2] = timeArray[2].split('\\.')[0];
        
        Date d = Date.newInstance(Integer.valueOf(dateArray[0]), Integer.valueOf(dateArray[1]), Integer.valueOf(dateArray[2]));
        
        Time t = Time.newInstance(Integer.valueOf(timeArray[0]), Integer.valueOf(timeArray[1]), Integer.valueOf(timeArray[2]), 00);
        
        Datetime dt = Datetime.newInstance(d, t);
        
        System.debug(dt);
        
        return dt;
        
    }
    
    public static Boolean isAuthenticated(Map<String, String> headers){
        
        String apiKey = EventExecutives_Configuration__c.getAll().get('X-API-KEY').Value__c; 
        
        if(!headers.containsKey('X-API-KEY')){
            
            error = new ErrorEnvelope();
            
            error.url 			= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            error.status 		= 401;
            error.errors 		= new List<String>{'Please include API authorization key in header.'};
                
                return false;
            
        }else if(headers.get('X-API-KEY') != apiKey){
            
            error = new ErrorEnvelope();
            
            error.url 			= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            error.status 		= 403;
            error.errors 		= new List<String>{'The API key is invalid.'};
                
                return false;
            
        }
        
        return true;
        
    }
    
    public static Boolean registrationEndpointIsValid(String registrationPicklistType){
        
        if(registrationPicklistType == null){
            
            error = new ErrorEnvelope();
            
            error.parameters 	= params;
            error.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            error.status 		= 400;
            error.errors 		= new List<String>{'You must supply a registration resource parameter.'};
                
            return false;   
            
        }

        return true;
        
    }
    
    public static Boolean eventIdIsValid(String eventId){
        
        if(eventId == null){
            
            error = new ErrorEnvelope();
            
            error.parameters 	= params;
            error.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            error.status 		= 400;
            error.errors 		= new List<String>{'You must supply an Event ID.'};
                
            return false;
            
        } 
        
        List<Event__c> events = [
            SELECT Id, Name 
            FROM Event__c 
            WHERE Id = :eventId 
            LIMIT 1
        ];
        
        if(events.isEmpty()){
            
            error = new ErrorEnvelope();
            
            error.parameters 	= params;
            error.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            error.status 		= 404;
            error.errors 		= new List<String>{'Event resource with ID ' + params.get('event') + ' does not exist.'};
                
                return false;
            
        }        
        
        return true;
    }
    
    public static Boolean attendeeIdIsValid(String attendeeId, String eventId){
        
        if(attendeeId == null){
            
            error = new ErrorEnvelope();
            
            error.parameters 	= params;
            error.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            error.status 		= 400;
            error.errors 		= new List<String>{'You must supply an Attendee ID (GARP Member ID).'};
                
                return false;
            
        }
        
        List<Event_Registration__c> eventRegistrations = [
            SELECT Event__c, Registration_ID__c
            FROM Event_Registration__c 
            WHERE Registration_ID__c != null AND Registration_ID__c = :attendeeId AND Event__c = :eventId
            LIMIT 1
        ];
        
        if(eventRegistrations.isEmpty()){
            
            error = new ErrorEnvelope();
            
            error.parameters 	= params;
            error.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            error.status 		= 404;
            error.errors 		= new List<String>{'Attendee resource with ID (GARP Member ID) ' + params.get('attendee') + ' does not exist.'};
                
                return false;             
            
        }
        
        return true;
        
    }
    
    public static Boolean attendedParameterIsValid(String attended){
        
        if(attended == null || (attended != 'true' && attended != 'false')){
            
            error = new ErrorEnvelope();
            
            error.parameters 	= params;
            error.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            error.status 		= 400;
            error.errors 		= new List<String>{'You are missing the \'attended=true/false\' URL parameter.'};
                
                return false;    
            
        }
        
        return true;
        
    }
    
    public static Envelope getInvalidRoute(){
        
        error = new ErrorEnvelope();
        
        error.parameters 	= params;
        error.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
       	error.status 		= 404;
        error.errors 		= new List<String>{'Invalid route.'};
            
        return error;    
        
    }
    
    public static Map<String, String> parameterMap(String uri){
        
        List<String> uriElements = uri.substring(1).split('/');
        
        Map<String, String> uriParameters = new Map<String, String>();
        for(Integer i = 0; i < uriElements.size(); i++){
            if(Math.mod(i, 2) == 0){
                uriParameters.put(uriElements[i], (i + 1 >= uriElements.size()) ? null : uriElements[i + 1]);
            }
        }
        
        return uriParameters;
        
    }
    
    public static Envelope getAttendees(String eventId){
        
        AttendeeCollectionEnvelope attendeeCollectionEnvelope = new AttendeeCollectionEnvelope();

        String queryString = String.join(new List<String>{
            'SELECT',
            getCollectionQueryFieldsString(),
            'FROM', 
            'Event_Registration__c',
            'WHERE',
            'Registration_ID__c != null',
            'AND', 
            'Event__c = :eventId'
        }, ' ');

        List<Event_Registration__c> eventRegistrations = Database.query(queryString);
        
        attendeeCollectionEnvelope.url 		  = 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
        attendeeCollectionEnvelope.parameters = params;
        attendeeCollectionEnvelope.status	  = 200;
        attendeeCollectionEnvelope.count	  = eventRegistrations.size();
        
        attendeeCollectionEnvelope.data = new List<AttendeeCollection>();        
        if(!eventRegistrations.isEmpty()){
            for(Event_Registration__c eventRegistration: eventRegistrations){
                attendeeCollectionEnvelope.data.add(new AttendeeCollection(eventRegistration));
            }
        }
        
        return attendeeCollectionEnvelope;
        
    }
    
    public static Envelope getAttendeesDetail(String eventId){
        
        AttendeeDetailCollectionEnvelope attendeeDetailCollectionEnvelope = new AttendeeDetailCollectionEnvelope();
        
        String queryString = String.join(new List<String>{
            'SELECT',
            getDetailQueryFieldsString(),
            'FROM',
            'Event_Registration__c',
            'WHERE',
            'Event__c = :eventId'
        }, ' ');
        
        List<Event_Registration__c> eventRegistrations = Database.query(queryString);
        
        attendeeDetailCollectionEnvelope.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
        attendeeDetailCollectionEnvelope.parameters 	= params;
        attendeeDetailCollectionEnvelope.status	  	    = 200;
        attendeeDetailCollectionEnvelope.count	  		= eventRegistrations.size();
        
        attendeeDetailCollectionEnvelope.data = new List<AttendeeDetail>();
        if(!eventRegistrations.isEmpty()){
            for(Event_Registration__c eventRegistration: eventRegistrations){
                attendeeDetailCollectionEnvelope.data.add(new AttendeeDetail(eventRegistration));
            }
        }
        
        return attendeeDetailCollectionEnvelope;
        
    }
    
    public static Envelope getAttendeesModifiedAfterDateTime(String eventId, String modifiedAfterDatetimeString){
        
        try{
            
            Datetime modifiedAfterDatetime = convertStringToDatetime(modifiedAfterDatetimeString);
            
            AttendeeCollectionEnvelope attendeeCollectionEnvelope = new AttendeeCollectionEnvelope();
    
            String queryString = String.join(new List<String>{
                'SELECT',
                getCollectionQueryFieldsString(),
                'FROM',
                'Event_Registration__c',
                'WHERE',
                'Registration_ID__c != null',
                'AND',
                'LastModifiedDate > :modifiedAfterDatetime',
                'AND', 
                'Event__c = :eventId',
                'ORDER BY LastModifiedDate DESC'
            }, ' ');
            
            List<Event_Registration__c> eventRegistrations = Database.query(queryString);
            
            attendeeCollectionEnvelope.url 		  = 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            attendeeCollectionEnvelope.parameters = params;
            attendeeCollectionEnvelope.status	  = 200;
            attendeeCollectionEnvelope.count	  = eventRegistrations.size();
            
            attendeeCollectionEnvelope.data = new List<AttendeeCollection>();
            
            if(!eventRegistrations.isEmpty()){
                for(Event_Registration__c eventRegistration: eventRegistrations){
                    attendeeCollectionEnvelope.data.add(new AttendeeCollection(eventRegistration));
                }
            }
            
            return attendeeCollectionEnvelope;
            
        }catch(Exception ex){
            
            error = new ErrorEnvelope();
            
            error.parameters 	= params;
            error.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
            error.status 		= 400;
            error.errors 		= new List<String>{ex.getMessage()};     
                
           	return error;
            
        }
        
    }
    
    public static Envelope getAttendeeByEmail(String eventId, String email){
        
        AttendeeDetailEnvelope attendeeDetailEnvelope = new AttendeeDetailEnvelope();
        
        String queryString = String.join(new List<String>{
            'SELECT',
            getDetailQueryFieldsString(),
            'FROM',
            'Event_Registration__c',
            'WHERE',
            'Registration_ID__c  != null',
            'AND',
            '(Contact__r.Email = :email OR User__r.Email = :email)',
            'AND', 
            'Event__c = :eventId'
        }, ' ');
        
        List<Event_Registration__c> eventRegistrations = Database.query(queryString);
        
        attendeeDetailEnvelope.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
        attendeeDetailEnvelope.parameters 	= params;
        attendeeDetailEnvelope.status	  	= 200;
        
        if(!eventRegistrations.isEmpty()) attendeeDetailEnvelope.data = new AttendeeDetail(eventRegistrations[0]);
        
        return attendeeDetailEnvelope;
        
    }
    
    
    public static Envelope getAttendeeByGarpId(String eventId, String attendeeId){
        
        AttendeeDetailEnvelope attendeeDetailEnvelope = new AttendeeDetailEnvelope();
        
        String queryString = String.join(new List<String>{
            'SELECT',
            getDetailQueryFieldsString(),
            'FROM',
            'Event_Registration__c',
            'WHERE',
            'Registration_ID__c != null',
            'AND',
            'Registration_ID__c = :attendeeId',
            'AND',
            'Event__c = :eventId'
        }, ' ');
        
        List<Event_Registration__c> eventRegistrations = Database.query(queryString);
        
        attendeeDetailEnvelope.url			= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
        attendeeDetailEnvelope.parameters 	= params;
        attendeeDetailEnvelope.status	  	= 200;
        
        if(!eventRegistrations.isEmpty()) attendeeDetailEnvelope.data = new AttendeeDetail(eventRegistrations[0]);
        
        return attendeeDetailEnvelope;
        
    }
    
    public static Envelope setRegistrationStatus(String eventId, String attendeeId, Boolean attended){
        
        AttendeeDetailEnvelope attendeeDetailEnvelope = new AttendeeDetailEnvelope();
        
        String queryString = String.join(new List<String>{
            'SELECT',
            getDetailQueryFieldsString(),
            'FROM',
            'Event_Registration__c',
            'WHERE',
            'Registration_ID__c  != null', 
            'AND', 
            'Registration_ID__c  = :attendeeId',
            'AND',
            'Event__c = :eventId'
        }, ' ');
        
        List<Event_Registration__c> eventRegistrations = Database.query(queryString);
        
        attendeeDetailEnvelope.url		 	= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
        attendeeDetailEnvelope.parameters 	= params;
        attendeeDetailEnvelope.status	  	= 200;
        
        if(!eventRegistrations.isEmpty()){       
            
            if(attended){           
                eventRegistrations[0].Status__c = 'Attended'; 
            }else{
                eventRegistrations[0].Status__c = 'Registered and Paid'; 
            }
            
            UPDATE eventRegistrations[0];
            
            attendeeDetailEnvelope.data = new AttendeeDetail(eventRegistrations[0]);
            
        }
        
        return attendeeDetailEnvelope;
        
    }
    
    public static Envelope getRegistrationStatuses(){
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Event_Registration__c').getDescribe().fields.getMap();
        List<Schema.PicklistEntry> picklistValues = fieldMap.get('Status__c').getDescribe().getPicklistValues();
        
        PicklistEntryEnvelope registrationStatusesEnvelope = new PicklistEntryEnvelope();
        
        registrationStatusesEnvelope.url		= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
        registrationStatusesEnvelope.parameters = params;
        registrationStatusesEnvelope.status	  	= 200; 
        registrationStatusesEnvelope.count	    = picklistValues.size();
        registrationStatusesEnvelope.data		= picklistValues;
        
        return registrationStatusesEnvelope;
        
    }
    
    public static Envelope getContributorTypes(){
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Event_Registration__c').getDescribe().fields.getMap();
        List<Schema.PicklistEntry> picklistValues = fieldMap.get('Registration_Type__c').getDescribe().getPicklistValues();
        
        PicklistEntryEnvelope registrationStatusesEnvelope = new PicklistEntryEnvelope();
        
        registrationStatusesEnvelope.url		= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
        registrationStatusesEnvelope.parameters = params;
        registrationStatusesEnvelope.status	  	= 200; 
        registrationStatusesEnvelope.count	    = picklistValues.size();
        registrationStatusesEnvelope.data		= picklistValues;
        
        return registrationStatusesEnvelope;
        
    }
    
    public static Envelope getParticipantTypes(){
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Event_Registration__c').getDescribe().fields.getMap();
        List<Schema.PicklistEntry> picklistValues = fieldMap.get('Participants__c').getDescribe().getPicklistValues();
        
        PicklistEntryEnvelope registrationStatusesEnvelope = new PicklistEntryEnvelope();
        
        registrationStatusesEnvelope.url		= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
        registrationStatusesEnvelope.parameters = params;
        registrationStatusesEnvelope.status	  	= 200; 
        registrationStatusesEnvelope.count	    = picklistValues.size();
        registrationStatusesEnvelope.data		= picklistValues;
        
        return registrationStatusesEnvelope;
        
    }
    
    public static Envelope getAttendeeTypes(){
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Event_Registration__c').getDescribe().fields.getMap();
        List<Schema.PicklistEntry> picklistValues = fieldMap.get('Attendee_Type__c').getDescribe().getPicklistValues();
        
        PicklistEntryEnvelope registrationStatusesEnvelope = new PicklistEntryEnvelope();
        
        registrationStatusesEnvelope.url		= 'https://' + System.URL.getSalesforceBaseUrl().getHost() + req.requestURI;
        registrationStatusesEnvelope.parameters = params;
        registrationStatusesEnvelope.status	  	= 200; 
        registrationStatusesEnvelope.count	    = picklistValues.size();
        registrationStatusesEnvelope.data		= picklistValues;
        
        return registrationStatusesEnvelope;
        
    }
    
}