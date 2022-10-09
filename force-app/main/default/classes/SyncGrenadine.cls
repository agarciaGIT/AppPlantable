/*******************************************
@Created Date - 18-09-2019
@Purpose - Sync With Grenadine Event
********************************************/

public class SyncGrenadine {    
    
    /**************************************************************************************
@Created Date - 18-09-2019
@Method - getEventData
@Desc  -This method is used for syncing Speaker,Event and Tracks Data With Grenadine
@Param - Event Record id as Input param
@Output - returning map containing flag values  
***************************************************************************************/
    public static String accessTokenData;
    public static boolean isBatchProcessing=false;
    
    @AuraEnabled 
    public static Map<String,String> getEventData(String recordId){
        
        Map<String,String> responseMap = New Map<String,String>{'Success' => '' ,'Error'=> ''};
            
        Event__c eve = [select id,Grenadine_Event_Key__c ,(Select id,Status__c,name,Grenadine_Session_ID__c from Event_Sessions__r ) from event__c where Id =: recordId LIMIT 1];
        
        if(eve == NUll){
            responseMap.put('Error','No related Record Found !!');
            return responseMap;
        }
        
        //Map of Event Session Which are Already in Salesforce       
        Map<Integer, Event_Sessions__c> mapAttachedEventWithExternalId = New Map<Integer, Event_Sessions__c>();
        
        for(Event_Sessions__c  Attchevt : eve.Event_Sessions__r){
            mapAttachedEventWithExternalId.put( integer.valueOf(Attchevt.Grenadine_Session_ID__c),Attchevt);
        }
        
        Map<string,Access_Token_Utilities__c> Access_Token_Data = Access_Token_Utilities__c.getall();
        
        String Endpoint = Access_Token_Data.get('Access_token_credential').Site_Url__c;
        
        String accessToken = getAccessToken(Access_Token_Data);
        
        if(!String.isEmpty(accessToken)){
            Endpoint = Endpoint + eve.Grenadine_Event_Key__c + '/planner_apis/1/published_items?access_token='+accessToken+'&paginated=false&child_items=true';  
            
            System.debug('Endpoint : '+ Endpoint);
            
            HttpResponse res = callEndpoint(Endpoint,'GET','','');
            
            if(Res.getStatusCode()==200){
                String resp = res.getBody();
                
                System.debug('Response Body : ' + resp );
                try{
                    
                    MAP<String, Event_Speaker_Session_Track__c> mapOldEST = new MAP<String, Event_Speaker_Session_Track__c>();
                    List<Event_Speaker_Session_Track__c> lstEST = [SELECT Id, Name, Role__c, Event_Session__r.Grenadine_Session_ID__c, Event_Speaker__r.Grenadine_Speaker_ID__c FROM Event_Speaker_Session_Track__c where Event_Session__r.Event__c = : eve.id];
                    for(Event_Speaker_Session_Track__c est :lstEST) {
                        mapOldEST.put(String.valueOf(est.Event_Session__r.Grenadine_Session_ID__c) + '~' + String.valueOf(est.Event_Speaker__r.Grenadine_Speaker_ID__c),est);
                    }             
                    System.debug('mapOldEST: ' + mapOldEST);
                    
                    Delete lstEST;
                    
                    GARP_Wrapper_Event_Session_Speaker  gWrap_event =  GARP_Wrapper_Event_Session_Speaker.parse(resp);
                    
                    //Creating Session and Speaker id List 
                    List<integer> sessionIds = new List<integer>();
                    List<integer> speakerIds = new List<integer>();
                    List<String> tracksName = new List<String>();
                    
                    //List for Events deleted from Grenadine 
                    List<Integer> delEventSession= new List<Integer>();
                    
                    List<String> eventSessionSpeakerTracks = new List<String>();
                    
                    Map<Integer,List<integer>> mapSessionWithSpeakerExternalIds = new Map<Integer,List<integer>>();
                    Map<Integer,List<String>> mapWithSessionTracksList = new Map<Integer, List<String>>();
                    Map<Integer,Map<integer,String>> mapPersonRoleWithId = new Map<Integer,Map<integer,String>>();
                    
                    for(GARP_Wrapper_Event_Session_Speaker.cls_response wrap_of_Event : gWrap_event.response ){
                        
                        System.debug('wrap_of_Event:' + wrap_of_Event);
                        System.debug('wrap_of_Event.id:' + wrap_of_Event.id);
                        
                        if(wrap_of_Event.child_ids != NULL && wrap_of_Event.child_ids.size() > 0)
                        {
                            System.debug('Skip Child IDs!');
                            continue;
                        }                        
                        
                        if(wrap_of_Event.visibility_id != NULL && wrap_of_Event.visibility_id == 'PRIV')
                        {
                            System.debug('Skip Private!');
                            continue;
                        }                        

                        
                        
                        Map<integer,String> mapRoleWithSpeakerId = new Map<Integer,String>();
                        
                        List<integer> speakerIdsInner = new List<integer>();
                        List<String> tracksNameInner = new List<String>();
                        
                        sessionIds.add(wrap_of_Event.id);                        
                        
                        for(GARP_Wrapper_Event_Session_Speaker.cls_sorted_published_item_assignments PeopleId :wrap_of_Event.sorted_published_item_assignments ){
                            
                            System.debug('PeopleId:' + PeopleId);
                            
                            if(PeopleId.person_role.equalsIgnoreCase('Moderator') || PeopleId.person_role.equalsIgnoreCase('Participant')){                                
                                if(! speakerIds.contains(PeopleId.person.id)){
                                    speakerIds.add(PeopleId.person.id);     
                                }
                                speakerIdsInner.add(PeopleId.person.id);
                                mapRoleWithSpeakerId.put(PeopleId.person.id,PeopleId.person_role);
                            
                            }
                            
                            System.debug('wrap_of_Event.theme_names : '+ wrap_of_Event.theme_names);
                            
                            if(wrap_of_Event.theme_names.size() > 0){
                                tracksName.add(eve.Grenadine_Event_Key__c + '-'+wrap_of_Event.theme_names[0].name);                            
                                eventSessionSpeakerTracks.add(eve.Grenadine_Event_Key__c + '-'+wrap_of_Event.theme_names[0].name  +' ' + wrap_of_Event.title.split(' ')[0]+' '+ PeopleId.person.full_publication_name);
                                tracksNameInner.add(eve.Grenadine_Event_Key__c + '-'+wrap_of_Event.theme_names[0].name);
                            }
                            else{
                                eventSessionSpeakerTracks.add(wrap_of_Event.title.split(' ')[0]+' '+ PeopleId.person.full_publication_name ); 
                            }
                            //mapPersonRoleWithId.put(PeopleId.person.id ,PeopleId.person_role);
                        }                                          
                        //System.debug(' : '+ wrap_of_Event.theme_names);
                        
                        // Add Track to Map if no speakers also
                        if(wrap_of_Event.theme_names.size() > 0){
                                tracksName.add(eve.Grenadine_Event_Key__c + '-'+wrap_of_Event.theme_names[0].name);           
                        }
                        
                        mapPersonRoleWithId.put(wrap_of_Event.id,mapRoleWithSpeakerId);
                        mapSessionWithSpeakerExternalIds.put(wrap_of_Event.id,speakerIdsInner);
                        mapWithSessionTracksList.put(wrap_of_Event.id,tracksNameInner);
                    }
                    
                    //Getting List of Event Session Deleted From Grenadine
                    
                    for(Integer keyVal : mapAttachedEventWithExternalId.keyset()){
                        if(! sessionIds.contains(keyVal))
                            delEventSession.add(keyVal);
                    }
                    
                    List<Event_Sessions__c> delEvents = new List<Event_Sessions__c>();
                    
                    //preparing List of Deleted Event
                    for(Integer delId  : delEventSession ){
                        Event_Sessions__c evt = mapAttachedEventWithExternalId.get(delId);
                        evt.Status__c='Draft';
                        delEvents.add(evt);
                    } 
                    
                    System.debug('mapPersonRoleWithId : '+ mapPersonRoleWithId);                      
                    System.debug('Events *******************************************************');
                    
                    System.debug('eventSessionSpeakerTracks : '+ eventSessionSpeakerTracks);                    
                    System.debug('mapWithSessionTracksList : '+ mapWithSessionTracksList);                    
                    System.debug('mapSessionWithSpeakerExternalIds: '+ mapSessionWithSpeakerExternalIds);
                    
                    System.debug('*******************************************************');
                    System.debug('');
                    Map<String, Event_Sessions__c> MapEventSessionWithExternalId = New Map<String, Event_Sessions__c>();
                    
                    Map<String,Event_Speaker__c> MapEventSpeakerWithExternalId = New Map<String,Event_Speaker__c>();
                    
                    Map<String,Event_Session_Track__c> MapEventSessionTrack = new Map<String ,Event_Session_Track__c>();
                    
                    Map<String,Event_Speaker_Session_Track__c> MapEventSessionSpeakerSessionTracks = new Map<String,Event_Speaker_Session_Track__c>();
                    
                    for(Event_Session_Track__c eventSessionTracks : [SELECT Id,Name, Grenadine_Track_Key__c FROM Event_Session_Track__c where Grenadine_Track_Key__c in : tracksName ]){
                        MapEventSessionTrack.put(String.valueOf(eventSessionTracks.Grenadine_Track_Key__c),eventSessionTracks);                        
                    }
                    System.debug('MapEventSessionTrack' +  MapEventSessionTrack);
                    
                    for(Event_Sessions__c eventSession : [SELECT Id, Name, Event__c, Grenadine_Session_ID__c,LastModifiedDate FROM Event_Sessions__c Where Grenadine_Session_ID__c in : sessionIds ]){
                        MapEventSessionWithExternalId.put(String.valueOf(eventSession.Grenadine_Session_ID__c),eventSession);
                    }                
                    
                    for(Event_Speaker__c eventSpeaker : [SELECT Id, Name, Grenadine_Speaker_ID__c FROM Event_Speaker__c where Grenadine_Speaker_ID__c in : speakerIds] ){
                        MapEventSpeakerWithExternalId.put( String.valueOf(eventSpeaker.Grenadine_Speaker_ID__c),eventSpeaker);
                    }
                    
                    for(Event_Speaker_Session_Track__c eventSpeakerSessionTrack : [SELECT Id,Name, Event_Session__c, Event_Session_Track__c, Event_Speaker__c, Event_Session_End_Date_Time__c, Session_Start_Date_and_Time__c, 
                                                                                   Featured__c, Order_By__c, Status__c FROM Event_Speaker_Session_Track__c where name in :eventSessionSpeakerTracks ]) {
                                                                                       MapEventSessionSpeakerSessionTracks.put(eventSpeakerSessionTrack.name,eventSpeakerSessionTrack);
                                                                                   }
                    
                    
                    /* System.debug('********************************************************************');

System.debug(' MapEventSessionTrack : '+  MapEventSessionTrack.keyset());
System.debug(' MapEventSessionWithExternalId : '+  MapEventSessionWithExternalId.keyset());
System.debug(' MapEventSpeakerWithExternalId : '+  MapEventSpeakerWithExternalId.keyset());
System.debug(' MapEventSessionSpeakerSessionTracks : '+  MapEventSessionSpeakerSessionTracks.keyset());

System.debug('********************************************************************');
*/
                    List<Event_Sessions__c> eventSessionToUpdateInsert = new  List<Event_Sessions__c>();
                    //List for handling Speakers 
                    List<Event_Speaker__c> eventSpeakerListToUpdateInsert = New List<Event_Speaker__c>();
                    
                    Map<integer , Event_Speaker__c> mapEventSpeakerToUpdateInsert =  New Map<integer , Event_Speaker__c> ();
                    
                    
                    for(GARP_Wrapper_Event_Session_Speaker.cls_response wrap_of_Event : gWrap_event.response ){
                        // sessionIds.add(wrap_of_Event.id);

                        System.debug('wrap_of_Event:' + wrap_of_Event);
                        System.debug('wrap_of_Event.id:' + wrap_of_Event.id);

                        if(wrap_of_Event.child_ids != NULL && wrap_of_Event.child_ids.size() > 0)
                        {
                            System.debug('Skip Child IDs!');
                            continue;
                        }           
                        
                        if(wrap_of_Event.visibility_id != NULL && wrap_of_Event.visibility_id == 'PRIV')
                        {
                            System.debug('Skip Private!');
                            continue;
                        }                        
                        
                        String gredSessionId = String.valueOf(wrap_of_Event.id);
                        Event_Sessions__c fndSession = MapEventSessionWithExternalId.get(gredSessionId);
                        
                        // Exists
                        if(fndSession != NULL){
                            // Update Session
                            //if(MapEventSessionWithExternalId.get(String.valueOf(wrap_of_Event.id)).LastModifiedDate  < wrap_of_Event.updated_at){
                                Event_Sessions__c eventSession = new Event_Sessions__c(id=fndSession.id, Event__c = eve.id, Name= wrap_of_Event.title.length()>80 ? wrap_of_Event.title.substring(0, 80) :  wrap_of_Event.title, 
                                                                                       Title__c =wrap_of_Event.title,Status__c='Active',Start_Date_Time__c=wrap_of_Event.start_time,
                                                                                       End_Date_Time__c=wrap_of_Event.end_time,Description__c= wrap_of_Event.description ,Details__c=wrap_of_Event.description,
                                                                                       Grenadine_Session_ID__c= wrap_of_Event.id
                                                                                      );
                                if(wrap_of_Event.theme_names.size() > 0){
                                    String trackKey = eve.Grenadine_Event_Key__c+'-'+wrap_of_Event.theme_names[0].name;
                                    Event_Session_Track__c fndTrack = MapEventSessionTrack.get(trackKey);
                                    if(fndTrack != NULL) {
                                        eventSession.Event_Session_Track__c = fndTrack.Id;
                                    }
                                    //eventSession.Event_Session_Track__c = MapEventSessionTrack.get(eve.Grenadine_Event_Key__c+'-'+wrap_of_Event.theme_names[0].name) != NUll ?MapEventSessionTrack.get(eve.Grenadine_Event_Key__c+'-'+wrap_of_Event.theme_names[0].name).id : '';                                    
                                }
                                else{
                                    eventSessionSpeakerTracks.add(eventSession.Name);
                                }
                                eventSessionToUpdateInsert.add(eventSession);  
                            //}
                        }
                        else{
                            // System.debug('Inside else Block ');
                            Event_Sessions__c eventSession = new Event_Sessions__c(
                                Event__c =  eve.id, Name= wrap_of_Event.title.length()>80 ? wrap_of_Event.title.substring(0, 80) :  wrap_of_Event.title, Title__c =wrap_of_Event.title,Status__c='Active',Start_Date_Time__c=wrap_of_Event.start_time ,
                                End_Date_Time__c=wrap_of_Event.end_time,Description__c= wrap_of_Event.description ,Details__c=wrap_of_Event.description,
                                Grenadine_Session_ID__c= wrap_of_Event.id
                            );
                            if(wrap_of_Event.theme_names.size() > 0){
                                if(MapEventSessionTrack.get(eve.Grenadine_Event_Key__c+'-'+wrap_of_Event.theme_names[0].name) != NUll){
                                    eventSession.Event_Session_Track__c   =MapEventSessionTrack.get(eve.Grenadine_Event_Key__c+'-'+wrap_of_Event.theme_names[0].name).id;
                                }
                                //eventSession.Event_Session_Track__c = MapEventSessionTrack.get(eve.Grenadine_Event_Key__c+'-'+wrap_of_Event.theme_names[0].name) != NUll ?MapEventSessionTrack.get(eve.Grenadine_Event_Key__c+'-'+wrap_of_Event.theme_names[0].name).id : ''; 
                            }
                            eventSessionToUpdateInsert.add(eventSession);  
                        }
                        //System.debug(' :' + wrap_of_Event.sorted_published_item_assignments);
                        // Looping Over Wrapper of Response for Speakr Id 
                        for(GARP_Wrapper_Event_Session_Speaker.cls_sorted_published_item_assignments PeopleId :wrap_of_Event.sorted_published_item_assignments ){
                            
                            //System.debug( PeopleId.person.id + '  : '+ MapEventSpeakerWithExternalId.get(String.valueOf(PeopleId.person.id)));
                            
                            if(MapEventSpeakerWithExternalId.get(String.valueOf(PeopleId.person.id))==NUll && (PeopleId.person_role.equalsIgnoreCase('Moderator') || PeopleId.person_role.equalsIgnoreCase('Participant'))){
                                Event_Speaker__c speaker= new Event_Speaker__c(Name =PeopleId.person.full_publication_name,
                                                                               Grenadine_Speaker_ID__c=PeopleId.person.id);
                                //eventSpeakerListToUpdateInsert.add(speaker);
                                mapEventSpeakerToUpdateInsert.Put(PeopleId.person.id,speaker);
                            }
                        }
                    }
                    
                    // Adding Event Session Records Which are Deleted From Grenadine Events
                    
                    for(Event_Sessions__c evtSessionVal : delEvents ){
                        eventSessionToUpdateInsert.add(evtSessionVal); 
                    }
                    
                    if(eventSessionToUpdateInsert.size()>0){
                        upsert eventSessionToUpdateInsert;
                        for(Event_Sessions__c evtSession : eventSessionToUpdateInsert){
                            MapEventSessionWithExternalId.put( String.valueOf(evtSession.Grenadine_Session_ID__c),evtSession);  
                            if( !sessionIds.contains(Integer.valueOf(evtSession.Grenadine_Session_ID__c)))
                                sessionIds.add(Integer.valueOf(evtSession.Grenadine_Session_ID__c));
                        }
                    }
                    
                    for( Event_Speaker__c sp :  mapEventSpeakerToUpdateInsert.values()){
                        System.debug(sp.Name +  ' : '+ sp.id);     
                    }                   
                    
                    if(mapEventSpeakerToUpdateInsert.values().size() > 0){                    
                        Upsert mapEventSpeakerToUpdateInsert.values();
                        
                        for( Event_Speaker__c speakerUpdate : mapEventSpeakerToUpdateInsert.values() ){
                            MapEventSpeakerWithExternalId.put(String.valueOf( speakerUpdate.Grenadine_Speaker_ID__c ),speakerUpdate);
                            
                            if( ! speakerIds.contains(Integer.valueOf(speakerUpdate.Grenadine_Speaker_ID__c)))
                                speakerIds.add( Integer.valueOf(speakerUpdate.Grenadine_Speaker_ID__c));
                        }
                    }
                    
                    System.debug('Speaker Id in Batchs  : ' + speakerIds);
                    System.debug('isBatchProcessing : '+ isBatchProcessing);
                    
                    if(! (Test.isRunningTest() || isBatchProcessing )){
                        system.debug('tried to Run Batch !!!');
                        syncSpeakerBatch btch= new syncSpeakerBatch(speakerIds,accessToken,eve.Grenadine_Event_Key__c);
                        Database.executeBatch(btch,10);                                 
                    }else{
                        //syncEventBatch.spakerIds.addAll(speakerIds);
                    }
                    
                    //Del Speaker Tracks
                    updateSpeakerRelatedTracks(speakerIds,eve.id);                    

                    
                    List<Event_Speaker_Session_Track__c> evtSpeakerSessionTracksList = new List<Event_Speaker_Session_Track__c>();                    
                    for(integer extSessionid : mapSessionWithSpeakerExternalIds.keyset()){
                        
                        System.debug('Session Id  : ' +  extSessionid + ' : '+  mapSessionWithSpeakerExternalIds.get(extSessionid));
                        
                        if(mapSessionWithSpeakerExternalIds.get(extSessionid).size() > 0){
                            for(integer speak : mapSessionWithSpeakerExternalIds.get(extSessionid)){
                                
                                String SessionSpeakerTrackName = MapEventSessionWithExternalId.get(String.valueof(extSessionid)).name.split(' ')[0] +' ' +MapEventSpeakerWithExternalId.get(String.valueof(speak)).Grenadine_Speaker_ID__c;
                                
                                //System.debug('SessionSpeakerTrackName ==> '+ SessionSpeakerTrackName);
                                
                                Event_Speaker_Session_Track__c evtSpSessionTrack = new Event_Speaker_Session_Track__c();
                                
                                String trackname ='';                               
                                
                                if(mapWithSessionTracksList.get(extSessionid).size() > 0){
                                    //System.debug('Inside Session Tracks List : '+ MapEventSessionTrack.get(mapWithSessionTracksList.get(extSessionid)[0].trim()).id+ ' : '+ mapWithSessionTracksList.get(extSessionid)[0]);
                                    if(MapEventSessionTrack.get(mapWithSessionTracksList.get(extSessionid)[0].trim()) != NULL){                                     
                                        evtSpSessionTrack.Event_Session_Track__c = MapEventSessionTrack.get(mapWithSessionTracksList.get(extSessionid)[0].trim()).id; 
                                        trackname = mapWithSessionTracksList.get(extSessionid)[0];   
                                    }
                                }
                                
                                trackname= trackname+' '+ MapEventSessionWithExternalId.get(String.valueof(extSessionid)).name.split(' ')[0] + ' ' + MapEventSpeakerWithExternalId.get(String.valueof(speak)).Name;
                                
                                // System.debug('SessionSpeakerTrackName : '+ SessionSpeakerTrackName + ' : '+ trackname + ' : '+ MapEventSessionSpeakerSessionTracks.keyset());
                                
                                evtSpSessionTrack.Name= trackname.length() >80 ? trackname.substring(0,80) : trackname;
                                
                                //System.debug( evtSpSessionTrack.Name.trim().length() + ' : '+ MapEventSessionSpeakerSessionTracks.containsKey(evtSpSessionTrack.Name.trim()) + ' : '+ MapEventSessionSpeakerSessionTracks.get(evtSpSessionTrack.Name.trim()));
                                
                                //if(MapEventSessionSpeakerSessionTracks.get(evtSpSessionTrack.Name.trim())!=NULL){
                                //    evtSpSessionTrack.id=MapEventSessionSpeakerSessionTracks.get(evtSpSessionTrack.Name.trim()).id;   
                                //}
                                
                                evtSpSessionTrack.Event_Session__c=MapEventSessionWithExternalId.get(String.valueof(extSessionid)).id;
                                evtSpSessionTrack.Event_Speaker__c=MapEventSpeakerWithExternalId.get(String.valueof(speak)).id;  
                                evtSpSessionTrack.Status__c ='Active';
                                
                                //System.debug( 'Speaker id With role : '+ speak + ' : '+ mapPersonRoleWithId.get(speak));
                                
                                if(mapPersonRoleWithId.get(extSessionid) !=NULL){
                                    
                                    System.debug( 'Speaker id With role : '+ speak + ' : '+ mapPersonRoleWithId.get(extSessionid).get(speak));
                                    
                                    if(mapPersonRoleWithId.get(extSessionid).get(speak).equalsIgnoreCase('Moderator')){
                                        evtSpSessionTrack.Role__c = 'Moderator';    
                                    } 
                                    if(mapPersonRoleWithId.get(extSessionid).get(speak).equalsIgnoreCase('Participant')){
                                        evtSpSessionTrack.Role__c = 'Presenter';    
                                    }
                                    // Check Role of existing record
                                    String speakerGrenID = String.valueOf(MapEventSpeakerWithExternalId.get(String.valueof(speak)).Grenadine_Speaker_ID__c);
                                    System.debug('speakerGrenID:' + speakerGrenID);
                                    String oldKey = extSessionid + '~' + speakerGrenID;
                                    System.debug('oldKey:' + oldKey);
                                    
                                    Event_Speaker_Session_Track__c oldEst= mapOldEST.get(oldKey);
                                    System.debug('Old Event_Speaker_Session_Track__c:' + oldEst);
                                    
                                    if(oldEst != NULL && oldEst.Role__c != NULL && oldEst.Role__c != 'Moderator' && oldEst.Role__c != 'Presenter') {
                                        evtSpSessionTrack.Role__c = oldEst.Role__c;
                                        System.debug('Fix Role:' + evtSpSessionTrack); 
                                    }
                                                                       
                                }
                                System.debug('Add evtSpSessionTrack: '+  evtSpSessionTrack );
                                evtSpeakerSessionTracksList.add(evtSpSessionTrack);
                            }
                            //System.debug(mapSessionWithSpeakerExternalIds.keyset() + ' : '+  mapSessionWithSpeakerExternalIds.values() );
                        }
                    }
                    System.debug(' evtSpeakerSessionTracksList : '+ evtSpeakerSessionTracksList);
                    
                    if(evtSpeakerSessionTracksList.size()>0 )
                        upsert evtSpeakerSessionTracksList; 
                                        
                    responseMap.put('Success',' Successfully Synced !! ');
                    return responseMap;  
                }
                catch(Exception ex){
                    System.debug('Error : '+ ex.getMessage() + ' : ' + ex.getLineNumber());
                    responseMap.put('Error', ex.getMessage());
                    return responseMap;
                }                
            }
            else{
                system.debug('Response Erorr : '+ res.getStatusCode());
                responseMap.put('Error', res.getStatus());
                return responseMap;
            }
        }
        else{           
            // if response is null garp-20th-risk-convention
            responseMap.put('Error','Technical Error in getting Response from grenadine !!');
            return responseMap;
        }
        
    }
    /*******************************
* 
*******************************/
    public static void updateSpeakerRelatedTracks(List<integer> SpeakerIds , String evtId){
        
        Map<Integer , Event_Speaker_Session_Track__c> SpeakerWithtrack = new Map <Integer ,Event_Speaker_Session_Track__c>();
        List<integer> delEvent = New List<Integer>();
        //Getting All information Related to 
        for(Event_Speaker_Session_Track__c evtSpeakerTrack : [SELECT Id, Name, Event_Session__c, Event_Speaker__r.Grenadine_Speaker_ID__c, Status__c
                                                              FROM Event_Speaker_Session_Track__c Where  Event_Session__r.Event__c= : evtId] ){
                                                                  SpeakerWithtrack.put (integer.valueOf(evtSpeakerTrack.Event_Speaker__r.Grenadine_Speaker_ID__c),evtSpeakerTrack);                                                                       
                                                              }
        for(integer keyVal : SpeakerWithtrack.Keyset()){
            if(!SpeakerIds.contains(keyVal)){
                delEvent.add(keyVal);
            }
        }
        
        Event_Speaker_Session_Track__c[] delEvtTracks = [SELECT Id, Name, Event_Session__c, Event_Speaker__r.Grenadine_Speaker_ID__c, Status__c
                                                         FROM Event_Speaker_Session_Track__c Where  Event_Speaker__r.Grenadine_Speaker_ID__c IN : delEvent];
        if(delEvtTracks.size() > 0)
            delete delEvtTracks;
    }
    
    
    /*******************************
* 
*****************************
    
    public static void getSpeakerData(){
        
        Map<string,Access_Token_Utilities__c> Access_Token_Data = Access_Token_Utilities__c.getall();
        
        String Endpoint = Access_Token_Data.get('Access_token_credential').Site_Url__c;
        
        String accessToken = getAccessToken(Access_Token_Data);
        
        Endpoint= Endpoint+ '/planner_apis/1/people/295?access_token='+accessToken+'&detailed_assignments=false';
        //System.debug('Endpoint : ' + Endpoint);
        
        HttpResponse res = callEndpoint(Endpoint,'GET','','');
        
        if(res.getStatusCode()==200){
            system.debug('Response body : '+  res.getBody());
        }
    }  
 **/   
    
    /*************************************
@Method ==> getAccessToken
@purpose - used for getting access token for Every Request
@Param - String Key (Event id in grenadine)
@Return - String (Access token)
@last_Updated_Date -18-09-2019
******************************************/
    
    Public Static String getAccessToken(Map<string,Access_Token_Utilities__c> Access_Token_Data){
        
        if(accessTokenData != NULL)
            return accessTokenData;
        
        String clientId = Access_Token_Data.get('Access_token_credential').Client_Id__c;
        String clientSecret = Access_Token_Data.get('Access_token_credential').Client_secret_key__c;
        String endPoint = Access_Token_Data.get('Access_token_credential').Site_Url__c;
        
        endPoint = endPoint + 'oauth/token?client_id='+clientId+'&client_secret='+clientSecret+'&grant_type=client_credentials';
        
        HttpResponse res = callEndpoint(endPoint,'POST','application/json','');
        
        if(res.getStatusCode()==200){
            Map<String,Object> responseMap= (Map<String,Object>)Json.deserializeUntyped(res.getBody());
            accessTokenData=(String)responseMap.get('access_token');  
            return accessTokenData;
        }
        else{
            return NULL;
        }
    }
    
    /**************************************************************************************
@last_Updated_Date - 18-09-2019
@Method - callEndpoint
@Desc  -This method is used for generic callout purpose
@Param - Endpoint , Callout method , accepted content type and Request body(In case of post) All String type 
@Output - HttpResponse Object 
***************************************************************************************/
    
    Public Static HttpResponse callEndpoint(String endPoint,String method,String ContentType,String reqBody){
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod(method);
        
        request.setHeader('Content-Type', ContentType);
        request.setHeader('Accept','application/json');
        
        if(!String.isEmpty(reqBody)){
            request.setBody(reqBody);
        }
        // system.debug(requestEndPoint);
        return new Http().send(request);
    }
}