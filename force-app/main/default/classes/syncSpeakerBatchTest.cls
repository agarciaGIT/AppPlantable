@istest
public class syncSpeakerBatchTest {

    @testSetup
    public static void setUpData(){
        
        // Custom Setting Data 
        Access_Token_Utilities__c  accessToken = new Access_Token_Utilities__c(Name='Access_token_credential',
                                                                               Client_Id__c='fcd5f952c672707a33763087624181363aadc3e2e6cfdb6754781f5478c51fdb'
                                                                               ,Client_secret_key__c='0fc71abcacaf3db9677a3b125ac90496c37c901b5d04aed127395fd955d0c2a2'
                                                                               ,Site_Url__c='https://garp.grenadine.co/');
        Insert accessToken;
        
        
        //Creating Sample Data for Speaker
        
        Event_Speaker__c speaker = new  Event_Speaker__c();
        speaker.Name='Test Speaker 1';
        speaker.Grenadine_Speaker_ID__c =397;     
        insert speaker;
    }
    
    @istest
    public static void testExecute(){
        
        List<integer> recList= new List<Integer>{397} ;
            
        test.setMock(HttpCalloutMock.class, new GrenadineMockResponseGenerator());
        
        test.startTest();
         syncSpeakerBatch sync= new syncSpeakerBatch(recList ,'71c9460f9011302ffab2b289a36','123');
         Database.executeBatch(sync);
        test.stopTest();
        
        Event_Speaker__c eventSpeaker = [select id,name from Event_Speaker__c where Grenadine_Speaker_ID__c=397 LIMIT 1];
        
        System.assertEquals('Michael Simone', eventSpeaker.Name);
    }
    
     @istest
    public static void testExecuteWithoutList(){
       
        test.setMock(HttpCalloutMock.class, new GrenadineMockResponseGenerator());
        
        test.startTest();
         syncSpeakerBatch sync= new syncSpeakerBatch('71c9460f9011302ffab2b289a36');
         Database.executeBatch(sync);
        test.stopTest();
        
        Event_Speaker__c eventSpeaker = [select id,name from Event_Speaker__c where Grenadine_Speaker_ID__c=397 LIMIT 1];
        
        System.assertEquals('Michael Simone', eventSpeaker.Name);
    }
}