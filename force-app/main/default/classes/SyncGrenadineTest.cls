@istest
public class SyncGrenadineTest {
    
    @testSetup
    public static void setUpData(){

        EventMobiApiBatch.disableBatch = true;

        Id recTypeId = Schema.SObjectType.Event__c.getRecordTypeInfosByName().get('Convention').getRecordTypeId();
        
        // Creating Custom Setting Data
        Access_Token_Utilities__c  accessToken = new Access_Token_Utilities__c(
            Name='Access_token_credential',
            Client_Id__c='fcd5f952c672707a33763087624181363aadc3e2e6cfdb6754781f5478c51fdb',
            Client_secret_key__c='0fc71abcacaf3db9677a3b125ac90496c37c901b5d04aed127395fd955d0c2a2',
            Site_Url__c='https://garp.grenadine.co/'
        );
        INSERT accessToken;
        
        Event__c eventData= New Event__c(
            Name='Sample Event Data',RecordTypeid =recTypeId,
            Grenadine_Event_Key__c='garp-20th-risk-convention'
        );
        INSERT eventData;
        
        //Creating Event Data For Update Purpose
        Event_Sessions__c eventSession = New  Event_Sessions__c(Event__c= eventData.id, Name='Sample Test Name');
        eventSession.Grenadine_Session_ID__c= 517;
        INSERT eventSession;
        
        //Creating Event Tracks Data 
        Event_Session_Track__c eventTracks = New Event_Session_Track__c();
        eventTracks.Name='Sample Event Name';
        eventTracks.Grenadine_Track_Key__c='garp-20th-risk-convention-Track A Part 1';
        INSERT eventTracks;
        
        //Creating Event Speaker
        Event_Speaker__c speaker = new  Event_Speaker__c();
        speaker.Name='Speaker Name';
        speaker.Grenadine_Speaker_ID__c =295;
        INSERT speaker;

    }
    
    @istest
    public static void testgetEventData(){
        
        Event__c evt = [select id,Grenadine_Event_Key__c from Event__c LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new GrenadineMockResponseGenerator());        
       
        Test.startTest();
        Map<String,String> retResponseMap = SyncGrenadine.getEventData(evt.id);
        Test.stopTest();
                
        System.assert(retResponseMap.get('Success') != NULL);
        
        Event__c EventData = [SELECT Id, Name ,(Select id,name from Event_sessions__r) FROM Event__c LIMIT 1];
        
        //Asserting the size of Event Session list 
        System.assertEquals(2, EventData.Event_sessions__r.size());  

    }
    
    @istest
    public static void testgetEventDataError(){
        
        Event__c evt = [select id,Grenadine_Event_Key__c from Event__c LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new GrenadineMockErrorResponseGenerator());        
       
        Test.startTest();
        Map<String,String> retResponseMap = SyncGrenadine.getEventData(evt.id);
        Test.stopTest();
       
        System.assert(retResponseMap.get('Error') != NULL);
        
        Event__c EventData = [SELECT Id, Name ,(Select id,name from Event_sessions__r) FROM Event__c LIMIT 1];
        
        //Asserting the size of Event Session list 
        System.assertEquals(1, EventData.Event_sessions__r.size());      
        
    }
}