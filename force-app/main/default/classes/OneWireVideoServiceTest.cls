@isTest
public class OneWireVideoServiceTest {

    public static String contentVideoRecordTypeId = RecordTypeHelper.getRecordTypeId('Content__c', 'Video');
    
    @TestSetup
    private static void setup(){
        
        Folder__c folder = new Folder__c(Name = 'OneWire Videos Repository');
        
        List<Content__c> contents = new List<Content__c>{
            new Content__c(
                Third_Party_URL__c = 'www.test.com',
                External_ID__c = 'A000001',
                Description__c = 'test',
                RecordTypeId = contentVideoRecordTypeId
            ),
            new Content__c(
                Third_Party_URL__c = 'www.test.com',
                External_ID__c = 'A000002',
                Description__c = 'test',
                RecordTypeId = contentVideoRecordTypeId
            ),
            new Content__c(
                Third_Party_URL__c = 'www.test.com',
                External_ID__c = 'A000003',
                Description__c = 'test',
                RecordTypeId = contentVideoRecordTypeId
            ),
            new Content__c(
                Third_Party_URL__c = 'www.test.com',
                External_ID__c = 'A000004',
                Description__c = 'test',
                RecordTypeId = contentVideoRecordTypeId
            ),
            new Content__c(
                Third_Party_URL__c = 'www.test.com',
                External_ID__c = 'A000005',
                Description__c = 'test',
                RecordTypeId = contentVideoRecordTypeId
            )
        };
       
        INSERT folder;
        INSERT contents;
        
        List<Content_Folders__c> contentFolders = new List<Content_Folders__c>();
        for(Content__c c: contents){
            Content_Folders__c cf = new Content_Folders__c();
            cf.Folder__c = folder.Id;
            cf.Content__c = c.Id;
            contentFolders.add(cf);
        }
        
        INSERT contentFolders;
        
    }
    
    @isTest
    private static void getVideos(){
        
    	Test.setMock(HttpCalloutMock.class, new OneWireVideoServiceMockHttpCallout());
        
        Test.startTest();
        OneWireVideoService.getVideos();
        Test.stopTest();
        
        System.assert(!([SELECT Id, External_ID__c FROM Content__c WHERE External_ID__c = 'A000008']).isEmpty());//RECORD WAS INSERTED
        System.assert( ([SELECT Id, External_ID__c FROM Content__c WHERE External_ID__c = 'A000005']).isEmpty());//RECORD WAS DELETED
        System.assertEquals('UPDATED VALUE', [SELECT Id, External_ID__c, Description__c FROM Content__c WHERE External_ID__c = 'A000001' LIMIT 1].Description__c);//RECORD WAS UPDATED        
        
    }
    
}