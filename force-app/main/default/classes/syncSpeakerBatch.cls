global class syncSpeakerBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    private list<Decimal> Speakerlist;
    Private String key ;
    private String Query='';
    Private String eventKey='';
    
    public syncSpeakerBatch(List<integer> SpeakerIds,String recordKey, String inEventKey){          
        key=recordKey;
        Speakerlist=SpeakerIds; 
        eventKey=inEventKey;
        Query = 'SELECT Id, Name, Grenadine_Speaker_ID__c FROM Event_Speaker__c where Grenadine_Speaker_ID__c =: Speakerlist' ;
    }
    
    public syncSpeakerBatch(String recordKey){
        Query = 'SELECT Id, Name, Grenadine_Speaker_ID__c FROM Event_Speaker__c where Grenadine_Speaker_ID__c != NULL';
        key=recordKey;
        //Speakerlist=SpeakerIds;key=recordKey;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {       
        return Database.getQueryLocator(Query); 
    }
    
    global void execute(Database.BatchableContext BC, List<Event_Speaker__c> records) {
        
        Map<String,Event_Speaker__c> MapOfSpeakerRecords = New Map<String,Event_speaker__c>();
        
        for(Event_Speaker__c evtSpeaker : records ){
            MapOfSpeakerRecords.put(String.valueOf(Integer.valueOf( evtSpeaker.Grenadine_Speaker_ID__c)), evtSpeaker);
        }
        System.debug('Map Records : '+ MapOfSpeakerRecords);
        
        Map<string,Access_Token_Utilities__c> Access_Token_Data = Access_Token_Utilities__c.getall();
        
        String baseEndpoint = Access_Token_Data.get('Access_token_credential').Site_Url__c;
        
        Map<id,Event_Speaker__c> EventSpeakerList = New Map<id,Event_Speaker__c>();
        
        Set<String> emailAddrs = new Set<String>();
        
        for(Event_Speaker__c evtSpeaker : records ){
            String endpoint = baseEndpoint + eventKey + '/planner_apis/1/people/' + Integer.valueOf(evtSpeaker.Grenadine_Speaker_ID__c) +'?access_token='+key+'&detailed_assignments=false&paginated=false'; 
            
            System.debug('Endpoint ' +endpoint);
            
            Httpresponse res= SyncGrenadine.callEndpoint(endPoint, 'GET','','');
            
            if(res.getStatusCode()==200){
                GARP_Wrapper_response_People_Information People = GARP_Wrapper_response_People_Information.parse(res.getBody());
                
                //System.debug('Condition  : ' + MapOfSpeakerRecords.get(String.valueOf(People.response.id)) + ' : '+ People.response.id );
                
                if(MapOfSpeakerRecords.get(String.valueOf(People.response.id))!=NUll){
                    
                    
                    
                    Event_Speaker__c speaker= new Event_Speaker__c(id = MapOfSpeakerRecords.get(String.valueOf(People.response.id)).id,
                                                                   Name =People.response.full_publication_name,Status__c='Active',
                                                                   Grenadine_Speaker_ID__c=People.response.id,
                                                                   First_Name__c=People.response.real_name.first,
                                                                   Last_Name__c=People.response.real_name.last,
                                                                   Title__c=People.response.real_name.prefix,
                                                                   Byline__c=People.response.job_title + ', ' + People.response.company
                                                                   ,Organization__c=People.response.company,Photo__c=People.response.public_image_url,
                                                                   Bio__c=People.response.edited_bio != Null ? People.response.edited_bio.bio : ''
                                                                   ,Email__c=People.response.email_addresses.size() > 0 ? People.response.email_addresses[0].email :''
                                                                  );
                    EventSpeakerList.put(MapOfSpeakerRecords.get(String.valueOf(People.response.id)).id,speaker);      
                    if(People.response.email_addresses.size() > 0) {
                        emailAddrs.add(People.response.email_addresses[0].email);
                    }               
                }
            }          
        }
        
        System.debug('emailAddrs:' + emailAddrs);
        
        List<Contact> lstCont = [select Id, Email from Contact where email in :emailAddrs];
        MAP<String,String> mapContEmail = new MAP<String,String>();
        for(Contact c :lstCont) {
            mapContEmail.put(c.email, c.Id);
        }
        System.debug('mapContEmail:' + mapContEmail);
        
        
        for(Id eid :EventSpeakerList.keyset()) {
            Event_Speaker__c es = EventSpeakerList.get(eid);
            if(es != NULL) {
                String fndCont = mapContEmail.get(es.Email__c);
                if(fndCont != NULL) {
                    es.Contact__c = fndCont;
                    EventSpeakerList.put(eid, es);
                }
            }
        }
        
        if(EventSpeakerList.size()>0)
            upsert  EventSpeakerList.values(); 
    }
    global void finish(Database.BatchableContext BC){    
        
    }
}