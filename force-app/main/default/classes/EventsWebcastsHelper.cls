public class EventsWebcastsHelper {
    
    public class EventWrapper{
        public Event__c event { get; set; }
        public List<Event_Speaker__c> eventSpeakers { get; set; }
    }

    public class WebcastWrapper{
        public Webcast__c webcast { get; set; }
        public List<Presenter__c> presenters { get; set; }
    }
    
    public static List<EventWrapper> getEventsData(){
        Map<Id, Event__c> eventsMap = new Map<Id, Event__c>([
            SELECT 
                Id,
                Name,
                Address__c,
                AddressMap_Image_URL__c,
                AlreadyRegisteredLink__c,
                Book_Hotel_Link__c,
                Cancellation_Policy__c,
                Can_Pay_By_wire__c,
                Can_Register__c,
                Chapter_Meeting__c,
                Content_Folder__c,
                Convert_ID__c,
                CPD_Credit__c,
                Description__c,
                Duration__c,
                DynamicNgClass__c,
                End_Date__c,
                Event_Day__c,
                Event_Last_Wire_Check_Day__c,
                Events_Photography_Release__c,
                GL_Code__c,
                Hashtag__c,
                Last_Date_For_Registration__c,
                Last_Date_for_Wire_Check_Registration__c,
                Overview__c,
                Online_Meeting_URL__c,
                Parent_Event__c,
                Photo_Album_Link__c,
                Post_Event_Description__c,
                Product_Code__c,
                Program_Change__c,
                RegisterNowLink__c,
                Start_Date__c,
                Status__c,
            	Invite_Only__c,
                Title__c,
                Vanity_URL__c,
                Venue_Guidelines__c,
                VenueName__c,
                RecordTypeId,
                RecordType.Name,
                Time_Zone__r.Abbreviation__c, 
                Time_Zone__r.Name, 
                Time_Zone__r.Add_This_Event_Zone__c
            FROM Event__c 
            WHERE Status__c = 'Active' AND Invite_Only__c = FALSE
        ]);   
        
        Map<Id, Event_Sessions__c> eventSessionsMap = new Map<Id, Event_Sessions__c>([
            SELECT Id, Event__c FROM Event_Sessions__c WHERE Event__c IN :eventsMap.keySet()
        ]);
        
        Map<Id, Event_Speaker_Session_Track__c> eventSpeakerSessionTracksMap = new Map<Id, Event_Speaker_Session_Track__c>([
            SELECT Id, Event_Session__c, Event_Speaker__c FROM Event_Speaker_Session_Track__c WHERE Event_Session__c IN :eventSessionsMap.keySet()
        ]);
        
        Map<Id, Event_Speaker__c> eventSpeakersMap = new Map<Id, Event_Speaker__c>([
            SELECT Id, First_Name__c, Last_Name__c, Photo__c, Status__c FROM Event_Speaker__c
        ]);

        List<EventWrapper> events = new List<EventWrapper>();        
        for(Event__c event: eventsMap.values()){
            
            EventWrapper eventWrapper = new EventWrapper();
            eventWrapper.event = event;
            eventWrapper.eventSpeakers = new List<Event_Speaker__c>();
            
            for(Event_Sessions__c eventSession: eventSessionsMap.values()){
                if(event.Id == eventSession.Event__c){
                    for(Event_Speaker_Session_Track__c eventSpeakerSessionTrack: eventSpeakerSessionTracksMap.values()){
                        if(eventSession.Id == eventSpeakerSessionTrack.Event_Session__c){
                            eventWrapper.eventSpeakers.add(eventSpeakersMap.get(eventSpeakerSessionTrack.Event_Speaker__c));
                        }
                    }
                }
            }
            
            events.add(eventWrapper);
            
        }
        
        return events;
        
    }
    
    public static List<WebcastWrapper> getWebcastsData(){
    
        Map<Id, Webcast__c> webcastsMap = new Map<Id, Webcast__c> ([
            SELECT Id, Name, Description__c, Duration__c, End_Date__c, Image__c, Start_Date__c, Status__c, Title__c, Convert_ID__c, Time_Zone__r.Name
            FROM Webcast__c
            WHERE Status__c = 'Active'
        ]);  
        
        Map<Id, Presenter__c> presentersMap = new Map<Id, Presenter__c>([
            SELECT Id, Name, Contact__c, Role__c, Webcast__c, Contact__r.Name 
            FROM Presenter__c 
            WHERE Webcast__c IN :webcastsMap.keySet()
        ]);
        
        List<WebcastWrapper> webcasts = new List<WebcastWrapper>();
        for(Webcast__c webcast: webcastsMap.values()){
            
            WebcastWrapper webcastWrapper = new WebcastWrapper();
            webcastWrapper.webcast = webcast;
            webcastWrapper.presenters = new List<Presenter__c>();
            
            for(Presenter__c presenter: presentersMap.values()){
                if(webcast.Id == presenter.Webcast__c){
                    webcastWrapper.presenters.add(presenter);
                }
            }    
            
            webcasts.add(webcastWrapper);
            
        }
        
        return webcasts;
        
    }
    
}